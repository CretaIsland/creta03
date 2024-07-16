import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../data_io/enterprise_manager.dart';
import '../../lang/creta_device_lang.dart';
import '../login/creta_account_manager.dart';

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
                      onChanged: (value) {
                        widget.data.name = value;
                        widget.data.message = '';
                      },
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
                      if (isExist) {
                        widget.data.message = CretaDeviceLang['alreadyExist']!;
                      } else {
                        final AccountSignUpType? accountSignUpType =
                            await AccountManager.isExistAccount(
                                '${widget.data.name}Admin@nomail.com');
                        if (accountSignUpType != null &&
                            accountSignUpType != AccountSignUpType.none &&
                            accountSignUpType != AccountSignUpType.end) {
                          widget.data.message =
                              '1.${CretaDeviceLang['alreadyExistEmail'] ?? "같은 email ID 가 이미 존재합니다"} (${widget.data.name}Admin@nomail.com)';
                        } else {
                          bool isUserExist = await CretaAccountManager.userPropertyManagerHolder
                              .isNameExist('${widget.data.name}Admin@nomail.com', name: "email");
                          if (isUserExist) {
                            widget.data.message =
                                '2.${CretaDeviceLang['alreadyExistEmail'] ?? "같은 email ID 가 이미 존재합니다"} (${widget.data.name}Admin@nomail.com)';
                          } else {
                            TeamManager dummyTeamManager = TeamManager();
                            bool isTeamExist = await dummyTeamManager.isNameExist(widget.data.name);
                            if (isTeamExist) {
                              widget.data.message =
                                  CretaDeviceLang['alreadyExistTeam'] ?? "같은 Team ID 가 이미 존재합니다";
                            } else {
                              widget.data.message = CretaDeviceLang['availiableID']!;
                            }
                          }
                        }
                      }
                      setState(() {});
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
                onChanged: (value) => widget.data.description = value,
                decoration: InputDecoration(hintText: CretaDeviceLang['description']!),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     onChanged: (value) => widget.data.enterpriseUrl = value,
            //     decoration: InputDecoration(hintText: CretaDeviceLang['enterpriseUrl']!),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
