//import 'package:creta_common/common/creta_common_utils.dart';
import 'dart:convert';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:intl/intl.dart';
import 'package:tcard/tcard.dart';

import '../../data_io/scrshot_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_ex_slider.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../design_system/component/creta_proprty_slider.dart';
import '../../design_system/component/snippet.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/enterprise_model.dart';
import '../../model/host_model.dart';
import '../../common/creta_utils.dart';
import '../../model/scrshot_model.dart';
import '../login/creta_account_manager.dart';
import 'book_select_filter.dart';

class DeviceDetailPage extends StatefulWidget {
  final HostModel hostModel;
  final GlobalKey<FormState> formKey;
  final bool isMultiSelected;
  final bool isChangeBook;
  final Size dialogSize;

  const DeviceDetailPage({
    super.key,
    required this.hostModel,
    required this.formKey,
    required this.dialogSize,
    this.isMultiSelected = false,
    this.isChangeBook = false,
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  List<bool> weekend = List.filled(7, false);
  bool _isShowScreenShot = false;
  // ignore: unused_field
  bool _isShowScreenShotHistory = false;
  late TCardController _controller;

  List<BookModel> books = [
    BookModel.withName('Book 1', creator: 'abc@sqisoft.com', creatorName: 'Kim abc', imageUrl: ''),
    BookModel.withName('Book 2', creator: 'bcd@sqisoft.com', creatorName: 'Kim bcd', imageUrl: ''),
    BookModel.withName('Book 3', creator: '123@sqisoft.com', creatorName: 'Park 123', imageUrl: ''),
    BookModel.withName('Book 4', creator: '456@sqisoft.com', creatorName: 'Park 456', imageUrl: ''),
  ];

  List<String> admins = [];
  Future<String>? scrshotUrl;
  Future<Map<String, String>>? scrshotHistory;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TCardController();

    if (widget.hostModel.weekend.isNotEmpty) {
      try {
        weekend = (jsonDecode(widget.hostModel.weekend) as List<dynamic>)
            .map((item) => item.toString() == 'true')
            .toList();
      } catch (e) {
        logger.warning('Error in parsing weekend: $e');
      }
    }
    EnterpriseModel? enterpriseModel =
        CretaAccountManager.enterpriseManagerHolder.onlyOne() as EnterpriseModel?;
    if (enterpriseModel != null) {
      admins = enterpriseModel.admins;
    }

    if (widget.hostModel.scrshotFile.isNotEmpty) {
      scrshotUrl = HycopFactory.storage!.getImageUrl(widget.hostModel.scrshotFile);
      scrshotHistory = _getScrshotHistory();
    } else {
      scrshotUrl = Future.value('');
    }
  }

  Future<Map<String, String>> _getScrshotHistory() async {
    ScrshotManager scrshotManager = ScrshotManager();
    List<AbsExModel> modelList =
        await scrshotManager.getScrshotHistory(widget.hostModel.hostId, limit: 30);
    //print('scrshot history: ${modelList.length}');
    // 여기서 URL 을 목록으로 가져오는 작업을 한다.
    Map<String, String> scrshotUrlHistory = {};

    for (var ele in modelList) {
      ScrshotModel model = ele as ScrshotModel;
      if (model.scrshotFile.isNotEmpty) {
        try {
          String url = await HycopFactory.storage!.getImageUrl(model.scrshotFile);
          //print('scrshot url: $url, ${model.scrshotTime}');
          scrshotUrlHistory[CretaUtils.dateToString(model.scrshotTime)] = (url);
        } catch (e) {
          logger.severe('Error in getting scrshot url: $e');
        }
      }
    }
    //print('scrshot list: ${scrshotUrlHistory.length}');
    return scrshotUrlHistory;
  }

  bool _hasAuth() {
    return (widget.hostModel.creator.isEmpty ||
        widget.hostModel.creator == AccountManager.currentLoginUser.email ||
        AccountManager.currentLoginUser.isSuperUser == true ||
        admins.contains(AccountManager.currentLoginUser.email));
  }

  @override
  Widget build(BuildContext context) {
    return _isShowScreenShot ? _screenshotView() : _detailView();
  }

  Widget _screenshotView() {
    Widget buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isShowScreenShotHistory)
              TextButton(
                onPressed: () {
                  // setState(() {
                  //   _isShowScreenShot = true;
                  // });
                  _controller.back();
                },
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            Tooltip(
              message: _isShowScreenShotHistory ? 'latest ScreenShot' : 'ScreenShot History',
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isShowScreenShotHistory = !_isShowScreenShotHistory;
                  });
                },
                child: Icon(_isShowScreenShotHistory ? Icons.image : Icons.calendar_month,
                    color: Colors.black),
              ),
            ),
            if (_isShowScreenShotHistory)
              TextButton(
                onPressed: () {
                  // setState(() {
                  //   _isShowScreenShot = true;
                  // });
                  _controller.forward(direction: SwipDirection.Right);
                },
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
          ],
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isShowScreenShot = false;
            });
          },
          child: const Icon(Icons.close, color: Colors.black),
        ),
      ],
    );

    if (_isShowScreenShotHistory == true) {
      return FutureBuilder<Map<String, String>?>(
          future: scrshotHistory,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              logger.severe("data fetch error(WaitDatum)");
              return Column(
                children: [
                  Snippet.noImageAvailable(),
                  const SizedBox(height: 10),
                  buttons,
                ],
              );
            }
            if (snapshot.hasData == false) {
              //print('xxxxxxxxxxxxxxxxxxxxx');
              logger.finest("wait data ...(WaitData)");
              return Center(
                child: CretaSnippet.showWaitSign(),
              );
            }
            if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return Snippet.noImageAvailable();
            }

            if (snapshot.connectionState == ConnectionState.done || snapshot.hasError) {
              List<Widget> cards = List.generate(
                snapshot.data!.length,
                (int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 17),
                          blurRadius: 23.0,
                          spreadRadius: -13.0,
                          color: Colors.black54,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              snapshot.data!.values.toList()[index],
                            ),
                          ),
                        ),
                        Text(snapshot.data!.keys.toList()[index]),
                      ],
                    ),
                  );
                },
              );

              return Column(
                children: [
                  TCard(
                    size: Size(widget.dialogSize.width - 100, widget.dialogSize.height - 100),
                    cards: cards,
                    controller: _controller,
                    delaySlideFor: 500,
                  ),
                  const SizedBox(height: 10),
                  buttons,
                ],
              );
            }
            return const SizedBox.shrink();
          });
    }

    return FutureBuilder<String>(
        future: scrshotUrl,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatum)");
            return Column(
              children: [
                Snippet.noImageAvailable(),
                const SizedBox(height: 10),
                buttons,
              ],
            );
          }
          if (snapshot.hasData == false) {
            //print('xxxxxxxxxxxxxxxxxxxxx');
            logger.finest("wait data ...(WaitData)");
            return Center(
              child: CretaSnippet.showWaitSign(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done || snapshot.hasError) {
            return Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 16.0, // 카드의 입체감을 조절합니다.
                    shadowColor: Colors.black87, // 그림자의 색상을 설정합니다.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 카드의 모서리를 둥글게 만듭니다.
                    ),
                    color: CretaColor.text[200],
                    child: snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty
                        ? Snippet.noImageAvailable()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // 이미지의 모서리를 둥글게 만듭니다.
                            //child: Image.network('https://picsum.photos/200/?random=200'),
                            child: Image.network(snapshot.data!),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                buttons,
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget _detailView() {
    String scrTime = widget.hostModel.scrshotTime.toIso8601String();
    scrTime = scrTime.substring(0, scrTime.length - 4);

    // print('widget.hostModel.hddInfo: ${widget.hostModel.hddInfo}');
    // print('widget.hostModel.cpuInfo: ${widget.hostModel.cpuInfo}');
    // print('widget.hostModel.memInfo: ${widget.hostModel.memInfo}');
    // hddInfo = '{"total":10578034688,"used":2768605184,"free":7809429504}';
    // cpuInfo = '{"current":1296,"cores":4,"min":408,"max":1296,"temperature":72.083}';
    // memInfo = '{"total":2054619136,"used":699301888,"free":1355317248,"usedByApp":2386568}';
    double hddUsage = 0;
    double memUsage = 0;
    double cpuUsage = 0;
    double cpuTemper = 0;
    double wifiLevel = 0;
    try {
      final hdd = jsonDecode(widget.hostModel.hddInfo.isEmpty ? '{}' : widget.hostModel.hddInfo);
      final cpu = jsonDecode(widget.hostModel.cpuInfo.isEmpty ? '{}' : widget.hostModel.cpuInfo);
      final mem = jsonDecode(widget.hostModel.memInfo.isEmpty ? '{}' : widget.hostModel.memInfo);
      final wifi = jsonDecode(widget.hostModel.netInfo.isEmpty ? '{}' : widget.hostModel.netInfo);
      hddUsage = (hdd['used'] ?? 0) / (hdd['total'] ?? 1) * 100;
      memUsage = (mem['used'] ?? 0) / (mem['total'] ?? 1) * 100;
      cpuTemper = cpu['temperature'] ?? 0.0;
      cpuUsage = (cpu['current'] ?? 0) / (cpu['max'] ?? 1) * 100;
      wifiLevel = double.parse(wifi['level'] ?? "0");
    } catch (e) {
      logger.warning('Error in parsing hdd, cpu, mem, wifi: $e');
    }
    return
        // Container(
        //   width: width,
        //   height: height,
        //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        //   color: Colors.white,
        //   child:
        Form(
      key: widget.formKey,
      child: Row(
        children: [
          if (widget.isMultiSelected == false)
            Expanded(
              child: ListView(
                children: <Widget>[
                  _nvRow('Enterprise', widget.hostModel.enterprise, onPressed: () {
                    widget.hostModel.enterprise = '';
                  }),
                  _nvRow('Device ID', widget.hostModel.hostId),
                  _nvRow('Device Type', widget.hostModel.hostType.name.split(".").last),
                  _nvRow('Mac Address', widget.hostModel.macAddress),
                  _nvRow('Interface Name', widget.hostModel.interfaceName),
                  _nvRow('IP', widget.hostModel.ip),
                  _nvRow('OS', widget.hostModel.os),
                  _boolRow('Is Connected', widget.hostModel.isConnected, false),
                  _boolRow('Is Operational', widget.hostModel.isOperational, false),
                  //_boolRow('Has License', widget.hostModel.isValidLicense, false),
                  //_nvRow('License Time', HycopUtils.dateTimeToDisplay(widget.hostModel.licenseTime)),
                  _nvRow('Initialize Time',
                      HycopUtils.dateTimeToDisplay(widget.hostModel.initializeTime)),
                  _nvRow('Last Connected Time',
                      HycopUtils.dateTimeToDisplay(widget.hostModel.lastUpdateTime)),
                  _nvRow('Last Power ON Time',
                      HycopUtils.dateTimeToDisplay(widget.hostModel.powerOnTime)),
                  _nvRow('Last Power OFF Time',
                      HycopUtils.dateTimeToDisplay(widget.hostModel.powerOffTime)),

                  _nvWidget(
                    'Memory usage',
                    LinearProgressIndicator(
                        value: memUsage / 100,
                        color: memUsage >= 90 ? CretaColor.stateCritical : CretaColor.primary),
                    Text('${memUsage.round()}%', textAlign: TextAlign.end),
                  ),
                  _nvWidget(
                    'HDD usage',
                    LinearProgressIndicator(
                        value: hddUsage / 100,
                        color: hddUsage >= 90 ? CretaColor.stateCritical : CretaColor.primary),
                    Text('${hddUsage.round()}%', textAlign: TextAlign.end),
                  ),
                  _nvWidget(
                    'CPU usage',
                    LinearProgressIndicator(
                        value: cpuUsage / 100,
                        color: cpuUsage >= 90 ? CretaColor.stateCritical : CretaColor.primary),
                    Text('${cpuUsage.round()}%', textAlign: TextAlign.end),
                  ),
                  _nvWidget(
                    'CPU temperature',
                    LinearProgressIndicator(
                        value: cpuTemper / 100,
                        color: cpuTemper >= 90 ? CretaColor.stateCritical : CretaColor.primary),
                    Text('${cpuTemper.toStringAsFixed(1)}\u00B0C', textAlign: TextAlign.end),
                  ),
                  _nvWidget(
                    'Wifi level',
                    LinearProgressIndicator(
                        value: wifiLevel == 0 ? 0.05 : (wifiLevel / 5),
                        color: wifiLevel <= 2 ? CretaColor.stateCritical : CretaColor.primary),
                    Text('$wifiLevel', textAlign: TextAlign.end),
                  ),

                  _nvRow('State Message', widget.hostModel.stateMsg),
                  _nvRow('Agent Version', widget.hostModel.agentVersion),
                  _nvRow('playerVersion', widget.hostModel.playerVersion),
                  if (widget.isChangeBook == false)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                      child: _buttonRow(
                        'View Screenshot',
                        widget.hostModel.scrshotFile,
                        scrTime.length > 19
                            ? scrTime.replaceFirst('T', ' ').substring(0, 19)
                            : scrTime.replaceFirst('T', ' '),
                        onPressed: () {
                          setState(() {
                            _isShowScreenShot = true;
                          });
                        },
                      ),
                    ),
                  _nvRow('Request', widget.hostModel.request),
                  _nvRow('RequestedTime',
                      HycopUtils.dateTimeToDisplay(widget.hostModel.requestedTime)),
                  _nvRow('Response', widget.hostModel.response),
                  _nvRow('Download Result', widget.hostModel.downloadResult.name.split('.').last),
                  _nvRow('Download Message', widget.hostModel.downloadMsg),

                  // _nvRow('scrshotFile', widget.hostModel.scrshotFile), // 그림으로 표시해야함.
                  // _nvRow('scrshotTime', widget.hostModel.scrshotTime.toIso8601String()),

                  //Text('Thumbnail URL: ${widget.hostModel.thumbnailUrl}'),
                ],
              ),
            ),
          if (widget.isMultiSelected == false) const SizedBox(width: 90),
          Expanded(
            child: ListView(
              children: <Widget>[
                if (widget.isChangeBook == false)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                    child: _boolRow(
                      CretaDeviceLang["usageSetting"], //'사용상태 설정',
                      widget.hostModel.isUsed,
                      true,
                      onChanged: (bool value) {
                        setState(() {
                          widget.hostModel.isUsed = value;
                        });
                      },
                    ),
                  ),
                // if (widget.isChangeBook == false)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                //     child: _boolRow(
                //       CretaDeviceLang["licenseSetting"] ?? '라이센스 설정',
                //       widget.hostModel.isValidLicense,
                //       true,
                //       onChanged: (bool value) {
                //         setState(() {
                //           widget.hostModel.isValidLicense = value;
                //         });
                //       },
                //     ),
                //   ),
                if (widget.isChangeBook == false)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                    child: _boolRow(
                      CretaDeviceLang["mute"] ?? '뮤트',
                      widget.hostModel.mute,
                      CretaVars.instance.serviceType != ServiceType.barricade,
                      onChanged: (bool value) {
                        setState(() {
                          widget.hostModel.mute = value;
                        });
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                  child: _sliderRow(
                    CretaDeviceLang["soundVolume"] ?? '소리 음량',
                    widget.hostModel.soundVolume,
                    CretaVars.instance.serviceType != ServiceType.barricade,
                    onChanged: (double value) {
                      setState(() {
                        widget.hostModel.soundVolume = value;
                      });
                    },
                  ),
                ),
                if (widget.isChangeBook == false)
                  Card(
                    elevation: 0,
                    color: Colors.grey[200],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(CretaDeviceLang["generalSetting"], //"일반 정보 설정",
                                style: dataStyle),
                          ),
                          _hasAuth()
                              ? TextFormField(
                                  initialValue: widget.hostModel.creator,
                                  decoration:
                                      InputDecoration(labelText: 'Owner', labelStyle: titleStyle),
                                  onSaved: (value) {
                                    widget.hostModel.creator = value ?? '';
                                    //print('Saved : ${widget.hostModel.creator}');
                                  },
                                )
                              : _nvRow('Owner', widget.hostModel.creator),
                          if (widget.isMultiSelected == false)
                            TextFormField(
                              initialValue: widget.hostModel.hostName,
                              decoration:
                                  InputDecoration(labelText: 'Host Name', labelStyle: titleStyle),
                              onSaved: (value) {
                                widget.hostModel.hostName = value ?? '';
                              },
                            ),
                          TextFormField(
                            initialValue: widget.hostModel.resolution,
                            decoration:
                                InputDecoration(labelText: 'Resolution', labelStyle: titleStyle),
                            onSaved: (value) {
                              widget.hostModel.resolution =
                                  value ?? ServiceType.defaultResolution();
                            },
                          ),
                          TextFormField(
                            initialValue: widget.hostModel.description,
                            decoration:
                                InputDecoration(labelText: 'Description', labelStyle: titleStyle),
                            onSaved: (value) => widget.hostModel.description = value ?? '',
                          ),
                          TextFormField(
                            initialValue: widget.hostModel.location,
                            decoration:
                                InputDecoration(labelText: 'Location', labelStyle: titleStyle),
                            onSaved: (value) => widget.hostModel.location = value ?? '',
                          ),
                          TextFormField(
                            initialValue: widget.isMultiSelected
                                ? null
                                : widget.hostModel.managePeriod.toString(),
                            decoration: InputDecoration(
                                labelText: 'Collection Period', labelStyle: titleStyle),
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                widget.hostModel.managePeriod = int.parse(value);
                              }
                            },
                          ),
                          TextFormField(
                            initialValue: widget.isMultiSelected
                                ? null
                                : widget.hostModel.scrshotPeriod.toString(),
                            decoration: InputDecoration(
                                labelText: 'ScreenShot Period', labelStyle: titleStyle),
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                widget.hostModel.scrshotPeriod = int.parse(value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.isChangeBook == false)
                  Card(
                    elevation: 0,
                    color: Colors.grey[200],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(CretaDeviceLang["powerSetting"], // "전원 설정",
                                style: dataStyle),
                          ),
                          //const Divider(color: Colors.grey),
                          _nvChanged(
                            'Auto Power On Time',
                            widget.hostModel.bootTime,
                            onPressed: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (selectedTime != null) {
                                String formattedTime = CretaUtils.get24HourFormat(selectedTime);
                                setState(() {
                                  widget.hostModel.bootTime = formattedTime;
                                });
                              }
                            },
                            onCanceled: () {
                              setState(() {
                                widget.hostModel.bootTime = '';
                              });
                            },
                            padding: 4,
                          ),
                          _nvChanged(
                            'Auto Reboot Time',
                            widget.hostModel.rebootTime,
                            onPressed: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (selectedTime != null) {
                                // 24시간제 포맷으로 시간 문자열 생성
                                String formattedTime = CretaUtils.get24HourFormat(selectedTime);
                                setState(() {
                                  widget.hostModel.rebootTime = formattedTime;
                                });
                              }
                            },
                            onCanceled: () {
                              setState(() {
                                widget.hostModel.rebootTime = '';
                              });
                            },
                            padding: 4,
                          ),
                          _nvChanged(
                            'Auto Power Off Time',
                            widget.hostModel.shutdownTime,
                            onPressed: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (selectedTime != null) {
                                String formattedTime = CretaUtils.get24HourFormat(selectedTime);
                                setState(() {
                                  widget.hostModel.shutdownTime = formattedTime;
                                });
                              }
                            },
                            onCanceled: () {
                              setState(() {
                                widget.hostModel.shutdownTime = '';
                              });
                            },
                            padding: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TextFormField(
                              initialValue: widget.hostModel.weekTime,
                              decoration: InputDecoration(
                                  labelText: 'Power off by WeeK Day',
                                  hintText: 'ex) SAT:20:30,SUN:18:30',
                                  labelStyle: titleStyle),
                              onSaved: (value) => widget.hostModel.weekTime = value ?? '',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: TextFormField(
                              initialValue: widget.hostModel.holiday,
                              decoration: InputDecoration(
                                  labelText: 'holiday',
                                  hintText: 'ex) 12-25,1-1,7-4',
                                  labelStyle: titleStyle),
                              onSaved: (value) => widget.hostModel.holiday = value ?? '',
                            ),
                          ),

                          _nvChangedColumn(
                            'Weekend',
                            widget.hostModel.weekend,
                            dataRow: Wrap(
                              //alignment: WrapAlignment.end,
                              //runAlignment: WrapAlignment.end,
                              children: <Widget>[
                                for (int i = 0; i < 7; i++)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                                    child: SizedBox(
                                      width: 62,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat.E().format(DateTime(2022, 1, i + 3)),
                                            ),
                                            Checkbox(
                                              activeColor: CretaColor.primary,
                                              value: weekend[i],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  weekend[i] = value!;
                                                  widget.hostModel.weekend = jsonEncode(weekend);
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                  ),
                                // CheckboxListTile(
                                //   title: Text(
                                //     DateFormat.E()
                                //         .format(DateTime(2022, 1, i + 3)), // Get day of week
                                //   ),
                                //   value: weekend[i],
                                //   onChanged: (bool? value) {
                                //     setState(() {
                                //       weekend[i] = value!;
                                //       widget.hostModel.weekend = jsonEncode(weekend);
                                //     });
                                //   },
                                // ),
                              ],
                            ),
                            padding: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                Card(
                  elevation: 0,
                  color: Colors.grey[200],
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(CretaDeviceLang["currentBookSetting"], //"현재 방송 설정",
                              style: dataStyle),
                        ),
                        _nvChanged(
                          'Requested Book 1',
                          widget.hostModel.requestedBook1,
                          onPressed: () {
                            _showBookList(context, books, (bookId, name) {
                              setState(() {
                                widget.hostModel.requestedBook1 = name;
                                widget.hostModel.requestedBook1Id = bookId;
                                widget.hostModel.requestedBook1Time = DateTime.now();
                              });
                            });
                          },
                          onCanceled: () {
                            setState(() {
                              widget.hostModel.requestedBook1 = 'EMPTY';
                              widget.hostModel.requestedBook1Id = '';
                              widget.hostModel.requestedBook1Time = DateTime.now();
                            });
                          },
                          subInfo:
                              HycopUtils.dateTimeToDisplay(widget.hostModel.requestedBook1Time),
                        ),
                        _nvChanged(
                          'Requested Book 2',
                          widget.hostModel.requestedBook2,
                          onPressed: () {
                            _showBookList(context, books, (bookId, name) {
                              setState(() {
                                widget.hostModel.requestedBook2 = name;
                                widget.hostModel.requestedBook2Id = bookId;
                                widget.hostModel.requestedBook2Time = DateTime.now();
                              });
                            });
                          },
                          onCanceled: () {
                            setState(() {
                              widget.hostModel.requestedBook2 = 'EMPTY';
                              widget.hostModel.requestedBook2Id = '';
                              widget.hostModel.requestedBook2Time = DateTime.now();
                            });
                          },
                          subInfo:
                              HycopUtils.dateTimeToDisplay(widget.hostModel.requestedBook2Time),
                        ),
                        _nvRow(
                          'Playing Book 1',
                          widget.hostModel.playingBook1,
                          //subInfo: HycopUtils.dateTimeToDisplay(widget.hostModel.playingBook1Time),
                        ),
                        _nvRow(
                          'Playing Book 2',
                          widget.hostModel.playingBook2,
                          //subInfo: HycopUtils.dateTimeToDisplay(widget.hostModel.playingBook2Time),
                        )
                      ],
                    ),
                  ),
                ),

                // Add more widgets for the second column here
              ],
            ),
          ),
        ],
      ),
      // GridView.count(
      //   crossAxisCount: 2,
      //   childAspectRatio: 5,
      //   padding: const EdgeInsets.all(8.0),
      //   children: <Widget>[
      //     Text('Host Type: ${widget.hostModel.hostType}'),
      //     Text('Host ID: ${widget.hostModel.hostId}'),
      //     TextFormField(
      //       initialValue: widget.hostModel.hostName,
      //       decoration: const InputDecoration(labelText: 'Host Name'),
      //       onSaved: (value) => widget.hostModel.hostName = value ?? '',
      //     ),
      //     TextFormField(
      //       initialValue: widget.hostModel.ip,
      //       decoration: const InputDecoration(labelText: 'IP'),
      //       onSaved: (value) => widget.hostModel.ip = value ?? '',
      //     ),
      //     Text('Interface Name: ${widget.hostModel.interfaceName}'),
      //     Text('Creator: ${widget.hostModel.creator}'),
      //     TextFormField(
      //       initialValue: widget.hostModel.location,
      //       decoration: const InputDecoration(labelText: 'Location'),
      //       onSaved: (value) => widget.hostModel.location = value ?? '',
      //     ),
      //     TextFormField(
      //       initialValue: widget.hostModel.description,
      //       decoration: const InputDecoration(labelText: 'Description'),
      //       onSaved: (value) => widget.hostModel.description = value ?? '',
      //     ),
      //     TextFormField(
      //       initialValue: widget.hostModel.os,
      //       decoration: const InputDecoration(labelText: 'OS'),
      //       onSaved: (value) => widget.hostModel.os = value ?? '',
      //     ),
      //     Text('Is Connected: ${widget.hostModel.isConnected}'),
      //     Text('Is Initialized: ${widget.hostModel.isValidLicense}'),
      //     Text('Is Valid License: ${widget.hostModel.isValidLicense}'),
      //     CheckboxListTile(
      //       title: const Text('Is Used'),
      //       value: widget.hostModel.isUsed,
      //       onChanged: (bool? value) {
      //         setState(() {
      //           widget.hostModel.isUsed = value ?? false;
      //         });
      //       },
      //     ),
      //   ],
      // ),
      //),
    );
    // return Center(
    //   child: Column(
    //     children: [
    //       CretaCommonUtils.underConstruction(
    //         width: 200,
    //         height: 200,
    //         padding: const EdgeInsets.all(10),
    //       ),
    //       const SizedBox(height: 20),
    //       TextButton(
    //         child: const Text('back to list'),
    //         onPressed: () {
    //           Routemaster.of(context).push(AppRoutes.deviceMainPage);
    //         },
    //       )
    //     ],
    //   ),
    // );
  }

  void _showBookList(BuildContext context, List<BookModel> books,
      void Function(String bookId, String name)? onSelected) {
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.5;
    double height = screenSize.height * 0.7;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CretaDeviceLang['selectBook']!),
              IconButton(
                  icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          content: SizedBox(
            width: width,
            height: height,
            child: BookSelectFilter(onSelected: onSelected, width: width, height: height),
            // ListView.builder(
            //   itemCount: books.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(books[index].name.value),
            //       subtitle: Text(books[index].description.value),
            //       trailing: Image.network(
            //           books[index].thumbnailUrl.value), //const Icon(Icons.arrow_forward_ios),
            //       onTap: () {
            //         // Do something with the selected book
            //         // For example, you might want to navigate to a detail page for the selected book
            //         onSelected?.call(books[index].mid, books[index].name.value);
            //         Navigator.of(context).pop();
            //       },
            //     );
            //   },
            // ),
          ),
        );
      },
    );
  }

// Usage
  Widget _nvWidget(String name, Widget value, Widget? value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 5, child: Text(name, style: titleStyle)),
          Expanded(flex: 8, child: value),
          if (value2 != null) Expanded(flex: 2, child: value2),
        ],
      ),
    );
  }

  Widget _nvRow(String name, String value, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 4, child: Text(name, style: titleStyle)),
          Expanded(
              flex: 6,
              child: Text(
                value.isEmpty ? '-' : value,
                textAlign: TextAlign.right,
                style: dataStyle,
                overflow: TextOverflow.ellipsis,
              )),
          if (onPressed != null) const SizedBox(width: 15),
          if (onPressed != null)
            BTN.fill_gray_100_i_s(
              onPressed: onPressed,
              icon: Icons.close,
            ),
        ],
      ),
    );
  }

  Widget _nvChanged(String name, String value,
      {required void Function() onPressed,
      required void Function() onCanceled,
      String? subInfo,
      double padding = 2.0,
      Widget? dataChild}) {
    Widget dataRow = dataChild ??
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: CretaColor.primary.withOpacity(0.7), // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Shadow elevation
                  padding: const EdgeInsets.all(10), // Padding
                  shape: RoundedRectangleBorder(
                    // Button shape
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: SizedBox(
                  width: 140,
                  child: Text(value.isEmpty ? '-' : value,
                      textAlign: TextAlign.right, style: dataStyle),
                )),
            IconButton(
              onPressed: onCanceled,
              icon: const Icon(
                Icons.close,
                color: CretaColor.primary,
              ),
            ),
          ],
        );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subInfo == null
              ? Text(name, style: titleStyle)
              : Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(name, style: titleStyle),
                ),
          subInfo == null
              ? dataRow
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dataRow,
                    Text(subInfo, style: titleStyle),
                  ],
                )
        ],
      ),
    );
  }

  Widget _nvChangedColumn(String name, String value,
      {double padding = 2.0, required Widget dataRow}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: titleStyle),
          SizedBox(
              //color: Colors.amber,
              width: double.infinity,
              child: Align(alignment: Alignment.centerRight, child: dataRow)),
        ],
      ),
    );
  }

  Widget _boolRow(String name, bool value, bool isActive, {void Function(bool)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          CretaToggleButton(
            width: 54 * (onChanged == null ? 0.9 : 1.0),
            height: 28 * (onChanged == null ? 0.66 : 1.0),
            defaultValue: value,
            onSelected: (v) {
              onChanged?.call(v);
            },
            isActive: isActive,
          ),
        ],
      ),
    );
  }

  Widget _sliderRow(String name, double value, bool isActive, {void Function(double)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          CretaExSlider(
            isActive: isActive,
            valueType: SliderValueType.normal,
            value: value,
            min: 0,
            max: 100,
            onChannged: (v) {
              onChanged?.call(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonRow(String name, String url, String buttonName, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: CretaColor.primary.withOpacity(0.7), // Text color
                shadowColor: Colors.grey, // Shadow color
                elevation: 5, // Shadow elevation
                padding: const EdgeInsets.all(10), // Padding
                shape: RoundedRectangleBorder(
                  // Button shape
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: SizedBox(
                width: 142,
                child: Text(buttonName, textAlign: TextAlign.right, style: dataStyle),
              )),
        ],
      ),
    );
  }
}
