// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';
import '../../../data_io/book_manager.dart';
import '../../../design_system/creta_color.dart';
import '../studio_constant.dart';
import '../studio_variables.dart';

class RightMenuBook extends StatefulWidget {
  const RightMenuBook({super.key});

  @override
  State<RightMenuBook> createState() => _RightMenuBookState();
}

class _RightMenuBookState extends State<RightMenuBook> {
  // ignore: unused_field
  BookManager? _bookManager;
  // ignore: unused_field
  late ScrollController _scrollController;

  final double verticalPadding = 10;
  final double horizontalPadding = 24;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_RightMenuBookState.initState');
    _scrollController = ScrollController(initialScrollOffset: 0.0);

    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      _bookManager = bookManager;
      return Column(
        children: [
          _menuBar(),
          _pageView(),
        ],
      );
    });
  }

  Widget _menuBar() {
    return Container(
      height: menuBarHeight,
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
    );
  }

  Widget _pageView() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: StudioVariables.workHeight,
      width: LayoutConst.rightMenuWidth,
    );
  }
}
