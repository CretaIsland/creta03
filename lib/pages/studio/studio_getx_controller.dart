import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

import '../../model/creta_model.dart';

class StudioEventController extends GetxController {
  final eventStream = StreamController<CretaModel>.broadcast();

  // Method to send an event
  void sendEvent(CretaModel model) {
    eventStream.add(model);
  }
}

class OffsetEventController extends GetxController {
  final eventStream = StreamController<Offset>.broadcast();

  // Method to send an event
  void sendEvent(Offset offset) {
    eventStream.add(offset);
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

class ContentsEventController extends StudioEventController {
  // Define an event stream
  // final eventStream = StreamController<FrameModel>.broadcast();

  // // Method to send an event
  // void sendEvent(FrameModel model) {
  //   eventStream.add(model);
  // }
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
