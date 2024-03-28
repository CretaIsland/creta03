import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

enum HostType {
  none,
  signage,
  barricade,
  escalator,
  board,
  cdu,
  etc,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static HostType fromInt(int? val) => HostType.values[validCheck(val ?? none.index)];
}

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
  HostType hostType = HostType.signage;    // read only
  String hostId = '';  // read only
  String hostName = '';
  String ip = '';
  String interfaceName = '';  // read only
  String creator = '';  // read only
  String location = '';
  String description = '';
  String os = '';  

  bool isConnected = false;  // read only
  bool isInitialized = false;  // read only
  bool isValidLicense = false; // read only
  bool isUsed = true;
  bool isOperational = true; // read only

  String licenseTime = '';  // read only
  String initializeTime = '';  // read only

  String thumbnailUrl = '';  // read only

  String powerOnTime = '';   // read only
  String powerOffTime = '';// read only
  String requestedBook1 = ''; // read only
  String requestedBook2 = '';// read only
  String requestedBook1Time = '';  // read only
  String requestedBook2Time = '';// read only
  String playingBook1 = ''; // read only
  String playingBook2 = ''; // read only
  String playingBook1Time = ''; // read only
  String playingBook2Time = ''; // read only

  String request = '';  // read only
  String response = ''; // read only

  DownloadResult downloadResult = DownloadResult.none;  // read only
  String downloadMsg = ''; // read only

  String hddInfo = ''; // read only
  String cpuInfo = ''; // read only
  String memInfo = ''; // read only

  String stateMsg = ''; // read only
  String bootTime = ''; // read only
  String shutdownTime = '';  // read only

  HostModel(String pmid) : super(pmid: pmid, type: ExModelType.host, parent: '');

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
        powerOnTime,
        powerOffTime,
        requestedBook1,
        requestedBook2,
        requestedBook1Time,
        requestedBook2Time,
        playingBook1,
        playingBook2,
        playingBook1Time,
        playingBook2Time,
        request,
        response,
        downloadResult,
        downloadMsg,
        hddInfo,
        cpuInfo,
        memInfo,
        stateMsg,
        bootTime,
        shutdownTime,
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

    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Time = srcHost.playingBook1Time;
    playingBook2Time = srcHost.playingBook2Time;
    request = srcHost.request;
    response = srcHost.response;
    downloadResult = srcHost.downloadResult;
    downloadMsg = srcHost.downloadMsg;
    hddInfo = srcHost.hddInfo;
    cpuInfo = srcHost.cpuInfo;
    memInfo = srcHost.memInfo;
    stateMsg = srcHost.stateMsg;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;

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

    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Time = srcHost.playingBook1Time;
    playingBook2Time = srcHost.playingBook2Time;
    request = srcHost.request;
    response = srcHost.response;
    downloadResult = srcHost.downloadResult;
    downloadMsg = srcHost.downloadMsg;
    hddInfo = srcHost.hddInfo;
    cpuInfo = srcHost.cpuInfo;
    memInfo = srcHost.memInfo;
    stateMsg = srcHost.stateMsg;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;

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

    powerOnTime = map["powerOnTime"] ?? '';
    powerOffTime = map["powerOffTime"] ?? '';
    requestedBook1 = map["requestedBook1"] ?? '';
    requestedBook2 = map["requestedBook2"] ?? '';
    requestedBook1Time = map["requestedBook1Time"] ?? '';
    requestedBook2Time = map["requestedBook2Time"] ?? '';
    playingBook1 = map["playingBook1"] ?? '';
    playingBook2 = map["playingBook2"] ?? '';
    playingBook1Time = map["playingBook1Time"] ?? '';
    playingBook2Time = map["playingBook2Time"] ?? '';
    request = map["request"] ?? '';
    response = map["response"] ?? '';
    downloadResult = DownloadResult.fromInt(map["downloadResult"] ?? DownloadResult.none.index);
    downloadMsg = map["downloadMsg"] ?? '';
    hddInfo = map["hddInfo"] ?? '';
    cpuInfo = map["cpuInfo"] ?? '';
    memInfo = map["memInfo"] ?? '';
    stateMsg = map["stateMsg"] ?? '';
    bootTime = map["bootTime"] ?? '';
    shutdownTime = map["shutdownTime"] ?? '';

    hostType = HostType.fromInt(map["hostType"] ?? HostType.signage.index);
    os = map["os"] ?? '';
    isInitialized = map["isInitialized"] ?? false;
    isValidLicense = map["isValidLicense"] ?? false;
    isUsed = map["isUsed"] ?? false;
    isOperational = map["isOperational"] ?? true;
    licenseTime = map["licenseTime"] ?? false;
    initializeTime = map["initializeTime"] ?? false;
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
        "powerOnTime": powerOnTime,
        "powerOffTime": powerOffTime,
        "requestedBook1": requestedBook1,
        "requestedBook2": requestedBook2,
        "requestedBook1Time": requestedBook1Time,
        "requestedBook2Time": requestedBook2Time,
        "playingBook1": playingBook1,
        "playingBook2": playingBook2,
        "playingBook1Time": playingBook1Time,
        "playingBook2Time": playingBook2Time,
        "request": request,
        "response": response,
        "downloadResult": downloadResult.index,
        "downloadMsg": downloadMsg,
        "hddInfo": hddInfo,
        "cpuInfo": cpuInfo,
        "memInfo": memInfo,
        "stateMsg": stateMsg,
        "bootTime": bootTime,
        "shutdownTime": shutdownTime,
        "hostType": hostType.index,
        "os": os,
        "isInitialized": isInitialized,
        "isValidLicense": isValidLicense,
        "isUsed": isUsed,
        "isOperational": isOperational,
        "licenseTime": licenseTime,
        "initializeTime": initializeTime,
      }.entries);
  }
}
