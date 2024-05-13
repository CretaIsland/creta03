import 'package:flutter/material.dart';

import '../../data_io/host_manager.dart';
import '../../lang/creta_device_lang.dart';

class DeviceData {
  GlobalObjectKey<FormState>? formKey;
  String hostId = '';
  String hostName = '';
  String message = '';
}

class NewDeviceInput extends StatefulWidget {
  final DeviceData data;
  final String formKeyStr;
  const NewDeviceInput({super.key, required this.data, required this.formKeyStr});

  @override
  NewDeviceInputState createState() => NewDeviceInputState();
}

class NewDeviceInputState extends State<NewDeviceInput> {
  late HostManager dummyHostManager;

  @override
  void initState() {
    super.initState();
    dummyHostManager = HostManager();
    widget.data.formKey = GlobalObjectKey<FormState>(widget.formKeyStr);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 400,
      child: Form(
        key: widget.data.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 240,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.data.hostId,
                      onChanged: (value) => widget.data.hostId = value,
                      decoration: InputDecoration(hintText: CretaDeviceLang['deviceId']!),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CretaDeviceLang['shouldInputDeviceId']!;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextButton(
                  child: Text(CretaDeviceLang['dupCheck']!),
                  onPressed: () async {
                    if (widget.data.formKey!.currentState!.validate()) {
                      bool isExist = await dummyHostManager.isNameExist(widget.data.hostId);
                      setState(() {
                        if (isExist) {
                          widget.data.message = CretaDeviceLang['alreadyExist']!;
                        } else {
                          widget.data.message = CretaDeviceLang['availiableID']!;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            if (widget.data.message.isNotEmpty)
              Text(
                widget.data.message,
                style: const TextStyle(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => widget.data.hostName = value,
                decoration: InputDecoration(hintText: CretaDeviceLang['deviceName']!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    widget.data.hostName = widget.data.hostId;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
