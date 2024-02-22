import 'dart:ui';

import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

import '../data_io/frame_manager.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import 'package:creta_studio_model/model/frame_model.dart';

class FrameModelUtil {
  static void toggeleOverlay(bool value, FrameManager frameManager, FrameModel model) {
    mychangeStack.startTrans();
    if (value == true) {
      double maxOrder = BookMainPage.getMaxOrderInBook();
      // 오버레이는 북에서 최고 높은 order 를 가진다.
      // 이미 있는  overlay 를 포함하여 값을 구한다.
      // 이떄  order 는 다른 대역폭에서 논다.
      if (maxOrder < 1000000.0) {
        maxOrder += 1000000.0;
      }
      model.order.set(maxOrder + 1);
      model.isOverlay.set(value);
      //BookMainPage.addOverlay(this);
      MyChange<FrameModel> c = MyChange<FrameModel>(
        model,
        execute: () async {
          BookMainPage.addOverlay(model);
          BookMainPage.pageManagerHolder!.notify();
        },
        redo: () async {
          BookMainPage.addOverlay(model);
          BookMainPage.pageManagerHolder!.notify();
        },
        undo: (FrameModel old) async {
          BookMainPage.removeOverlay(model.mid);
          BookMainPage.pageManagerHolder!.notify();
        },
      );
      mychangeStack.add(c);
    } else {
      // order 도 내려야 한다.  order 를 구한다음.  isOveraly 를 풀어야 한다.
      // 이때  order 는 overlay 를 포함하지 않는다.  local maxOrder
      double maxOrder = frameManager.getMaxOrder();
      model.order.set(maxOrder + 1);
      model.isOverlay.set(value);
      //BookMainPage.removeOverlay(mid);
      MyChange<FrameModel> c = MyChange<FrameModel>(
        model,
        execute: () async {
          BookMainPage.removeOverlay(model.mid);
          BookMainPage.pageManagerHolder!.notify();
        },
        redo: () async {
          BookMainPage.removeOverlay(model.mid);
          BookMainPage.pageManagerHolder!.notify();
        },
        undo: (FrameModel old) async {
          BookMainPage.addOverlay(model);
          BookMainPage.pageManagerHolder!.notify();
        },
      );
      mychangeStack.add(c);
    }
    mychangeStack.endTrans();
  }

  static double getRealPosX(FrameModel model) {
    return (model.posX.value * StudioVariables.applyScale) +
        BookMainPage.pageOffset.dx -
        (LayoutConst.stikerOffset / 2);
  }

  static double getRealPosY(FrameModel model) {
    return (model.posY.value * StudioVariables.applyScale) +
        BookMainPage.pageOffset.dy -
        (LayoutConst.stikerOffset / 2);
  }

  static Size getRealSize(FrameModel model) {
    return Size(model.width.value * StudioVariables.applyScale,
        model.height.value * StudioVariables.applyScale);
  }

  static void toggeleBackgoundMusic(
      bool value, FrameManager frameManager, BookModel book, FrameModel model) {
    // 뮤직인 경우 백그라운드 뮤직이 된다.
    mychangeStack.startTrans();
    if (value == true) {
      //print('set background');
      BookMainPage.backGroundMusic = model;
      book.backgroundMusicFrame.set(model.mid);
      model.isShow.set(false);
    } else {
      //print('release background');
      BookMainPage.backGroundMusic = null;
      book.backgroundMusicFrame.set('');
      model.isShow.set(true);
    }
    mychangeStack.endTrans();
    BookMainPage.bookManagerHolder?.notify();
    return;
  }

  static bool isBackgroundMusic(FrameModel model) {
    return model.isMusicType() &&
        BookMainPage.backGroundMusic != null &&
        BookMainPage.backGroundMusic!.mid == model.mid;
  }

  static bool isVisible(String pageMid, FrameModel model) {
    if (model.isRemoved.value == true) return false;

    if (model.eventReceive.value.length > 2 && model.showWhenEventReceived.value == true) {
      logger.fine(
          '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
      List<String> eventNameList = CretaCommonUtils.jsonStringToList(model.eventReceive.value);
      for (String eventName in eventNameList) {
        if (BookMainPage.clickReceiverHandler.isEventOn(eventName) == true) {
          return true;
        }
      }
      return false;
    }
    if (BookMainPage.filterManagerHolder!.isVisible(model) == false) {
      return false;
    }

    if (model.isThisPageExclude(pageMid)) {
      return false;
    }
    return model.isShow.value;
  }

  static bool isDropAble(FrameModel model) {
    if (LinkParams.isLinkNewMode) {
      return false;
    }
    switch (model.frameType) {
      case FrameType.text:
        return false;
      // case FrameType.music:
      //   return false;
      case FrameType.weather1:
        return false;
      case FrameType.weather2:
        return false;
      case FrameType.weatherSticker1:
        return false;
      case FrameType.weatherSticker2:
        return false;
      case FrameType.weatherSticker3:
        return false;
      case FrameType.analogWatch:
        return false;
      case FrameType.digitalWatch:
        return false;
      case FrameType.stopWatch:
        return false;
      case FrameType.dateTimeFormat:
        return false;
      case FrameType.countDownTimer:
        return false;
      case FrameType.sticker:
        return false;
      case FrameType.showcaseTimeline:
        return false;
      case FrameType.footballTimeline:
        return false;
      case FrameType.activityTimeline:
        return false;
      case FrameType.successTimeline:
        return false;
      case FrameType.deliveryTimeline:
        return false;
      case FrameType.weatherTimeline:
        return false;
      case FrameType.monthHorizTimeline:
        return false;
      case FrameType.appHorizTimeline:
        return false;
      case FrameType.deliveryHorizTimeline:
        return false;
      case FrameType.camera:
        return false;
      case FrameType.map:
        return false;
      default:
        return true;
    }
  }
}
