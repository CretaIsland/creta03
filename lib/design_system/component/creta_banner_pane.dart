import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../lang/creta_lang.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_snippet.dart';
import '../creta_font.dart';
import '../menu/creta_drop_down_button.dart';
import '../menu/creta_popup_menu.dart';
import '../text_field/creta_search_bar.dart';

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
  const CretaBannerPane(
      {super.key,
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
      this.onSearch});

  @override
  State<CretaBannerPane> createState() => _CretaBannerPaneState();
}

class _CretaBannerPaneState extends State<CretaBannerPane> {
  @override
  Widget build(BuildContext context) {
    bool isExistFilter = widget.listOfListFilter.isNotEmpty
        || (widget.onSearch != null && !(widget.isSearchbarInBanner ?? false))
        || (widget.listOfListFilterOnRight != null && widget.listOfListFilterOnRight!.isNotEmpty);
    double internalWidth =
        widget.width - LayoutConst.cretaTopTitlePaddingLT.width - LayoutConst.cretaTopTitlePaddingRB.width;
    double heightDelta = widget.height -
        (LayoutConst.cretaPaddingPixel + LayoutConst.cretaTopTitleHeight);
    if (isExistFilter) {
      heightDelta -= LayoutConst.cretaTopFilterHeight;
    } else {
      heightDelta -= LayoutConst.cretaPaddingPixel;
    }
    return Container(
      width: widget.width - ((widget.scrollbarOnRight ?? false) ? LayoutConst.cretaScrollbarWidth : 0),
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
                  ? widget.titlePane!.call(Size(internalWidth, LayoutConst.cretaTopTitleHeight + heightDelta))
                  : _titlePane(
                      title: widget.title,
                      description: widget.description,
                    ),
            ),
          ),
          Positioned(
            left: LayoutConst.cretaTopFilterPaddingLT.width,
            top: LayoutConst.cretaTopFilterPaddingLT.height + heightDelta,
            child: Container(
              width: internalWidth,
              height: LayoutConst.cretaTopFilterItemHeight,
              color: Colors.white,
              child: _filterPane(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterPane() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.width > 500
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.listOfListFilter
                    .map(
                      (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
                    )
                    .toList(),
              )
            : Container(),
        Row(
          children: [
            widget.width > 700 && widget.onSearch != null && !(widget.isSearchbarInBanner ?? false)
                ? CretaSearchBar(
                    hintText: CretaLang.searchBar,
                    onSearch: (value) {
                      widget.onSearch?.call(value);
                    },
                    width: 246,
                    height: 32,
                  )
                : Container(),
            widget.width > 500 && widget.listOfListFilterOnRight != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                      ),
                      ...widget.listOfListFilterOnRight!
                          .map(
                            (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
                          )
                          .toList(),
                    ],
                  )
                : Container(
                    width: 0,
                  ),
          ],
        ),
      ],
    );
  }

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
                  hintText: CretaLang.searchBar,
                  onSearch: (value) {
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
