// ignore_for_file: prefer_const_constructors, avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:creta03/data_io/enterprise_manager.dart';
import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/design_system/buttons/creta_radio_button.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/gestures.dart';

import '../data_io/user_property_manager.dart';
import '../design_system/buttons/creta_button_wrapper.dart';
import '../design_system/buttons/creta_checkbox.dart';
import '../model/app_enums.dart';
import '../routes.dart';
import '../design_system/component/snippet.dart';
import '../design_system/creta_color.dart';
import '../design_system/creta_font.dart';
import '../design_system/buttons/creta_button.dart';
import '../design_system/menu/creta_drop_down_button.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../design_system/dialog/creta_dialog.dart';
import '../common/cross_common_job.dart';

enum IntroPageType {
  none,
  login,
  signup,
  resetPassword,
  resetPasswordConfirm,
  end;

  static int validCheck(int val) {
    if (val >= end.index) return (end.index - 1);
    if (val <= none.index) return (none.index + 1);
    return val;
  }

  static IntroPageType fromInt(int val) => IntroPageType.values[validCheck(val)];
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static UserPropertyManager? userPropertyManagerHolder;
  static TeamManager? teamManagerHolder;
  static EnterpriseManager? enterpriseHolder;

  static Future<bool> initUserProperty() async {
    if (LoginPage.userPropertyManagerHolder == null) {
      LoginPage.userPropertyManagerHolder = UserPropertyManager();
      LoginPage.userPropertyManagerHolder?.configEvent();
      LoginPage.userPropertyManagerHolder?.clearAll();
    }
    if (LoginPage.teamManagerHolder == null) {
      LoginPage.teamManagerHolder = TeamManager();
      LoginPage.teamManagerHolder?.configEvent();
      LoginPage.teamManagerHolder?.clearAll();
    }
    if (LoginPage.enterpriseHolder == null) {
      LoginPage.enterpriseHolder = EnterpriseManager();
      LoginPage.enterpriseHolder?.configEvent();
      LoginPage.enterpriseHolder?.clearAll();
    }
    // 현재 로그인정보로 사용자정보 가져옴
    await LoginPage.userPropertyManagerHolder!.initUserProperty();
    if (LoginPage.userPropertyManagerHolder!.userPropertyModel == null) {
      // 사용자정보 없음 => 모든정보초기화
      AccountManager.logout();
      LoginPage.teamManagerHolder?.clearAll();
      LoginPage.enterpriseHolder?.clearAll();
      return false;
    }
    // team 및 ent 정보 가져움
    await LoginPage.teamManagerHolder?.initTeam();
    await LoginPage.enterpriseHolder?.initEnterprise();
    //if (LoginPage.teamManagerHolder!.modelList.isEmpty || LoginPage.enterpriseHolder!.modelList.isEmpty) {
    // team이 없거나, ent없으면 모든정보초기화
    if (LoginPage.enterpriseHolder!.modelList.isEmpty) {
      // team이 없는건 가능, ent없으면 모든정보초기화
      await logout();
      return false;
    }
    return true;
  }

  static Future<bool> logout() async {
    LoginPage.userPropertyManagerHolder?.clearAll();
    LoginPage.userPropertyManagerHolder?.clearUserProperty();
    LoginPage.teamManagerHolder?.clearAll();
    LoginPage.enterpriseHolder?.clearAll();
    await AccountManager.logout();
    return true;
  }

  // static void initTeam() {
  //   LoginPage.teamManagerHolder = TeamManager();
  //   LoginPage.teamManagerHolder!.configEvent();
  //   LoginPage.teamManagerHolder!.clearAll();
  //   LoginPage.teamManagerHolder!.initTeam();
  // }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  IntroPageType _pageIndex = IntroPageType.login;
  String _errMsg = '';

  final _loginEmailTextEditingController = TextEditingController();
  final _loginPasswordTextEditingController = TextEditingController();

  final _signinNameTextEditingController = TextEditingController();
  final _signinEmailTextEditingController = TextEditingController();
  final _signinPasswordTextEditingController = TextEditingController();

  final _resetPasswordEmailTextEditingController = TextEditingController();

  final _resetPasswordConfirmEmailTextEditingController = TextEditingController();
  final _resetPasswordConfirmSecretTextEditingController = TextEditingController();
  final _resetPasswordConfirmNewPasswordTextEditingController = TextEditingController();

  void _resetFormField() {
    _loginEmailTextEditingController.text = '';
    _loginPasswordTextEditingController.text = '';

    _signinNameTextEditingController.text = '';
    _signinEmailTextEditingController.text = '';
    _signinPasswordTextEditingController.text = '';

    _resetPasswordEmailTextEditingController.text = '';

    _resetPasswordConfirmEmailTextEditingController.text = '';
    _resetPasswordConfirmSecretTextEditingController.text = '';
    _resetPasswordConfirmNewPasswordTextEditingController.text = '';
  }

  Future<void> _login(String email, String password) async {
    Navigator.of(context).pop();

    logger.finest('_login pressed');
    _errMsg = '';

    //String email = _loginEmailTextEditingController.text;
    //String password = _loginPasswordTextEditingController.text;

    AccountManager.login(email, password).then((value) async {
      HycopFactory.setBucketId();
      LoginPage.initUserProperty().then((value) {
        if (value) {
          Routemaster.of(context).push(AppRoutes.intro);
        } else {
          throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
        }
      });
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Unknown DB Error !!!';
      }
      logger.severe(_errMsg);
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    });
  }

  Future<void> _loginByGoogle() async {
    logger.finest('_loginByGoogle pressed');
    _errMsg = '';

    AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
      Navigator.of(context).pop();
      HycopFactory.setBucketId();
      LoginPage.userPropertyManagerHolder!.addWhereClause('email', QueryValue(value: AccountManager.currentLoginUser.email));
      LoginPage.userPropertyManagerHolder!.queryByAddedContitions().then((value) async {
        if (value.isEmpty) {
          //
          // 기본 팀 생성 !!! teams[0]? myTeamId?
          //
          await LoginPage.userPropertyManagerHolder!.createUserProperty(agreeUsingMarketing: true); // 구글은 일단 무조건 마케팅 동의
        }
        LoginPage.initUserProperty().then((value) {
          if (value) {
            Routemaster.of(context).push(AppRoutes.intro);
          } else {
            throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
          }
        });
      });
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    });
  }

  Future<void> _signup(String nickname, String email, String password, bool agreeUsingMarketing) async {
    Navigator.of(context).pop();

    logger.finest('_signup pressed');
    _errMsg = '';

    //String name = _signinNameTextEditingController.text;
    //String email = _signinEmailTextEditingController.text;
    //String password = _signinPasswordTextEditingController.text;

    logger.finest('isExistAccount');
    AccountManager.isExistAccount(email).then((value) {
      if (value) {
        showSnackBar(context, '이미 가입된 이메일입니다');
        return;
      }
      Map<String, dynamic> userData = {};
      userData['name'] = nickname;
      userData['email'] = email;
      userData['password'] = password;
      logger.finest('register start');
      AccountManager.createAccount(userData).then((value) {
        logger.finest('register end');
        //
        // 기본 팀 생성 !!! teams[0]? myTeamId?
        //
        LoginPage.userPropertyManagerHolder!.createUserProperty(agreeUsingMarketing: agreeUsingMarketing);
        Routemaster.of(context).push(AppRoutes.intro);
        logger.finest('goto user-info-page');
        Timer.periodic(const Duration(seconds: 1), (timer) {
          timer.cancel();
          _popupExtraInfoDialog();
        });
      }).onError((error, stackTrace) {
        if (error is HycopException) {
          HycopException ex = error;
          _errMsg = ex.message;
        } else {
          _errMsg = 'Unknown DB Error !!!';
        }
        showSnackBar(context, _errMsg);
        setState(() {
          _isHidden = true;
        });
      });
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    });
  }

  // Future<void> _signupByGoogle() async {
  //   logger.finest('_signupByGoogle pressed');
  //   _errMsg = '';
  //
  //   try {
  //     AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
  //       LoginPage.userPropertyManagerHolder!.createUserProperty();
  //       Routemaster.of(context).push(AppRoutes.intro);
  //     }).onError((error, stackTrace) {
  //       if (error is HycopException) {
  //         HycopException ex = error;
  //         _errMsg = ex.message;
  //       } else {
  //         _errMsg = 'Unknown DB Error !!!';
  //       }
  //       showSnackBar(context, _errMsg);
  //       setState(() {
  //         _isHidden = true;
  //       });
  //     });
  //     // }
  //   } catch (e) {
  //     _errMsg = e.toString();
  //     showSnackBar(context, _errMsg);
  //     setState(() {
  //       _isHidden = true;
  //     });
  //   }
  // }

  Future<void> _resetPassword() async {
    logger.finest('_resetPassword pressed');
    _errMsg = '';

    String email = _resetPasswordEmailTextEditingController.text;
    if (email.isEmpty) {
      _errMsg = 'email is empty !!!';
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
      return;
    }

    AccountManager.resetPassword(email).then((value) {
      _errMsg = 'send a password recovery email to your account, check it';
      setState(() {
        _isHidden = true;
      });
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    });
  }

  Future<void> _resetPasswordConfirm() async {
    String email = _resetPasswordConfirmEmailTextEditingController.text;
    String secret = _resetPasswordConfirmSecretTextEditingController.text;
    String newPassword = _resetPasswordConfirmNewPasswordTextEditingController.text;

    AccountManager.resetPasswordConfirm(email, secret, newPassword).then((value) {
      _errMsg = 'password reseted successfully, go to login';
      setState(() {
        _isHidden = true;
      });
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    });
  }

  bool addPasswordCss = false;
  FocusNode passwordFocusNode = FocusNode();
  void fixEdgePasswordRevealButton(FocusNode focusNode) {
    focusNode.unfocus();
    if (addPasswordCss) return;
    addPasswordCss = true; // 한번만 실행
    CrossCommonJob ccj = CrossCommonJob();
    ccj.fixEdgePasswordRevealButton(focusNode);
  }

  bool _isHidden = true;

  final GlobalKey _loginLoginDialogKey = GlobalKey();
  final GlobalKey _loginSignupDialogKey = GlobalKey();

  void _onResetPassword(String email) {
    // 아직 미지원
  }

  void _popupLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => CretaDialog(
        key: _loginLoginDialogKey,
        width: 406.0,
        height: 490.0,
        title: '',
        crossAxisAlign: CrossAxisAlignment.center,
        hideTopSplitLine: true,
        content: LoginDialogBody(
          size: Size(406, 490 - 46),
          onLogin: _login,
          onLoginByGoogle: _loginByGoogle,
          onSignup: _signup,
          onResetPassword: _onResetPassword,
        ),
      ),
    );
  }

  void _changeExtraInfo(int usingPurpose, int genderType, int birthYear) {
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.usingPurpose = BookType.fromInt(usingPurpose);
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.genderType = GenderType.fromInt(genderType);
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.birthYear = birthYear;
    // //LoginPage.userPropertyManagerHolder!.updateModel(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
    // LoginPage.userPropertyManagerHolder!.setToDB(LoginPage.userPropertyManagerHolder!.userPropertyModel!);

    Navigator.of(context).pop();
  }

  void _popupExtraInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => CretaDialog(
        key: _loginSignupDialogKey,
        width: 406.0,
        height: 350.0,
        title: '',
        crossAxisAlign: CrossAxisAlignment.center,
        hideTopSplitLine: true,
        content: ExtraInfoDialogBody(
          size: Size(406, 350 - 46),
          onChangeExtraInfo: _changeExtraInfo,
        ),
      ),
    );
  }

  Widget _loginPage() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Welcome to Creta ! 👋🏻  Ver 0.01', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextField(
              controller: _loginEmailTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              //style: const TextStyle(fontSize: 12.0),
            ), //TextFormField(controller: _loginEmailTextEditingController),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextField(
              onChanged: (_) async {
                fixEdgePasswordRevealButton(passwordFocusNode);
              },
              obscureText: _isHidden,
              controller: _loginPasswordTextEditingController,
              decoration: InputDecoration(
                hintText: 'Password',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.password),
                suffixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
              ),
              //style: const TextStyle(fontSize: 12.0),
            ), //TextFormField(controller: _loginPasswordTextEditingController),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Log in',
              icon: Icons.arrow_forward_outlined,
              onPressed: () {},//_login,
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Log in by Google',
              icon: Icons.arrow_forward_outlined,
              //onPressed: _loginByGoogle,
              onPressed: () {
                _popupLoginDialog();
              },
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Reset Password',
              icon: Icons.arrow_forward_outlined,
              onPressed: () {
                // setState(() {
                //   _isHidden = true;
                //   _pageIndex = IntroPageType.resetPassword;
                //   _resetFormField();
                // });
                _popupExtraInfoDialog();
              },
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Reset Password Confirm',
              icon: Icons.arrow_forward_outlined,
              onPressed: () {
                setState(() {
                  _isHidden = true;
                  _pageIndex = IntroPageType.resetPasswordConfirm;
                  _resetFormField();
                });
              },
              width: 300,
            ),
          ),
          _errMsg.isNotEmpty
              ? SizedBox(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _errMsg,
                        style: const TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w800),
                      )
                    ],
                  ))
              : const SizedBox(
                  height: 40,
                ),
          Text.rich(
            TextSpan(
              text: 'Don\'t have an account?  ',
              children: [
                TextSpan(
                  text: 'Sign up now !',
                  mouseCursor: SystemMouseCursors.click,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isHidden = true;
                        _pageIndex = IntroPageType.signup;
                        _resetFormField();
                      });
                    },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _signupPage() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Create an account 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              controller: _signinNameTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Name',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              controller: _signinEmailTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              onChanged: (_) async {
                fixEdgePasswordRevealButton(passwordFocusNode);
              },
              obscureText: _isHidden,
              controller: _signinPasswordTextEditingController,
              decoration: InputDecoration(
                hintText: 'Password',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.password),
                suffixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Sign up',
              icon: Icons.arrow_forward_outlined,
              onPressed: _signup,
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Sign up by google',
              icon: Icons.arrow_forward_outlined,
              onPressed: () {},//_signupByGoogle,
              width: 300,
            ),
          ),
          _errMsg.isNotEmpty
              ? SizedBox(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _errMsg,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                      )
                    ],
                  ))
              : const SizedBox(
                  height: 40,
                ),
          Text.rich(
            TextSpan(
              text: 'Already have an account?  ',
              children: [
                TextSpan(
                  text: 'Login in now !',
                  mouseCursor: SystemMouseCursors.click,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isHidden = true;
                        _pageIndex = IntroPageType.login;
                        _resetFormField();
                      });
                    },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BTN.fill_blue_ti_el(
                text: 'Back',
                icon: Icons.arrow_forward_outlined,
                onPressed: () {
                  setState(() {
                    _isHidden = true;
                    _pageIndex = IntroPageType.login;
                    _resetFormField();
                  });
                },
                width: 300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resetPasswordPage() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              controller: _resetPasswordEmailTextEditingController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Reset Password',
              icon: Icons.arrow_forward_outlined,
              onPressed: _resetPassword,
              width: 300,
            ),
          ),
          _errMsg.isNotEmpty
              ? SizedBox(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _errMsg,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                      )
                    ],
                  ))
              : const SizedBox(
                  height: 40,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BTN.fill_blue_ti_el(
                text: 'Back',
                icon: Icons.arrow_forward_outlined,
                onPressed: () {
                  setState(() {
                    _isHidden = true;
                    _pageIndex = IntroPageType.login;
                    _resetFormField();
                  });
                },
                width: 300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resetPasswordConfirmPage() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Reset password Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              controller: _resetPasswordConfirmEmailTextEditingController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              controller: _resetPasswordConfirmSecretTextEditingController,
              decoration: InputDecoration(
                hintText: 'Secret Text',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150.0, 0.0, 150.0, 0.0),
            child: TextFormField(
              onChanged: (_) async {
                fixEdgePasswordRevealButton(passwordFocusNode);
              },
              obscureText: _isHidden,
              controller: _resetPasswordConfirmNewPasswordTextEditingController,
              decoration: InputDecoration(
                hintText: 'New Password',
                border: UnderlineInputBorder(),
                prefixIcon: Icon(Icons.password),
                suffixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Reset Password Confirm',
              icon: Icons.arrow_forward_outlined,
              onPressed: _resetPasswordConfirm,
              width: 300,
            ),
          ),
          _errMsg.isNotEmpty
              ? SizedBox(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _errMsg,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
                      )
                    ],
                  ))
              : const SizedBox(
                  height: 40,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BTN.fill_blue_ti_el(
                text: 'Back',
                icon: Icons.arrow_forward_outlined,
                onPressed: () {
                  setState(() {
                    _isHidden = true;
                    _pageIndex = IntroPageType.login;
                    _resetFormField();
                  });
                },
                width: 300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectPage() {
    switch (_pageIndex) {
      case IntroPageType.signup:
        return _signupPage();

      case IntroPageType.resetPassword:
        return _resetPasswordPage();

      case IntroPageType.resetPasswordConfirm:
        return _resetPasswordConfirmPage();

      case IntroPageType.login:
      default:
        return _loginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      title: Snippet.logo('Login page'),
      context: context,
      child: _selectPage(),
    );
  }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
class LoginDialogBody extends StatefulWidget {
  const LoginDialogBody({
    super.key,
    required this.size,
    required this.onLogin,
    required this.onLoginByGoogle,
    required this.onSignup,
    required this.onResetPassword,
  });
  final Size size; // 406 x 394
  final Function(String, String) onLogin;
  final Function onLoginByGoogle;
  final Function(String, String, String, bool) onSignup;
  final Function(String) onResetPassword;

  @override
  State<LoginDialogBody> createState() => _LoginDialogBodyState();
}

enum LoginPageState {
  login, // 로그인
  singup, // 회원가입
  resetPassword, // 비번 찾기
}

class _LoginDialogBodyState extends State<LoginDialogBody> {
  LoginPageState _loginPageState = LoginPageState.login;
  final Map<String, bool> _checkboxLoginValueMap = {
    '로그인 상태 유지 ': true,
  };

  static const String stringAgreeTerms = '(필수) 크레타 이용약관 동의';
  static const String stringAgreeUsingMarketing = '(선택) 마케팅 정보 발송 동의';

  final Map<String, bool> _checkboxSignupValueMap = {
    stringAgreeTerms: false,
    stringAgreeUsingMarketing: false,
  };

  final _loginEmailTextEditingController = TextEditingController();
  final _loginPasswordTextEditingController = TextEditingController();

  final _signupNicknameTextEditingController = TextEditingController();
  final _signupEmailTextEditingController = TextEditingController();
  final _signupPasswordTextEditingController = TextEditingController();
  final _signupPasswordConfirmTextEditingController = TextEditingController();

  final _resetEmailTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _getBody(BuildContext context) {
    switch (_loginPageState) {
      case LoginPageState.singup: // 회원가입
        return [
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _signupNicknameTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '닉네임',
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _signupEmailTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '이메일',
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _signupPasswordTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '비밀번호',
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _signupPasswordConfirmTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '비밀번호 확인',
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          SizedBox(
            width: 304,
            child: CretaCheckbox(
              density: 8,
              valueMap: _checkboxSignupValueMap,
              onSelected: (title, value, nvMap) {
                logger.finest('selected $title=$value');
              },
            ),
          ),
          const SizedBox(height: 21),
          BTN.line_blue_iti_m(
            width: 294,
            text: '회원가입',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String nickname = _signupNicknameTextEditingController.text;
              String email = _signupEmailTextEditingController.text;
              String password = _signupPasswordTextEditingController.text;
              String confirm = _signupPasswordConfirmTextEditingController.text;
              nickname = nickname.trim();
              email = email.trim();
              password = password.trim();
              confirm = confirm.trim();
              if (nickname.isEmpty) {
                showSnackBar(context, '닉네임을 입력해주세요');
                return;
              }
              if (email.isEmpty) {
                showSnackBar(context, '이메일을 입력해주세요');
                return;
              }
              if (password.isEmpty) {
                showSnackBar(context, '비밀번호를 입력해주세요');
                return;
              }
              if (password.compareTo(confirm) != 0) {
                showSnackBar(context, '비밀번호를 확인해주세요');
                return;
              }
              bool agreeTerms = _checkboxSignupValueMap[stringAgreeTerms] ?? false;
              bool agreeUsingMarketing = _checkboxSignupValueMap[stringAgreeUsingMarketing] ?? false;
              if (agreeTerms == false) {
                showSnackBar(context, '필수 항목을 동의해주세요');
                return;
              }
              widget.onSignup.call(nickname, email, password, agreeUsingMarketing);
            },
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.fromLTRB(116, 0, 117, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이미 회원이신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    setState(() {
                      _loginPageState = LoginPageState.login;
                    });
                  },
                  child: Text(
                    '로그인하기',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary[400]),
                  ),
                ),
              ],
            ),
          ),
        ];
      case LoginPageState.resetPassword:
        return [
          Text(
            '가입한 이메일 주소로 임시 비밀번호를 알려드립니다.',
            style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
          ),
          const SizedBox(height: 8),
          Text(
            '로그인 후 비밀번호를 꼭 변경해주세요.',
            style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
          ),
          const SizedBox(height: 32),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _resetEmailTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '이메일',
              onEditComplete: (value) {}),
          const SizedBox(height: 24),
          BTN.line_blue_iti_m(
            width: 294,
            text: '임시 비밀번호 전송',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String email = _resetEmailTextEditingController.text;
              email = email.trim();
              if (email.isEmpty) {
                showSnackBar(context, '이메일을 입력해주세요');
                return;
              }
              widget.onResetPassword.call(email);
            },
          ),
          const SizedBox(height: 184),
          Padding(
            padding: const EdgeInsets.fromLTRB(98, 0, 104, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '비밀번호가 기억나셨나요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    setState(() {
                      _loginPageState = LoginPageState.login;
                    });
                  },
                  child: Text(
                    '로그인하기',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary[400]),
                  ),
                ),
              ],
            ),
          ),
        ];
      case LoginPageState.login:
      default:
        return [
          BTN.line_blue_iti_m(
            width: 294,
            text: '구글로 로그인하기',
            svgImg1: 'assets/google__g__logo.svg',
            onPressed: () {
              widget.onLoginByGoogle.call();
            },
          ),
          const SizedBox(height: 31),
          Container(width: 294, height: 2, color: CretaColor.text[200]),
          const SizedBox(height: 31),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _loginEmailTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '이메일',
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          CretaTextField(
              textFieldKey: GlobalKey(),
              controller: _loginPasswordTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '비밀번호',
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {}),
          const SizedBox(height: 24),
          BTN.line_blue_iti_m(
            width: 294,
            text: '로그인하기',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {
              String id = _loginEmailTextEditingController.text;
              String pwd = _loginPasswordTextEditingController.text;
              widget.onLogin(id, pwd);
            },
          ),
          const SizedBox(height: 11),
          SizedBox(
            width: 304,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CretaCheckbox(
                  valueMap: _checkboxLoginValueMap,
                  onSelected: (title, value, nvMap) {
                    logger.finest('selected $title=$value');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _loginPageState = LoginPageState.resetPassword;
                      });
                    },
                    child: Text(
                      '비밀번호 찾기',
                      style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.fromLTRB(111, 0, 110, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '아직 회원이 아니신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    setState(() {
                      _loginPageState = LoginPageState.singup;
                    });
                  },
                  child: Text(
                    '회원가입',
                    style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary[400]),
                  ),
                ),
              ],
            ),
          ),
        ];
    }
    //return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: Image(
              image: AssetImage("assets/creta_logo_blue.png"),
              width: 100,
              height: 26,
            ),
          ),
          const SizedBox(height: 32),
          ..._getBody(context),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
class ExtraInfoDialogBody extends StatefulWidget {
  const ExtraInfoDialogBody({
    super.key,
    required this.size,
    required this.onChangeExtraInfo,
  });
  final Size size; // 406 x 394
  final Function(int, int, int) onChangeExtraInfo;

  @override
  State<ExtraInfoDialogBody> createState() => _ExtraInfoDialogBodyState();
}

enum ExtraInfoPageState {
  //nickname, // 닉네임
  purpose, // 사용용도
  genderAndBirth, // 성별과 출생년도
  end,
}

class _ExtraInfoDialogBodyState extends State<ExtraInfoDialogBody> {
  ExtraInfoPageState _extraInfoPageState = ExtraInfoPageState.purpose;
  final Map<String, int> _genderValueMap = { '남': GenderType.male.index, '여': GenderType.female.index };
  late final List<CretaMenuItem> _purposeDropdownMenuList;
  final List<CretaMenuItem> _birthDropdownMenuList = [];
  BookType _usingPurpose = BookType.presentaion;
  int _birthYear = 1950;
  GenderType _genderType = GenderType.none;

  @override
  void initState() {
    super.initState();

    _purposeDropdownMenuList = [
      CretaMenuItem(
        caption: '프리젠테이션',
        //iconData: Icons.home_outlined,
        onPressed: () {
          _usingPurpose = BookType.presentaion;
        },
        //linkUrl: AppRoutes.communityHome,
        //isIconText: true,
        selected: true,
      ),
      CretaMenuItem(
        caption: '디지털 사이니지',
        //iconData: Icons.home_outlined,
        onPressed: () {
          _usingPurpose = BookType.signage;
        },
        //linkUrl: AppRoutes.communityHome,
        //isIconText: true,
      ),
      CretaMenuItem(
        caption: '전자칠판',
        //iconData: Icons.home_outlined,
        onPressed: () {
          _usingPurpose = BookType.board;
        },
        //linkUrl: AppRoutes.communityHome,
        //isIconText: true,
      ),
    ];

    DateTime now = DateTime.now();
    int nowYear = now.year;
    for(int year = 1950; year < nowYear; year++) {
      _birthDropdownMenuList.add(CretaMenuItem(
        caption: year.toString(),
        //iconData: Icons.home_outlined,
        onPressed: () {
          _birthYear = year;
        },
        //linkUrl: AppRoutes.communityHome,
        //isIconText: true,
      ));
    }
  }

  List<Widget> _getBody() {
    switch (_extraInfoPageState) {
      // case ExtraInfoPageState.nickname:
      //   return [
      //     Text(
      //       '크레타에서 사용하실 닉네임을 입력해주세요?',
      //       style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
      //     ),
      //     SizedBox(height: 32),
      //     SizedBox(
      //       width: 294,
      //       height: 30,
      //       child: CretaTextField(
      //           textFieldKey: GlobalKey(),
      //           width: 294,
      //           height: 30,
      //           value: '',
      //           hintText: '닉네임',
      //           onEditComplete: (value) {}),
      //     ),
      //     SizedBox(height: 92),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(29, 0, 56, 0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           // BTN.line_blue_iti_m(
      //           //   width: 116,
      //           //   icon1: Icons.arrow_back_ios_new,
      //           //   icon1Size: 8,
      //           //   text: '이전으로',
      //           //   buttonColor: CretaButtonColor.transparent,
      //           //   decoType: CretaButtonDeco.opacity,
      //           //   onPressed: () {},
      //           // ),
      //           SizedBox(width: 116,),
      //           BTN.line_blue_iti_m(
      //             width: 193,
      //             text: '다음으로',
      //             icon2: Icons.arrow_forward_ios,
      //             icon2Size: 8,
      //             buttonColor: CretaButtonColor.skyTitle,
      //             decoType: CretaButtonDeco.fill,
      //             textColor: Colors.white ,
      //             onPressed: () {
      //               setState(() {
      //                 _extraInfoPageState = ExtraInfoPageState.purpose;
      //               });
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ];
      case ExtraInfoPageState.purpose:
        return [
          Text(
            '세부 사용 용도는 어떻게 되시나요?',
            style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: 294,
            height: 30,
            child: CretaDropDownButton(
              width: 294 - 10,
              height: 30,
              dropDownMenuItemList: _purposeDropdownMenuList,
              borderRadius: 3,
              alwaysShowBorder: true,
              allTextColor: CretaColor.text[700],
              textStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]),
            ),
          ),
          SizedBox(height: 92),
          Padding(
            padding: const EdgeInsets.fromLTRB(29, 0, 56, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BTN.line_blue_iti_m(
                //   width: 116,
                //   icon1: Icons.arrow_back_ios_new,
                //   icon1Size: 8,
                //   text: '이전으로',
                //   buttonColor: CretaButtonColor.transparent,
                //   decoType: CretaButtonDeco.opacity,
                //   onPressed: () {
                //     setState(() {
                //       _extraInfoPageState = ExtraInfoPageState.nickname;
                //     });
                //   },
                // ),
                SizedBox(width: 116,),
                BTN.line_blue_iti_m(
                  width: 193,
                  text: '다음으로',
                  icon2: Icons.arrow_forward_ios,
                  icon2Size: 8,
                  buttonColor: CretaButtonColor.skyTitle,
                  decoType: CretaButtonDeco.fill,
                  textColor: Colors.white ,
                  onPressed: () {
                    setState(() {
                      _extraInfoPageState = ExtraInfoPageState.genderAndBirth;
                    });
                  },
                ),
              ],
            ),
          ),
        ];
      case ExtraInfoPageState.genderAndBirth:
      default:
      return [
        Text(
          '성별과 출생연도는 어떻게 되시나요?',
          style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
        ),
        SizedBox(height: 37),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 47),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('성별', style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),),
              SizedBox(
                width: 120,
                height: 20,
                child: CretaRadioButton(
                  spacebetween: 20,
                  direction: Axis.horizontal,
                  onSelected: (title, value) {
                    _genderType = GenderType.fromInt(value);
                  },
                  valueMap: _genderValueMap,
                  defaultTitle: (_genderType.index == GenderType.male.index) ? '남' : (_genderType.index == GenderType.female.index) ? '여' : '',
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 62),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('출생연도', style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),),
              SizedBox(
                width: 100,
                height: 30,
                child: CretaDropDownButton(
                  width: 100 - 10,
                  height: 30,
                  dropDownMenuItemList: _birthDropdownMenuList,
                  borderRadius: 3,
                  alwaysShowBorder: true,
                  allTextColor: CretaColor.text[700],
                  textStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 43),
        Padding(
          padding: const EdgeInsets.fromLTRB(29, 0, 56, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BTN.line_blue_iti_m(
                width: 116,
                icon1: Icons.arrow_back_ios_new,
                icon1Size: 8,
                text: '이전으로',
                buttonColor: CretaButtonColor.transparent,
                decoType: CretaButtonDeco.opacity,
                onPressed: () {
                  setState(() {
                    _extraInfoPageState = ExtraInfoPageState.purpose;
                  });
                },
              ),
              BTN.line_blue_iti_m(
                width: 193,
                text: '완료',
                buttonColor: CretaButtonColor.skyTitle,
                decoType: CretaButtonDeco.fill,
                textColor: Colors.white ,
                onPressed: () {
                  if (_genderType == GenderType.none) {
                    showSnackBar(context, '성별을 선택해주세요');
                    return;
                  }
                  widget.onChangeExtraInfo(_usingPurpose.index, _genderType.index, _birthYear);
                },
              ),
            ],
          ),
        ),
      ];
    }
    //return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(117, 0, 117, 0),
            child: CretaStepper(totalSteps: ExtraInfoPageState.end.index, currentStep: _extraInfoPageState.index),
          ),
          const SizedBox(height: 37),
          ..._getBody(),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
class CretaStepper extends StatelessWidget {
  const CretaStepper({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.width = 172.0,
    this.stepSize = 18.0,
  });

  final double width;
  final double stepSize;
  final int totalSteps;
  final int currentStep;

  List<Widget> _getStepList() {
    double gapSpace = width - (stepSize * totalSteps);
    List<Widget> retList = [];
    for (int i = 0; i < totalSteps; i++) {
      if (i != 0) {
        retList.add(SizedBox(width: gapSpace));
      }
      if (currentStep == i) {
        retList.add(SizedBox(
          width: stepSize,
          height: stepSize,
          child: Stack(
            children: [
              SizedBox(
                width: stepSize,
                height: stepSize,
                child: Icon(Icons.circle_rounded, color: CretaColor.primary, size: stepSize),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(stepSize / 4 - 0.5, stepSize / 4, 0, 0),
                child: Icon(Icons.fiber_manual_record_rounded, color: Colors.white, size: stepSize / 2),
              ),
            ],
          ),
        ));
      } else if (i > currentStep) {
        retList.add(SizedBox(
          width: stepSize,
          height: stepSize,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(stepSize / 4 - 0.5, stepSize / 4, 0, 0),
                child: Icon(Icons.fiber_manual_record_rounded, color: CretaColor.text[300], size: stepSize / 2),
              ),
            ],
          ),
        ));
      } else if (i < currentStep) {
        retList.add(SizedBox(
          width: stepSize,
          height: stepSize,
          child: Icon(Icons.check_circle, color: CretaColor.primary, size: stepSize),
        ));
      }
    }
    return retList;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: stepSize,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(stepSize / 2, stepSize / 2, stepSize / 2, 0),
            child: SizedBox(
              width: width - stepSize,
              height: 0.5,
              child: Divider(
                thickness: 1,
                color: CretaColor.text[200],
              ),
            ),
          ),
          Row(children: _getStepList()),
        ],
      ),
    );
  }
}
