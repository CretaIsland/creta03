import 'package:flutter/material.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/component/creta_icon_toggle_button.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../studio_constant.dart';
import '../property_mixin.dart';

class ContentsOrderedList extends StatefulWidget {
  final ContentsManager contentsManager;
  const ContentsOrderedList({super.key, required this.contentsManager});

  @override
  State<ContentsOrderedList> createState() => _ContentsOrderedListState();
}

class _ContentsOrderedListState extends State<ContentsOrderedList> with PropertyMixin {
  bool _isPlayListOpen = true;
  final double spacing = 6.0;
  final double lineHeight = LayoutConst.contentsListHeight;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final List<CretaModel> items = [...widget.contentsManager.valueList()];
    int lineLimit = 5;
    if (_isExpanded) {
      lineLimit = 10;
    }
    final int itemCount = widget.contentsManager.getAvailLength();
    final double boxHeight =
        (lineHeight + spacing * 2) * (itemCount > lineLimit ? lineLimit : itemCount);

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
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              SizedBox(
                width: LayoutConst.rightMenuWidth,
                height: boxHeight,
                child: ReorderableListView.builder(
                  itemCount: itemCount,
                  buildDefaultDragHandles: true,
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final ContentsModel item = items.removeAt(oldIndex) as ContentsModel;
                      items.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    ContentsModel model = items[index] as ContentsModel;
                    String? uri = model.thumbnail;
                    return GestureDetector(
                      key: Key('$index'),
                      onLongPressDown: (detail) {
                        widget.contentsManager.goto(model.order.value).then((v) {
                          widget.contentsManager.setSelectedMid(model.mid);
                        });
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: spacing, bottom: spacing, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _leadings(index, uri),
                                _title(model),
                                _buttons(model),
                              ],
                            ),
                          ),
                          if (widget.contentsManager.isSelected(model.mid)) _selectBar(),
                        ],
                      ),
                    );
                    // return ListTile(
                    //   key: Key('$index'),
                    //   title: Text(model.name, style: CretaFont.bodySmall),
                    //   leading: const Icon(Icons.drag_handle),
                    // );
                  },
                ),
              ),
              if (itemCount > 5) _expandButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leadings(int index, String? uri) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            width: 30,
            child: Text(
              index < 10 ? '0${index + 1}' : '${index + 1}',
              style: CretaFont.bodySmall,
              textAlign: TextAlign.left,
            ),
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
            image: uri == null || uri.isEmpty
                ? const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/no_image.png'),
                  )
                : DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(uri),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _title(ContentsModel model) {
    return SizedBox(
        width: 130,
        child: Text(
          model.name,
          maxLines: 1,
          style: CretaFont.bodySmall,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Widget _buttons(ContentsModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CretaIconToggleButton(
          buttonSize: lineHeight,
          toggleValue: model.volume.value == 0,
          icon1: Icons.volume_up,
          icon2: Icons.volume_off,
          buttonStyle: ToggleButtonStyle.fill_gray_i_s,
          tooltip: CretaLang.mute,
          onPressed: () {},
        ),
        CretaIconToggleButton(
          buttonSize: lineHeight,
          toggleValue: model.isShow.value,
          icon1: Icons.visibility_outlined,
          icon2: Icons.visibility_off_outlined,
          buttonStyle: ToggleButtonStyle.fill_gray_i_s,
          tooltip: CretaStudioLang.showUnshow,
          onPressed: () {},
        ),
        BTN.fill_gray_image_m(
          buttonSize: lineHeight,
          iconSize: 12,
          tooltip: CretaStudioLang.tooltipDelete,
          tooltipBg: CretaColor.text[700]!,
          iconImageFile: "assets/delete.svg",
          onPressed: () {
            model.isRemoved.set(true);
            widget.contentsManager.notify();
          },
        ),
      ],
    );
  }

  Widget _selectBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: CretaColor.primary.withOpacity(0.3),
      ),
      height: lineHeight + spacing * 2,
    );
  }

  Widget _expandButton() {
    return CretaIconToggleButton(
      buttonSize: lineHeight + 4,
      toggleValue: _isExpanded,
      icon1: Icons.keyboard_double_arrow_up_outlined,
      icon2: Icons.keyboard_double_arrow_down_outlined,
      buttonStyle: ToggleButtonStyle.floating_l,
      tooltip: CretaStudioLang.showUnshow,
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
    );
    //keyboard_double_arrow_down_outlined
  }
}
