// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_ex_slider.dart';
import '../../../../design_system/buttons/creta_tab_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_font_deco_bar.dart';
import '../../../../design_system/component/creta_font_selector.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
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
  static bool _isLinkControlOpen = false;
  static bool _isPlayControlOpen = false;
  static bool _isTextFontOpen = false;
  static bool _isTextBorderOpen = false;
  // static bool _isImageFilterOpen = false;

  ContentsEventController? _sendEvent;
  //ContentsEventController? _receiveEvent;
  OffsetEventController? _linkSendEvent;
  BoolEventController? _linkReceiveEvent;

  @override
  void initState() {
    logger.finest('_ContentsPropertyState.initState');

    super.initMixin();
    super.initState();

    final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');
    final ContentsEventController sendEventText = Get.find(tag: 'text-property-to-textplayer');

    if (widget.model.isText()) {
      _sendEvent = sendEventText;
    } else {
      _sendEvent = sendEvent;
    }

    final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkSendEvent = linkSendEvent;

    final BoolEventController linkReceiveEvent = Get.find(tag: 'link-widget-to-property');
    _linkReceiveEvent = linkReceiveEvent;
    //final ContentsEventController receiveEvent = Get.find(tag: 'contents-main-to-property');
    //_receiveEvent = receiveEvent;

    //_contentsManager = widget.frameManager.getContentsManager(widget.model.parentMid.value);
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
      // propertyDivider(height: 28),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       ..._info(),
      //     ],
      //   ),
      // ),
      // propertyDivider(height: 28),
      // Padding(
      //   padding: EdgeInsets.only(
      //       left: horizontalPadding, right: horizontalPadding - (isAuthor() ? 16 : 0)),
      //   child: _copyRight(),
      // ),
      propertyDivider(height: 28),
      if (!widget.model.isText()) _linkControl(),
      if (!widget.model.isText()) propertyDivider(height: 28),
      if (!widget.model.isText()) _imageControl(),
      if (widget.model.isText()) _textFont(),
      propertyDivider(height: 28),
      if (widget.model.isImage()) _imageFilter(),
      if (widget.model.isText()) _textBorder(),
      propertyDivider(height: 28),
      _hashTag(),
    ]);
    //});
  }

  Widget _textFont() {
    String fontName = CretaUtils.getFontName(widget.model.font.value);
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isTextFontOpen,
        onPressed: () {
          setState(() {
            _isTextFontOpen = !_isTextFontOpen;
          });
        },
        titleWidget: Text(CretaLang.font, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          '$fontName ${widget.model.fontSize.value}',
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall.copyWith(
            overflow: TextOverflow.fade,
            color: widget.model.fontColor.value,
            fontFamily: widget.model.font.value,
            fontWeight: StudioConst.fontWeight2Type[widget.model.fontWeight.value],
          ),
        ),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: _fontBody(),
      ),
    );
  }

  Widget _fontBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fontDecoBar(),
        CretaFontSelector(
          // 폰트, 폰트 weight
          defaultFont: widget.model.font.value,
          defaultFontWeight: widget.model.fontWeight.value,
          onFontChanged: (val) {
            if (val != widget.model.font.value) {
              widget.model.fontWeight.set(400); // 폰트가 변경되면, weight 도 초기화
              widget.model.font.set(val);

              logger.info('save ${widget.model.mid}-----------------');
              logger.info('save ${widget.model.font.value}----------');
              _sendEvent!.sendEvent(widget.model);
            }
          },
          onFontWeightChanged: (val) {
            if (val != widget.model.fontWeight.value) {
              widget.model.fontWeight.set(val);
              _sendEvent!.sendEvent(widget.model);
            }
          },
          textStyle: dataStyle,
        ),
        propertyLine(
          // 프레임 크기에 자동 맞춤
          name: CretaStudioLang.autoSizeFont,
          widget: CretaToggleButton(
            width: 54 * 0.75,
            height: 28 * 0.75,
            defaultValue: widget.model.isAutoSize.value,
            onSelected: (value) {
              widget.model.isAutoSize.set(value);
              _sendEvent!.sendEvent(widget.model);
              setState(() {});
            },
          ),
        ),
        if (widget.model.isAutoSize.value == false) _fontSizeArea2(),
        propertyLine(
          // fontColor
          name: CretaStudioLang.color,
          widget: colorIndicator(
            widget.model.fontColor.value,
            widget.model.opacity.value,
            onColorChanged: (color) {
              setState(() {
                widget.model.fontColor.set(color);
              });
              _sendEvent!.sendEvent(widget.model);
            },
            onClicked: () {},
          ),
        ),
        propertyLine(
          // Opacity
          name: CretaStudioLang.opacity,
          widget: CretaExSlider(
            valueType: SliderValueType.reverse,
            value: widget.model.opacity.value,
            min: 0,
            max: 100,
            onChanngeComplete: (val) {
              setState(() {
                widget.model.opacity.set(val);
              });
              _sendEvent!.sendEvent(widget.model);
            },
            onChannged: (val) {
              widget.model.opacity.set(val);
              _sendEvent!.sendEvent(widget.model);
            },
          ),
        ),
      ],
    );
  }

  Widget _fontDecoBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CretaFontDecoBar(
        bold: widget.model.isBold.value,
        italic: widget.model.isBold.value,
        underline: widget.model.isBold.value,
        strike: widget.model.isBold.value,
        toggleBold: (val) {
          widget.model.isBold.set(val);
          _sendEvent!.sendEvent(widget.model);
        },
        toggleItalic: (val) {
          widget.model.isItalic.set(val);
          _sendEvent!.sendEvent(widget.model);
        },
        toggleUnderline: (val) {
          widget.model.isUnderline.set(val);
          _sendEvent!.sendEvent(widget.model);
        },
        toggleStrikethrough: (val) {
          widget.model.isStrike.set(val);
          _sendEvent!.sendEvent(widget.model);
        },
      ),
    );
  }

  Widget _fontSizeArea2() {
    return propertyLine2(
      // 프레임 크기에 자동 맞춤
      widget1: CretaDropDownButton(
        align: MainAxisAlignment.start,
        selectedColor: CretaColor.text[700]!,
        textStyle: dataStyle,
        width: 176,
        height: 36,
        itemHeight: 24,
        dropDownMenuItemList: getFontSizeItem(
            defaultValue: widget.model.fontSizeType.value,
            onChanged: (val) {
              widget.model.fontSizeType.set(val);
              if (FontSizeType.userDefine != widget.model.fontSizeType.value) {
                widget.model.fontSize.set(FontSizeType.enumToVal[val]!);
              }
              _sendEvent!.sendEvent(widget.model);
              setState(() {});
            }),
      ),
      widget2: CretaExSlider(
        //disabled: widget.model.fontSizeType.value != FontSizeType.userDefine,
        key: GlobalKey(),
        min: 6,
        max: StudioConst.maxFontSize,
        value: widget.model.fontSize.value,
        valueType: SliderValueType.normal,
        sliderWidth: 136,
        onChanngeComplete: (val) {
          setState(() {
            widget.model.fontSize.set(val);
            FontSizeType? fontSyzeType = FontSizeType.valToEnum[val];
            if (fontSyzeType == null ||
                fontSyzeType == FontSizeType.userDefine ||
                fontSyzeType == FontSizeType.none ||
                fontSyzeType == FontSizeType.end) {
              if (widget.model.fontSizeType.value != FontSizeType.userDefine) {
                widget.model.fontSizeType.set(FontSizeType.userDefine);
              }
            } else {
              if (widget.model.fontSizeType.value != fontSyzeType) {
                widget.model.fontSizeType.set(fontSyzeType);
              }
            }
            _sendEvent!.sendEvent(widget.model);
          });
        },
        onChannged: (val) {
          widget.model.fontSize.set(val);
          _sendEvent!.sendEvent(widget.model);
        },
      ),
    );
  }

  List<CretaMenuItem> getFontSizeItem(
      {required FontSizeType defaultValue, required void Function(FontSizeType) onChanged}) {
    return CretaStudioLang.textSizeMap.keys.map(
      (sizeStr) {
        double sizeVal = CretaStudioLang.textSizeMap[sizeStr]!;
        double currentVal = FontSizeType.enumToVal[defaultValue]!;
        return CretaMenuItem(
            caption: sizeStr,
            onPressed: () {
              onChanged(FontSizeType.valToEnum[sizeVal]!);
            },
            selected: sizeVal == currentVal);
      },
    ).toList();
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
              //widget.model.save();
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
                Text(CretaStudioLang.fitting, style: titleStyle),
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

  Widget _textBorder() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
      child: propertyCard(
        isOpen: _isTextBorderOpen,
        onPressed: () {
          setState(() {
            _isTextBorderOpen = !_isTextBorderOpen;
          });
        },
        titleWidget: Text(CretaStudioLang.border, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          'A',
          textAlign: TextAlign.right,
          style: widget.model.outLineWidth.value > 0
              ? CretaFont.titleSmall.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = widget.model.outLineWidth.value / 10
                    ..color = widget.model.outLineColor.value,
                )
              : CretaFont.titleSmall,
        ),
        hasRemoveButton: widget.model.outLineWidth.value > 0,
        onDelete: () {
          setState(() {
            widget.model.outLineWidth.set(0);
          });
          _sendEvent!.sendEvent(widget.model);
        },
        bodyWidget: _textBorderBody(),
      ),
    );
  }

  Widget _textBorderBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        propertyLine(
          // 테두리 색
          name: CretaStudioLang.color,
          widget: colorIndicator(
            widget.model.outLineColor.value,
            widget.model.opacity.value,
            onColorChanged: (color) {
              setState(() {
                widget.model.outLineColor.set(color);
              });
              _sendEvent!.sendEvent(widget.model);
            },
            onClicked: () {},
          ),
        ),
        propertyLine(
          // 테두리 두께
          name: CretaStudioLang.outlineWidth,
          widget: CretaExSlider(
            valueType: SliderValueType.normal,
            value: widget.model.outLineWidth.value,
            min: 0,
            max: 36,
            onChanngeComplete: (val) {
              setState(() {
                widget.model.outLineWidth.set(val);
              });
              _sendEvent!.sendEvent(widget.model);
            },
            onChannged: (val) {
              widget.model.outLineWidth.set(val);
              _sendEvent!.sendEvent(widget.model);
            },
          ),
        ),
      ],
    );
  }

  Widget _linkControl() {
    bool isLinkEditMode = widget.model.isLinkEditMode;
    return StreamBuilder<bool>(
        stream: _linkReceiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is bool) {
            if (snapshot.data != null) {
              isLinkEditMode = snapshot.data!;
            }
          }
          logger.info('_linkControl ($isLinkEditMode)');
          // if (offset == Offset.zero) {
          //   return const SizedBox.shrink();
          // }
          return Padding(
            padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
            child: propertyCard(
              isOpen: _isLinkControlOpen,
              onPressed: () {
                setState(() {
                  _isLinkControlOpen = !_isLinkControlOpen;
                });
              },
              titleWidget: Text(CretaStudioLang.linkControl, style: CretaFont.titleSmall),
              //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
              trailWidget: _linkToggle(isLinkEditMode),
              hasRemoveButton: false,
              onDelete: () {},
              bodyWidget: _linkControlBody(isLinkEditMode),
            ),
          );
        });
  }

  Widget _linkControlBody(bool isLinkEditMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: propertyLine(
        // 링크 편집 모드
        name: CretaStudioLang.linkControl,
        widget: _linkToggle(isLinkEditMode),
      ),
    );
  }

  Widget _linkToggle(bool isLinkEditMode) {
    logger.info('_linkToggle ($isLinkEditMode)');
    return CretaToggleButton(
      key: GlobalObjectKey('_linkToggle$isLinkEditMode${widget.model.mid}'),
      width: 54 * 0.75,
      height: 28 * 0.75,
      defaultValue: isLinkEditMode,
      onSelected: (value) {
        widget.model.isLinkEditMode = value;
        if (widget.model.isLinkEditMode == true) {
          StudioVariables.isAutoPlay = true;
        }
        _linkSendEvent!.sendEvent(Offset(1, 1));
        setState(() {});
      },
    );
  }

  Widget _hashTag() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: PropertyMixin.isHashTagOpen,
        onPressed: () {
          setState(() {
            PropertyMixin.isHashTagOpen = !PropertyMixin.isHashTagOpen;
          });
        },
        titleWidget: Text(CretaStudioLang.hashTab, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: widget.model.hashTag.value.isEmpty
            ? SizedBox.shrink()
            : SizedBox(
                width: 160,
                child: Text(
                  widget.model.hashTag.value,
                  style: CretaFont.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        hasRemoveButton: widget.model.hashTag.value.isNotEmpty,
        onDelete: () {
          setState(() {
            widget.model.hashTag.set('');
          });
        },
        bodyWidget: Column(children: _tagBody()),
      ),
    );
  }

  List<Widget> _tagBody() {
    return hashTagWrapper.hashTag(
      hasTitle: false,
      top: 12,
      model: widget.model,
      minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
      onTagChanged: (value) {
        setState(() {});
      },
      onSubmitted: (value) {
        setState(() {});
      },
      onDeleted: (value) {
        setState(() {});
      },
    );
  }
}
