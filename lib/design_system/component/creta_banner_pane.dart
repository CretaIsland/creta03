import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_snippet.dart';
import 'package:creta_common/common/creta_font.dart';
//import '../menu/creta_drop_down_button.dart';
import '../menu/creta_popup_menu.dart';
import '../text_field/creta_search_bar.dart';
import 'package:creta_common/common/creta_color.dart';
import 'creta_filter_pane.dart';

//const double cretaBannerMinHeight = 196;

class CretaBannerPane extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final String title;
  final String description;
  final List<List<CretaMenuItem>> listOfListFilter;
  final Widget Function(Size)? titlePane;
  final bool? isSearchbarInBanner;
  final void Function(String)? onSearch;
  final List<List<CretaMenuItem>>? listOfListFilterOnRight;
  final bool? scrollbarOnRight;
  final double? leftPaddingOnFilter;
  final List<CretaMenuItem>? tabMenuList;
  const CretaBannerPane({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.title,
    required this.description,
    required this.listOfListFilter,
    this.titlePane,
    this.isSearchbarInBanner,
    this.listOfListFilterOnRight,
    this.scrollbarOnRight,
    this.onSearch,
    this.leftPaddingOnFilter,
    this.tabMenuList,
  });

  @override
  State<CretaBannerPane> createState() => _CretaBannerPaneState();
}

class _CretaBannerPaneState extends State<CretaBannerPane> {
  @override
  Widget build(BuildContext context) {
    bool isExistFilter = widget.listOfListFilter.isNotEmpty ||
        (widget.onSearch != null && !(widget.isSearchbarInBanner ?? false)) ||
        (widget.listOfListFilterOnRight?.isNotEmpty ?? false);
    double internalWidth = widget.width -
        LayoutConst.cretaTopTitlePaddingLT.width -
        LayoutConst.cretaTopTitlePaddingRB.width;
    double heightDelta =
        widget.height - (CretaConst.cretaPaddingPixel + LayoutConst.cretaTopTitleHeight);
    if (isExistFilter) {
      heightDelta -= LayoutConst.cretaTopFilterHeight;
    } else {
      heightDelta -= CretaConst.cretaPaddingPixel;
    }
    bool isExistTabMenu = (widget.tabMenuList ?? []).isNotEmpty;
    if (isExistTabMenu) {
      heightDelta -= (32 + 36 + 16 - 20);
    }
    return Container(
      width:
          widget.width - ((widget.scrollbarOnRight ?? false) ? LayoutConst.cretaScrollbarWidth : 0),
      height: widget.height,
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            left: LayoutConst.cretaTopTitlePaddingLT.width,
            top: LayoutConst.cretaTopTitlePaddingLT.height,
            child: Container(
              width: internalWidth,
              height: LayoutConst.cretaTopTitleHeight + heightDelta,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.2),
                boxShadow: StudioSnippet.fullShadow(),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     spreadRadius: 3,
                //     blurRadius: 3,
                //     offset: Offset(0, 1), // changes position of shadow
                //   ),
                // ],
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.titlePane != null
                  ? widget.titlePane!
                      .call(Size(internalWidth, LayoutConst.cretaTopTitleHeight + heightDelta))
                  : _titlePane(
                      title: widget.title,
                      description: widget.description,
                    ),
            ),
          ),
          if (isExistTabMenu)
            Positioned(
              left: 0,
              top: LayoutConst.cretaTopFilterPaddingLT.height + heightDelta + 12,
              child: Container(
                width: widget.width,
                height: 36,
                color: CretaColor.text[100],
                child: Row(
                  children: [
                    const SizedBox(width: 40),
                    ...widget.tabMenuList!.expand((menuItem) {
                      return [
                        BTN.fill_color_t_m(
                          text: menuItem.caption,
                          height: 24,
                          width: null,
                          sidePadding: CretaButtonSidePadding(left: 12, right: 12),
                          buttonColor: menuItem.selected
                              ? CretaButtonColor.channelTabSelected
                              : CretaButtonColor.channelTabUnselected,
                          isSelected: menuItem.selected,
                          onPressed: menuItem.onPressed ?? () {},
                        ),
                        const SizedBox(width: 4),
                      ];
                    }),
                  ],
                ),
              ),
            ),
          Positioned(
            left: LayoutConst.cretaTopFilterPaddingLT.width + (widget.leftPaddingOnFilter ?? 0),
            top: LayoutConst.cretaTopFilterPaddingLT.height +
                heightDelta +
                (isExistTabMenu ? 64 : 0),
            child: CretaFilterPane(
              width: internalWidth - (widget.leftPaddingOnFilter ?? 0),
              height: LayoutConst.cretaTopFilterItemHeight,
              listOfListFilter: widget.listOfListFilter,
              listOfListFilterOnRight: widget.listOfListFilterOnRight,
              onSearch: widget.onSearch,
            ),
            // child: Container(
            //   width: internalWidth,
            //   height: LayoutConst.cretaTopFilterItemHeight,
            //   color: Colors.white,
            //   child: _filterPane(),
            // ),
          ),
        ],
      ),
    );
  }

  // Widget _filterPane() {
  //   double filterWidth = 40 + 40;
  //   List<List<CretaMenuItem>> listOfListFilter = [];
  //   if (widget.listOfListFilter.isNotEmpty) {
  //     for(int i = 0; i < widget.listOfListFilter.length; i++) {
  //       filterWidth += 150;
  //       if (widget.width < filterWidth) {
  //         break;
  //       }
  //       listOfListFilter.add(widget.listOfListFilter[i]);
  //     }
  //   }
  //   List<List<CretaMenuItem>> listOfListFilterOnRight = [];
  //   if (widget.listOfListFilterOnRight != null
  //       && widget.listOfListFilterOnRight!.isNotEmpty) {
  //     for(int i = 0; i < widget.listOfListFilterOnRight!.length; i++) {
  //       filterWidth += 150;
  //       if (widget.width < filterWidth) {
  //         break;
  //       }
  //       listOfListFilterOnRight.add(widget.listOfListFilterOnRight![i]);
  //     }
  //   }
  //   bool showSearchbar = (widget.width > filterWidth + 246) && (widget.onSearch != null);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       // widget.width > 500
  //       //     ? Row(
  //       //         mainAxisAlignment: MainAxisAlignment.start,
  //       //         children: widget.listOfListFilter
  //       //             .map(
  //       //               (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
  //       //             )
  //       //             .toList(),
  //       //       )
  //       //     : Container(),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: listOfListFilter
  //           .map(
  //               (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
  //         )
  //             .toList(),
  //       ),
  //       Row(
  //         children: [
  //           showSearchbar
  //           //widget.width > 750 && widget.onSearch != null && !(widget.isSearchbarInBanner ?? false)
  //               ? CretaSearchBar(
  //                   hintText: CretaLang['searchBar']!,
  //                   onSearch: (value) {
  //                     widget.onSearch?.call(value);
  //                   },
  //                   width: 246,
  //                   height: 32,
  //                 )
  //               : Container(),
  //           // widget.width > 500 && widget.listOfListFilterOnRight != null
  //           //     ? Row(
  //           //         mainAxisAlignment: MainAxisAlignment.start,
  //           //         children: [
  //           //           Container(
  //           //             width: 8,
  //           //           ),
  //           //           ...widget.listOfListFilterOnRight!
  //           //               .map(
  //           //                 (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
  //           //               )
  //           //               .toList(),
  //           //         ],
  //           //       )
  //           //     : Container(
  //           //         width: 0,
  //           //       ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Container(
  //                 width: 8,
  //               ),
  //               ...listOfListFilterOnRight
  //                   .map(
  //                     (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
  //               )
  //                   .toList(),
  //             ],
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _titlePane({Widget? icon, required String title, required String description}) {
    String desc = '${AccountManager.currentLoginUser.name} $description';
    double titleWidth = title.length * CretaFont.titleELarge.fontSize! * 1.2 + 12 * 2 + 80;
    double descWidth = desc.length * CretaFont.bodyMedium.fontSize! * 1.2 + 12 * 2;
    return Padding(
      padding: const EdgeInsets.only(
        left: 28,
      ),
      child: Row(
        children: [
          icon ?? Container(),
          titleWidth < widget.width
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    title,
                    style: CretaFont.titleELarge,
                    overflow: TextOverflow.fade,
                  ),
                )
              : Container(),
          titleWidth + descWidth < widget.width
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    desc,
                    style: CretaFont.bodyMedium,
                    overflow: TextOverflow.fade,
                  ),
                )
              : Container(),
          Expanded(
            child: Container(),
          ),
          widget.width > 600 && (widget.isSearchbarInBanner ?? false)
              ? CretaSearchBar(
                  hintText: CretaLang['searchBar']!,
                  onSearch: (value) {
                    if (kDebugMode) print('widget.onSearch($value)');
                    widget.onSearch?.call(value);
                  },
                  width: 246,
                  height: 32,
                )
              : Container(),
        ],
      ),
    );
  }
}
