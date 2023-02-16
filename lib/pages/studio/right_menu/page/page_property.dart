// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/data_io/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';

import '../../../../design_system/creta_font.dart';
import '../../../../model/book_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../property_mixin.dart';

class PageProperty extends StatefulWidget {
  const PageProperty({super.key});

  @override
  State<PageProperty> createState() => _PagePropertyState();
}

class _PagePropertyState extends State<PageProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;
  BookModel? _book;
  // ignore: unused_field
  PageModel? _pageModel;
  // ignore: unused_field
  PageManager? _pageManager;

  @override
  void initState() {
    logger.finer('_PagePropertyState.initState');
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _book = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
      if (_book == null) {
        return Center(
          child: Text("No CretaBook Selected", style: CretaFont.titleLarge),
        );
      }
      _pageManager = pageManager;
      pageManager.reOrdering();
      _pageModel = pageManager.getSelected();
      return Column(
        children: const [
          Text('page property'),
        ],
      );
    });
  }
}

// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.label,
//     required this.onDeleted,
//     required this.index,
//   });

//   final String label;
//   final ValueChanged<int> onDeleted;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       clipBehavior: Clip.antiAlias,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//         side: BorderSide(
//           width: 1,
//           color: CretaColor.text[700]!,
//         ),
//       ),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//       label: Text(
//         '#$label',
//         style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
//       ),
//       deleteIcon: Icon(
//         Icons.close,
//         size: 18,
//       ),
//       onDeleted: () {
//         onDeleted(index);
//       },
//     );
//   }
// }
