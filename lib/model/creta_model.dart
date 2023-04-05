// ignore_for_file: must_be_immutable, use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../data_io/creta_manager.dart';
import '../design_system/component/snippet.dart';

class CretaModelSnippet {
  static FutureBuilder<List<AbsExModel>> waitData({
    required CretaManager manager,
    //required String userId,
    required Widget Function()? consumerFunc,
  }) {
    return FutureBuilder<List<AbsExModel>>(
        future: manager.isGetListFromDBComplete(),
        builder: (context, AsyncSnapshot<List<AbsExModel>> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatat)");
            return const Center(child: Text('data fetch error(WaitDatat)'));
          }
          if (snapshot.hasData == false) {
            logger.finest("wait data ...(WaitDatat)");
            return Center(
              child: Snippet.showWaitSign(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("founded ${snapshot.data!.length}");
            // if (snapshot.data!.isEmpty) {
            //   return const Center(child: Text('no book founded'));
            // }
            if (consumerFunc != null) {
              return consumerFunc();
            }
            return const SizedBox.shrink();
          }
          return Container();
        });
  }

  static FutureBuilder<bool> waitDatum({
    required List<CretaManager> managerList,
    required Widget Function()? consumerFunc,
  }) {
    return FutureBuilder<bool>(
        future: CretaModelSnippet._waitUntilAllManager(managerList),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatum)");
            return const Center(child: Text('data fetch error(WaitDatum)'));
          }
          if (snapshot.hasData == false) {
            logger.finest("wait data ...(WaitData)");
            return Center(
              child: Snippet.showWaitSign(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("founded ${snapshot.data!}");
            // if (snapshot.data!.isEmpty) {
            //   return const Center(child: Text('no book founded'));
            // }
            if (consumerFunc != null) {
              return consumerFunc();
            }
            return const SizedBox.shrink();
          }
          return Container();
        });
  }

  static Future<bool> _waitUntilAllManager(List<CretaManager> managerList) async {
    for (var manager in managerList) {
      await manager.isGetListFromDBComplete();
    }
    return true;
  }
}

class CretaModel extends AbsExModel {
  final GlobalKey key = GlobalKey();
  CretaModel({required String pmid, required super.type, required super.parent})
      : super(pmid: pmid);
}
