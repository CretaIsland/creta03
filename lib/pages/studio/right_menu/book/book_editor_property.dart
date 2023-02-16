// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/book_model.dart';
import '../property_mixin.dart';

class BookEditorProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  const BookEditorProperty({super.key, required this.model, required this.parentNotify});

  @override
  State<BookEditorProperty> createState() => _BookEditorPropertyState();
}

class _BookEditorPropertyState extends State<BookEditorProperty> with PropertyMixin {
  @override
  void initState() {
    logger.finer('_BookEditorPropertyState.initState');
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
          child: Text(CretaStudioLang.onLine, style: CretaFont.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(CretaStudioLang.offLine, style: CretaFont.titleSmall),
        ),
      ],
    );
  }
}
