import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../common/creta_constant.dart';
import '../../data_io/creta_manager.dart';
import '../../data_io/frame_manager.dart';
import '../../model/creta_model.dart';
import '../../model/page_model.dart';
import '../login_page.dart';
import 'book_main_page.dart';
import 'studio_constant.dart';

class StudioVariables {
  static double topMenuBarHeight = LayoutConst.topMenuBarHeight;
  static double menuStickWidth = LayoutConst.menuStickWidth;
  static double appbarHeight = CretaConstant.appbarHeight;

  static double verticalScrollOffset = 0;
  static double horizontalScrollOffset = 0;

  static double fitScale = 1.0;
  static double scale = 1.0;
  static bool autoScale = true;
  static bool allowMutilUser = true;

  static double displayWidth = 1920;
  static double displayHeight = 961;
  static Size displaySize = Size.zero;

  static double workWidth = 1920 - 80;
  static double workHeight = 961;
  static double workRatio = 1;

  static double availWidth = 0; // work width의 90% 영역
  static double availHeight = 0; // work height의 90% 영역

  static double virtualWidth = 1920 - 80;
  static double virtualHeight = 961;

  static bool isHandToolMode = false;

  static double applyScale = 1;

  static bool isMute = false;
  static bool isReadOnly = false;
  static bool isAutoPlay = true;

  static bool isPreview = false;

  static bool isFullscreen = false;

  static CretaModel? clipBoard;
  static String? clipBoardDataType;
  static String? clipBoardAction;
  static CretaManager? clipBoardManager;

  static void clearClipBoard() {
    clipBoard = null;
    clipBoardDataType = null;
    clipBoardAction = null;
  }

  static void clipFrame(CretaModel model, CretaManager manager) {
    clipBoard = model;
    clipBoardDataType = 'frame';
    clipBoardAction = 'copy';
    clipBoardManager = manager;
  }

  static void clipPage(CretaModel model, CretaManager manager) {
    clipBoard = model;
    clipBoardDataType = 'page';
    clipBoardAction = 'copy';
    clipBoardManager = manager;
  }

  static void cropFrame(CretaModel model, CretaManager manager) {
    clipBoard = model;
    clipBoardDataType = 'frame';
    clipBoardAction = 'crop';
    clipBoardManager = manager;
  }

  static void cropPage(CretaModel model, CretaManager manager) {
    clipBoard = model;
    clipBoardDataType = 'page';
    clipBoardAction = 'crop';
    clipBoardManager = manager;
  }

  static void globalToggleMute({bool save = true}) {
    StudioVariables.isMute = !StudioVariables.isMute;
    if (save) {
      LoginPage.userPropertyManagerHolder?.setMute(StudioVariables.isMute);
    }
    if (BookMainPage.pageManagerHolder == null) {
      return;
    }
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) {
      return;
    }
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    if (frameManager == null) {
      return;
    }
    if (StudioVariables.isMute == true) {
      logger.info('frameManager.setSoundOff()--------');
      frameManager.setSoundOff();
    } else {
      logger.info('frameManager.resumeSound()--------');
      frameManager.resumeSound();
    }
  }

  static void globalToggleAutoPlay(
      // OffsetEventController? linkSendEvent,
      // AutoPlayChangeEventController? autoPlaySendEvent,
      {
    bool save = true,
    bool? forceValue,
  }) {
    if (forceValue == null) {
      StudioVariables.isAutoPlay = !StudioVariables.isAutoPlay;
    } else {
      StudioVariables.isAutoPlay = forceValue;
    }
    if (save) {
      LoginPage.userPropertyManagerHolder?.setAutoPlay(StudioVariables.isAutoPlay);
    }

    // _sendEvent 가 필요
    //linkSendEvent?.sendEvent(const Offset(1, 1));
    //autoPlaySendEvent?.sendEvent(StudioVariables.isAutoPlay);

    if (BookMainPage.pageManagerHolder == null) {
      return;
    }
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) {
      return;
    }
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    if (frameManager == null) {
      return;
    }
    if (StudioVariables.isAutoPlay == true) {
      logger.info('frameManager.resume()--------');
      frameManager.resume();
    } else {
      logger.info('frameManager.pause()--------');
      frameManager.pause();
    }
  }
}

class LinkParams {
  static bool isLinkNewMode = false;
  static bool isLinkEditMode = false;
  static String connectedMid = '';
  static String connectedClass = '';
  static Offset? linkPostion;
  static Offset? orgPostion;
  static String? invokerMid;

  //static bool get isLinkState => isLinkEditMode || isLinkNewMode;
  //static bool get isNotLinkState => !isLinkEditMode && !isLinkNewMode;

  static bool linkNew(CretaModel model) {
    if (LinkParams.isLinkNewMode == true) {
      if (StudioVariables.isAutoPlay == true) {
        StudioVariables.globalToggleAutoPlay(forceValue: false);
      }
      LinkParams.connectedMid = model.mid;
      LinkParams.connectedClass = model.type.name;
      // if (StudioVariables.isLinkEditMode == false) {
      //   StudioVariables.isLinkEditMode = true;
      // }
      return true;
    }
    return false;
  }

  static bool linkCancel(CretaModel model) {
    if (LinkParams.isLinkNewMode == false) {
      LinkParams.connectedMid = '';
      LinkParams.connectedClass = '';

      // if (StudioVariables.isLinkEditMode == false) {
      //   StudioVariables.isLinkEditMode = true;
      // }
      return true;
    }
    return false;
  }
}
