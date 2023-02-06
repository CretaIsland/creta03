// ignore_for_file: must_be_immutable, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../data_io/creta_manager.dart';
import '../design_system/creta_color.dart';

class CretaModelSnippet {
  static FutureBuilder<List<AbsExModel>> waitData(
    BuildContext context, {
    required CretaManager manager,
    required String userId,
    required Widget Function(BuildContext, List<AbsExModel>?) consumerFunc,
  }) {
    return FutureBuilder<List<AbsExModel>>(
        //future: manager.getListFromDB(userId),
        future: manager.isGetListFromDBComplete(),
        builder: (context, AsyncSnapshot<List<AbsExModel>> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error($userId)");
            return const Center(child: Text('data fetch error'));
          }
          if (snapshot.hasData == false) {
            logger.finest("wait data ...($userId)");
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: CretaColor.primary,
                size: 40.0,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("founded ${snapshot.data!.length}");
            // if (snapshot.data!.isEmpty) {
            //   return const Center(child: Text('no book founded'));
            // }
            return consumerFunc(context, snapshot.data);
          }
          return Container();
        });
  }
}

class CretaModel extends AbsExModel {
  final GlobalKey key = GlobalKey();
  CretaModel({required String pmid, required super.type, required super.parent})
      : super(pmid: pmid);
}
