// ignore_for_file: must_be_immutable, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/absModel/abs_ex_model_manager.dart';

class CretaModelSnippet {
  static FutureBuilder<List<AbsExModel>> getData(
    BuildContext context, {
    required AbsExModelManager holder,
    required String userId,
    required Widget Function(BuildContext, List<AbsExModel>?) consumerFunc,
  }) {
    return FutureBuilder<List<AbsExModel>>(
        future: holder.getListFromDB(userId),
        builder: (context, AsyncSnapshot<List<AbsExModel>> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error($userId)");
            return const Center(child: Text('data fetch error'));
          }
          if (snapshot.hasData == false) {
            logger.severe("No data founded($userId)");
            return const Center(
              child: CircularProgressIndicator(),
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

  CretaModel({required super.type, required super.parent});
}
