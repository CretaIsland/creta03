// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/component/time_input_widget.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../property_mixin.dart';

class ContentsProperty extends StatefulWidget {
  final ContentsModel model;
  final FrameManager frameManager;
  final BookModel? book;
  const ContentsProperty(
      {super.key, required this.model, required this.frameManager, required this.book});

  @override
  State<ContentsProperty> createState() => _ContentsPropertyState();
}

class _ContentsPropertyState extends State<ContentsProperty> with PropertyMixin {
  //ContentsManager? _contentsManager;

  // static bool _isInfoOpen = false;
  static bool _isPlayControlOpen = false;
  // static bool _isImageFilterOpen = false;

  ContentsEventController? _sendEvent;
  //ContentsEventController? _receiveEvent;

  late TextStyle _titleStyle;
  late TextStyle _dataStyle;

  @override
  void initState() {
    logger.finest('_ContentsPropertyState.initState');

    super.initMixin();
    super.initState();

    final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');
    _sendEvent = sendEvent;
    //final ContentsEventController receiveEvent = Get.find(tag: 'contents-main-to-property');
    //_receiveEvent = receiveEvent;

    //_contentsManager = widget.frameManager.getContentsManager(widget.model.parentMid.value);

    _titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    _dataStyle = CretaFont.bodySmall;
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  bool isAuthor() =>
      widget.book != null && widget.book!.creator == AccountManager.currentLoginUser.email;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._info(),
          ],
        ),
      ),
      propertyDivider(height: 28),
      Padding(
        padding: EdgeInsets.only(
            left: horizontalPadding, right: horizontalPadding - (isAuthor() ? 16 : 0)),
        child: _copyRight(),
      ),
      propertyDivider(height: 28),
      _imageControl(),
      propertyDivider(),
      _imageFilter(),
      propertyDivider(),
    ]);
    //});
  }

  List<Widget> _info() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 12),
        child: Text(CretaStudioLang.infomation, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.contentyType,
              style: _titleStyle,
            ),
            Text(CretaLang.contentsTypeString[widget.model.contentsType.index], style: _dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.fileSize,
              style: _titleStyle,
            ),
            Text(widget.model.size, style: _dataStyle),
          ],
        ),
      ),
      _durationWidget(),
    ];
  }

  Widget _copyRight() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang.copyRight, style: CretaFont.titleSmall),
          widget.book != null && widget.book!.creator == AccountManager.currentLoginUser.email
              ? CretaDropDownButton(
                  selectedColor: CretaColor.text[700]!,
                  textStyle: _dataStyle,
                  width: 260,
                  height: 36,
                  itemHeight: 24,
                  dropDownMenuItemList: StudioSnippet.getCopyRightListItem(
                      defaultValue: widget.model.copyRight.value,
                      onChanged: (val) {
                        widget.model.copyRight.set(val);
                      }))
              : Text(CretaStudioLang.copyWrightList[widget.model.copyRight.value.index],
                  style: _dataStyle),
        ],
      ),
    );
  }

  Widget _imageControl() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isPlayControlOpen,
        onPressed: () {
          setState(() {
            _isPlayControlOpen = !_isPlayControlOpen;
          });
        },
        titleWidget: Text(CretaStudioLang.imageControl, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          _trailString(),
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
        ),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: _imageControlBody(),
      ),
    );
  }

  String _trailString() {
    int idx = widget.model.fit.value.index;
    if (idx > ContentsFitType.none.index && idx < ContentsFitType.end.index) {
      return CretaStudioLang.fitList.keys.toList()[idx - 1];
    }
    return '';
  }

  Widget _imageControlBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CretaPropertySlider(
            // 투명도
            key: GlobalKey(),
            name: CretaStudioLang.opacity,
            min: 0,
            max: 100,
            value: CretaUtils.validCheckDouble(widget.model.opacity.value, 0, 1),
            valueType: SliderValueType.reverse,
            onChannged: (value) {
              widget.model.opacity.set(value);
              widget.model.save();
              logger.info('opacity=${widget.model.opacity.value}');
              _sendEvent!.sendEvent(widget.model);
            },
            postfix: '%',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(CretaStudioLang.borderCap, style: titleStyle),
                CretaTabButton(
                  onEditComplete: (value) {
                    int idx = 1;
                    for (String val in CretaStudioLang.fitList.values) {
                      if (value == val) {
                        widget.model.fit.set(ContentsFitType.values[idx]);
                      }
                      idx++;
                    }
                    _sendEvent!.sendEvent(widget.model);
                  },
                  width: 75,
                  height: 24,
                  selectedTextColor: CretaColor.primary,
                  unSelectedTextColor: CretaColor.text[700]!,
                  selectedColor: Colors.white,
                  unSelectedColor: CretaColor.text[100]!,
                  selectedBorderColor: CretaColor.primary,
                  defaultString: _getFit(),
                  buttonLables: CretaStudioLang.fitList.keys.toList(),
                  buttonValues: CretaStudioLang.fitList.values.toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFit() {
    switch (widget.model.fit.value) {
      case ContentsFitType.cover:
        return 'cover';
      case ContentsFitType.fill:
        return 'fill';
      case ContentsFitType.free:
        return 'free';
      default:
        return 'cover';
    }
  }

  Widget _durationWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaLang.playTime, style: titleStyle),
          if (widget.model.playTime.value >= 0)
            TimeInputWidget(
              textWidth: 30,
              textStyle: titleStyle,
              initValue: (widget.model.playTime.value / 1000).round(),
              onValueChnaged: (duration) {
                logger.info('save : ${widget.model.mid}');
                widget.model.playTime.set(duration.inSeconds * 1000.0);
              },
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(CretaLang.forever, style: titleStyle),
              ),
              CretaToggleButton(
                  width: 54 * 0.75,
                  height: 28 * 0.75,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        widget.model.reservPlayTime();
                        widget.model.playTime.set(-1);
                      } else {
                        widget.model.resetPlayTime();
                      }
                    });
                  },
                  defaultValue: widget.model.playTime.value < 0),
            ],
          )
        ],
      ),
    );
  }

  Widget _imageFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: imageFilterCard(
        imageFilterType: widget.model.filter.value,
        onPressed: () {
          setState(() {});
        },
        onImageFilterChanged: (val) {
          setState(() {
            widget.model.filter.set(val);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        onDelete: () {
          setState(() {
            widget.model.filter.set(ImageFilterType.none);
          });
          _sendEvent!.sendEvent(widget.model);
        },
      ),
    );
  }
}
