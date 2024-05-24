import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_const.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../login/creta_account_manager.dart';
import 'book_main_page.dart';
import 'containees/containee_nofifier.dart';
import 'studio_constant.dart';

enum ClickToCreateEnum {
  normal,
  textCreate,
  frameCreate,
}

class StudioVariables {
  static double pageDisplayRate = 0.849;
  static double maxMemoryPage = 5;
  static double pageVertivalPadding = 10;

  static String selectedBookMid = ''; // selected book mid
  static double topMenuBarHeight = LayoutConst.topMenuBarHeight;
  static double menuStickWidth = LayoutConst.menuStickWidth;
  static double appbarHeight = CretaConst.appbarHeight;

  static double verticalScrollOffset = 0;
  static double horizontalScrollOffset = 0;

  static double fitScale = 1.0; // autoFit 의 scale  값.
  static double scale = 1.0; // TopMenu 에 보이는 배율
  static bool autoScale = true;
  static bool allowMutilUser = true;

  static double displayWidth = 1920;
  static double displayHeight = 961;

  static double workWidth = 1920 - 80;
  static double workHeight = 961;
  static double workRatio = 1;

  // static double availWidth = 0; // work width의 90% 영역
  // static double availHeight = 0; // work height의 90% 영역

  static double virtualWidth = workWidth;
  static double virtualHeight = workHeight;

  static double availWidth = workWidth;
  static double availHeight = workHeight;

  static bool isHandToolMode = false;
  //static ClickToCreateEnum clickToCreateMode = ClickToCreateEnum.normal;

  static double applyScale = 1;

  static bool isMute = false;
  static bool isReadOnly = false;
  static bool isAutoPlay = true;
  static bool stopPaging = false;
  static bool stopNextContents = false;
  static bool useMagnet = true;
  static double magnetMargin = 3;

  static bool isSizeChanging = false;
  static bool isPreview = false;
  static bool hideMouse = false;

  static bool isFullscreen = false;

  static CretaModel? clipBoard;
  static String? clipBoardDataType;
  static String? clipBoardAction;
  static CretaManager? clipBoardManager;

  static bool isShiftPressed = false;
  static bool isCtrlPressed = false;
  static ContaineeEnum selectedKeyType = ContaineeEnum.None;

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
      CretaAccountManager.setMute(StudioVariables.isMute);
    }
    if (BookMainPage.pageManagerHolder == null) {
      return;
    }

    for (var frameManager in BookMainPage.pageManagerHolder!.frameManagerMap.values) {
      if (StudioVariables.isMute == true) {
        logger.fine('frameManager.setSoundOff()--------');
        frameManager!.setSoundOff();
      } else {
        logger.fine('frameManager.resumeSound()--------');
        frameManager!.resumeSound();
      }
    }

    // PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    // if (pageModel == null) {
    //   return;
    // }
    // FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    // if (frameManager == null) {
    //   return;
    // }
    // if (StudioVariables.isMute == true) {
    //   logger.fine('frameManager.setSoundOff()--------');
    //   frameManager.setSoundOff();
    // } else {
    //   logger.fine('frameManager.resumeSound()--------');
    //   frameManager.resumeSound();
    // }
  }

  static void globalToggleAutoPlay(
      // OffsetEventController? linkSendEvent,
      // FrameEachEventController? autoPlaySendEvent,
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
      CretaAccountManager.setAutoPlay(StudioVariables.isAutoPlay);
    }

    // _sendEvent 가 필요
    //linkSendEvent?.sendEvent(const Offset(1, 1));
    //autoPlaySendEvent?.sendEvent(StudioVariables.isAutoPlay);

    if (StudioVariables.isPreview && StudioVariables.stopPaging == true) {
      //프리뷰모드에서는 동영상 플레이가 정지하는 것이 아니고, 다음페이지로 넘어가지 않는 것이다.
      return;
    }

    if (BookMainPage.pageManagerHolder == null) {
      return;
    }
    for (var frameManager in BookMainPage.pageManagerHolder!.frameManagerMap.values) {
      if (StudioVariables.isAutoPlay == true) {
        logger.fine('frameManager.resume()--------');
        frameManager!.resume();
      } else {
        logger.fine('frameManager.pause()--------');
        frameManager!.pause();
      }
    }

    // PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    // if (pageModel == null) {
    //   return;
    // }
    // FrameManager? frameManager = BookMainPage.pageManagerHolder!.findFrameManager(pageModel.mid);
    // if (frameManager == null) {
    //   return;
    // }
    // if (StudioVariables.isAutoPlay == true) {
    //   logger.fine('frameManager.resume()--------');
    //   frameManager.resume();
    // } else {
    //   logger.fine('frameManager.pause()--------');
    //   frameManager.pause();
    // }
  }
}

class LinkParams {
  static bool isLinkNewMode = false;
  static bool isLinkEditMode = false;
  static String connectedMid = '';
  static String connectedClass = '';
  static String connectedName = '';
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

      if (model is FrameModel) {
        LinkParams.connectedName = model.name.value;
      } else if (model is PageModel) {
        LinkParams.connectedName = model.name.value;
      }
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
      LinkParams.connectedName = '';

      // if (StudioVariables.isLinkEditMode == false) {
      //   StudioVariables.isLinkEditMode = true;
      // }
      return true;
    }
    return false;
  }
}
