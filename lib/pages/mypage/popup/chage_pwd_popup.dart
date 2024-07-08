import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../../lang/creta_commu_lang.dart';

class ChangePwdPopUp {
  static String _nowPassword = '';
  static String _newPassword = '';
  static String _checkNewPassword = '';

  static Widget changePwdPopUp(BuildContext context, {String? title}) {
    return CretaDialog(
      width: 406.0,
      height: 289.0,
      title: title ?? CretaCommuLang['changePassword'],
      crossAxisAlign: CrossAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28.0),
          CretaTextField(
            textFieldKey: GlobalKey(),
            value: '',
            hintText: CretaMyPageLang['oldPassword'], //'현재 비밀번호',
            width: 294.0,
            height: 30.0,
            onChanged: (value) => _nowPassword = value,
            onEditComplete: (String value) => _nowPassword = value,
          ),
          const SizedBox(height: 20.0),
          CretaTextField(
            textFieldKey: GlobalKey(),
            value: '',
            hintText: CretaMyPageLang['newPassword'], //'새 비밀번호',
            width: 294.0,
            height: 30.0,
            onChanged: (value) => _newPassword = value,
            onEditComplete: (String value) => _newPassword = value,
          ),
          const SizedBox(height: 20.0),
          CretaTextField(
            textFieldKey: GlobalKey(),
            value: '',
            hintText: CretaMyPageLang['newPasswordConfirm'], //'새 비밀번호 확인',
            width: 294.0,
            height: 30.0,
            onChanged: (value) => _checkNewPassword = value,
            onEditComplete: (String value) => _checkNewPassword = value,
          ),
          const SizedBox(height: 24.0),
          BTN.fill_blue_t_m(
              text: CretaMyPageLang['passwordChangeBTN']!,
              width: 294.0,
              height: 32.0,
              onPressed: () {
                if (_nowPassword.isEmpty || _newPassword.isEmpty || _checkNewPassword.isEmpty) {
                  logger.fine('empty textfield');
                  return;
                }
                if (_newPassword != _checkNewPassword) {
                  logger.fine('not match new password');
                  return;
                }
                if (_newPassword == _checkNewPassword) {
                  HycopFactory.account!
                      .updateAccountPassword(_newPassword, _nowPassword)
                      .onError((error, stackTrace) {
                    if (error.toString().contains('no exist')) {
                      logger.fine('wrong password');
                    }
                  }).then((value) => Navigator.of(context).pop());
                }
              })
        ],
      ),
    );
  }
}
