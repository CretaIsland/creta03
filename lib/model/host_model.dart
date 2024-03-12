import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

enum HostType {
  none,
  signage,
  barricade,
  escalator,
  board,
  cdu,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static HostType fromInt(int? val) => HostType.values[validCheck(val ?? none.index)];
}

// ignore: must_be_immutable
class HostModel extends CretaModel {
  String hostId = '';
  String hostName = '';
  String ip = '';
  String interfaceName = '';
  String siteId = '';
  bool isConnected = false;
  String description = '';
  HostType hostType = HostType.signage;
  String os = '';
  bool isInitialized = false;
  bool isValidLicense = false;
  bool isUsed = true;
  String licenseTime = '';
  String initializeTime = '';

  HostModel(String pmid) : super(pmid: pmid, type: ExModelType.host, parent: '');
  HostModel.withName({
    super.type = ExModelType.host,
    super.parent = 'local',
    this.hostName = '',
    this.interfaceName = '',
    this.ip = '',
    this.isConnected = false,
    required super.pmid,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        hostName,
        interfaceName,
        ip,
        isConnected,
        siteId,
        description,
        hostType,
        os,
        isInitialized,
        isValidLicense,
        isUsed,
        licenseTime,
        initializeTime,
      ];

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    HostModel srcHost = src as HostModel;

    hostName = srcHost.hostName;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    siteId = srcHost.siteId;
    description = srcHost.description;
    hostType = srcHost.hostType;
    os = srcHost.os;
    isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    HostModel srcHost = src as HostModel;
    hostName = srcHost.hostName;
    interfaceName = srcHost.interfaceName;
    ip = srcHost.ip;
    isConnected = srcHost.isConnected;
    siteId = srcHost.siteId;
    description = srcHost.description;
    hostType = srcHost.hostType;
    os = srcHost.os;
    isInitialized = srcHost.isInitialized;
    isValidLicense = srcHost.isValidLicense;
    isUsed = srcHost.isUsed;
    licenseTime = srcHost.licenseTime;
    initializeTime = srcHost.initializeTime;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    //super.fromMap(map);
    hostName = map["hostName"] ?? '';
    interfaceName = map["interfaceName"] ?? '';
    ip = map["ip"] ?? '';
    isConnected = map["isConnected"] ?? false;
    siteId = map["siteId"] ?? '';
    description = map["description"] ?? '';
    hostType = map["hostType"] ?? HostType.signage;
    os = map["os"] ?? '';
    isInitialized = map["isInitialized"] ?? false;
    isValidLicense = map["isValidLicense"] ?? false;
    isUsed = map["isUsed"] ?? false;
    licenseTime = map["licenseTime"] ?? false;
    initializeTime = map["initializeTime"] ?? false;
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "hostName": hostName,
        "interfaceName": interfaceName,
        "ip": ip,
        "isConnected": isConnected,
        "siteId": siteId,
        "description": description,
        "hostType": hostType,
        "os": os,
        "isInitialized": isInitialized,
        "isValidLicense": isValidLicense,
        "isUsed": isUsed,
        "licenseTime": licenseTime,
        "initializeTime": initializeTime,
      }.entries);
  }
}
