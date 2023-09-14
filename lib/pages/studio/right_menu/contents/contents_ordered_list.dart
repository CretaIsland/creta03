import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_checkbox.dart';
import '../../../../design_system/buttons/creta_ex_slider.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_font_deco_bar.dart';
import '../../../../design_system/component/creta_font_selector.dart';
import '../../../../design_system/component/creta_icon_toggle_button.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
import '../../../../design_system/component/time_input_widget.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../player/music/creta_music_mixin.dart';
import '../../left_menu/left_menu_page.dart';
import '../../left_menu/music/music_player_frame.dart';
import '../../studio_constant.dart';
import '../../studio_snippet.dart';
import '../property_mixin.dart';

class ContentsOrderedList extends StatefulWidget {
  final BookModel? book;

  final ContentsManager contentsManager;
  final FrameManager? frameManager;
  const ContentsOrderedList(
      {super.key, required this.book, required this.frameManager, required this.contentsManager});

  @override
  State<ContentsOrderedList> createState() => _ContentsOrderedListState();
}

class _ContentsOrderedListState extends State<ContentsOrderedList> with PropertyMixin {
  //final ScrollController scrollController = ScrollController();

  bool _isPlayListOpen = true;
  final double spacing = 6.0;
  final double lineHeight = LayoutConst.contentsListHeight;
  int _selectedIndex = 0;
  //static bool _isExpanded = false;

  void invalidate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<CretaModel> items = widget.contentsManager.valueList();
    int lineLimit = 10;
    // if (_isExpanded) {
    //   lineLimit = 10;
    // }
    final int itemCount = widget.contentsManager.getAvailLength();

    //print('itemCount======================$itemCount==');

    final double boxHeight =
        (lineHeight + spacing * 2) * (itemCount > lineLimit ? lineLimit : itemCount);

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }
    ContentsModel? model = widget.contentsManager.getSelected() as ContentsModel?;
    model ??= widget.contentsManager.getFirstModel();

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: propertyCard(
        animate: false,
        isOpen: _isPlayListOpen,
        onPressed: () {
          setState(() {
            _isPlayListOpen = !_isPlayListOpen;
          });
        },
        titleWidget: Text(
            (model != null && model.isText()) ? CretaLang.text : CretaStudioLang.playList,
            style: CretaFont.titleSmall),
        trailWidget: (model != null && model.isText())
            ? Text(
                '${CretaUtils.getFontName(model.font.value)},${model.fontSize.value.ceil()}',
                textAlign: TextAlign.right,
                style: CretaFont.titleSmall.copyWith(
                  overflow: TextOverflow.fade,
                  //color: model.fontColor.value.withOpacity(model.opacity.value),
                  color: Colors.black,
                  fontFamily: model.font.value,
                  fontWeight: StudioConst.fontWeight2Type[model.fontWeight.value],
                ),
              )
            : Text('$itemCount ${CretaLang.count}', style: dataStyle),
        showTrail: true,
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: _orderColumn(model, items, itemCount, boxHeight),
        ),
        //),
      ),
    );
  }

  Widget _orderColumn(
      ContentsModel? model, List<CretaModel> items, int itemCount, double boxHeight) {
    if (model != null && model.isText()) {
      return _textEditor(model);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Scrollbar(
        //   controller: scrollController,
        //   thumbVisibility: false,
        //   trackVisibility: false,
        //   child:
        SizedBox(
          width: LayoutConst.rightMenuWidth,
          height: boxHeight,
          child: DropZoneWidget(
            bookMid: widget.contentsManager.frameModel.realTimeKey,
            parentId: '',
            onDroppedFile: (modelList) {
              String frameId = widget.contentsManager.frameModel.mid;
              logger.info(' dropzone contents added to $frameId');
              ContentsManager.createContents(
                widget.frameManager,
                modelList,
                widget.contentsManager.frameModel,
                widget.contentsManager.pageModel,
                isResizeFrame: false,
                onUploadComplete: (currentModel) {
                  if (currentModel.isMusic()) {
                    debugPrint('--------------add song named ${currentModel.name} to playlist');
                    GlobalObjectKey<MusicPlayerFrameState>? musicKey = musicKeyMap[frameId];
                    if (musicKey != null) {
                      musicKey.currentState?.addMusic(currentModel);
                    } else {
                      logger.severe('musicKey  is null');
                    }
                  }
                },
              );
            },
            child: ReorderableListView.builder(
              //scrollController: scrollController,
              itemCount: itemCount,
              buildDefaultDragHandles: false,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }

                  final ContentsModel pushedOne = items[newIndex] as ContentsModel;
                  ContentsModel movedOne = items[oldIndex] as ContentsModel;

                  logger.info(
                      '${pushedOne.name}, ${pushedOne.order.value} ,<=> ${movedOne.name}, ${movedOne.order.value} ');
                  widget.contentsManager.pushReverseOrder(movedOne.mid, pushedOne.mid, "playList",
                      onComplete: () {
                    widget.contentsManager.reOrdering();
                    if (model != null && model.isMusic()) {
                      String frameId = widget.contentsManager.frameModel.mid;
                      GlobalObjectKey<MusicPlayerFrameState>? musicKey = musicKeyMap[frameId];
                      if (musicKey != null) {
                        musicKey.currentState?.reorderPlaylist(model, oldIndex, newIndex);
                      } else {
                        logger.severe('musicKey is null');
                      }
                    }
                    LeftMenuPage.treeInvalidate();
                    LeftMenuPage.initTreeNodes();
                  });

                  // widget.contentsManager.reOrdering().then((value) {
                  //   return null;
                  // });
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return _itemWidget(index, items);
                // return ListTile(
                //   key: Key('$index'),
                //   title: Text(model.name, style: CretaFont.bodySmall),
                //   leading: const Icon(Icons.drag_handle),
                // );
              },
            ),
          ),
        ),
        //),
        if (_selectedIndex >= 0 && itemCount > 0 && _selectedIndex < itemCount) ..._info(items),
      ],
    );
  }

  Widget _itemWidget(int index, List<CretaModel> items) {
    ContentsModel model = items[index] as ContentsModel;

    //('orderedList=${model.name}, ${model.isRemoved.value}');

    String? uri = model.thumbnail;
    if (uri == null || uri.isEmpty) {
      if (model.isImage()) {
        uri = model.getURI();
      }
    }
    if (widget.contentsManager.isSelected(model.mid)) {
      _selectedIndex = index;
    }

    return Stack(
      key: Key('$index${model.order.value}${model.mid}'),
      children: [
        Padding(
          padding: EdgeInsets.only(top: spacing, bottom: spacing, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dragHandler(index),
              GestureDetector(
                onLongPressDown: (detail) {
                  if (_selectedIndex != index && model.isShow.value == true) {
                    logger.info('ContentsOrderedList $_selectedIndex $index');
                    widget.contentsManager.playTimer?.releasePause();
                    widget.contentsManager.goto(model.order.value).then((v) {
                      widget.contentsManager.setSelectedMid(model.mid);
                    });
                    setState(() {
                      _selectedIndex = index;
                      logger.info('ContentsOrderedList $_selectedIndex $index');
                      widget.contentsManager.selectMusic(model, index);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _leadings(index, uri, model),
                    _title(model),
                  ],
                ),
              ),
              _buttons(model, index, items),
            ],
          ),
        ),
        if (widget.contentsManager.isSelected(model.mid)) _selectBar(),
      ],
      //),
    );
  }

  ReorderableDragStartListener _dragHandler(int index) {
    return ReorderableDragStartListener(
      index: index,
      child: const MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: LayoutConst.contentsListHeight,
          height: LayoutConst.contentsListHeight,
          child: Icon(Icons.menu_outlined, size: 16),
        ),
      ),
    );
  }

  Widget _leadings(int index, String? uri, ContentsModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            index < 9 ? '0${index + 1}' : '${index + 1}',
            style: model.isShow.value
                ? CretaFont.bodySmall
                : CretaFont.bodySmall.copyWith(color: CretaColor.text[300]!),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: 32,
          height: lineHeight,
          decoration: BoxDecoration(
            border: Border.all(
              color: CretaColor.text[700]!,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            image: uri != null && uri.isNotEmpty
                ? DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(uri),
                    colorFilter: model.isShow.value
                        ? null
                        : ColorFilter.mode(
                            //CretaColor.text.withOpacity(0.25),
                            Colors.blue.withOpacity(0.5),
                            BlendMode.srcOver,
                          ),
                  )
                : null,
          ),
          child: uri == null || uri.isEmpty
              ? const Icon(Icons.panorama_outlined)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _title(ContentsModel model) {
    return Tooltip(
      message: model.name,
      child: SizedBox(
          width: 130,
          child: Text(
            ' ${model.name}',
            maxLines: 1,
            style: model.isShow.value
                ? CretaFont.bodySmall
                : CretaFont.bodySmall.copyWith(color: CretaColor.text[300]!),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }

  Widget _buttons(ContentsModel model, int index, List<CretaModel> items) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!model.isMusic())
          CretaIconToggleButton(
            buttonSize: lineHeight,
            toggleValue: model.mute.value == true,
            icon1: Icons.volume_off,
            icon2: Icons.volume_up,
            buttonStyle: ToggleButtonStyle.fill_gray_i_m,
            iconColor: model.isShow.value == true ? CretaColor.text[700]! : CretaColor.text[300]!,
            //tooltip: CretaLang.mute,
            onPressed: () {
              if (model.isShow.value == false) return;

              model.mute.set(!model.mute.value);
              if (model.mute.value == true) {
                widget.contentsManager.setSoundOff(mid: model.mid);
              } else {
                widget.contentsManager.resumeSound(mid: model.mid);
              }
            },
          ),
        CretaIconToggleButton(
          doToggle: false,
          buttonSize: lineHeight,
          toggleValue: model.isShow.value,
          icon1: Icons.visibility_outlined,
          icon2: Icons.visibility_off_outlined,
          buttonStyle: ToggleButtonStyle.fill_gray_i_m,
          //tooltip: CretaStudioLang.showUnshow,
          onPressed: () {
            // bool doNotify = false;
            // int len = widget.contentsManager.getShowLength();
            // if (model.isShow.value == false) {
            //   // true 로 간다는 뜻이다.
            //   if (len == 0) {
            //     // 0 --> 1 로 되려고 하고 있다.
            //     doNotify = true;
            //   } else if (len == 1) {
            //     // 1--> 2 로 되겨고 한다.
            //     //widget.contentsManager.notify();
            //     widget.contentsManager.setLoopingAll(false);
            //   }
            // } else {
            //   // false 로 간다는 뜻이다.
            //   if (len == 1) {
            //     // 1 --> 0 로 되려고 하고 있다.
            //     doNotify = true;
            //   } else if (len == 2) {
            //     // 2 --> 1 로 되려고 하고 있다.
            //     //widget.contentsManager.notify();
            //     widget.contentsManager.setLooping(true);
            //   }
            // }
            model.isShow.set(!model.isShow.value);
            widget.contentsManager.reOrdering();
            int len = widget.contentsManager.getShowLength();
            LeftMenuPage.treeInvalidate();
            // 돌릴게 없을때,
            if (len == 0) {
              //widget.contentsManager.clearCurrentModel();
              setState(() {});
              widget.contentsManager.notify();
              return;
            }
            widget.contentsManager.afterShowUnshow(model, index, invalidate);

            // ContentsModel? current = widget.contentsManager.getCurrentModel();
            // if (model.isShow.value == false) {
            //   widget.contentsManager.unshowMusic(model);
            //   if (current != null && current.mid == model.mid) {
            //     // 현재 방송중인 것을 unshow 하려고 한다.
            //     if (len > 0) {
            //       widget.contentsManager.gotoNext();
            //       setState(() {});
            //       return;
            //     }
            //   }
            // } else {
            //   widget.contentsManager.showMusic(model, index);
            //   // show 했는데, current 가 null 이다.
            //   if (current == null && widget.contentsManager.isEmptySelected()) {
            //     if (len > 0) {
            //       widget.contentsManager.setSelectedMid(model.mid);
            //       widget.contentsManager.gotoNext();
            //       setState(() {});
            //       return;
            //     }
            //   }
            // }

            //if(current != null && current.mid == model.mid || len <= 2) {
            setState(() {});
            widget.contentsManager.notify();

            //}
            // if (doNotify) {
            //   widget.contentsManager.notify();
            // }
          },
        ),
        BTN.fill_gray_image_m(
          buttonSize: lineHeight,
          iconSize: 12,
          //tooltip: CretaStudioLang.tooltipDelete,
          //tooltipBg: CretaColor.text[700]!,
          iconImageFile: "assets/delete.svg",
          onPressed: () {
            // int showLen = widget.contentsManager.getShowLength();
            // int availLen = widget.contentsManager.getAvailLength();
            // if (model.isShow.value == true && showLen == 1 && showLen < availLen) {
            //   logger.warning('It is last one!! can not be unshowed');
            //   showSnackBar(context, CretaStudioLang.contentsCannotBeUnshowd);
            //   setState(() {});
            //   return;
            // }
            setState(() {
              items.removeAt(index);
            });
            widget.contentsManager.removeContents(context, model).then((value) {
              if (value == true) {
                widget.contentsManager.removeMusic(model);
                showSnackBar(context, model.name + CretaLang.contentsDeleted);
              }
            });
            // if (widget.contentsManager.getShowLength() == 1) {
            //   // 원래 둘이었는데 하나가 되었다.
            //   widget.contentsManager.notify();
            // }
          },
        ),
      ],
    );
  }

  Widget _selectBar() {
    return IgnorePointer(
      child: Container(
        height: lineHeight + spacing * 2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.7)),
          color: CretaColor.text[400]!.withOpacity(0.25),
        ),
      ),
    );
  }

  List<Widget> _info(List<CretaModel> items) {
    ContentsModel? model;
    int index = 0;
    for (var item in items) {
      if (widget.contentsManager.isSelected(item.mid)) {
        model = item as ContentsModel;
        break;
      }
      index++;
    }
    if (model == null) {
      return [];
    }
    _selectedIndex = index;
    //print('===$_selectedIndex=======model=${model.name}, ${model.mid}');

    return [
      propertyDivider(height: 28),
      // Padding(
      //   padding: const EdgeInsets.only(top: 6, bottom: 12),
      //   child: Text(
      //     CretaStudioLang.infomation,
      //     style: CretaFont.titleSmall,
      //     textAlign: TextAlign.left,
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.contentyType,
              style: titleStyle,
            ),
            Text(CretaLang.contentsTypeString[model.contentsType.index], style: dataStyle),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaStudioLang.fileSize,
              style: titleStyle,
            ),
            Text(model.size, style: dataStyle),
          ],
        ),
      ),
      if (model.isImage()) _imageDurationWidget(model),
      if (model.isVideo()) _videoDurationWidget(model),
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(CretaStudioLang.copyRight, style: titleStyle),
            widget.book != null && widget.book!.creator == AccountManager.currentLoginUser.email
                ? CretaDropDownButton(
                    selectedColor: CretaColor.text[700]!,
                    textStyle: dataStyle,
                    width: 260,
                    height: 36,
                    itemHeight: 24,
                    dropDownMenuItemList: StudioSnippet.getCopyRightListItem(
                        defaultValue: model.copyRight.value,
                        onChanged: (val) {
                          model!.copyRight.set(val);
                        }),
                  )
                : Text(CretaStudioLang.copyWrightList[model.copyRight.value.index],
                    style: dataStyle),
          ],
        ),
      ),
      if ((model.isImage() || model.isVideo()) &&
          model.thumbnail != null &&
          model.thumbnail!.isNotEmpty)
        propertyLine(
          // useThisThumbnail
          topPadding: 10,
          name: CretaStudioLang.useThisThumbnail,
          widget: CretaToggleButton(
            width: 54 * 0.75,
            height: 28 * 0.75,
            defaultValue: model.thumbnail != null &&
                widget.book!.thumbnailUrl.value.isNotEmpty &&
                widget.book!.thumbnailUrl.value == model.thumbnail!,
            onSelected: (value) {
              if (value == true) {
                widget.book!.thumbnailUrl.set(model!.thumbnail!, noUndo: true);
              } else {
                if (widget.book!.thumbnailUrl.value == model!.thumbnail!) {
                  widget.book!.thumbnailUrl.set('', noUndo: true);
                }
              }
              widget.book!.isAutoThumbnail.set(value, noUndo: true);
              //setState(() {});
            },
          ),
        ),
    ];
  }

  Widget _imageDurationWidget(ContentsModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaLang.playTime, style: titleStyle),
          if (model.playTime.value >= 0)
            TimeInputWidget(
              textWidth: 30,
              textStyle: titleStyle,
              initValue: (model.playTime.value / 1000).round(),
              onValueChnaged: (duration) {
                logger.info('save : ${model.mid}');
                model.playTime.set(duration.inSeconds * 1000.0);
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
                        model.reservPlayTime();
                        model.playTime.set(-1);
                      } else {
                        model.resetPlayTime();
                      }
                    });
                  },
                  defaultValue: model.playTime.value < 0),
            ],
          )
        ],
      ),
    );
  }

  // Widget _textDurationWidget(ContentsModel model) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 6, bottom: 6),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(CretaLang.playDuration, style: titleStyle),
  //         if (model.playTime.value >= 0)
  //           TimeInputWidget(
  //             textWidth: 30,
  //             textStyle: titleStyle,
  //             initValue: (model.playTime.value / 1000).round(),
  //             onValueChnaged: (duration) {
  //               logger.info('save : ${model.mid}');
  //               model.playTime.set(duration.inSeconds * 1000.0);
  //             },
  //           ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 2.0),
  //               child: Text(CretaLang.onlyOnce, style: titleStyle),
  //             ),
  //             CretaToggleButton(
  //                 width: 54 * 0.75,
  //                 height: 28 * 0.75,
  //                 onSelected: (value) {
  //                   setState(() {
  //                     if (value) {
  //                       model.reservPlayTime();
  //                       model.playTime.set(-1);
  //                     } else {
  //                       model.resetPlayTime();
  //                     }
  //                   });
  //                 },
  //                 defaultValue: model.playTime.value < 0),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _videoDurationWidget(ContentsModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaLang.playTime, style: titleStyle),
          Text(CretaUtils.secToDurationString(model.videoPlayTime.value / 1000), style: dataStyle),
        ],
      ),
    );
  }

  // Widget _expandButton() {
  //   return CretaIconToggleButton(
  //     buttonSize: lineHeight + 4,
  //     toggleValue: _isExpanded,
  //     icon1: Icons.keyboard_double_arrow_up_outlined,
  //     icon2: Icons.keyboard_double_arrow_down_outlined,
  //     buttonStyle: ToggleButtonStyle.floating_l,
  //     tooltip: CretaStudioLang.showUnshow,
  //     onPressed: () {
  //       setState(() {
  //         _isExpanded = !_isExpanded;
  //       });
  //     },
  //   );
  //keyboard_double_arrow_down_outlined
  //}

  Widget _textEditor(ContentsModel model) {
    GlobalKey<CretaTextFieldState> key = GlobalKey<CretaTextFieldState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CretaTextField.long(
          textFieldKey: key,
          value: model.remoteUrl ?? '',
          hintText: model.name,
          selectAtInit: true,
          autoComplete: true,
          autoHeight: true,
          height: 17, // autoHeight 가 true 이므로 line heiht 로 작동한다.
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          alignVertical: TextAlignVertical.top,
          onEditComplete: (value) {
            model.remoteUrl = value;
            widget.contentsManager.setToDB(model);
            widget.contentsManager.notify();
          },
          onChanged: (value) {
            model.remoteUrl = value;
            widget.contentsManager.notify();
          },
        ),
        _textAlign(model),
        _fontDecoBar(model),
        propertyDivider(height: 28),
        CretaCheckbox(
          // 창 크기에 맞춤
          valueMap: {
            CretaStudioLang.autoFontSize: model.autoSizeType.value == AutoSizeType.autoFontSize,
            CretaStudioLang.autoFrameSize: model.autoSizeType.value == AutoSizeType.autoFrameSize,
            CretaStudioLang.noAutoSize: model.autoSizeType.value == AutoSizeType.noAutoSize,
          },
          onSelected: (title, value, nvMap) {
            model.autoSizeType.set(AutoSizeType.fromString(title));
            //_sendEvent!.sendEvent(model);
            widget.contentsManager.notify();
            setState(() {});
          },
        ),
        propertyDivider(height: 28),
        CretaFontSelector(
          // 폰트, 폰트 weight
          topPadding: 10,
          title: Text(CretaStudioLang.fontName, style: titleStyle),
          defaultFont: model.font.value,
          defaultFontWeight: model.fontWeight.value,
          onFontChanged: (val) {
            if (val != model.font.value) {
              model.fontWeight.set(400); // 폰트가 변경되면, weight 도 초기화
              model.font.set(val);

              logger.info('save ${model.mid}-----------------');
              logger.info('save ${model.font.value}----------');
              //_sendEvent!.sendEvent(model);
              widget.contentsManager.notify();
              setState(() {});
            }
          },
          onFontWeightChanged: (val) {
            if (val != model.fontWeight.value) {
              model.fontWeight.set(val);
              //_sendEvent!.sendEvent(model);
              widget.contentsManager.notify();
              setState(() {});
            }
          },
          textStyle: dataStyle,
        ),
        //const SizedBox(height: 10),
        // 폰트 사이즈
        propertyLine(
          // letterSpacing  자간
          name: CretaStudioLang.fontSize,
          widget: CretaExSlider(
            valueType: SliderValueType.normal,
            value: model.fontSize.value,
            textType: CretaTextFieldType.number,
            min: 6,
            max: StudioConst.maxFontSize,
            onChanngeComplete: (val) {
              //setState(() {
              model.fontSize.set(val);
              FontSizeType? fontSyzeType = FontSizeType.valToEnum[val];
              if (fontSyzeType == null ||
                  fontSyzeType == FontSizeType.userDefine ||
                  fontSyzeType == FontSizeType.none ||
                  fontSyzeType == FontSizeType.end) {
                if (model.fontSizeType.value != FontSizeType.userDefine) {
                  model.fontSizeType.set(FontSizeType.userDefine);
                }
              } else {
                if (model.fontSizeType.value != fontSyzeType) {
                  model.fontSizeType.set(fontSyzeType);
                }
              }
              widget.contentsManager.notify();

              //_sendEvent!.sendEvent(model);
              //});
            },
            onChannged: (val) {
              model.fontSize.set(val);
              widget.contentsManager.notify();
            },
          ),
        ),
        propertyLine(
          // letterSpacing  자간
          name: CretaStudioLang.letterSpacing,
          widget: CretaExSlider(
            valueType: SliderValueType.normal,
            value: model.letterSpacing.value,
            textType: CretaTextFieldType.number,
            min: -10,
            max: 10,
            onChanngeComplete: (val) {
              //setState(() {
              model.letterSpacing.set(val);
              //});
              widget.contentsManager.notify();
              //_sendEvent!.sendEvent(model);
            },
            onChannged: (val) {
              model.letterSpacing.set(val);
              widget.contentsManager.notify();
              //_sendEvent!.sendEvent(model);
            },
          ),
        ),
        propertyLine(
          // lineHeight  행간
          name: CretaStudioLang.lineHeight,
          widget: CretaExSlider(
            valueType: SliderValueType.normal,
            textType: CretaTextFieldType.number,
            value: model.lineHeight.value,
            min: 0,
            max: 100,
            onChanngeComplete: (val) {
              //setState(() {
              model.lineHeight.set(val);
              //});
              widget.contentsManager.notify();
              //_sendEvent!.sendEvent(model);
            },
            onChannged: (val) {
              model.lineHeight.set(val);
              widget.contentsManager.notify();
              //_sendEvent!.sendEvent(model);
            },
          ),
        ),

        // propertyLine(
        //   // 프레임 크기에 자동 맞춤
        //   name: CretaStudioLang.autoSizeFont,
        //   widget: CretaToggleButton(
        //     width: 54 * 0.75,
        //     height: 28 * 0.75,
        //     defaultValue: model.autoSizeType.value,
        //     onSelected: (value) {
        //       model.autoSizeType.set(value);
        //       //_sendEvent!.sendEvent(model);
        //       widget.contentsManager.notify();
        //       setState(() {});
        //     },
        //   ),
        // ),
        //if (model.autoSizeType.value == false) _fontSizeArea2(model),

        // _translateRow(model),
        // propertyLine(
        //   // TTS
        //   topPadding: 10,
        //   name: CretaStudioLang.tts,
        //   widget: CretaToggleButton(
        //     width: 54 * 0.75,
        //     height: 28 * 0.75,
        //     defaultValue: model.isTTS.value,
        //     onSelected: (value) {
        //       model.isTTS.set(value);
        //       model.mute.set(!value);
        //       widget.contentsManager.notify();
        //       setState(() {});
        //     },
        //   ),
        // ),
        // if (model.isTTS.value) const SizedBox(height: 14),
        // if (model.isTTS.value) _textDurationWidget(model),
      ],
    );
  }

  // Widget _fontSizeArea2(ContentsModel model) {
  //   return propertyLine2(
  //     // 프레임 크기에 자동 맞춤
  //     widget1: CretaDropDownButton(
  //       align: MainAxisAlignment.start,
  //       selectedColor: CretaColor.text[700]!,
  //       textStyle: dataStyle,
  //       width: 176,
  //       height: 36,
  //       itemHeight: 24,
  //       dropDownMenuItemList: _getFontSizeItem(
  //           defaultValue: model.fontSizeType.value,
  //           onChanged: (val) {
  //             model.fontSizeType.set(val);
  //             if (FontSizeType.userDefine != model.fontSizeType.value) {
  //               model.fontSize.set(FontSizeType.enumToVal[val]!);
  //             }
  //             //_sendEvent!.sendEvent(model);
  //             widget.contentsManager.notify();
  //             setState(() {});
  //           }),
  //     ),
  //     widget2: CretaExSlider(
  //       //disabled: model.fontSizeType.value != FontSizeType.userDefine,
  //       key: GlobalKey(),
  //       min: 6,
  //       max: StudioConst.maxFontSize,
  //       value: model.fontSize.value,
  //       valueType: SliderValueType.normal,
  //       sliderWidth: 136,
  //       onChanngeComplete: (val) {
  //         //setState(() {
  //         model.fontSize.set(val);
  //         FontSizeType? fontSyzeType = FontSizeType.valToEnum[val];
  //         if (fontSyzeType == null ||
  //             fontSyzeType == FontSizeType.userDefine ||
  //             fontSyzeType == FontSizeType.none ||
  //             fontSyzeType == FontSizeType.end) {
  //           if (model.fontSizeType.value != FontSizeType.userDefine) {
  //             model.fontSizeType.set(FontSizeType.userDefine);
  //           }
  //         } else {
  //           if (model.fontSizeType.value != fontSyzeType) {
  //             model.fontSizeType.set(fontSyzeType);
  //           }
  //         }
  //         widget.contentsManager.notify();

  //         //_sendEvent!.sendEvent(model);
  //         //});
  //       },
  //       onChannged: (val) {
  //         model.fontSize.set(val);
  //         widget.contentsManager.notify();

  //         //_sendEvent!.sendEvent(model);
  //       },
  //     ),
  //   );
  // }

  // List<CretaMenuItem> _getFontSizeItem(
  //     {required FontSizeType defaultValue, required void Function(FontSizeType) onChanged}) {
  //   return CretaStudioLang.textSizeMap.keys.map(
  //     (sizeStr) {
  //       double sizeVal = CretaStudioLang.textSizeMap[sizeStr]!;
  //       double currentVal = FontSizeType.enumToVal[defaultValue]!;
  //       return CretaMenuItem(
  //           caption: sizeStr,
  //           onPressed: () {
  //             onChanged(FontSizeType.valToEnum[sizeVal]!);
  //           },
  //           selected: sizeVal == currentVal);
  //     },
  //   ).toList();
  // }

  Widget _textAlign(ContentsModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BTN.fill_gray_i_m(
                  icon: Icons.format_align_left,
                  buttonColor: model.align.value == TextAlign.left
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.align.set(TextAlign.left);
                    });
                    widget.contentsManager.notify();
                  }),
              BTN.fill_gray_i_m(
                  buttonColor: model.align.value == TextAlign.right
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  icon: Icons.format_align_right,
                  onPressed: () {
                    setState(() {
                      model.align.set(TextAlign.right);
                    });
                    widget.contentsManager.notify();
                  }),
              BTN.fill_gray_i_m(
                  icon: Icons.format_align_center,
                  buttonColor: model.align.value == TextAlign.center
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.align.set(TextAlign.center);
                    });
                    widget.contentsManager.notify();
                  }),
              BTN.fill_gray_i_m(
                  icon: Icons.format_align_justify,
                  buttonColor: model.align.value == TextAlign.justify
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.align.set(TextAlign.justify);
                    });
                    widget.contentsManager.notify();
                  }),
            ],
          ),
          const SizedBox(width: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BTN.fill_gray_i_m(
                  icon: Icons.vertical_align_top,
                  //iconColor: model.valign.value == TextAlign.start ? CretaColor.primary[700] : null,
                  buttonColor: model.valign.value == -1 //TextAlignVertical.top
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.valign.set(-1 /*TextAlignVertical.top*/);
                    });
                    widget.contentsManager.notify();
                  }),
              BTN.fill_gray_i_m(
                  icon: Icons.vertical_align_center,
                  buttonColor: model.valign.value == 0 //TextAlignVertical.center
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.valign.set(0 /*TextAlignVertical.center*/);
                    });
                    widget.contentsManager.notify();
                  }),
              BTN.fill_gray_i_m(
                  icon: Icons.vertical_align_bottom,
                  buttonColor: model.valign.value == 1 //TextAlignVertical.bottom
                      ? CretaButtonColor.primary
                      : CretaButtonColor.white,
                  onPressed: () {
                    setState(() {
                      model.valign.set(1 /*TextAlignVertical.bottom*/);
                    });
                    widget.contentsManager.notify();
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fontDecoBar(ContentsModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: CretaFontDecoBar(
        bold: model.isBold.value,
        italic: model.isItalic.value,
        underline: model.isUnderline.value,
        strike: model.isStrike.value,
        toggleBold: (val) {
          model.isBold.set(val);
          widget.contentsManager.notify();
        },
        toggleItalic: (val) {
          model.isItalic.set(val);
          widget.contentsManager.notify();
        },
        toggleUnderline: (val) {
          model.isUnderline.set(val);
          widget.contentsManager.notify();
        },
        toggleStrikethrough: (val) {
          model.isStrike.set(val);
          widget.contentsManager.notify();
        },
      ),
    );
  }

  // Widget _translateRow(ContentsModel model) {
  //   return propertyLine(
  //     topPadding: 10,
  //     name: CretaStudioLang.translate,
  //     widget: CretaDropDownButton(
  //       align: MainAxisAlignment.start,
  //       selectedColor: CretaColor.text[700]!,
  //       textStyle: dataStyle,
  //       width: 200,
  //       height: 36,
  //       itemHeight: 24,
  //       dropDownMenuItemList: CretaUtils.getLangItem(
  //           defaultValue: model.lang.value,
  //           onChanged: (val) async {
  //             model.lang.set(val);
  //             if (model.remoteUrl != null) {
  //               Translation result = await model.remoteUrl!.translate(to: model.lang.value);
  //               model.remoteUrl = result.text;
  //               model.url = result.text;
  //               model.name = result.text;
  //               model.save();
  //             }
  //             widget.contentsManager.notify();
  //             setState(() {});
  //           }),
  //     ),
  //   );
  // }

  // List<CretaMenuItem> _getLangItem(
  //     {required String defaultValue, required void Function(String) onChanged}) {
  //   return StudioConst.code2LangMap.keys.map(
  //     (code) {
  //       String langStr = StudioConst.code2LangMap[code]!;

  //       return CretaMenuItem(
  //         caption: langStr,
  //         onPressed: () {
  //           onChanged(StudioConst.lang2CodeMap[langStr]!);
  //         },
  //         selected: code == defaultValue,
  //       );
  //     },
  //   ).toList();
  // }
}
