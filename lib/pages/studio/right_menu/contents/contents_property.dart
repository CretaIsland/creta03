// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/creta_font.dart';
import '../../../../model/contents_model.dart';

class ContentsProperty extends StatefulWidget {
  final ContentsModel model;
  const ContentsProperty({super.key, required this.model});

  @override
  State<ContentsProperty> createState() => _ContentsPropertyState();
}

class _ContentsPropertyState extends State<ContentsProperty> {
  @override
  void initState() {
    logger.finest('_ContentsPropertyState.initState');
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      widget.model.name,
      style: CretaFont.titleLarge,
    ));
  }
}
