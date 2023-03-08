import 'dart:async';

import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';

import '../../model/frame_model.dart';

class FrameEventController extends GetxController {
  // Define an event stream
  final eventStream = StreamController<FrameModel>.broadcast();

  // Method to send an event
  void sendEvent(FrameModel model) {
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
    logger.info('==========================StudioGetXController initialized================');
    Get.put(FrameEventController(), tag: 'frame-property-to-main');
    Get.put(FrameEventController(), tag: 'frame-main-to-property');
    // Initialize EventController2 instance with a tag
    //Get.put(PageEventController(), tag: 'page-property-to-main');
    super.onInit();
  }

  @override
  void onClose() {
    logger.info('==========================StudioGetXController onClose================');
    super.onClose();
    //Dispose of eventController here
    // frameEvent?.onClose();
    // pageEvent?.onClose();
  }
}
