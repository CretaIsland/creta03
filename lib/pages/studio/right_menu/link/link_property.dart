// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import '../../studio_getx_controller.dart';
import '../property_mixin.dart';

class LinkProperty extends StatefulWidget {
  final ContentsModel contentsModel;
  final LinkModel linkModel;
  final FrameManager frameManager;
  final BookModel? book;
  final void Function(Color) onColorChanged;
  final void Function(double) onOpacityChanged;
  final void Function() onPosChanged;
  final void Function(double) onSizeChanged;
  final void Function(LinkIconType) onIconDataChanged;

  const LinkProperty({
    super.key,
    required this.linkModel,
    required this.contentsModel,
    required this.frameManager,
    required this.book,
    required this.onColorChanged,
    required this.onOpacityChanged,
    required this.onPosChanged,
    required this.onSizeChanged,
    required this.onIconDataChanged,
  });

  @override
  State<LinkProperty> createState() => _LinkPropertyState();
}

class _LinkPropertyState extends State<LinkProperty> with PropertyMixin {
  // ignore: unused_field
  ContentsManager? _contentsManager;

  // ignore: unused_field
  static bool _isLinkControlOpen = false;

  // ignore: unused_field
  OffsetEventController? _linkSendEvent;
  // ignore: unused_field
  BoolEventController? _linkReceiveEvent;

  static bool _isShapeOpen = true;
  static bool _isSizeOpen = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    logger.finest('_LinkPropertyState.initState');

    super.initMixin();
    super.initState();

    final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkSendEvent = linkSendEvent;
    final BoolEventController linkReceiveEvent = Get.find(tag: 'link-widget-to-property');
    _linkReceiveEvent = linkReceiveEvent;

    _contentsManager = widget.frameManager.getContentsManager(widget.contentsModel.parentMid.value);
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //FrameModel frameModel = _contentsManager!.frameModel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(children: [
        //_linkControl(),

        propertyCard(
          //padding: horizontalPadding,
          isOpen: _isSizeOpen,
          onPressed: () {
            setState(() {
              _isSizeOpen = !_isSizeOpen;
            });
          },
          titleWidget: Text(CretaStudioLang['linkProp']!, style: CretaFont.titleSmall),
          onDelete: () {},
          hasRemoveButton: false,
          bodyWidget: Column(
            children: [
              _position(),
              propertyLine(
                // 아이콘 색
                name: CretaStudioLang['linkColor']!,
                widget: colorIndicator(
                  widget.linkModel.bgColor.value,
                  1.0,
                  onColorChanged: (color) {
                    widget.onColorChanged(color);
                    setState(() {});
                  },
                  onClicked: () {},
                ),
              ),
              CretaPropertySlider(
                // 아이콘 투명도
                key: GlobalKey(),
                name: CretaStudioLang['opacity']!,
                min: 0,
                max: 100,
                value:
                    CretaCommonUtils.validCheckDouble(widget.linkModel.bgColor.value.opacity, 0, 1),
                valueType: SliderValueType.reverse,
                onChannged: widget.onOpacityChanged,
                onChanngeComplete: widget.onOpacityChanged,
                //onChanngeComplete: onOpacityChangeComplete,
                postfix: '%',
              ),
              CretaPropertySlider(
                // 아이콘 크기
                key: GlobalKey(),
                name: CretaStudioLang['linkIconSize']!,
                min: 0,
                max: 50,
                value: widget.linkModel.iconSize.value,
                valueType: SliderValueType.normal,
                onChannged: widget.onSizeChanged,
                onChanngeComplete: widget.onSizeChanged,
                //onChanngeComplete: onSpreadChangeComplete,
              ),
              propertyLine(
                name: CretaStudioLang['linkClass']!,
                widget: Text(widget.linkModel.name),
              ),
            ],
          ),
        ),

        propertyDivider(),
        _shape(),
      ]),
    );
    //});
  }

  Widget _position() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 97,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CretaStudioLang['posX']!,
                  style: titleStyle,
                ),
                CretaTextField.xshortNumber(
                  defaultBorder: Border.all(color: CretaColor.text[100]!),
                  width: 45,
                  limit: 5,
                  textFieldKey: GlobalKey(),
                  value: widget.linkModel.posX.value.round().toString(),
                  hintText: '',
                  onEditComplete: ((value) {
                    logger.info('onEditComplete');
                    widget.linkModel.posX.set(int.parse(value).toDouble());
                    widget.onPosChanged();
                  }),
                  minNumber: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: 64),
          SizedBox(
            width: 97,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CretaStudioLang['posY']!,
                  style: titleStyle,
                ),
                CretaTextField.xshortNumber(
                  defaultBorder: Border.all(color: CretaColor.text[100]!),
                  width: 45,
                  limit: 5,
                  textFieldKey: GlobalKey(),
                  value: widget.linkModel.posY.value.round().toString(),
                  //value: widget.model.posY.value.toString(),
                  hintText: '',
                  minNumber: 0,
                  onEditComplete: ((value) {
                    widget.linkModel.posY.set(int.parse(value).toDouble());
                    widget.onPosChanged();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shape() {
    // 아이콘 모양
    return propertyCard(
      isOpen: _isShapeOpen,
      onPressed: () {
        setState(() {
          _isShapeOpen = !_isShapeOpen;
        });
      },
      titleWidget: Text(CretaStudioLang['shape']!, style: CretaFont.titleSmall),
      trailWidget: widget.linkModel.iconData.value == LinkIconType.none
          ? const SizedBox.shrink()
          : IconButton(
              icon: Icon(LinkIconType.toIcon(widget.linkModel.iconData.value)),
              iconSize: 24,
              onPressed: () {},
              color: CretaColor.primary,
            ),
      hasRemoveButton: false,
      onDelete: () {},
      bodyWidget: _shapeListView(
        onShapeTapPressed: (value) {
          setState(() {
            widget.linkModel.iconData.set(value);
          });
          widget.onIconDataChanged(value); // _sendEvent!.sendEvent(widget.model);;
        },
      ),
    );
  }

  Widget _shapeListView({required void Function(LinkIconType value) onShapeTapPressed}) {
    List<Widget> shapeList = [];

    for (int i = 1; i < LinkIconType.end.index; i++) {
      LinkIconType gType = LinkIconType.values[i];
      bool isSelected = (widget.linkModel.iconData.value == gType);

      shapeList.add(IconButton(
        icon: Icon(LinkIconType.toIcon(gType)),
        iconSize: 36,
        onPressed: () {
          onShapeTapPressed(gType);
        },
        color: isSelected ? CretaColor.primary : CretaColor.text[400],
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      //child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: gradientList),
      child: Wrap(children: shapeList),
    );
  }

  // Widget _linkControl() {
  //   bool isLinkEditMode = widget.contentsModel.isLinkEditMode;
  //   return StreamBuilder<bool>(
  //       stream: _linkReceiveEvent!.eventStream.stream,
  //       builder: (context, snapshot) {
  //         if (snapshot.data != null && snapshot.data is bool) {
  //           if (snapshot.data != null) {
  //             isLinkEditMode = snapshot.data!;
  //           }
  //         }
  //         logger.fine('_linkControl ($isLinkEditMode)');
  //         // if (offset == Offset.zero) {
  //         //   return const SizedBox.shrink();
  //         // }
  //         return Padding(
  //           padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 5),
  //           child: propertyCard(
  //             isOpen: _isLinkControlOpen,
  //             onPressed: () {
  //               setState(() {
  //                 _isLinkControlOpen = !_isLinkControlOpen;
  //               });
  //             },
  //             titleWidget: Text(CretaStudioLang['linkControl']!, style: CretaFont.titleSmall),
  //             //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
  //             trailWidget: _linkToggle(isLinkEditMode),
  //             hasRemoveButton: false,
  //             onDelete: () {},
  //             bodyWidget: _linkControlBody(isLinkEditMode),
  //           ),
  //         );
  //       });
  // }

  // Widget _linkControlBody(bool isLinkEditMode) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 16.0),
  //     child: propertyLine(
  //       // 링크 편집 모드
  //       name: CretaStudioLang['linkControl']!,
  //       widget: _linkToggle(isLinkEditMode),
  //     ),
  //   );
  // }

  // Widget _linkToggle(bool isLinkEditMode) {
  //   logger.fine('_linkToggle ($isLinkEditMode)');
  //   return CretaToggleButton(
  //     key: GlobalObjectKey('_linkToggle$isLinkEditMode${widget.contentsModel.mid}'),
  //     width: 54 * 0.75,
  //     height: 28 * 0.75,
  //     defaultValue: isLinkEditMode,
  //     onSelected: (value) {
  //       widget.contentsModel.isLinkEditMode = value;
  //       if (widget.contentsModel.isLinkEditMode == true) {
  //         StudioVariables.isAutoPlay = true;
  //       }
  //       _linkSendEvent!.sendEvent(Offset(1, 1));
  //       setState(() {});
  //     },
  //   );
  // }
}
