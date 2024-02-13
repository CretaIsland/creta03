// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';

import '../pages/login/creta_account_manager.dart';
import '../../routes.dart';
import '../common/creta_utils.dart';
import '../design_system/component/snippet.dart';
import '../../design_system/text_field/creta_text_field.dart';
import '../design_system/creta_font.dart';
import '../design_system/creta_color.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/dialog/creta_dialog.dart';

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
  final _newPasswordTextEditingController = TextEditingController();
  final _newPasswordConfirmTextEditingController = TextEditingController();
  bool _newPasswordError = false;
  bool _newPasswordConfirmError = false;

  bool _isJobProcessing = false;
  bool _successResetPassword = false;

  @override
  void initState() {
    super.initState();
  }

  void _doResetPasswordConfirm() {
    String newPassword = _newPasswordTextEditingController.text;
    if (HycopFactory.account == null) {
      showSnackBar(context, '내부 에러가 발생하였습니다. 관리자에게 문의해주세요.');
      return;
    }

    setState(() {
      _isJobProcessing = true;
      _successResetPassword = false;
    });
    HycopFactory.account!.resetPasswordConfirm(widget.userId, widget.secretKey, newPassword).then((value) {
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
            width: 326,
            widget: Snippet.showWaitSign(color: Colors.white, size: 16),
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {},
          )
        : BTN.line_blue_iti_m(
            width: 326,
            text: _successResetPassword ? '비밀번호가 변경되었습니다' : '비밀번호 변경',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String newPassword = _newPasswordTextEditingController.text;
              String newPasswordConfirm = _newPasswordConfirmTextEditingController.text;
              if (newPassword != newPasswordConfirm || !CretaUtils.checkPasswordStrength(newPassword)) {
                showSnackBar(context, '비밀번호를 다시 확인해주세요');
                return;
              }
              _doResetPasswordConfirm();
            },
          );
  }

  void checkPasswordStrength(String password) {
    setState(() {
      _newPasswordError = (password.isEmpty) ? false : !CretaUtils.checkPasswordStrength(password);
    });
  }

  void checkPasswordConfirmStrength(String password) {
    setState(() {
      _newPasswordConfirmError = (password.isEmpty) ? false : !CretaUtils.checkPasswordStrength(password);
    });
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
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: CretaStackDialog(
            width: 406,
            height: 288,
            showCloseButton: false,
            elevation: 5,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 40, 0, 0),
                  child: Text(
                    '비밀번호',
                    style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 0, 0),
                  child: CretaTextField(
                    textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.newPassword'),
                    controller: _newPasswordTextEditingController,
                    width: 326,
                    height: 30,
                    value: '',
                    textType: CretaTextFieldType.password,
                    hintText: '비밀번호 (6자~16자, 영문/숫자 필수)',
                    autofillHints: const [AutofillHints.newPassword],
                    onEditComplete: (value) {},
                    onChanged: checkPasswordStrength,
                    fixedOutlineColor: _newPasswordError ? CretaColor.stateCritical : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 0, 0),
                  child: Text(
                    '비밀번호 확인',
                    style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 0, 0),
                  child: CretaTextField(
                    textFieldKey: GlobalObjectKey('ResetPasswordConfirmPage.newPasswordConfirm'),
                    controller: _newPasswordConfirmTextEditingController,
                    width: 326,
                    height: 30,
                    value: '',
                    textType: CretaTextFieldType.password,
                    hintText: '비밀번호 (6자~16자, 영문/숫자 필수)',
                    autofillHints: const [AutofillHints.newPassword],
                    onEditComplete: (value) {},
                    onChanged: checkPasswordConfirmStrength,
                    fixedOutlineColor: _newPasswordConfirmError ? CretaColor.stateCritical : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 44, 0, 0),
                  child: _getChangePasswordButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
