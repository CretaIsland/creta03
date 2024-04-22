// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../property_mixin.dart';

class BookHistoryProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  const BookHistoryProperty({super.key, required this.model, required this.parentNotify});

  @override
  State<BookHistoryProperty> createState() => _BookHistoryPropertyState();
}

class _BookHistoryPropertyState extends State<BookHistoryProperty> with PropertyMixin {
  @override
  void initState() {
    logger.finer('_BookHistoryPropertyState.initState');
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(CretaStudioLang['bookHistory']!, style: CretaFont.titleSmall),
        ),
      ],
    );
  }
}
