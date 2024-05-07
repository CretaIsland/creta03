import 'package:creta_common/model/app_enums.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

// enum ServiceType {
//   none,
//   signage,
//   barricade,
//   escalator,
//   board,
//   cdu,
//   etc,
//   end;

//   static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
//   static ServiceType fromInt(int? val) => ServiceType.values[validCheck(val ?? none.index)];
// }

enum DownloadResult {
  none,
  start,
  downloading,
  complete,
  fail,
  partial,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static DownloadResult fromInt(int? val) => DownloadResult.values[validCheck(val ?? none.index)];
}

// ignore: must_be_immutable
class HostModel extends CretaModel {
  ServiceType hostType = ServiceType.signage; // read only
  String hostId = ''; // read only
  String hostName = '';
  String ip = '';
  String interfaceName = ''; // read only
  String creator = ''; // read only
  String location = '';
  String description = '';
  String os = '';

  bool isConnected = false; // read only
  bool isInitialized = false; // read only
  bool isValidLicense = false; // read only
  bool isUsed = true;
  bool isOperational = true; // read only

  DateTime licenseTime = DateTime(1970, 1, 1); // read only
  DateTime initializeTime = DateTime(1970, 1, 1); // read only

  String thumbnailUrl = ''; // read only

  String weekend = '';
  String holiday = '';
  String powerOnTime = '';
  String powerOffTime = '';
  String requestedBook1 = '';
  String requestedBook1Id = '';
  String requestedBook2 = '';
  String requestedBook2Id = '';
  DateTime requestedBook1Time = DateTime(1970, 1, 1); // read only
  DateTime requestedBook2Time = DateTime(1970, 1, 1); // read only
  String playingBook1 = ''; // read only
  String playingBook2 = ''; // read only
  DateTime playingBook1Time = DateTime(1970, 1, 1); // read only
  DateTime playingBook2Time = DateTime(1970, 1, 1); // read only

  String notice1 = ''; // read only
  String notice2 = ''; // read only
  DateTime notice1Time = DateTime(1970, 1, 1); // read only
  DateTime notice2Time = DateTime(1970, 1, 1); // read only

  String request = ''; // read only
  DateTime requestedTime = DateTime(1970, 1, 1); // read only
  String response = ''; // read only

  DownloadResult downloadResult = DownloadResult.none; // read only
  String downloadMsg = ''; // read only

  String hddInfo = ''; // read only
  String cpuInfo = ''; // read only
  String memInfo = ''; // read only

  String stateMsg = ''; // read only
  DateTime bootTime = DateTime(1970, 1, 1); // read only
  DateTime shutdownTime = DateTime(1970, 1, 1); // read only

  double monthlyUseTime = 0.0; // read only

  HostModel(String pmid) : super(pmid: pmid, type: ExModelType.host, parent: '');
  HostModel.dummy()
      : super(pmid: HycopUtils.genMid(ExModelType.host), type: ExModelType.host, parent: '');

  HostModel.withName({
    super.type = ExModelType.host,
    required this.hostId,
    this.hostName = '',
    super.parent = '',
    this.interfaceName = '',
    this.ip = '',
    this.isConnected = false,
    this.thumbnailUrl = '',
    required super.pmid,
    required this.creator,
    required this.hostType,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        hostId,
        hostName,
        interfaceName,
        ip,
        isConnected,
        creator,
        location,
        description,
        thumbnailUrl,
        weekend,
        holiday,
        powerOnTime,
        powerOffTime,
        requestedBook1,
        requestedBook2,
        requestedBook1Id,
        requestedBook2Id,
        requestedBook1Time,
        requestedBook2Time,
        playingBook1,
        playingBook2,
        playingBook1Time,
        playingBook2Time,
        notice1,
        notice2,
        notice1Time,
        notice2Time,
        request,
        requestedTime,
        response,
        downloadResult,
        downloadMsg,
        hddInfo,
        cpuInfo,
        memInfo,
        stateMsg,
        bootTime,
        shutdownTime,
        monthlyUseTime,
        hostType,
        os,
        isInitialized,
        isValidLicense,
        isUsed,
        isOperational,
        licenseTime,
        initializeTime,
      ];

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    HostModel srcHost = src as HostModel;

    hostId = srcHost.hostId;
    hostName = srcHost.hostName;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    creator = srcHost.creator;
    location = srcHost.location;
    description = srcHost.description;
    thumbnailUrl = srcHost.thumbnailUrl;

    weekend = srcHost.weekend;
    holiday = srcHost.holiday;
    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Id = srcHost.requestedBook1Id;
    requestedBook2Id = srcHost.requestedBook2Id;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Time = srcHost.playingBook1Time;
    playingBook2Time = srcHost.playingBook2Time;

    notice1 = srcHost.notice1;
    notice2 = srcHost.notice2;
    notice1Time = srcHost.notice1Time;
    notice2Time = srcHost.notice2Time;

    request = srcHost.request;
    requestedTime = srcHost.requestedTime;
    response = srcHost.response;
    downloadResult = srcHost.downloadResult;
    downloadMsg = srcHost.downloadMsg;
    hddInfo = srcHost.hddInfo;
    cpuInfo = srcHost.cpuInfo;
    memInfo = srcHost.memInfo;
    stateMsg = srcHost.stateMsg;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;
    monthlyUseTime = srcHost.monthlyUseTime;

    hostType = srcHost.hostType;
    os = srcHost.os;
    isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    isOperational = srcHost.isOperational;
    licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    HostModel srcHost = src as HostModel;
    hostId = srcHost.hostId;
    hostName = srcHost.hostName;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    creator = srcHost.creator;
    location = srcHost.location;
    description = srcHost.description;
    thumbnailUrl = srcHost.thumbnailUrl;

    weekend = srcHost.weekend;
    holiday = srcHost.holiday;
    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Id = srcHost.requestedBook1Id;
    requestedBook2Id = srcHost.requestedBook2Id;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Time = srcHost.playingBook1Time;
    playingBook2Time = srcHost.playingBook2Time;

    notice1 = srcHost.notice1;
    notice2 = srcHost.notice2;
    notice1Time = srcHost.notice1Time;
    notice2Time = srcHost.notice2Time;

    request = srcHost.request;
    requestedTime = srcHost.requestedTime;
    response = srcHost.response;
    downloadResult = srcHost.downloadResult;
    downloadMsg = srcHost.downloadMsg;
    hddInfo = srcHost.hddInfo;
    cpuInfo = srcHost.cpuInfo;
    memInfo = srcHost.memInfo;
    stateMsg = srcHost.stateMsg;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;
    monthlyUseTime = srcHost.monthlyUseTime;

    hostType = srcHost.hostType;
    os = srcHost.os;
    isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    isOperational = srcHost.isOperational;
    licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
  }

  void modifiedFrom(HostModel srcHost, String request) {
    if (srcHost.hostName.isNotEmpty && srcHost.hostName != hostName) {
      hostName = srcHost.hostName;
    }
    if (srcHost.location.isNotEmpty && srcHost.location != location) {
      location = srcHost.location;
    }
    if (srcHost.description.isNotEmpty && srcHost.description != description) {
      description = srcHost.description;
    }

    if (srcHost.weekend.isNotEmpty && srcHost.weekend != weekend) {
      weekend = srcHost.weekend;
    }
    if (srcHost.holiday.isNotEmpty && srcHost.holiday != holiday) {
      holiday = srcHost.holiday;
    }
    if (srcHost.powerOnTime.isNotEmpty && srcHost.powerOnTime != powerOnTime) {
      powerOnTime = srcHost.powerOnTime;
    }
    if (srcHost.powerOffTime.isNotEmpty && srcHost.powerOffTime != powerOffTime) {
      powerOffTime = srcHost.powerOffTime;
    }
    if (srcHost.requestedBook1.isNotEmpty && srcHost.requestedBook1 != requestedBook1) {
      requestedBook1 = srcHost.requestedBook1;
    }
    if (srcHost.requestedBook2.isNotEmpty && srcHost.requestedBook2 != requestedBook2) {
      requestedBook2 = srcHost.requestedBook2;
    }
    if (srcHost.requestedBook1Id.isNotEmpty && srcHost.requestedBook1Id != requestedBook1Id) {
      requestedBook1Id = srcHost.requestedBook1Id;
      requestedBook1Time = srcHost.requestedBook1Time;
    }
    if (srcHost.requestedBook2Id.isNotEmpty && srcHost.requestedBook2Id != requestedBook2Id) {
      requestedBook2Id = srcHost.requestedBook2Id;
      requestedBook2Time = srcHost.requestedBook2Time;
    }
    request = request;
    requestedTime = DateTime.now();
  }

  DateTime _stringToDate(String? val) {
    try {
      return DateTime.parse(val ?? '1970-01-01 09:00:00.000');
    } catch (e) {
      return DateTime(1970, 1, 1);
    }
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    //super.fromMap(map);
    hostId = map["hostId"] ?? '';
    hostName = map["hostName"] ?? '';
    interfaceName = map["interfaceName"] ?? '';
    ip = map["ip"] ?? '';
    isConnected = map["isConnected"] ?? false;
    creator = map["creator"] ?? '';
    location = map["location"] ?? '';
    description = map["description"] ?? '';
    thumbnailUrl = map["thumbnailUrl"] ?? '';

    weekend = map["weekend"] ?? '';
    holiday = map["holiday"] ?? '';
    powerOnTime = map["powerOnTime"] ?? '';
    powerOffTime = map["powerOffTime"] ?? '';
    requestedBook1 = map["requestedBook1"] ?? '';
    requestedBook2 = map["requestedBook2"] ?? '';
    requestedBook1Id = map["requestedBook1Id"] ?? '';
    requestedBook2Id = map["requestedBook2Id"] ?? '';
    requestedBook1Time = _stringToDate(map["requestedBook1Time"]);
    requestedBook2Time = _stringToDate(map["requestedBook2Time"]);

    playingBook1 = map["playingBook1"] ?? '';
    playingBook2 = map["playingBook2"] ?? '';
    playingBook1Time = _stringToDate(map["playingBook1Time"]);
    playingBook2Time = _stringToDate(map["playingBook2Time"]);

    notice1 = map["notice1"] ?? '';
    notice2 = map["notice2"] ?? '';
    notice1Time = _stringToDate(map["notice1Time"]);
    notice2Time = _stringToDate(map["notice2Time"]);

    request = map["request"] ?? '';
    requestedTime = _stringToDate(map["requestedTime"]);
    response = map["response"] ?? '';
    downloadResult = DownloadResult.fromInt(map["downloadResult"] ?? DownloadResult.none.index);
    downloadMsg = map["downloadMsg"] ?? '';
    hddInfo = map["hddInfo"] ?? '';
    cpuInfo = map["cpuInfo"] ?? '';
    memInfo = map["memInfo"] ?? '';
    stateMsg = map["stateMsg"] ?? '';
    bootTime = _stringToDate(map["bootTime"]);
    shutdownTime = _stringToDate(map["shutdownTime"]);
    monthlyUseTime = map["monthlyUseTime"] ?? 0.0;

    hostType = ServiceType.fromInt(map["hostType"] ?? ServiceType.signage.index);
    os = map["os"] ?? '';
    isInitialized = map["isInitialized"] ?? false;
    isValidLicense = map["isValidLicense"] ?? false;
    isUsed = map["isUsed"] ?? false;
    isOperational = map["isOperational"] ?? true;
    licenseTime = _stringToDate(map["licenseTime"]);
    initializeTime = _stringToDate(map["initializeTime"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "hostId": hostId,
        "hostName": hostName,
        "interfaceName": interfaceName,
        "ip": ip,
        "isConnected": isConnected,
        "creator": creator,
        "location": location,
        "description": description,
        "thumbnailUrl": thumbnailUrl,
        "weekend": weekend,
        "holiday": holiday,
        "powerOnTime": powerOnTime,
        "powerOffTime": powerOffTime,
        "requestedBook1": requestedBook1,
        "requestedBook2": requestedBook2,
        "requestedBook1Id": requestedBook1Id,
        "requestedBook2Id": requestedBook2Id,
        "requestedBook1Time": HycopUtils.dateTimeToDB(requestedBook1Time),
        "requestedBook2Time": HycopUtils.dateTimeToDB(requestedBook2Time),
        "playingBook1": playingBook1,
        "playingBook2": playingBook2,
        "playingBook1Time": HycopUtils.dateTimeToDB(playingBook1Time),
        "playingBook2Time": HycopUtils.dateTimeToDB(playingBook2Time),
        "notice1": notice1,
        "notice2": notice2,
        "notice1Time": HycopUtils.dateTimeToDB(notice1Time),
        "notice2Time": HycopUtils.dateTimeToDB(notice2Time),
        "request": request,
        "requestedTime": HycopUtils.dateTimeToDB(requestedTime),
        "response": response,
        "downloadResult": downloadResult.index,
        "downloadMsg": downloadMsg,
        "hddInfo": hddInfo,
        "cpuInfo": cpuInfo,
        "memInfo": memInfo,
        "stateMsg": stateMsg,
        "bootTime": HycopUtils.dateTimeToDB(bootTime),
        "shutdownTime": HycopUtils.dateTimeToDB(shutdownTime),
        "monthlyUseTime": monthlyUseTime,
        "hostType": hostType.index,
        "os": os,
        "isInitialized": isInitialized,
        "isValidLicense": isValidLicense,
        "isUsed": isUsed,
        "isOperational": isOperational,
        "licenseTime": HycopUtils.dateTimeToDB(licenseTime),
        "initializeTime": HycopUtils.dateTimeToDB(initializeTime),
      }.entries);
  }
}
