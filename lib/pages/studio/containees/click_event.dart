import 'dart:async';

import 'package:hycop/common/util/logger.dart';
//import 'package:mutex/mutex.dart';
import '../../../common/creta_utils.dart';
import '../../../model/creta_model.dart';
import '../studio_getx_controller.dart';

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
  //static final _lock = Mutex();
  static final Map<String, ClickReceiver> _eventReceived = {};
  static Timer? _timer;

  static void init() {
    //_timer ??= Timer.periodic(const Duration(milliseconds: 100), _timerFunction);
  }

  static void eventOn(String eventName) {
    //_lock.acquire();
    _eventReceived[eventName] = ClickReceiver(eventName);
    logger.fine('eventOn($eventName)=${_eventReceived[eventName]!.eventName}');
    //_lock.release();
  }

  static void eventOff(String eventName) {
    //_lock.acquire();
    _eventReceived.remove(eventName);
    //_lock.release();
  }

  static bool isEventOn(String eventName) {
    bool retval = false;
    //_lock.acquire();
    retval = _eventReceived[eventName] == null ? false : true;
    //_lock.release();
    logger.fine('isEventOn($eventName)=$retval');
    return retval;
  }

  // ignore: unused_element
  static void _timerFunction(Timer timer) {
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

  static void deleteTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      logger.finest('delete timer');
    }
  }
}

class ClickEvent {
  final CretaModel model;
  final StudioEventController eventController;
  ClickEvent({required this.model, required this.eventController});
}

class ClickEventHandler {
  static Map<String, Map<String, ClickEvent>> registerMap = {};
  //static final _lock = Mutex();

  ClickEventHandler();

  static void subscribeList(
      String eventNameStringList, CretaModel model, StudioEventController eventController) {
    //_lock.acquire();
    logger.fine('subscribeList($eventNameStringList, ${model.mid}) ');

    // 먼저 해당 모델로 된 subsribe 를 모두 지워야 한다.
    for (Map<String, ClickEvent> valueMap in registerMap.values) {
      valueMap.remove(model.mid);
    }

    if (eventNameStringList.isEmpty || eventNameStringList.length <= 2) {
      return;
    }

    List<String> eventNameList = CretaUtils.jsonStringToList(eventNameStringList);
    for (String eventName in eventNameList) {
      _subscribe(eventName, model, eventController);
    }
    //_lock.release();
  }

  static void _subscribe(
      String eventName, CretaModel model, StudioEventController eventController) {
    //_lock.acquire();
    logger.fine('subscribe($eventName, ${model.mid}) ');
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    if (eventMap == null) {
      eventMap = {};
      registerMap[eventName] = eventMap;
    }
    eventMap[model.mid] = ClickEvent(model: model, eventController: eventController);
    //_lock.release();
  }

  // ignore: unused_element
  static void _unsubscribe(String eventName, String mid) {
    logger.fine('unsubscribe($eventName, $mid) ');
    //_lock.acquire();
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    eventMap?.remove(mid);
    //_lock.release();
  }

  static void publish(String eventName) {
    // _lock.acquire();
    logger.fine('publish($eventName) ');
    Map<String, ClickEvent>? eventMap = registerMap[eventName];
    if (eventMap == null) {
      logger.fine('NO SUBS EVENT');
      //_lock.release();
      return;
    }
    eventMap.map((key, value) {
      ClickReceiverHandler.eventOn(eventName);
      logger.fine('publish($eventName) key=$key');
      value.eventController.sendEvent(value.model);
      return MapEntry(key, value);
    });
    //_lock.release();
  }
}
