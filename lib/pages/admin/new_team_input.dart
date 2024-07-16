import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:flutter/material.dart';

import '../../lang/creta_device_lang.dart';

class TeamData {
  GlobalObjectKey<FormState>? formKey;
  //String description = '';
  String name = '';
  String teamUrl = '';
  String message = '';
}

class NewTeamInput extends StatefulWidget {
  final TeamData data;
  final String formKeyStr;
  const NewTeamInput({super.key, required this.data, required this.formKeyStr});

  @override
  NewTeamInputState createState() => NewTeamInputState();
}

class NewTeamInputState extends State<NewTeamInput> {
  late TeamManager dummyTeamManager;

  @override
  void initState() {
    super.initState();
    dummyTeamManager = TeamManager();
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
                      onChanged: (value) {
                        widget.data.name = value;
                        widget.data.message = '';
                      },
                      decoration: InputDecoration(hintText: CretaDeviceLang['teamName']!),
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
                      bool isExist = await dummyTeamManager.isNameExist(widget.data.name);
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
            //     onChanged: (value) => widget.data.teamUrl = value,
            //     decoration: InputDecoration(hintText: CretaDeviceLang['teamUrl']!),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
