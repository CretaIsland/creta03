import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:hycop/hycop/account/account_manager.dart';

import 'package:creta_common/lang/creta_lang.dart';
//import '../../pages/studio/studio_constant.dart';
//import '../../pages/studio/studio_snippet.dart';
//import 'package:creta_common/common/creta_font.dart';
import '../menu/creta_drop_down_button.dart';
import '../menu/creta_popup_menu.dart';
import '../text_field/creta_search_bar.dart';

//const double cretaBannerMinHeight = 196;

class CretaFilterPane extends StatefulWidget {
  final double width;
  final double height;
  //final Color color;
  //final String title;
  //final String description;
  final List<List<CretaMenuItem>> listOfListFilter;
  //final Widget Function(Size)? titlePane;
  //final bool? isSearchbarInBanner;
  final void Function(String)? onSearch;
  final List<List<CretaMenuItem>>? listOfListFilterOnRight;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final Widget? toolbar;
  //final bool? scrollbarOnRight;
  const CretaFilterPane({
    super.key,
    required this.width,
    required this.height,
    //required this.color,
    //required this.title,
    //required this.description,
    required this.listOfListFilter,
    //this.titlePane,
    //this.isSearchbarInBanner,
    this.listOfListFilterOnRight,
    //this.scrollbarOnRight,
    this.onSearch,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.toolbar,
  });

  @override
  State<CretaFilterPane> createState() => _CretaFilterPaneState();
}

class _CretaFilterPaneState extends State<CretaFilterPane> {
  @override
  Widget build(BuildContext context) {
    // bool isExistFilter = widget.listOfListFilter.isNotEmpty
    //     || (widget.onSearch != null && !(widget.isSearchbarInBanner ?? false))
    //     || (widget.listOfListFilterOnRight != null && widget.listOfListFilterOnRight!.isNotEmpty);
    // double internalWidth =
    //     widget.width - LayoutConst.cretaTopTitlePaddingLT.width - LayoutConst.cretaTopTitlePaddingRB.width;
    // double heightDelta = widget.height -
    //     (CretaConst.cretaPaddingPixel + LayoutConst.cretaTopTitleHeight);
    // if (isExistFilter) {
    //   heightDelta -= LayoutConst.cretaTopFilterHeight;
    // } else {
    //   heightDelta -= CretaConst.cretaPaddingPixel;
    // }
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: widget.toolbar != null
          ? Column(
              children: [
                widget.toolbar!,
                Expanded(child: _filterPane()),
              ],
            )
          : _filterPane(),
    );
  }

  Widget _filterPane() {
    double filterWidth = 40 + 40;
    List<List<CretaMenuItem>> listOfListFilter = [];
    if (widget.listOfListFilter.isNotEmpty) {
      for (int i = 0; i < widget.listOfListFilter.length; i++) {
        filterWidth += 150;
        if (widget.width < filterWidth) {
          break;
        }
        listOfListFilter.add(widget.listOfListFilter[i]);
      }
    }
    List<List<CretaMenuItem>> listOfListFilterOnRight = [];
    if (widget.listOfListFilterOnRight != null && widget.listOfListFilterOnRight!.isNotEmpty) {
      for (int i = 0; i < widget.listOfListFilterOnRight!.length; i++) {
        filterWidth += 150;
        if (widget.width < filterWidth) {
          break;
        }
        listOfListFilterOnRight.add(widget.listOfListFilterOnRight![i]);
      }
    }
    bool showSearchbar = (widget.width > filterWidth + 246) && (widget.onSearch != null);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: widget.rowCrossAxisAlignment,
      children: [
        // listOfListFilter
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: listOfListFilter
              .map(
                (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
              )
              .toList(),
        ),
        Row(
          children: [
            // onSearch
            showSearchbar
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
            // listOfListFilterOnRight
            (listOfListFilterOnRight.isEmpty)
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      ...listOfListFilterOnRight
                          .map(
                            (e) => CretaDropDownButton(height: 36, dropDownMenuItemList: e),
                          )
                          .toList(),
                    ],
                  )
          ],
        ),
      ],
    );
  }
}
