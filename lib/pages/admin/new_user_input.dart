import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';

import '../../lang/creta_device_lang.dart';

class UserData {
  GlobalObjectKey<FormState>? formKey;
  //String description = '';
  String nickname = '';
  String email = '';
  String password = '';
  String teamMid = '';
  String message = '';
}

class NewUserInput extends StatefulWidget {
  final UserData data;
  final String formKeyStr;
  const NewUserInput({super.key, required this.data, required this.formKeyStr});

  @override
  NewUserInputState createState() => NewUserInputState();
}

class NewUserInputState extends State<NewUserInput> {
  late UserPropertyManager dummyUserPropertyManager;

  @override
  void initState() {
    super.initState();
    dummyUserPropertyManager = UserPropertyManager();
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
                      initialValue: widget.data.nickname,
                      onChanged: (value) => widget.data.nickname = value,
                      decoration: InputDecoration(hintText: CretaDeviceLang['userName']!),
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
                      bool isExist =
                          await dummyUserPropertyManager.isNameExist(widget.data.nickname);
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     onChanged: (value) => widget.data.description = value,
            //     decoration: InputDecoration(hintText: CretaDeviceLang['description']!),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     onChanged: (value) => widget.data.email = value,
            //     decoration: InputDecoration(hintText: CretaDeviceLang['email']!),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
