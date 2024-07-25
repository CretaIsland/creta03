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
  String enterprise = '';
  String macAddress = '';
  String ip = '';
  String interfaceName = ''; // read only
  String creator = ''; // read only
  String location = '';
  String description = '';
  String os = '';
  String resolution = '';

  String agentVersion = ''; // read only
  String playerVersion = ''; // read only
  String weekTime = '';
  String scrshotFile = ''; // read only
  String rebootTime = '';
  DateTime scrshotTime = DateTime(1970, 1, 1); //read only
  int managePeriod = 60;
  int scrshotPeriod = 360;

  bool isConnected = false; // read only
  //bool isInitialized = false; // read only
  bool isValidLicense = true; // read only
  bool isUsed = true;
  bool isVNC = true;
  bool isOperational = true; // read only

  //DateTime licenseTime = DateTime(1970, 1, 1); // read only
  DateTime initializeTime = DateTime(1970, 1, 1); // read only
  DateTime lastUpdateTime = DateTime(1970, 1, 1); // read only

  String thumbnailUrl = ''; // read only

  String weekend = '';
  String holiday = '';
  String bootTime = '';
  String shutdownTime = '';
  String requestedBook1 = '';
  String requestedBook1Id = '';
  String requestedBook2 = '';
  String requestedBook2Id = '';
  DateTime requestedBook1Time = DateTime(1970, 1, 1); // read only
  DateTime requestedBook2Time = DateTime(1970, 1, 1); // read only
  String playingBook1 = ''; // read only
  String playingBook2 = ''; // read only
  String playingBook1Id = ''; // read only
  String playingBook2Id = ''; // read only
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
  String netInfo = ''; // read only

  String stateMsg = ''; // read only
  DateTime powerOnTime = DateTime(1970, 1, 1); // read only
  DateTime powerOffTime = DateTime(1970, 1, 1); // read only

  double monthlyUseTime = 0.0; // read only
  double soundVolume = 50.0;
  bool mute = false;

  HostModel(String pmid) : super(pmid: pmid, type: ExModelType.host, parent: '');
  HostModel.dummy()
      : super(pmid: HycopUtils.genMid(ExModelType.host), type: ExModelType.host, parent: '');

  HostModel.withName({
    super.type = ExModelType.host,
    required this.hostId,
    this.hostName = '',
    this.enterprise = '',
    this.macAddress = '',
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
        enterprise,
        macAddress,
        interfaceName,
        ip,
        isConnected,
        creator,
        location,
        description,
        resolution,
        agentVersion,
        playerVersion,
        weekTime,
        scrshotFile,
        thumbnailUrl,
        weekend,
        holiday,
        bootTime,
        shutdownTime,
        requestedBook1,
        requestedBook2,
        requestedBook1Id,
        requestedBook2Id,
        requestedBook1Time,
        requestedBook2Time,
        playingBook1,
        playingBook2,
        playingBook1Id,
        playingBook2Id,
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
        netInfo,
        stateMsg,
        powerOnTime,
        powerOffTime,
        monthlyUseTime,
        soundVolume,
        hostType,
        os,
        //isInitialized,
        isValidLicense,
        isUsed,
        isVNC,
        isOperational,
        mute,
        managePeriod,
        scrshotPeriod,
        //licenseTime,
        initializeTime,
        lastUpdateTime,
        rebootTime,
        scrshotTime,
      ];

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    HostModel srcHost = src as HostModel;

    hostId = srcHost.hostId;
    hostName = srcHost.hostName;
    enterprise = srcHost.enterprise;
    macAddress = srcHost.macAddress;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    creator = srcHost.creator;
    location = srcHost.location;
    description = srcHost.description;
    resolution = srcHost.resolution;
    agentVersion = srcHost.agentVersion;
    playerVersion = srcHost.playerVersion;
    weekTime = srcHost.weekTime;
    scrshotFile = srcHost.scrshotFile;
    thumbnailUrl = srcHost.thumbnailUrl;

    weekend = srcHost.weekend;
    holiday = srcHost.holiday;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Id = srcHost.requestedBook1Id;
    requestedBook2Id = srcHost.requestedBook2Id;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Id = srcHost.playingBook1Id;
    playingBook2Id = srcHost.playingBook2Id;
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
    netInfo = srcHost.netInfo;
    stateMsg = srcHost.stateMsg;
    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    monthlyUseTime = srcHost.monthlyUseTime;
    soundVolume = srcHost.soundVolume;

    hostType = srcHost.hostType;
    os = srcHost.os;
    //isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    isVNC = srcHost.isVNC;
    isOperational = srcHost.isOperational;
    mute = srcHost.mute;
    managePeriod = srcHost.managePeriod;
    scrshotPeriod = srcHost.scrshotPeriod;
    //licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
    lastUpdateTime = srcHost.lastUpdateTime;
    rebootTime = srcHost.rebootTime;
    scrshotTime = srcHost.scrshotTime;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    HostModel srcHost = src as HostModel;
    hostId = srcHost.hostId;
    hostName = srcHost.hostName;
    enterprise = srcHost.enterprise;
    macAddress = srcHost.macAddress;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    creator = srcHost.creator;
    location = srcHost.location;
    description = srcHost.description;
    resolution = srcHost.resolution;
    agentVersion = srcHost.agentVersion;
    playerVersion = srcHost.playerVersion;
    weekTime = srcHost.weekTime;
    scrshotFile = srcHost.scrshotFile;
    thumbnailUrl = srcHost.thumbnailUrl;

    weekend = srcHost.weekend;
    holiday = srcHost.holiday;
    bootTime = srcHost.bootTime;
    shutdownTime = srcHost.shutdownTime;
    requestedBook1 = srcHost.requestedBook1;
    requestedBook2 = srcHost.requestedBook2;
    requestedBook1Id = srcHost.requestedBook1Id;
    requestedBook2Id = srcHost.requestedBook2Id;
    requestedBook1Time = srcHost.requestedBook1Time;
    requestedBook2Time = srcHost.requestedBook2Time;
    playingBook1 = srcHost.playingBook1;
    playingBook2 = srcHost.playingBook2;
    playingBook1Id = srcHost.playingBook1Id;
    playingBook2Id = srcHost.playingBook2Id;
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
    netInfo = srcHost.netInfo;
    stateMsg = srcHost.stateMsg;
    powerOnTime = srcHost.powerOnTime;
    powerOffTime = srcHost.powerOffTime;
    monthlyUseTime = srcHost.monthlyUseTime;
    soundVolume = srcHost.soundVolume;

    hostType = srcHost.hostType;
    os = srcHost.os;
    //isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    isVNC = srcHost.isVNC;
    mute = srcHost.mute;
    isOperational = srcHost.isOperational;
    managePeriod = srcHost.managePeriod;
    scrshotPeriod = srcHost.scrshotPeriod;
    //licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
    lastUpdateTime = srcHost.lastUpdateTime;
    rebootTime = srcHost.rebootTime;
    scrshotTime = srcHost.scrshotTime;
  }

  void modifiedFrom(HostModel srcHost, String req) {
    if (srcHost.hostName.isNotEmpty && srcHost.hostName != hostName) {
      hostName = srcHost.hostName;
    }
    if (srcHost.enterprise.isNotEmpty && srcHost.enterprise != enterprise) {
      enterprise = srcHost.enterprise;
    }
    if (srcHost.macAddress.isNotEmpty && srcHost.macAddress != macAddress) {
      macAddress = srcHost.macAddress;
    }
    if (srcHost.location.isNotEmpty && srcHost.location != location) {
      location = srcHost.location;
    }
    if (srcHost.description.isNotEmpty && srcHost.description != description) {
      description = srcHost.description;
    }
    if (srcHost.resolution.isNotEmpty && srcHost.resolution != resolution) {
      resolution = srcHost.resolution;
    }
    if (srcHost.agentVersion.isNotEmpty && srcHost.agentVersion != agentVersion) {
      agentVersion = srcHost.agentVersion;
    }
    if (srcHost.playerVersion.isNotEmpty && srcHost.playerVersion != playerVersion) {
      playerVersion = srcHost.playerVersion;
    }
    if (srcHost.weekTime.isNotEmpty && srcHost.weekTime != weekTime) {
      weekTime = srcHost.weekTime;
    }
    if (srcHost.scrshotFile.isNotEmpty && srcHost.scrshotFile != scrshotFile) {
      scrshotFile = srcHost.scrshotFile;
    }

    if (srcHost.weekend.isNotEmpty && srcHost.weekend != weekend) {
      weekend = srcHost.weekend;
    }
    if (srcHost.holiday.isNotEmpty && srcHost.holiday != holiday) {
      holiday = srcHost.holiday;
    }
    if (srcHost.bootTime.isNotEmpty && srcHost.bootTime != bootTime) {
      bootTime = srcHost.bootTime;
    }
    if (srcHost.shutdownTime.isNotEmpty && srcHost.shutdownTime != shutdownTime) {
      shutdownTime = srcHost.shutdownTime;
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
    request = req;
    requestedTime = DateTime.now();
  }

  // DateTime HycopUtils.dateTimeFromDB(String? val) {
  //   try {
  //     return DateTime.parse(val ?? '1970-01-01 09:00:00.000');
  //   } catch (e) {
  //     return DateTime(1970, 1, 1);
  //   }
  // }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    hostId = map["hostId"] ?? '';
    hostName = map["hostName"] ?? '';
    enterprise = map["enterprise"] ?? '';
    macAddress = map["macAddress"] ?? '';
    interfaceName = map["interfaceName"] ?? '';
    ip = map["ip"] ?? '';
    isConnected = map["isConnected"] ?? false;
    creator = map["creator"] ?? '';
    location = map["location"] ?? '';
    weekTime = map["weekTime"] ?? '';
    resolution = map["resolution"] ?? ServiceType.defaultResolution();
    agentVersion = map["agentVersion"] ?? '';
    playerVersion = map["playerVersion"] ?? '';
    scrshotFile = map["scrshotFile"] ?? '';
    description = map["description"] ?? '';
    thumbnailUrl = map["thumbnailUrl"] ?? '';

    weekend = map["weekend"] ?? '';
    holiday = map["holiday"] ?? '';
    bootTime = map["bootTime"] ?? '';
    shutdownTime = map["shutdownTime"] ?? '';
    requestedBook1 = map["requestedBook1"] ?? '';
    requestedBook2 = map["requestedBook2"] ?? '';
    requestedBook1Id = map["requestedBook1Id"] ?? '';
    requestedBook2Id = map["requestedBook2Id"] ?? '';
    requestedBook1Time = HycopUtils.dateTimeFromDB(map["requestedBook1Time"] ?? '');
    requestedBook2Time = HycopUtils.dateTimeFromDB(map["requestedBook2Time"] ?? '');

    playingBook1 = map["playingBook1"] ?? '';
    playingBook2 = map["playingBook2"] ?? '';
    playingBook1Id = map["playingBook1Id"] ?? '';
    playingBook2Id = map["playingBook2Id"] ?? '';
    playingBook1Time = HycopUtils.dateTimeFromDB(map["playingBook1Time"] ?? '');
    playingBook2Time = HycopUtils.dateTimeFromDB(map["playingBook2Time"] ?? '');

    notice1 = map["notice1"] ?? '';
    notice2 = map["notice2"] ?? '';
    notice1Time = HycopUtils.dateTimeFromDB(map["notice1Time"] ?? '');
    notice2Time = HycopUtils.dateTimeFromDB(map["notice2Time"] ?? '');

    request = map["request"] ?? '';
    requestedTime = HycopUtils.dateTimeFromDB(map["requestedTime"] ?? '');
    response = map["response"] ?? '';
    downloadResult = DownloadResult.fromInt(map["downloadResult"] ?? DownloadResult.none.index);
    downloadMsg = map["downloadMsg"] ?? '';
    hddInfo = map["hddInfo"] ?? '';
    cpuInfo = map["cpuInfo"] ?? '';
    memInfo = map["memInfo"] ?? '';
    netInfo = map["netInfo"] ?? '';
    stateMsg = map["stateMsg"] ?? '';
    powerOnTime = HycopUtils.dateTimeFromDB(map["powerOnTime"] ?? '');
    powerOffTime = HycopUtils.dateTimeFromDB(map["powerOffTime"] ?? '');
    monthlyUseTime = map["monthlyUseTime"] ?? 0.0;
    soundVolume = map["soundVolume"] ?? 50.0;

    hostType = ServiceType.fromInt(map["hostType"] ?? ServiceType.signage.index);
    os = map["os"] ?? '';
    //isInitialized = map["isInitialized"] ?? false;
    isValidLicense = map["isValidLicense"] ?? true;
    isUsed = map["isUsed"] ?? true;
    isVNC = map["isVNC"] ?? false;
    isOperational = map["isOperational"] ?? true;
    mute = map["mute"] ?? false;
    managePeriod = map["managePeriod"] ?? 60;
    scrshotPeriod = map["scrshotPeriod"] ?? 360;
    //licenseTime = HycopUtils.dateTimeFromDB(map["licenseTime"]);
    initializeTime = HycopUtils.dateTimeFromDB(map["initializeTime"] ?? '');
    lastUpdateTime = HycopUtils.dateTimeFromDB(map["lastUpdateTime"] ?? '');
    rebootTime = map["rebootTime"] ?? '';
    scrshotTime = HycopUtils.dateTimeFromDB(map["scrshotTime"] ?? '');
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "hostId": hostId,
        "hostName": hostName,
        "enterprise": enterprise,
        "macAddress": macAddress,
        "interfaceName": interfaceName,
        "ip": ip,
        "isConnected": isConnected,
        "creator": creator,
        "location": location,
        "description": description,
        "resolution": resolution.isEmpty ? ServiceType.defaultResolution() : resolution,
        "agentVersion": agentVersion,
        "playerVersion": playerVersion,
        "weekTime": weekTime,
        "scrshotFile": scrshotFile,
        "thumbnailUrl": thumbnailUrl,
        "weekend": weekend,
        "holiday": holiday,
        "bootTime": bootTime,
        "shutdownTime": shutdownTime,
        "requestedBook1": requestedBook1,
        "requestedBook2": requestedBook2,
        "requestedBook1Id": requestedBook1Id,
        "requestedBook2Id": requestedBook2Id,
        "requestedBook1Time": HycopUtils.dateTimeToDB(requestedBook1Time),
        "requestedBook2Time": HycopUtils.dateTimeToDB(requestedBook2Time),
        "playingBook1": playingBook1,
        "playingBook2": playingBook2,
        "playingBook1Id": playingBook1Id,
        "playingBook2Id": playingBook2Id,
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
        "netInfo": netInfo,
        "stateMsg": stateMsg,
        "powerOnTime": HycopUtils.dateTimeToDB(powerOnTime),
        "powerOffTime": HycopUtils.dateTimeToDB(powerOffTime),
        "monthlyUseTime": monthlyUseTime,
        "soundVolume": soundVolume,
        "hostType": hostType.index,
        "os": os,
        //"isInitialized": isInitialized,
        "isValidLicense": isValidLicense,
        "isUsed": isUsed,
        "isVNC": isVNC,
        "isOperational": isOperational,
        "mute": mute,
        "managePeriod": managePeriod,
        "scrshotPeriod": scrshotPeriod,
        //"licenseTime": HycopUtils.dateTimeToDB(licenseTime),
        "initializeTime": HycopUtils.dateTimeToDB(initializeTime),
        "lastUpdateTime": HycopUtils.dateTimeToDB(lastUpdateTime),
        "rebootTime": rebootTime,
        "scrshotTime": HycopUtils.dateTimeToDB(scrshotTime),
      }.entries);
  }
}
