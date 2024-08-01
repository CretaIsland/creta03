// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';

import '../../design_system/text_field/creta_text_field.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/dialog/creta_dialog.dart';
import '../lang/creta_commu_lang.dart';
import '../routes.dart';
import 'login/creta_account_manager.dart';

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
      showSnackBar(context, CretaCommuLang["internalError"]! //'내부 에러가 발생하였습니다. 관리자에게 문의해주세요.'
          );
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
        showSnackBar(context, CretaCommuLang["passwordChanged"]! //'비밀번호가 변경되었습니다.'
            );
      });
    }).catchError((error, stackTrace) {
      setState(() {
        _isJobProcessing = false;
        showSnackBar(context, CretaCommuLang["cantChangePassword"]! //'비밀번호를 변경할 수 없습니다.'
            );
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
            widget: CretaSnippet.showWaitSign(color: Colors.white, size: 16),
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {},
          )
        : BTN.line_blue_iti_m(
            width: 326,
            text: _successResetPassword
                ? CretaCommuLang["passwordChanged"]! //'비밀번호가 변경되었습니다'
                : CretaCommuLang["changePassword"]!, //'비밀번호 변경',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String newPassword = _newPasswordTextEditingController.text;
              String newPasswordConfirm = _newPasswordConfirmTextEditingController.text;
              if (newPassword != newPasswordConfirm) {
                showSnackBar(
                  context,
                  CretaCommuLang["confirmPasswordAgain"]!, //'비밀번호를 다시 확인해주세요'
                );
                return;
              }
              if (!CretaCommonUtils.checkPasswordStrength(newPassword)) {
                showSnackBar(
                  context,
                  CretaCommuLang["invalidPasswordStrength"]!, //'비밀번호는 6자~16자, 영문/숫자 필수입니다.'
                );
                return;
              }
              _doResetPasswordConfirm();
            },
          );
  }

  void checkPasswordStrength(String password) {
    setState(() {
      _newPasswordError = (password.isEmpty) ? false : !CretaCommonUtils.checkPasswordStrength(password);
    });
  }

  void checkPasswordConfirmStrength(String password) {
    setState(() {
      _newPasswordConfirmError = (password.isEmpty) ? false : !CretaCommonUtils.checkPasswordStrength(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    String logoUrl = (CretaAccountManager.currentLoginUser.isLoginedUser) ? AppRoutes.communityHome : AppRoutes.intro;
    double displayWidth = MediaQuery.of(context).size.width;
    //double displayHeight = MediaQuery.of(context).size.height;
    // return Snippet.CretaScaffoldOfCommunity(
    //   onFoldButtonPressed: () {
    //     setState(() {});
    //   },
    //   // title: Row(
    //   //   children: [
    //   //     SizedBox(
    //   //       width: 24,
    //   //     ),
    //   //     Theme(
    //   //       data: ThemeData(
    //   //         hoverColor: Colors.transparent,
    //   //       ),
    //   //       child: Link(
    //   //         uri: Uri.parse(logoUrl),
    //   //         builder: (context, function) {
    //   //           return InkWell(
    //   //             onTap: () => Routemaster.of(context).push(logoUrl),
    //   //             child: Image(
    //   //               image: AssetImage('assets/creta_logo_blue.png'),
    //   //               //width: 120,
    //   //               height: 20,
    //   //             ),
    //   //           );
    //   //         },
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    //   context: context,
    //   getBuildContext: getBuildContext,
    //   showVerticalAppBar: false,
    //   showDrawer: false,
    //   child: Column(
    return Scaffold(
      body: Column(
        children: [
          // app bar
          Container(
            width: displayWidth,
            height: 60, //CretaConst.appbarHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500]!,
                  spreadRadius: 0,
                  blurRadius: 5.0,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
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
          ),
          // main body
          Expanded(
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
                          CretaCommuLang["password"]!, //'비밀번호',
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
                          hintText: CretaCommuLang["enterPassword"]!,
                          autofillHints: const [AutofillHints.newPassword],
                          onEditComplete: (value) {},
                          onChanged: checkPasswordStrength,
                          fixedOutlineColor: _newPasswordError ? CretaColor.stateCritical : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 32, 0, 0),
                        child: Text(
                          CretaCommuLang["confirmPassword"]!, // '비밀번호 확인',
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
                          hintText: CretaCommuLang["enterPassword"]!,
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
          ),
        ],
      ),
    );
  }
}
