//import 'package:creta_common/common/creta_common_utils.dart';
import 'dart:convert';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:intl/intl.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/host_model.dart';
import 'book_select_filter.dart';

class DeviceDetailPage extends StatefulWidget {
  final HostModel hostModel;
  final void Function() onExit;
  final GlobalKey<FormState> formKey;

  const DeviceDetailPage({
    super.key,
    required this.hostModel,
    required this.onExit,
    required this.formKey,
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  List<bool> weekend = List.filled(7, false);

  List<BookModel> books = [
    BookModel.withName('Book 1', creator: 'abc@sqisoft.com', creatorName: 'Kim abc', imageUrl: ''),
    BookModel.withName('Book 2', creator: 'bcd@sqisoft.com', creatorName: 'Kim bcd', imageUrl: ''),
    BookModel.withName('Book 3', creator: '123@sqisoft.com', creatorName: 'Park 123', imageUrl: ''),
    BookModel.withName('Book 4', creator: '456@sqisoft.com', creatorName: 'Park 456', imageUrl: ''),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.hostModel.weekend.isNotEmpty) {
      try {
        weekend = (jsonDecode(widget.hostModel.weekend) as List<dynamic>)
            .map((item) => item.toString() == 'true')
            .toList();
      } catch (e) {
        logger.warning('Error in parsing weekend: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    // double width = screenSize.width * 0.5;
    // double height = screenSize.height * 0.5;

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
          Expanded(
            child: ListView(
              children: <Widget>[
                _nvRow('Device ID', widget.hostModel.hostId),
                _nvRow('Device Type', widget.hostModel.hostType.name.split(".").last),
                _nvRow('Owner', widget.hostModel.creator),
                _nvRow('Interface Name', widget.hostModel.interfaceName),
                _nvRow('IP', widget.hostModel.ip),
                _nvRow('OS', widget.hostModel.os),
                _boolRow('Is Connected', widget.hostModel.isConnected, false),
                _boolRow('Is Operational', widget.hostModel.isOperational, false),
                _boolRow('Is Initialized', widget.hostModel.isInitialized, false),
                //_boolRow('Is Licensed', widget.hostModel.isValidLicense, false),
                _nvRow('License Time', HycopUtils.dateTimeToDB(widget.hostModel.licenseTime)),
                _nvRow('Initialize Time', HycopUtils.dateTimeToDB(widget.hostModel.initializeTime)),
                _nvRow('Last Connected Time', HycopUtils.dateTimeToDB(widget.hostModel.updateTime)),
                _nvRow('Last Boot Time', HycopUtils.dateTimeToDB(widget.hostModel.bootTime)),
                _nvRow(
                    'Last Shutdown Time', HycopUtils.dateTimeToDB(widget.hostModel.shutdownTime)),

                _nvRow('HDD Info', widget.hostModel.hddInfo),
                _nvRow('CPU Info', widget.hostModel.cpuInfo),
                _nvRow('Memory Info', widget.hostModel.memInfo),
                _nvRow('State Message', widget.hostModel.stateMsg),
                _nvRow('Request', widget.hostModel.request),
                _nvRow('Response', widget.hostModel.response),
                _nvRow('Download Result', widget.hostModel.downloadResult.name.split('.').last),
                _nvRow('Download Message', widget.hostModel.downloadMsg),

                //Text('Thumbnail URL: ${widget.hostModel.thumbnailUrl}'),
              ],
            ),
          ),
          const SizedBox(width: 90),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8.0, right: 2),
                  child: _boolRow(
                    '사용상태 설정',
                    widget.hostModel.isUsed,
                    true,
                    onChanged: (bool value) {
                      setState(() {
                        widget.hostModel.isUsed = value;
                      });
                    },
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
                          child: Text("일반 정보 설정", style: dataStyle),
                        ),
                        TextFormField(
                          initialValue: widget.hostModel.hostName,
                          decoration: const InputDecoration(labelText: 'Host Name'),
                          onSaved: (value) => widget.hostModel.hostName = value ?? '',
                        ),
                        TextFormField(
                          initialValue: widget.hostModel.description,
                          decoration: const InputDecoration(labelText: 'Description'),
                          onSaved: (value) => widget.hostModel.description = value ?? '',
                        ),
                        TextFormField(
                          initialValue: widget.hostModel.location,
                          decoration: const InputDecoration(labelText: 'Location'),
                          onSaved: (value) => widget.hostModel.location = value ?? '',
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
                          child: Text("전원 설정", style: dataStyle),
                        ),
                        //const Divider(color: Colors.grey),
                        _nvChanged(
                          'Power On Time',
                          widget.hostModel.powerOnTime,
                          () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (selectedTime != null) {
                              // ignore: use_build_context_synchronously
                              setState(() {
                                widget.hostModel.powerOnTime = selectedTime.format(context);
                              });
                            }
                          },
                          padding: 4,
                        ),
                        _nvChanged(
                          'Power Off Time',
                          widget.hostModel.powerOffTime,
                          () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (selectedTime != null) {
                              // ignore: use_build_context_synchronously
                              setState(() {
                                widget.hostModel.powerOffTime = selectedTime.format(context);
                              });
                            }
                          },
                          padding: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            initialValue: widget.hostModel.holiday,
                            decoration: const InputDecoration(
                              labelText: 'holiday',
                              hintText: 'ex) 12-25,1-1,7-4',
                            ),
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
                                    width: 50,
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
                          child: Text("현재 방송 설정", style: dataStyle),
                        ),
                        _nvChanged(
                          'Requested Book 1',
                          widget.hostModel.requestedBook1,
                          () {
                            _showBookList(context, books, (bookId, name) {
                              setState(() {
                                widget.hostModel.requestedBook1 = name;
                                widget.hostModel.requestedBook1Id = bookId;
                                widget.hostModel.requestedBook1Time = DateTime.now();
                              });
                            });
                          },
                          subInfo: HycopUtils.dateTimeToDB(widget.hostModel.requestedBook1Time),
                        ),
                        _nvChanged(
                          'Requested Book 2',
                          widget.hostModel.requestedBook2,
                          () {
                            _showBookList(context, books, (bookId, name) {
                              setState(() {
                                widget.hostModel.requestedBook2 = name;
                                widget.hostModel.requestedBook2Id = bookId;
                                widget.hostModel.requestedBook2Time = DateTime.now();
                              });
                            });
                          },
                          subInfo: HycopUtils.dateTimeToDB(widget.hostModel.requestedBook2Time),
                        ),
                        _nvRow(
                          'Playing Book 1',
                          widget.hostModel.playingBook1,
                          //subInfo: HycopUtils.dateTimeToDB(widget.hostModel.playingBook1Time),
                        ),
                        _nvRow(
                          'Playing Book 2',
                          widget.hostModel.playingBook2,
                          //subInfo: HycopUtils.dateTimeToDB(widget.hostModel.playingBook2Time),
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
      //     Text('Is Initialized: ${widget.hostModel.isInitialized}'),
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
              Text(CretaDeviceLang.selectBook),
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

  Widget _nvRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: dataStyle),
        ],
      ),
    );
  }

  Widget _nvChanged(String name, String value, void Function() onPressed,
      {String? subInfo, double padding = 2.0, Widget? dataChild}) {
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
                  width: 160,
                  child: Text(value.isEmpty ? '-' : value,
                      textAlign: TextAlign.right, style: dataStyle),
                )),
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
}
