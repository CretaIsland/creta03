import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';

class StudioEventController extends GetxController {
  final eventStream = StreamController<CretaModel>.broadcast();

  // Method to send an event
  void sendEvent(CretaModel model) {
    eventStream.add(model);
  }
}

class BoolEventController extends GetxController {
  final eventStream = StreamController<bool>.broadcast();

  // Method to send an event
  void sendEvent(bool value) {
    eventStream.add(value);
  }
}

class OffsetEventController extends GetxController {
  final eventStream = StreamController<Offset>.broadcast();

  // Method to send an event
  void sendEvent(Offset offset) {
    eventStream.add(offset);
  }
}

class FrameEachEventController extends GetxController {
  final eventStream = StreamController<bool>.broadcast();

  // Method to send an event
  void sendEvent(bool val) {
    eventStream.add(val);
  }
}

class FrameEventController extends StudioEventController {
  // Define an event stream
  // final eventStream = StreamController<FrameModel>.broadcast();

  // // Method to send an event
  // void sendEvent(FrameModel model) {
  //   eventStream.add(model);
  // }
}

class PageEventController extends StudioEventController {
  // Define an event stream
  // final eventStream = StreamController<FrameModel>.broadcast();

  // // Method to send an event
  // void sendEvent(FrameModel model) {
  //   eventStream.add(model);
  // }
}

class ContentsEventController extends GetxController {
  final eventStream = StreamController<ContentsModel>.broadcast();

  // Method to send an event
  void sendEvent(ContentsModel model) {
    eventStream.add(model);
  }
}

// class PageEventController extends GetxController {
//   // Define an event stream
//   final eventStream = StreamController<PageModel>.broadcast();

//   // Method to send an event
//   void sendEvent(PageModel model) {
//     eventStream.add(model);
//   }
// }

class StudioGetXController extends GetxController {
  // FrameEventController? frameEvent;
  // PageEventController? pageEvent;
  @override
  void onInit() {
    // Initialize EventController1 instance with a tag
    //logger.fine('==========================StudioGetXController initialized================');
    Get.put(PageEventController(), tag: 'page-property-to-main');
    Get.put(PageEventController(), tag: 'page-main-to-property');

    Get.put(FrameEventController(), tag: 'frame-property-to-main');
    Get.put(FrameEventController(), tag: 'frame-main-to-property');

    Get.put(ContentsEventController(), tag: 'contents-property-to-main');
    Get.put(ContentsEventController(), tag: 'contents-main-to-property');

    Get.put(ContentsEventController(), tag: 'text-property-to-textplayer');
    Get.put(ContentsEventController(), tag: 'textplayer-to-text-property');

    Get.put(OffsetEventController(), tag: 'frame-each-to-on-link');
    Get.put(OffsetEventController(), tag: 'on-link-to-link-widget');

    Get.put(BoolEventController(), tag: 'link-widget-to-property');
    Get.put(BoolEventController(), tag: 'vertical-app-bar-to-creta-left-bar');

    Get.put(FrameEachEventController(), tag: 'to-FrameEach');

    Get.put(BoolEventController(), tag: 'draw-link');

    // Initialize EventController2 instance with a tag
    //Get.put(PageEventController(), tag: 'page-property-to-main');
    super.onInit();
  }

  @override
  void onClose() {
    //logger.fine('==========================StudioGetXController onClose================');
    super.onClose();
    //Dispose of eventController here
    // frameEvent?.onClose();
    // pageEvent?.onClose();
  }
}
