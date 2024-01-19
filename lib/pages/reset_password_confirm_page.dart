// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';

import '../../routes.dart';
import '../design_system/component/snippet.dart';
import '../../design_system/text_field/creta_text_field.dart';
//import '../design_system/creta_font.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';

class ResetPasswordConfirmPage extends StatefulWidget {
  const ResetPasswordConfirmPage({
    super.key,
    required this.userId,
    required this.secretKey,
  });

  final String userId;
  final String secretKey;

  @override
  State<ResetPasswordConfirmPage> createState() => _ResetPasswordConfirmPageState();
}

class _ResetPasswordConfirmPageState extends State<ResetPasswordConfirmPage> {
  final _userIdTextEditingController = TextEditingController();
  final _secretKeyTextEditingController = TextEditingController();
  final _newPasswordTextEditingController = TextEditingController();
  final _newPasswordConfirmTextEditingController = TextEditingController();

  bool _isJobProcessing = false;
  bool _successResetPassword = false;

  @override
  void initState() {
    super.initState();
  }

  void _doResetPasswordConfirm() {
    String userId = _userIdTextEditingController.text;
    String secretKey = _secretKeyTextEditingController.text;
    String newPassword = _newPasswordTextEditingController.text;
    if (HycopFactory.account == null) {
      showSnackBar(context, '내부 에러가 발생하였습니다. 관리자에게 문의해주세요.');
      return;
    }

    setState(() {
      _isJobProcessing = true;
      _successResetPassword = false;
    });
    HycopFactory.account!.resetPasswordConfirm(userId, secretKey, newPassword).then((value) {
      setState(() {
        _isJobProcessing = false;
        _successResetPassword = true;
        showSnackBar(context, '비밀번호가 변경되었습니다.');
      });
    }).catchError((error, stackTrace) {
      setState(() {
        _isJobProcessing = false;
        showSnackBar(context, '비밀번호를 변경할 수 없습니다.');
      });
    });
  }

  BuildContext getBuildContext() {
    return context;
  }

  Widget _getChangePasswordButton() {
    return _isJobProcessing
        ? BTN.line_blue_iwi_m(
            width: 294,
            widget: Snippet.showWaitSign(color: Colors.white, size: 16),
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {},
          )
        : BTN.line_blue_iti_m(
            width: 200,
            text: _successResetPassword ? 'Password is changed' : 'Change password',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String newPassword = _newPasswordTextEditingController.text;
              String newPasswordConfirm = _newPasswordConfirmTextEditingController.text;
              if (newPassword != newPasswordConfirm) {
                showSnackBar(context, '비밀번호를 다시 확인해주세요');
                return;
              }
              _doResetPasswordConfirm();
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    String logoUrl = (CretaAccountManager.currentLoginUser.isLoginedUser) ? AppRoutes.communityHome : AppRoutes.intro;
    return Snippet.CretaScaffoldOfCommunity(
      title: Row(
        children: [
          SizedBox(
            width: 24,
          ),
          Theme(
            data: ThemeData(
              hoverColor: Colors.transparent,
            ),
            child: Link(
              uri: Uri.parse(logoUrl),
              builder: (context, function) {
                return InkWell(
                  onTap: () => Routemaster.of(context).push(logoUrl),
                  child: Image(
                    image: AssetImage('assets/creta_logo_blue.png'),
                    //width: 120,
                    height: 20,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      context: context,
      getBuildContext: getBuildContext,
      child: Center(
          child: SizedBox(
            width: 450,
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('User ID'),
                    ),
                    CretaTextField(
                      textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.userId'),
                      controller: _userIdTextEditingController,
                      width: 300,
                      height: 30,
                      value: widget.userId,
                      hintText: '사용자ID',
                      autofillHints: const [AutofillHints.username],
                      onEditComplete: (value) {},
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('Secret Key'),
                    ),
                    CretaTextField(
                      textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.secretKey'),
                      controller: _secretKeyTextEditingController,
                      width: 300,
                      height: 30,
                      value: widget.secretKey,
                      hintText: '비밀키',
                      autofillHints: const [AutofillHints.photo],
                      onEditComplete: (value) {},
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('New password'),
                    ),
                    CretaTextField(
                      textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.newPassword'),
                      controller: _newPasswordTextEditingController,
                      width: 300,
                      height: 30,
                      value: '',
                      textType: CretaTextFieldType.password,
                      hintText: '새 비밀번호',
                      autofillHints: const [AutofillHints.photo],
                      onEditComplete: (value) {},
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('Confirm new password'),
                    ),
                    CretaTextField(
                      textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.newPasswordConfirm'),
                      controller: _newPasswordConfirmTextEditingController,
                      width: 300,
                      height: 30,
                      value: '',
                      textType: CretaTextFieldType.password,
                      hintText: '새 비밀번호 확인',
                      autofillHints: const [AutofillHints.photo],
                      onEditComplete: (value) {},
                    ),
                  ],
                ),
                _getChangePasswordButton(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: BTN.line_blue_iti_m(
                    width: 200,
                    text: '크레타 홈으로 이동',
                    buttonColor: CretaButtonColor.skyTitle,
                    decoType: CretaButtonDeco.fill,
                    textColor: Colors.white,
                    onPressed: () {
                      Routemaster.of(context).push(AppRoutes.communityHome);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
