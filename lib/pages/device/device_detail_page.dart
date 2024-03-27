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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: widget.onExit,
          child: Text('back to list', style: CretaFont.titleLarge),
        ),
        Container(
          color: Colors.red,
          height: 300,
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Host ID'),
                  onSaved: (value) => widget.hostModel.hostId = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Host Name'),
                  onSaved: (value) => widget.hostModel.hostName = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'IP'),
                  onSaved: (value) => widget.hostModel.ip = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Interface Name'),
                  onSaved: (value) => widget.hostModel.interfaceName = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Creator'),
                  onSaved: (value) => widget.hostModel.creator = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  onSaved: (value) => widget.hostModel.location = value ?? '',
                ),
                CheckboxListTile(
                  title: const Text('Is Connected'),
                  value: widget.hostModel.isConnected,
                  onChanged: (value) =>
                      setState(() => widget.hostModel.isConnected = value ?? false),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => widget.hostModel.description = value ?? '',
                ),
                DropdownButton<HostType>(
                  value: widget.hostModel.hostType,
                  onChanged: (value) =>
                      setState(() => widget.hostModel.hostType = value ?? HostType.signage),
                  items: HostType.values
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          ))
                      .toList(),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'OS'),
                  onSaved: (value) => widget.hostModel.os = value ?? '',
                ),
                CheckboxListTile(
                  title: const Text('Is Initialized'),
                  value: widget.hostModel.isInitialized,
                  onChanged: (value) =>
                      setState(() => widget.hostModel.isInitialized = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Is Valid License'),
                  value: widget.hostModel.isValidLicense,
                  onChanged: (value) =>
                      setState(() => widget.hostModel.isValidLicense = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Is Used'),
                  value: widget.hostModel.isUsed,
                  onChanged: (value) => setState(() => widget.hostModel.isUsed = value ?? false),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'License Time'),
                  onSaved: (value) => widget.hostModel.licenseTime = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Initialize Time'),
                  onSaved: (value) => widget.hostModel.initializeTime = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                  onSaved: (value) => widget.hostModel.thumbnailUrl = value ?? '',
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: widget.onExit,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save the host to your data source here
                }
              },
            ),
          ],
        ),
      ],
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
