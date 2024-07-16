import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../data_io/host_manager.dart';
import '../../lang/creta_device_lang.dart';

class DeviceData {
  GlobalObjectKey<FormState>? formKey;
  String hostId = '';
  String hostName = '';
  String enterprise = '';
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
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;

  @override
  void initState() {
    super.initState();
    dummyHostManager = HostManager();
    widget.data.formKey = GlobalObjectKey<FormState>(widget.formKeyStr);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: 400,
      child: Form(
        key: widget.data.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(CretaDeviceLang['enterpriseName']!),
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8.0),
                  child: AccountManager.currentLoginUser.isSuperUser
                      ? TextFormField(
                          initialValue: widget.data.enterprise,
                          onChanged: (value) {
                            widget.data.enterprise = value;
                          },
                          decoration: InputDecoration(hintText: CretaDeviceLang['enterpriseName']!),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return CretaDeviceLang['shouldInputEntterpriseName']!;
                            }
                            return null;
                          },
                        )
                      : Text(widget.data.enterprise, style: dataStyle),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 240,
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.data.hostId,
                    onChanged: (value) {
                      widget.data.hostId = value;
                      widget.data.message = '';
                    },
                    decoration: InputDecoration(hintText: CretaDeviceLang['deviceId']!),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CretaDeviceLang['shouldInputDeviceId']!;
                      }
                      return null;
                    },
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
                style: TextStyle(
                    color: (widget.data.message == CretaDeviceLang['availiableID']!)
                        ? Colors.blue
                        : Colors.red),
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
