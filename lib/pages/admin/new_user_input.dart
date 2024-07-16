import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';

import '../../lang/creta_commu_lang.dart';
import '../../lang/creta_device_lang.dart';

class UserData {
  GlobalObjectKey<FormState>? formKey;
  //String description = '';
  String nickname = '';
  String email = '';
  String password = '';
  String teamMid = '';
  String enterprise = '';
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

  bool _obscured = true;
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  void initState() {
    super.initState();
    dummyUserPropertyManager = UserPropertyManager();
    widget.data.formKey = GlobalObjectKey<FormState>(widget.formKeyStr);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Form(
        key: widget.data.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 240,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.data.enterprise,
                  onChanged: (value) {
                    widget.data.enterprise = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'enterprise',
                    labelText: 'enterprise',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CretaDeviceLang['shouldInputEntterpriseName'] ?? '엔터프라이즈 이름을 입력하세요';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              width: 240,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: widget.data.email,
                  onChanged: (value) {
                    widget.data.email = value;
                    widget.data.message = '';
                  },
                  decoration: InputDecoration(
                    hintText: CretaDeviceLang['userEmail'] ?? '유저 ID',
                    labelText: CretaDeviceLang['userEmail'] ?? '유저 ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CretaDeviceLang['shouldInputUserEmail'] ?? '유저 ID(Email)을 입력해주세요';
                    }
                    if (CretaCommonUtils.isValidEmail(value) == false) {
                      return CretaDeviceLang['Invalidemail'];
                    }
                    return null;
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 240,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: widget.data.nickname,
                      onChanged: (value) {
                        widget.data.nickname = value;
                        widget.data.message = '';
                      },
                      decoration: InputDecoration(
                        hintText: CretaDeviceLang['userName'] ?? '유저 이름',
                        labelText: CretaDeviceLang['userName'] ?? '유저 이름',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CretaDeviceLang['shouldInputUserName'] ?? '유저 이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextButton(
                  child: Text(CretaDeviceLang['dupCheck']!),
                  onPressed: () async {
                    //if (widget.data.formKey!.currentState!.validate()) {
                    widget.data.formKey!.currentState!.validate();

                    bool isExist = await dummyUserPropertyManager.isNameExist(widget.data.email,
                        name: 'email');
                    if (isExist) {
                      widget.data.message = CretaDeviceLang['alreadyExist']!;
                      setState(() {});
                      return;
                    }
                    isExist = await dummyUserPropertyManager.isNameExist(widget.data.nickname,
                        name: 'nickname');
                    if (isExist) {
                      widget.data.message = CretaDeviceLang['alreadyExistName']!;
                    } else {
                      widget.data.message = CretaDeviceLang['availiableID']!;
                    }
                    setState(() {});
                    //}
                  },
                ),
              ],
            ),
            SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: _obscured,
                  initialValue: widget.data.password,
                  onChanged: (value) => widget.data.password = value,
                  decoration: InputDecoration(
                    hintText: CretaCommuLang['password'] ?? '패스워드',
                    labelText: CretaCommuLang['password'] ?? '패스워드',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          size: 18,
                          //color: (_focusNode?.hasFocus ?? false) ? CretaColor.primary : CretaColor.text[200]!,
                          color: CretaColor.primary,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return CretaCommuLang['checkPassword'] ?? '비밀번호를 확인하세요';
                    }
                    if (CretaCommonUtils.isPasswordSecure(value) == false) {
                      return CretaCommuLang['enterPassword'];
                    }
                    return null;
                  },
                ),
              ),
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
