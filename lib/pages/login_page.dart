// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter/gestures.dart';

import '../design_system/buttons/creta_button_wrapper.dart';
import '../routes.dart';
import '../design_system/component/snippet.dart';

import 'dart:js' as js;

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

  Future<void> _login() async {
    logger.finest('_login pressed');
    _errMsg = '';

    String email = _loginEmailTextEditingController.text;
    String password = _loginPasswordTextEditingController.text;

    AccountManager.login(email, password).then((value) {
      HycopFactory.setBucketId();
      Routemaster.of(context).push(AppRoutes.intro);
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

    AccountManager.loginByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
      Routemaster.of(context).push(AppRoutes.intro);
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

  Future<void> _signup() async {
    logger.finest('_signup pressed');
    _errMsg = '';

    String name = _signinNameTextEditingController.text;
    String email = _signinEmailTextEditingController.text;
    String password = _signinPasswordTextEditingController.text;
    logger.finest('isExistAccount');
    AccountManager.isExistAccount(email).then((value) {
      Map<String, dynamic> userData = {};
      userData['name'] = name;
      userData['email'] = email;
      userData['password'] = password;
      logger.finest('register start');
      AccountManager.createAccount(userData).then((value) {
        logger.finest('register end');
        Routemaster.of(context).push(AppRoutes.intro);
        logger.finest('goto user-info-page');
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

  Future<void> _signupByGoogle() async {
    logger.finest('_signupByGoogle pressed');
    _errMsg = '';

    try {
      AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
        Routemaster.of(context).push(AppRoutes.intro);
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
      // }
    } catch (e) {
      _errMsg = e.toString();
      showSnackBar(context, _errMsg);
      setState(() {
        _isHidden = true;
      });
    }
  }

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
    Future.microtask(() {
      focusNode.requestFocus();
      // 자바스크립트 호출
      dynamic ret = js.context.callMethod("fixPasswordCss", []); // index.html에서 fixPasswordCss 참조
    });
  }

  bool _isHidden = true;

  Widget _loginPage() {
    return SizedBox(
      width: 600,
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Welcome to Creta ! 👋🏻', style: TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: _login,
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Log in by Google',
              icon: Icons.arrow_forward_outlined,
              onPressed: _loginByGoogle,
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BTN.fill_blue_ti_el(
              text: 'Reset Password',
              icon: Icons.arrow_forward_outlined,
              onPressed: () {
                setState(() {
                  _isHidden = true;
                  _pageIndex = IntroPageType.resetPassword;
                  _resetFormField();
                });
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
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
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
              onPressed: _signupByGoogle,
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
      title: 'Login page',
      context: context,
      child: _selectPage(),
    );
  }
}
