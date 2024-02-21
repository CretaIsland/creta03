import 'dart:async';

import 'package:hycop/common/util/logger.dart';
//import 'package:mutex/mutex.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../data_io/page_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import '../book_main_page.dart';
import '../studio_getx_controller.dart';
import 'containee_nofifier.dart';

class ClickReceiver {
  final String eventName;
  late DateTime receivedTime;
  ClickReceiver(
    this.eventName,
  ) {
    receivedTime = DateTime.now();
  }
}

class ClickReceiverHandler {
  // final _lock = Mutex();
  final Map<String, ClickReceiver> _eventReceived = {};
  Timer? _timer;

  void init() {
    //_timer ??= Timer.periodic(const Duration(milliseconds: 100), _timerFunction);
  }

  void eventOn(String eventName) {
    //_lock.acquire();
    _eventReceived[eventName] = ClickReceiver(eventName);
    logger.fine('eventOn($eventName)=${_eventReceived[eventName]!.eventName}');
    //_lock.release();
  }

  void eventOff(String eventName) {
    //_lock.acquire();
    _eventReceived.remove(eventName);
    //_lock.release();
  }

  bool isEventOn(String eventName) {
    bool retval = false;
    //_lock.acquire();
    retval = _eventReceived[eventName] == null ? false : true;
    //_lock.release();
    logger.fine('isEventOn($eventName)=$retval');
    return retval;
  }

  // ignore: unused_element
  void _timerFunction(Timer timer) {
    List<String> deleteTargetList = [];
    _eventReceived.map((key, value) {
      if (DateTime.now().millisecondsSinceEpoch - value.receivedTime.millisecondsSinceEpoch >
          1000) {
        deleteTargetList.add(key);
      }
      return MapEntry(key, value);
    });
    for (String ele in deleteTargetList) {
      logger.fine('delete event $ele');
      _eventReceived.remove(ele);
    }
  }

  void deleteTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      logger.finest('delete timer');
    }
  }
}

class ClickEvent {
  final CretaModel model;
  StudioEventController? eventController;
  PageManager? pageManager;
  ClickEvent({required this.model, this.eventController, this.pageManager});
}

class ClickEventHandler {
  Map<String, Map<String, ClickEvent>> registerMap = {};
  // final _lock = Mutex();

  ClickEventHandler();

  void subscribeList(String eventNameStringList, CretaModel model,
      StudioEventController? eventController, PageManager? pageManager) {
    //_lock.acquire();
    logger.fine('subscribeList($eventNameStringList, ${model.mid}) ');

    // 먼저 해당 모델로 된 subsribe 를 모두 지워야 한다.
    for (Map<String, ClickEvent> valueMap in registerMap.values) {
      valueMap.remove(model.mid);
    }

    if (eventNameStringList.isEmpty || eventNameStringList.length <= 2) {
      return;
    }

    List<String> eventNameList = CretaCommonUtils.jsonStringToList(eventNameStringList);
    for (String eventName in eventNameList) {
      _subscribe(eventName, model, eventController, pageManager);
    }
    //_lock.release();
  }

  void _subscribe(String eventName, CretaModel model, StudioEventController? eventController,
      PageManager? pageManager) {
    //_lock.acquire();
    logger.fine('subscribe($eventName, ${model.mid}) ');
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    if (eventMap == null) {
      eventMap = {};
      registerMap[eventName] = eventMap;
    }
    eventMap[model.mid] =
        ClickEvent(model: model, eventController: eventController, pageManager: pageManager);
    //_lock.release();
  }

  // ignore: unused_element
  void _unsubscribe(String eventName, String mid) {
    logger.fine('unsubscribe($eventName, $mid) ');
    //_lock.acquire();
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    eventMap?.remove(mid);
    //_lock.release();
  }

  void publish(String eventName) {
    // _lock.acquire();
    logger.fine('publish($eventName) ');
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    if (eventMap == null) {
      logger.fine('NO SUBS EVENT');
      //_lock.release();
      return;
    }
    eventMap.map((key, value) {
      BookMainPage.clickReceiverHandler.eventOn(eventName);
      logger.fine('publish($eventName) key=$key');
      value.eventController?.sendEvent(value.model);
      if (value.pageManager != null) {
        value.pageManager?.setSelectedMid(value.model.mid);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
      }
      return MapEntry(key, value);
    });
    //_lock.release();
  }
}
