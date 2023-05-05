// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:html' as html;
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';

// import '../../../../data_io/contents_manager.dart';

import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
// import '../../../../model/contents_model.dart';
// import '../../../../model/frame_model.dart';
// import '../../../../model/page_model.dart';
// import '../../book_main_page.dart';
// import '../../studio_snippet.dart';
// import '../containee_nofifier.dart';
// import 'sticker/draggable_stickers.dart';

mixin FramePlayMixin {
  FrameManager? frameManager;

  void initFrameManager() {
    frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  }

  Future<void> createNewFrameAndContents(List<ContentsModel> modelList, PageModel pageModel,
      {FrameModel? frameModel}) async {
    // 프레임을 생성한다.
    frameModel ??= await frameManager!.createNextFrame(doNotify: false);
    // 코텐츠를 play 하고 DB 에 Crete 하고 업로드까지 한다.
    logger.info('frameCretated(${frameModel.mid}');
    await ContentsManager.createContents(frameManager, modelList, frameModel, pageModel);
  }

  Future<void> createContent(
    ContentsModel model,
    PageModel? pageModel,
    FrameModel frameModel,
  ) async {
    if (pageModel != null) {
      return await createNewFrameAndContents(
        [model],
        pageModel,
        frameModel: frameModel,
      );
    }
  }
//   Future<void> createContents(
//       List<ContentsModel> contentsModelList, FrameModel frameModel, PageModel pageModel,
//       {bool isResizeFrame = true}) async {
//     // 콘텐츠 매니저를 생성한다.
//     ContentsManager? contentsManager = frameManager!.findContentsManager(frameModel.mid);
//     contentsManager ??= frameManager!.newContentsManager(frameModel);
//     //int counter = contentsModelList.length;

//     for (var contentsModel in contentsModelList) {
//       contentsModel.parentMid.set(frameModel.mid, save: false, noUndo: true);

//       if (contentsModel.contentsType == ContentsType.image) {
//         await _imageProcess(contentsManager, contentsModel, frameModel, pageModel,
//             isResizeFrame: isResizeFrame);
//       } else if (contentsModel.contentsType == ContentsType.video) {
//         // if (contentsManager.getAvailLength() == 1) {
//         //   contentsManager.setLoop(false);
//         // }
//         if (isResizeFrame) {
//           contentsManager.frameManager = frameManager;
//         }
//         await _videoProcess(contentsManager, contentsModel, isResizeFrame: isResizeFrame);
//       }
//       // 콘텐츠 객체를 DB에 Crete 한다.
//       await contentsManager.createNextContents(contentsModel, doNotify: false);
//     }
//     BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: true);
//     DraggableStickers.selectedAssetId = frameModel.mid;
//     frameManager!.setSelectedMid(frameModel.mid);
//     //frameManager!.notify();
//     // 플레이를 해야하는데, 플레이는 timer 가 model list 에 모델이 있을 경우 계속 돌리고 있게 된다.
//   }

//   Future<void> _imageProcess(ContentsManager contentsManager, ContentsModel contentsModel,
//       FrameModel frameModel, PageModel pageModel,
//       {required bool isResizeFrame}) async {
//     final reader = html.FileReader();
//     reader.readAsArrayBuffer(contentsModel.file!);
//     await reader.onLoad.first;
//     Uint8List blob = reader.result as Uint8List;

//     var image = await decodeImageFromList(blob);
//     // 그림의 가로 세로 규격을 알아낸다.
//     double imageWidth = image.width.toDouble();
//     double imageHeight = image.height.toDouble();

//     double pageHeight = pageModel.height.value;
//     double pageWidth = pageModel.width.value;

//     // width 가 더 크다
//     if (imageWidth > pageWidth) {
//       // 근데, width 가 page 를 넘어간다.
//       imageHeight = imageHeight * (pageWidth / imageWidth);
//       imageWidth = pageWidth;
//     }
//     //이렇게 했는데도, imageHeight 가 page 를 넘어간다.
//     if (imageHeight > pageHeight) {
//       imageWidth = imageWidth * (pageHeight / imageHeight);
//       imageHeight = pageHeight;
//     }

//     contentsModel.width.set(imageWidth, save: false, noUndo: true);
//     contentsModel.height.set(imageHeight, save: false, noUndo: true);
//     contentsModel.aspectRatio
//         .set(contentsModel.height.value / contentsModel.width.value, save: false, noUndo: true);

//     logger.info('contentsSize, ${contentsModel.width.value} x ${contentsModel.height.value}');

//     if (isResizeFrame) {
// // 그림의 규격에 따라 프레임 사이즈를 수정해 준다
//       frameManager?.resizeFrame(
//         frameModel,
//         contentsModel.aspectRatio.value,
//         contentsModel.width.value,
//         contentsModel.height.value,
//         invalidate: true,
//       );
//     }

//     // 업로드는  async 로 진행한다.
//     if (contentsModel.file != null &&
//         (contentsModel.remoteUrl == null || contentsModel.remoteUrl!.isEmpty)) {
//       // upload 되어 있지 않으므로 업로드한다.
//       StudioSnippet.uploadFile(contentsModel, contentsManager, blob);
//     }

//     return;
//   }

//   Future<void> _videoProcess(ContentsManager contentsManager, ContentsModel contentsModel,
//       {required bool isResizeFrame}) async {
//     //dropdown 하는 순간에 이미 플레이되고 있는 video 가 있다면, 정지시켜야 한다.
//     //contentsManager.pause();

//     if (contentsModel.file == null) {
//       return;
//     }

//     //bool uploadComplete = false;
//     html.FileReader fileReader = html.FileReader();
//     fileReader.onLoadEnd.listen((event) async {
//       logger.info('upload waiting ...............${contentsModel.name}');
//       StudioSnippet.uploadFile(contentsModel, contentsManager, fileReader.result as Uint8List);
//       fileReader = html.FileReader(); // file reader 초기화
//       //uploadComplete = true;
//       logger.info('upload complete');
//     });

//     // while (uploadComplete) {
//     //   await Future.delayed(const Duration(milliseconds: 100));
//     // }

//     fileReader.onError.listen((err) {
//       logger.severe('message: ${err.toString()}');
//     });

//     fileReader.readAsArrayBuffer(contentsModel.file!);
//     return;
//   }
}
