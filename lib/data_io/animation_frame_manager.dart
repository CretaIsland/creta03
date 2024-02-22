// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/database/abs_database.dart';

// import 'package:creta_common/model/app_enums.dart';
// import 'package:creta_studio_model/model/frame_model.dart';
// import 'frame_manager.dart';

// class AnimationFrameManager extends FrameManager {
//   @override
//   Future<FrameModel> createNextFrame() async {
//     updateLastOrder();
//     FrameModel defaultFrame =
//         FrameModel.makeSample(++lastOrder, pageModel!.mid, pType: FrameType.animation);
//     await createToDB(defaultFrame);
//     insert(defaultFrame, postion: getAvailLength());
//     selectedMid = defaultFrame.mid;
//     return defaultFrame;
//   }

//   @override
//   Future<int> getFrames({int limit = 99}) async {
//     logger.finest('getFrames');
//     Map<String, QueryValue> query = {};
//     query['parentMid'] = QueryValue(value: 'TEMPLATE');
//     query['isRemoved'] = QueryValue(value: false);
//     query['frameType'] = QueryValue(value: FrameType.animation.index);
//     Map<String, OrderDirection> orderBy = {};
//     orderBy['order'] = OrderDirection.ascending;
//     await queryFromDB(query, orderBy: orderBy, limit: limit);
//     logger.finest('getFrames ${modelList.length}');
//     updateLastOrder();
//     return modelList.length;
//   }
// }
