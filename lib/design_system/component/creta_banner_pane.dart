import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../lang/creta_lang.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_snippet.dart';
import '../creta_font.dart';
import '../menu/creta_drop_down_button.dart';
import '../menu/creta_popup_menu.dart';
import '../text_field/creta_search_bar.dart';

const double cretaBannerMinHeight = 196;

class CretaBannerPane extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final String title;
  final String description;
  final List<List<CretaMenuItem>> listOfListFilter;
  final void Function(String)? onSearch;
  const CretaBannerPane(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.title,
      required this.description,
      required this.listOfListFilter,
      this.onSearch});

  @override
  State<CretaBannerPane> createState() => _CretaBannerPaneState();
}

class _CretaBannerPaneState extends State<CretaBannerPane> {
  @override
  Widget build(BuildContext context) {
    double internalWidth = widget.width -
        LayoutConst.cretaTopTitlePaddingLT.width -
        LayoutConst.cretaTopTitlePaddingRB.width;
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            left: LayoutConst.cretaTopTitlePaddingLT.width,
            top: LayoutConst.cretaTopTitlePaddingLT.height,
            child: Container(
              width: internalWidth,
              height: LayoutConst.cretaTopTitleHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.2),
                boxShadow: StudioSnippet.fullShadow(),
              ),
              clipBehavior: Clip.antiAlias,
              child: _titlePane(
                title: widget.title,
                description: widget.description,
              ),
            ),
          ),
          Positioned(
            left: LayoutConst.cretaTopFilterPaddingLT.width,
            top: LayoutConst.cretaTopFilterPaddingLT.height,
            child: Container(
              width: internalWidth,
              height: LayoutConst.cretaTopFilterHeight,
              color: Colors.white,
              child: _filterPane(),
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   width: widget.width,
    //   height: widget.height,
    //   color: widget.color,
    //   child: Padding(
    //     padding: LayoutConst.cretaTopPadding,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Container(
    //           height: 76,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(7.2),
    //             boxShadow: StudioSnippet.fullShadow(),
    //           ),
    //           clipBehavior: Clip.antiAlias,
    //           child: _titlePane(
    //             title: widget.title,
    //             description: widget.description,
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         Container(
    //           height: 36,
    //           color: Colors.white,
    //           child: _filterPane(),
    //         )
    //       ],
    //     ),
    //   ),
    // );
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
        widget.width > 700
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
    );
  }

  Widget _titlePane({Widget? icon, required String title, required String description}) {
    String desc = '${AccountManager.currentLoginUser.name} $description';
    double titleWidth = title.length * CretaFont.titleELarge.fontSize! * 1.2 + 12 * 2 + 80;
    double descWidth = desc.length * CretaFont.bodyMedium.fontSize! * 1.2 + 12 * 2;
    return Padding(
      padding: const EdgeInsets.only(left: 28),
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
        ],
      ),
    );
  }
}
