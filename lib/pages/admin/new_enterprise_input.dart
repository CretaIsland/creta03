import 'package:flutter/material.dart';

import '../../data_io/enterprise_manager.dart';
import '../../lang/creta_device_lang.dart';

class EnterpriseData {
  GlobalObjectKey<FormState>? formKey;
  String description = '';
  String name = '';
  String enterpriseUrl = '';
  String message = '';
}

class NewEnterpriseInput extends StatefulWidget {
  final EnterpriseData data;
  final String formKeyStr;
  const NewEnterpriseInput({super.key, required this.data, required this.formKeyStr});

  @override
  NewEnterpriseInputState createState() => NewEnterpriseInputState();
}

class NewEnterpriseInputState extends State<NewEnterpriseInput> {
  late EnterpriseManager dummyEnterpriseManager;

  @override
  void initState() {
    super.initState();
    dummyEnterpriseManager = EnterpriseManager();
    widget.data.formKey = GlobalObjectKey<FormState>(widget.formKeyStr);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
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
                      initialValue: widget.data.name,
                      onChanged: (value) => widget.data.name = value,
                      decoration: InputDecoration(hintText: CretaDeviceLang['enterpriseName']!),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CretaDeviceLang['shouldInputEntterpriseName']!;
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
                      bool isExist = await dummyEnterpriseManager.isNameExist(widget.data.name);
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
                onChanged: (value) => widget.data.description = value,
                decoration: InputDecoration(hintText: CretaDeviceLang['description']!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => widget.data.enterpriseUrl = value,
                decoration: InputDecoration(hintText: CretaDeviceLang['enterpriseUrl']!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
