// import 'package:hycop/hycop/absModel/abs_ex_model.dart';
// import 'package:creta_common/model/creta_model.dart';
// import '../model/message_model.dart';
// import 'package:creta_user_io/data_io/creta_manager.dart';

// MessageManager? messageManagerHolder;

// class MessageManager extends CretaManager {
//   MessageManager() : super('creta_message');
//   @override
//   AbsExModel newModel(String mid) => MessageModel(mid);

//   @override
//   CretaModel cloneModel(CretaModel src) {
//     MessageModel retval = newModel(src.mid) as MessageModel;
//     src.copyTo(retval);
//     return retval;
//   }
