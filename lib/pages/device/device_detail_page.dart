//import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/utils/hycop_utils.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../model/host_model.dart';

class DeviceDetailPage extends StatefulWidget {
  final HostModel hostModel;
  final void Function() onExit;

  const DeviceDetailPage({
    super.key,
    required this.hostModel,
    required this.onExit,
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  final _formKey = GlobalKey<FormState>();
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 2;
    double height = screenSize.height / 1.5;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Device Detail : ${widget.hostModel.hostId}', style: CretaFont.titleLarge),
          backgroundColor: CretaColor.primary,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              child: BTN.fill_blue_i_l(
                  icon: Icons.close_outlined,
                  onPressed: () {
                    widget.onExit();
                  }),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Container(
            //       color: CretaColor.primary,
            //       height: 40,
            //       width: screenSize.width / 2,
            //       child: Center(child: Text(widget.hostModel.hostId, style: CretaFont.titleLarge))),
            // ),
            Container(
              color: Colors.white,
              height: height - 130,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                key: _formKey,
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
                          _nvRow('License Time', widget.hostModel.licenseTime),
                          _nvRow('Initialize Time', widget.hostModel.initializeTime),
                          _nvRow('Last Connected Time',
                              HycopUtils.dateTimeToDB(widget.hostModel.updateTime)),
                          _nvRow('Last Boot Time', widget.hostModel.bootTime),
                          _nvRow('Last Shutdown Time', widget.hostModel.shutdownTime),

                          _nvRow('HDD Info', widget.hostModel.hddInfo),
                          _nvRow('CPU Info', widget.hostModel.cpuInfo),
                          _nvRow('Memory Info', widget.hostModel.memInfo),
                          _nvRow('State Message', widget.hostModel.stateMsg),
                          _nvRow('Request', widget.hostModel.request),
                          _nvRow('Response', widget.hostModel.response),
                          _nvRow('Download Result',
                              widget.hostModel.downloadResult.name.split('.').last),
                          _nvRow('Download Message', widget.hostModel.downloadMsg),

                          //Text('Thumbnail URL: ${widget.hostModel.thumbnailUrl}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 100),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: _boolRow(
                              'Is Used',
                              widget.hostModel.isUsed,
                              true,
                              onChanged: (bool value) {
                                setState(() {
                                  widget.hostModel.isUsed = value;
                                });
                              },
                            ),
                          ),
                          _nvChanged(
                            'Power On Time',
                            widget.hostModel.powerOnTime,
                            () {},
                          ),
                          _nvChanged(
                            'Power Off Time',
                            widget.hostModel.powerOffTime,
                            () {},
                          ),
                          _nvChanged(
                            'Requested Book 1',
                            widget.hostModel.requestedBook1,
                            () {},
                          ),
                          _nvChanged(
                            'Requested Book 2',
                            widget.hostModel.requestedBook2,
                            () {},
                          ),
                          _nvRow('Requested Book 1 Time', widget.hostModel.requestedBook1Time),
                          _nvRow('Requested Book 2 Time', widget.hostModel.requestedBook2Time),
                          _nvRow('Playing Book 1', widget.hostModel.playingBook1),
                          _nvRow('Playing Book 2', widget.hostModel.playingBook2),
                          _nvRow('Playing Book 1 Time', widget.hostModel.playingBook1Time),
                          _nvRow('Playing Book 2 Time', widget.hostModel.playingBook2Time),

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
              ),
            ),
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Save the host to your data source here
                        }
                        widget.onExit();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: widget.onExit, child: const Text('Cancel')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _nvRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: dataStyle),
        ],
      ),
    );
  }

  Widget _nvChanged(String name, String value, void Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: dataStyle),
              SizedBox(
                width: 20,
                height: 20,
                child: IconButton(
                    icon: const Icon(Icons.edit, color: CretaColor.text),
                    iconSize: 12,
                    onPressed: onPressed),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _boolRow(String name, bool value, bool isActive, {void Function(bool)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          CretaToggleButton(
            width: 54 * 0.9,
            height: 28 * 0.66,
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
