//import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 2,
      height: screenSize.height / 2,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 40, child: Text(widget.hostModel.hostId, style: CretaFont.titleLarge)),
          ),
          Container(
            color: Colors.white,
            height: (screenSize.height / 2) - 130,
            margin: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Text('Host Type: ${widget.hostModel.hostType}'),
                        TextFormField(
                          initialValue: widget.hostModel.hostName,
                          decoration: const InputDecoration(labelText: 'Host Name'),
                          onSaved: (value) => widget.hostModel.hostName = value ?? '',
                        ),
                        Text('Interface Name: ${widget.hostModel.interfaceName}'),
                        TextFormField(
                          initialValue: widget.hostModel.location,
                          decoration: const InputDecoration(labelText: 'Location'),
                          onSaved: (value) => widget.hostModel.location = value ?? '',
                        ),
                        TextFormField(
                          initialValue: widget.hostModel.os,
                          decoration: const InputDecoration(labelText: 'OS'),
                          onSaved: (value) => widget.hostModel.os = value ?? '',
                        ),
                        Text('Is Connected: ${widget.hostModel.isConnected}'),
                        Text('Is Valid License: ${widget.hostModel.isValidLicense}'),
                        // Add more widgets for the first column here
                        Text('Is Operational: ${widget.hostModel.isOperational}'),
                        Text('License Time: ${widget.hostModel.licenseTime}'),
                        Text('Initialize Time: ${widget.hostModel.initializeTime}'),
                        Text('Thumbnail URL: ${widget.hostModel.thumbnailUrl}'),
                        Text('Power On Time: ${widget.hostModel.powerOnTime}'),
                        Text('Power Off Time: ${widget.hostModel.powerOffTime}'),
                        Text('Requested Book 1: ${widget.hostModel.requestedBook1}'),
                        Text('Requested Book 2: ${widget.hostModel.requestedBook2}'),
                        Text('Requested Book 1 Time: ${widget.hostModel.requestedBook1Time}'),
                        Text('Requested Book 2 Time: ${widget.hostModel.requestedBook2Time}'),
                        Text('Playing Book 1: ${widget.hostModel.playingBook1}'),
                        Text('Playing Book 2: ${widget.hostModel.playingBook2}'),
                        Text('Playing Book 1 Time: ${widget.hostModel.playingBook1Time}'),
                        Text('Playing Book 2 Time: ${widget.hostModel.playingBook2Time}'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Text('Host ID: ${widget.hostModel.hostId}'),
                        TextFormField(
                          initialValue: widget.hostModel.ip,
                          decoration: const InputDecoration(labelText: 'IP'),
                          onSaved: (value) => widget.hostModel.ip = value ?? '',
                        ),
                        Text('Creator: ${widget.hostModel.creator}'),
                        TextFormField(
                          initialValue: widget.hostModel.description,
                          decoration: const InputDecoration(labelText: 'Description'),
                          onSaved: (value) => widget.hostModel.description = value ?? '',
                        ),
                        Text('Is Initialized: ${widget.hostModel.isInitialized}'),
                        CheckboxListTile(
                          title: const Text('Is Used'),
                          value: widget.hostModel.isUsed,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.hostModel.isUsed = value ?? false;
                            });
                          },
                        ),

                        Text('Request: ${widget.hostModel.request}'),
                        Text('Response: ${widget.hostModel.response}'),
                        Text('Download Result: ${widget.hostModel.downloadResult}'),
                        Text('Download Message: ${widget.hostModel.downloadMsg}'),
                        Text('HDD Info: ${widget.hostModel.hddInfo}'),
                        Text('CPU Info: ${widget.hostModel.cpuInfo}'),
                        Text('Memory Info: ${widget.hostModel.memInfo}'),
                        Text('State Message: ${widget.hostModel.stateMsg}'),
                        Text('Boot Time: ${widget.hostModel.bootTime}'),
                        Text('Shutdown Time: ${widget.hostModel.shutdownTime}'),
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
}
