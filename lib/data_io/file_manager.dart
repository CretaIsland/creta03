// import 'package:flutter/material.dart';
// import 'package:hycop/common/util/config.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';
// import 'package:hycop/hycop/hycop_factory.dart';
// import 'package:hycop/hycop/model/file_model.dart';
// // ignore: unnecessary_import
// import 'package:flutter/foundation.dart';

// FileManager? fileManagerHolder;

// class FileManager extends ChangeNotifier {
//   List<FileModel> imgFileList = [];
//   List<FileModel> videoFileList = [];
//   List<FileModel> etcFileList = [];

//   void notify() => notifyListeners();

//   Future<void> getImgFileList() async {
//     debugPrint("----Start obtaining image list----");
//     imgFileList = [];

//     final res = (await HycopFactory.storage!.getMultiFileData(search: "content/image/"));
//     for (var element in res!) {
//       imgFileList.add(FileModel(
//             id: element.id,
//             name: element.name,
//             url: element.url,
//             thumbnailUrl: element.thumbnailUrl,
//             size: element.size,
//             contentType: element.contentType));
//     }

//     debugPrint("----Done----");
//     notifyListeners();
//   }

//   Future<void> getVideoFileList() async {
//     debugPrint("----Start obtaining video list----");
//     videoFileList = [];

//     final res = await HycopFactory.storage!.getMultiFileData(search: "content/video/");
//     for (var element in res!) {
//       imgFileList.add(FileModel(
//             id: element.id,
//             name: element.name,
//             url: element.url,
//             thumbnailUrl: element.thumbnailUrl,
//             size: element.size,
//             contentType: element.contentType));
//     }
//     debugPrint("----Done----");
//     notifyListeners();
//   }

//   Future<void> getEtcFileList() async {
//     etcFileList = [];

//     final res = await HycopFactory.storage!.getMultiFileData(search: "content/etc/");
//     for (var element in res!) {
//       imgFileList.add(FileModel(
//             id: element.id,
//             name: element.name,
//             url: element.url,
//             thumbnailUrl: element.thumbnailUrl,
//             size: element.size,
//             contentType: element.contentType));
//     }
//     notifyListeners();
//   }

//   ImageProvider<Object> getThumbnail(String fileId) {
//     // get thumbnail logic
//     // ignore: prefer_const_declarations
//     final thumbnailView = null;

//     if (thumbnailView == null) {
//       return Image.asset("assets/video_icon.png").image;
//     } else {
//       if (HycopFactory.serverType == ServerType.appwrite) {
//         return Image.memory(thumbnailView.fileView).image;
//       }
//       return NetworkImage(thumbnailView);
//     }
//   }

//   Future<void> deleteFile(String fileId, ContentsType contentsType) async {
//     await HycopFactory.storage!.deleteFile(fileId);
//     switch (contentsType) {
//       case ContentsType.image:
//         imgFileList.removeWhere((element) => element.id == fileId);
//         break;
//       case ContentsType.video:
//         videoFileList.removeWhere((element) => element.id == fileId);
//         break;
//       default:
//         etcFileList.removeWhere((element) => element.id == fileId);
//         break;
//     }
//     notifyListeners();
//   }
// }
