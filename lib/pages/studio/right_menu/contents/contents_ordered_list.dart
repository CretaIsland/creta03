import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_icon_toggle_button.dart';
import '../../../../design_system/component/time_input_widget.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../studio_constant.dart';
import '../../studio_snippet.dart';
import '../property_mixin.dart';

class ContentsOrderedList extends StatefulWidget {
  final BookModel? book;

  final ContentsManager contentsManager;
  const ContentsOrderedList({super.key, required this.book, required this.contentsManager});

  @override
  State<ContentsOrderedList> createState() => _ContentsOrderedListState();
}

class _ContentsOrderedListState extends State<ContentsOrderedList> with PropertyMixin {
  final ScrollController scrollController = ScrollController();

  bool _isPlayListOpen = true;
  final double spacing = 6.0;
  final double lineHeight = LayoutConst.contentsListHeight;
  int _selectedIndex = 0;
  //static bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  Widget build(BuildContext context) {
    List<CretaModel> items = widget.contentsManager.valueList();
    int lineLimit = 10;
    // if (_isExpanded) {
    //   lineLimit = 10;
    // }
    final int itemCount = widget.contentsManager.getAvailLength();
    final double boxHeight =
        (lineHeight + spacing * 2) * (itemCount > lineLimit ? lineLimit : itemCount);

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

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
        titleWidget: Text(CretaStudioLang.playList, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        hasRemoveButton: false,
        onDelete: () {},
        bodyWidget: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Scrollbar(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      width: LayoutConst.rightMenuWidth,
                      height: boxHeight,
                      child: ReorderableListView.builder(
                        scrollController: scrollController,
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
                            widget.contentsManager
                                .pushReverseOrder(movedOne.mid, pushedOne.mid, "playList");
                            widget.contentsManager.reOrdering();

                            // oldOne = items.removeAt(oldIndex) as ContentsModel;
                            // items.insert(newIndex, oldOne);
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
                    //if (itemCount > 5) _expandButton(),
                  ],
                ),
              ),
              if (itemCount > 0 && _selectedIndex < itemCount)
                ..._info(items[_selectedIndex] as ContentsModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWidget(int index, List<CretaModel> items) {
    ContentsModel model = items[index] as ContentsModel;
    String? uri = model.thumbnail;
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
                  widget.contentsManager.playTimer?.releasePause();
                  widget.contentsManager.goto(model.order.value).then((v) {
                    widget.contentsManager.setSelectedMid(model.mid);
                  });
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _leadings(index, uri),
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

  Widget _leadings(int index, String? uri) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            index < 9 ? '0${index + 1}' : '${index + 1}',
            style: CretaFont.bodySmall,
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
    return SizedBox(
        width: 130,
        child: Text(
          ' ${model.name}',
          maxLines: 1,
          style: CretaFont.bodySmall,
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
        ));
  }

  Widget _buttons(ContentsModel model, int index, List<CretaModel> items) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CretaIconToggleButton(
          buttonSize: lineHeight,
          toggleValue: model.mute.value == true,
          icon1: Icons.volume_off,
          icon2: Icons.volume_up,
          buttonStyle: ToggleButtonStyle.fill_gray_i_m,
          //tooltip: CretaLang.mute,
          onPressed: () {
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
            if (model.isShow.value == true) {
              if (widget.contentsManager.getShowLength() <= 1) {
                // 가장 마지막 것은 unshow 할 수 없다.
                logger.warning('It is last one!! can not be unshowed');
                showSnackBar(context, CretaStudioLang.contentsCannotBeUnshowd);
                setState(() {});
                return;
              }
            } else {}
            model.isShow.set(!model.isShow.value);
            if (model.isShow.value == false) {
              ContentsModel? current = widget.contentsManager.getCurrentModel();
              if (current != null) {
                if (current.mid == model.mid) {
                  // 현재 방송중인 것을 unshow 하려고 한다.
                  widget.contentsManager.gotoNext();
                }
              }
              if (widget.contentsManager.getShowLength() == 1) {
                // 원래 둘이었는데 하나가 되었다.
                widget.contentsManager.notify();
              }
            } else {
              if (widget.contentsManager.getShowLength() == 2) {
                // 원래 하나 인데, 둘이 되었다.
                widget.contentsManager.notify();
              }
            }
            setState(() {});
          },
        ),
        BTN.fill_gray_image_m(
          buttonSize: lineHeight,
          iconSize: 12,
          //tooltip: CretaStudioLang.tooltipDelete,
          //tooltipBg: CretaColor.text[700]!,
          iconImageFile: "assets/delete.svg",
          onPressed: () {
            int showLen = widget.contentsManager.getShowLength();
            int availLen = widget.contentsManager.getAvailLength();
            if (model.isShow.value == true && showLen == 1 && showLen < availLen) {
              logger.warning('It is last one!! can not be unshowed');
              showSnackBar(context, CretaStudioLang.contentsCannotBeUnshowd);
              setState(() {});
              return;
            }
            widget.contentsManager.removeContents(context, model).then((value) {
              if (value == true) {
                setState(() {
                  items.removeAt(index);
                });
              }
            });
            if (widget.contentsManager.getShowLength() == 1) {
              // 원래 둘이었는데 하나가 되었다.
              widget.contentsManager.notify();
            }
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

  List<Widget> _info(ContentsModel model) {
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
                          model.copyRight.set(val);
                        }))
                : Text(CretaStudioLang.copyWrightList[model.copyRight.value.index],
                    style: dataStyle),
          ],
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
}
