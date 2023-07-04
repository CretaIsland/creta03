// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import 'package:routemaster/routemaster.dart';

import '../login_page.dart';
//import '../../routes.dart';
//import '../../design_system/component/snippet.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_checkbox.dart';
import '../../design_system/buttons/creta_radio_button.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/dialog/creta_dialog.dart';
import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../design_system/text_field/creta_text_field.dart';
import '../../model/app_enums.dart';
import '../../model/user_property_model.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({
    super.key,
    required this.context,
    required this.size,
    this.doAfterLogin,
  });
  final BuildContext context;
  final Size size;
  final Function? doAfterLogin;

  @override
  State<LoginDialog> createState() => _LoginDialogState();

  static bool _showExtraInfoDialog = false;
  static void setShowExtraInfoDialog(bool show) => (_showExtraInfoDialog = show);
  static void popupDialog(BuildContext context, Function? doAfterLogin) {
    _showExtraInfoDialog = false;
    showDialog(
      context: context,
      builder: (context) => CretaDialog(
        key: GlobalObjectKey('LoginDialog.LoginDialog'),
        width: 406.0,
        height: 490.0,
        title: '',
        crossAxisAlign: CrossAxisAlignment.center,
        hideTopSplitLine: true,
        content: LoginDialog(
          context: context,
          size: Size(406, 490 - 46),
          doAfterLogin: doAfterLogin,
        ),
      ),
    ).then((value) {
      if (_showExtraInfoDialog) {
        ExtraInfoDialog.popupDialog(context, doAfterLogin);
      }
    });
  }
}

enum LoginPageState {
  login, // 로그인
  singup, // 회원가입
  resetPassword, // 비번 찾기
}

class _LoginDialogState extends State<LoginDialog> {
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

  Future<void> _login(String email, String password) async {
    logger.finest('_login pressed');
    Navigator.of(widget.context).pop();

    AccountManager.login(email, password).then((value) async {
      HycopFactory.setBucketId();
      LoginPage.initUserProperty().then((value) {
        if (value) {
          //Routemaster.of(widget.context).push(AppRoutes.intro);
          widget.doAfterLogin?.call();
        } else {
          throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
        }
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        errMsg = ex.message;
      } else {
        errMsg = 'Unknown DB Error !!!';
      }
      logger.severe(errMsg);
      showSnackBar(widget.context, errMsg);
    });
  }

  Future<void> _loginByGoogle() async {
    logger.finest('_loginByGoogle pressed');

    AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
      Navigator.of(widget.context).pop();
      HycopFactory.setBucketId();
      LoginPage.userPropertyManagerHolder!
          .addWhereClause('email', QueryValue(value: AccountManager.currentLoginUser.email));
      LoginPage.userPropertyManagerHolder!.queryByAddedContitions().then((value) async {
        if (value.isEmpty) {
          UserPropertyModel model =
          LoginPage.userPropertyManagerHolder!.getNewUserProperty(agreeUsingMarketing: true);
          await LoginPage.teamManagerHolder!.createTeam(
            createAndSetToCurrent: true,
            username: AccountManager.currentLoginUser.name,
            userId: model.mid,
          );
          await LoginPage.userPropertyManagerHolder!.createUserProperty(createModel: model);
          LoginDialog.setShowExtraInfoDialog(true);
        }
        LoginPage.initUserProperty().then((value) {
          if (value) {
            //Routemaster.of(widget.context).push(AppRoutes.intro);
            widget.doAfterLogin?.call();
          } else {
            throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
          }
        });
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        errMsg = ex.message;
      } else {
        errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(widget.context, errMsg);
    });
  }

  Future<void> _signup(String nickname, String email, String password, bool agreeUsingMarketing) async {
    logger.finest('_signup pressed');
    Navigator.of(widget.context).pop();

    logger.finest('isExistAccount');
    AccountManager.isExistAccount(email).then((value) {
      if (value) {
        showSnackBar(widget.context, '이미 가입된 이메일입니다');
        return;
      }
      Map<String, dynamic> userData = {};
      userData['name'] = nickname;
      userData['email'] = email;
      userData['password'] = password;
      logger.finest('register start');
      AccountManager.createAccount(userData).then((value) async {
        logger.finest('register end');
        UserPropertyModel model =
            LoginPage.userPropertyManagerHolder!.getNewUserProperty(agreeUsingMarketing: agreeUsingMarketing);
        await LoginPage.teamManagerHolder!.createTeam(
          createAndSetToCurrent: true,
          username: nickname,
          userId: model.mid,
        );
        await LoginPage.userPropertyManagerHolder!.createUserProperty(createModel: model);
        LoginDialog.setShowExtraInfoDialog(true);
        //Routemaster.of(widget.context).push(AppRoutes.intro);
        logger.finest('goto user-info-page');
      }).onError((error, stackTrace) {
        String errMsg;
        if (error is HycopException) {
          HycopException ex = error;
          errMsg = ex.message;
        } else {
          errMsg = 'Unknown DB Error !!!';
        }
        showSnackBar(widget.context, errMsg);
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        errMsg = ex.message;
      } else {
        errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(widget.context, errMsg);
    });
  }

  Future<void> _resetPassword(String email) async {
    logger.finest('_resetPassword pressed');

    if (email.isEmpty) {
      String errMsg = 'email is empty !!!';
      showSnackBar(widget.context, errMsg);
      return;
    }

    AccountManager.resetPassword(email).then((value) {
      //
      // success
      //
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        errMsg = ex.message;
      } else {
        errMsg = 'Unknown DB Error !!!';
      }
      showSnackBar(widget.context, errMsg);
    });
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
                showSnackBar(widget.context, '닉네임을 입력해주세요');
                return;
              }
              if (email.isEmpty) {
                showSnackBar(widget.context, '이메일을 입력해주세요');
                return;
              }
              if (password.isEmpty) {
                showSnackBar(widget.context, '비밀번호를 입력해주세요');
                return;
              }
              if (password.compareTo(confirm) != 0) {
                showSnackBar(widget.context, '비밀번호를 확인해주세요');
                return;
              }
              bool agreeTerms = _checkboxSignupValueMap[stringAgreeTerms] ?? false;
              bool agreeUsingMarketing = _checkboxSignupValueMap[stringAgreeUsingMarketing] ?? false;
              if (agreeTerms == false) {
                showSnackBar(widget.context, '필수 항목을 동의해주세요');
                return;
              }
              _signup(nickname, email, password, agreeUsingMarketing);
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
                showSnackBar(widget.context, '이메일을 입력해주세요');
                return;
              }
              _resetPassword(email);
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
              _loginByGoogle();
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
              _login(id, pwd);
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
class ExtraInfoDialog extends StatefulWidget {
  const ExtraInfoDialog({
    super.key,
    required this.context,
    required this.size,
  });
  final BuildContext context;
  final Size size; // 406 x 394

  @override
  State<ExtraInfoDialog> createState() => _ExtraInfoDialogState();

  static void popupDialog(BuildContext context, Function? doAfterLogin) {
    showDialog(
      context: context,
      builder: (context) => CretaDialog(
        key: GlobalObjectKey('LoginDialog.ExtraInfoDialog'),
        width: 406.0,
        height: 350.0,
        title: '',
        crossAxisAlign: CrossAxisAlignment.center,
        hideTopSplitLine: true,
        content: ExtraInfoDialog(
          context: context,
          size: Size(406, 350 - 46),
        ),
      ),
    ).then((value) {
      doAfterLogin?.call();
    });
  }
}

enum ExtraInfoPageState {
  //nickname, // 닉네임
  purpose, // 사용용도
  genderAndBirth, // 성별과 출생년도
  end,
}

class _ExtraInfoDialogState extends State<ExtraInfoDialog> {
  ExtraInfoPageState _extraInfoPageState = ExtraInfoPageState.purpose;
  final Map<String, int> _genderValueMap = {'남': GenderType.male.index, '여': GenderType.female.index};
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
    for (int year = 1950; year < nowYear; year++) {
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

  void _changeExtraInfo(int usingPurpose, int genderType, int birthYear) {
    LoginPage.userPropertyManagerHolder!.userPropertyModel!.usingPurpose = BookType.fromInt(usingPurpose);
    LoginPage.userPropertyManagerHolder!.userPropertyModel!.genderType = GenderType.fromInt(genderType);
    LoginPage.userPropertyManagerHolder!.userPropertyModel!.birthYear = birthYear;
    //LoginPage.userPropertyManagerHolder!.updateModel(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
    LoginPage.userPropertyManagerHolder!.setToDB(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
    //Navigator.of(context).pop();
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
                SizedBox(
                  width: 116,
                ),
                BTN.line_blue_iti_m(
                  width: 193,
                  text: '다음으로',
                  icon2: Icons.arrow_forward_ios,
                  icon2Size: 8,
                  buttonColor: CretaButtonColor.skyTitle,
                  decoType: CretaButtonDeco.fill,
                  textColor: Colors.white,
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
                Text(
                  '성별',
                  style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                ),
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
                    defaultTitle: (_genderType.index == GenderType.male.index)
                        ? '남'
                        : (_genderType.index == GenderType.female.index)
                            ? '여'
                            : '',
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
                Text(
                  '출생연도',
                  style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                ),
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
                  textColor: Colors.white,
                  onPressed: () {
                    if (_genderType == GenderType.none) {
                      showSnackBar(context, '성별을 선택해주세요');
                      return;
                    }
                    _changeExtraInfo(_usingPurpose.index, _genderType.index, _birthYear);
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
