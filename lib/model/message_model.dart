// // ignore_for_file: prefer_const_constructors
// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/absModel/abs_ex_model.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';

// import 'creta_model.dart';

// // ignore: must_be_immutable
// class MessageModel extends CretaModel {
//   String sender = '';
//   String receiver = '';
//   String msg = '';
//   bool done = false;

//   @override
//   List<Object?> get props => [
//         ...super.props,
//         sender,
//         receiver,
//         msg,
//         done,
//       ];

//   MessageModel(String pmid) : super(pmid: pmid, type: ExModelType.page, parent: '');
//   MessageModel.makeSample(this.sender, this.receiver, this.msg, String pid)
//       : super(pmid: '', type: ExModelType.message, parent: pid);

//   @override
//   void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
//     super.copyFrom(src, newMid: newMid, pMid: pMid);
//     MessageModel srcMsg = src as MessageModel;
//     sender = srcMsg.sender;
//     receiver = srcMsg.receiver;
//     msg = srcMsg.msg;
//     done = srcMsg.done;
//   }

//   @override
//   void fromMap(Map<String, dynamic> map) {
//     super.fromMap(map);
//     sender = map["sender"] ?? '';
//     receiver = map["receiver"] ?? '';
//     msg = map["msg"] ?? '';
//     done = map["done"] ?? '';
//   }

//   @override
//   Map<String, dynamic> toMap() {
//     return super.toMap()
//       ..addEntries({
//         "sender": sender,
//         "receiver": receiver,
//         "msg": msg,
//         "done": done,
//       }.entries);
//   }

//   Future<bool> waitPageBuild() async {
//     while (key.currentContext == null) {
//       await Future.delayed(const Duration(milliseconds: 10));
//     }
//     logger.finest('page build complete !!!');
//     return true;
//   }
// }
