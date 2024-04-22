//import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../design_system/text_field/creta_search_bar.dart';
import '../studio/book_grid_page.dart';
import 'book_select_page.dart';

class BookSelectFilter extends StatefulWidget {
  final void Function(String bookId, String name)? onSelected;
  final double width;
  final double height;
  const BookSelectFilter({super.key, this.onSelected, required this.width, required this.height});

  @override
  State<BookSelectFilter> createState() => _BookSelectFilterState();
}

class _BookSelectFilterState extends State<BookSelectFilter> {
  SelectedPage selectedPage = SelectedPage.myPage;
  String _searchText = '';

  late List<CretaMenuItem> _dropDownMenuItemList1;

  List<CretaMenuItem> _getFilterMenu() {
    return [
      CretaMenuItem(
        caption: SelectedPage.myPage.toDisplayString(),
        onPressed: () {
          setState(() {
            selectedPage = SelectedPage.myPage;
          });
        },
        selected: selectedPage == SelectedPage.myPage,
      ),
      CretaMenuItem(
        caption: SelectedPage.sharedPage.toDisplayString(),
        onPressed: () {
          setState(() {
            selectedPage = SelectedPage.sharedPage;
          });
        },
        selected: selectedPage == SelectedPage.sharedPage,
      ),
      CretaMenuItem(
        caption: SelectedPage.teamPage.toDisplayString(), //
        onPressed: () {
          setState(() {
            selectedPage = SelectedPage.teamPage;
          });
        },
        selected: selectedPage == SelectedPage.teamPage,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuItemList1 = _getFilterMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CretaDropDownButton(height: 36, dropDownMenuItemList: _dropDownMenuItemList1),
            // DropdownButton<SelectedPage>(
            //   style: const TextStyle(color: CretaColor.primary), // Change text color
            //   icon: const Icon(Icons.arrow_downward), // Change dropdown icon
            //   iconSize: 20, // Change icon size
            //   elevation: 16, // Change elevation
            //   underline: Container(
            //     // Change underline
            //     alignment: Alignment.bottomCenter,
            //     height: 2,
            //     color: Colors.deepPurpleAccent,
            //   ),
            //   value: selectedPage,
            //   items: <SelectedPage>[
            //     SelectedPage.myPage,
            //     SelectedPage.sharedPage,
            //     SelectedPage.teamPage
            //   ].map<DropdownMenuItem<SelectedPage>>((SelectedPage value) {
            //     return DropdownMenuItem<SelectedPage>(
            //       value: value,
            //       child: Text(value.toDisplayString()),
            //     );
            //   }).toList(),
            //   onChanged: (SelectedPage? newValue) {
            //     setState(() {
            //       selectedPage = newValue!;
            //     });
            //   },
            // ),
            CretaSearchBar(
              hintText: CretaLang['searchBar']!,
              onSearch: (value) {
                if (kDebugMode) print('widget.onSearch($value)');
                //bookManagerHolder!.onSearch(value, () => setState(() {}));
                setState(() {
                  _searchText = value;
                });
              },
              width: 246,
              height: 32,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: widget.width,
            height: widget.height * 0.8,
            child: BookSelectPage(
                key: GlobalObjectKey('BookSelectPage${selectedPage.index}$_searchText'),
                onSelected: widget.onSelected,
                selectedPage: selectedPage,
                searchText: _searchText),
          ),
        ),
      ],
    );
  }
}
