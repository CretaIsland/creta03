// ignore_for_file: prefer_const_constructors

import 'package:creta03/data_io/user_property_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';

//import '../login_page.dart';
import 'creta_account_manager.dart';
//import '../../routes.dart';
import '../../design_system/component/snippet.dart';
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
import '../../model/team_model.dart';
import '../../model/channel_model.dart';
import '../../common/creta_utils.dart';

enum LoginPageState {
  login, // 로그인
  singup, // 회원가입
  verifyEmail,
  resetPassword, // 비번 찾기
}

class LoginDialog extends StatefulWidget {
  const LoginDialog({
    super.key,
    required this.context,
    required this.size,
    // this.doAfterLogin,
    // this.doAfterSignup,
    // this.onErrorReport,
    required this.getBuildContext,
    this.loginPageState,
  });
  final BuildContext context;
  final Size size;
  // final Function? doAfterLogin;
  // final Function? doAfterSignup;
  // final Function(String)? onErrorReport;
  final Function getBuildContext;
  final LoginPageState? loginPageState;

  @override
  State<LoginDialog> createState() => _LoginDialogState();

  static bool _showExtraInfoDialog = false;
  static String nextPageAfterLoginSuccess = '';
  static void setShowExtraInfoDialog(bool show) {
    if (kDebugMode) print('setShowExtraInfoDialog($show)');
    _showExtraInfoDialog = show;
  }

  static void popupDialog({
    required BuildContext context,
    // Function? doAfterLogin,
    // Function? doAfterSignup,
    // Function(String)? onErrorReport,
    required Function getBuildContext,
    LoginPageState loginPageState = LoginPageState.login,
    String nextPageAfterLoginSuccess = '', //AppRoutes.communityHome,
    Function? onAfterLogin, //skpark add
  }) {
    _showExtraInfoDialog = false;
    LoginDialog.nextPageAfterLoginSuccess = nextPageAfterLoginSuccess;
    showDialog(
      context: context,
      builder: (context) => CretaStackDialog(
        key: GlobalObjectKey('LoginDialog.LoginDialog'),
        width: 406.0,
        height: 490.0,
        //title: '',
        //crossAxisAlign: CrossAxisAlignment.center,
        //hideTopSplitLine: true,
        content: LoginDialog(
          context: context,
          size: Size(406, 490 - 46),
          // doAfterLogin: doAfterLogin,
          // doAfterSignup: doAfterSignup,
          // onErrorReport: onErrorReport,
          getBuildContext: getBuildContext,
          loginPageState: loginPageState,
        ),
      ),
    ).then((value) {
      CretaAccountManager.experienceWithoutLogin = false; //skpark add
      if (kDebugMode) print('ExtraInfoDialog.popupDialog($_showExtraInfoDialog)');
      if (_showExtraInfoDialog) {
        if (kDebugMode) print('if(_showExtraInfoDialog)');
        ExtraInfoDialog.popupDialog(
          context: getBuildContext.call(),
          // doAfterLogin: doAfterLogin,
          // onErrorReport: onErrorReport,
          getBuildContext: getBuildContext,
        );
        if (AccountManager.currentLoginUser.isLoginedUser) {
          // 로그인에 성공했을때,  아래 변수를 초기화 해주어야 함.
          CretaAccountManager.experienceWithoutLogin = false; //skpark add
          onAfterLogin?.call();
        }
      } else {
        //Routemaster.of(getBuildContext.call()).push(AppRoutes.intro);
        if (AccountManager.currentLoginUser.isLoginedUser) {
          // 로그인에 성공했을때,  아래 변수를 초기화 해주어야 함.
          CretaAccountManager.experienceWithoutLogin = false; //skpark add
          onAfterLogin?.call();
          String path = LoginDialog.nextPageAfterLoginSuccess;
          if (path.isEmpty) {
            path = Uri.base.path;
          }
          Routemaster.of(getBuildContext.call()).push(path);
        } else {
          // do nothing
        }
      }
    });
  }
}

class _LoginDialogState extends State<LoginDialog> {
  late LoginPageState _loginPageState;
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

  bool _isLoginProcessing = false;

  @override
  void initState() {
    super.initState();

    _loginPageState = widget.loginPageState ?? LoginPageState.login;
  }

  Future<void> _login(String email, String password) async {
    logger.finest('_login pressed');
    if (AccountManager.currentLoginUser.isGuestUser) {
      await CretaAccountManager.logout(doGuestLogin: false);
    }
    AccountManager.login(email, password).then((value) async {
      HycopFactory.setBucketId();
      CretaAccountManager.initUserProperty().then((value) {
        if (value) {
          Navigator.of(widget.context).pop();
          //Routemaster.of(widget.getBuildContext.call()).push(AppRoutes.intro);
          //widget.doAfterLogin?.call();
        } else {
          throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
        }
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '로그인에 실패하였습니다. 가입된 정보를 확인해보세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      showSnackBar(widget.context, errMsg);
      //widget.onErrorReport?.call(errMsg);
    });
  }

  Future<void> _loginByGoogle() async {
    logger.finest('_loginByGoogle pressed');

    AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
      HycopFactory.setBucketId();
      CretaAccountManager.userPropertyManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('email', QueryValue(value: AccountManager.currentLoginUser.email));
      CretaAccountManager.userPropertyManagerHolder.queryByAddedContitions().then((value) async {
        bool isNewUser = value.isEmpty;
        if (isNewUser) {
          // create model objects
          UserPropertyModel userModel =
              CretaAccountManager.userPropertyManagerHolder.makeCurrentNewUserProperty(agreeUsingMarketing: true);
          TeamModel teamModel = CretaAccountManager.teamManagerHolder.getNewTeam(
            createAndSetToCurrent: true,
            username: AccountManager.currentLoginUser.name,
            userEmail: userModel.email,
          );
          ChannelModel teamChannelModel =
              CretaAccountManager.channelManagerHolder.makeNewChannel(teamId: teamModel.mid);
          ChannelModel myChannelModel =
              CretaAccountManager.channelManagerHolder.makeNewChannel(userId: userModel.email);
          userModel.channelId = myChannelModel.mid;
          teamModel.channelId = teamChannelModel.mid;
          userModel.channelId = myChannelModel.mid;
          userModel.teams = [teamModel.mid];
          // create to DB
          await CretaAccountManager.channelManagerHolder.createChannel(teamChannelModel);
          await CretaAccountManager.channelManagerHolder.createChannel(myChannelModel);
          await CretaAccountManager.teamManagerHolder.createTeam(teamModel);
          await CretaAccountManager.userPropertyManagerHolder.createUserProperty(createModel: userModel);
          await CretaAccountManager.initUserProperty();
          LoginDialog.setShowExtraInfoDialog(true);
        }
        CretaAccountManager.initUserProperty().then((value) {
          if (value) {
            Navigator.of(widget.context).pop();
            //Routemaster.of(widget.getBuildContext.call()).push(AppRoutes.intro);
            // if (isNewUser) {
            //   print('_loginByGoogle.widget.doAfterSignup?.call()');
            //   //widget.doAfterSignup?.call();
            // } else {
            //   print('_loginByGoogle.widget.doAfterLogin?.call()');
            //   //widget.doAfterLogin?.call();
            // }
          } else {
            throw HycopUtils.getHycopException(defaultMessage: 'Login failed !!!');
          }
        });
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '구글 계정으로 로그인에 실패하였습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      showSnackBar(widget.context, errMsg);
      //widget.onErrorReport?.call(errMsg);
    });
  }

  Future<void> _signup(String nickname, String email, String password, bool agreeUsingMarketing) async {
    logger.finest('_signup pressed');

    logger.finest('isExistAccount');
    AccountManager.isExistAccount(email).then((value) {
      AccountSignUpType accountSignUpType = value ?? AccountSignUpType.none;
      if (accountSignUpType != AccountSignUpType.none) {
        showSnackBar(widget.context, '이미 가입된 이메일입니다.');
        //widget.onErrorReport?.call('이미 가입된 이메일입니다.');
        return;
      }
      Map<String, dynamic> userData = {};
      userData['name'] = nickname;
      userData['email'] = email;
      userData['password'] = password;
      logger.finest('register start');
      AccountManager.createAccount(userData).then((value) async {
        logger.finest('register end');
        // create model objects
        UserPropertyModel userModel = CretaAccountManager.userPropertyManagerHolder
            .makeCurrentNewUserProperty(agreeUsingMarketing: agreeUsingMarketing);
        TeamModel teamModel = CretaAccountManager.teamManagerHolder.getNewTeam(
          createAndSetToCurrent: true,
          username: nickname,
          userEmail: userModel.email,
        );
        ChannelModel teamChannelModel = CretaAccountManager.channelManagerHolder.makeNewChannel(teamId: teamModel.mid);
        ChannelModel myChannelModel = CretaAccountManager.channelManagerHolder.makeNewChannel(userId: userModel.email);
        userModel.channelId = myChannelModel.mid;
        teamModel.channelId = teamChannelModel.mid;
        userModel.channelId = myChannelModel.mid;
        userModel.teams = [teamModel.mid];
        // create to DB
        await CretaAccountManager.channelManagerHolder.createChannel(teamChannelModel);
        await CretaAccountManager.channelManagerHolder.createChannel(myChannelModel);
        await CretaAccountManager.teamManagerHolder.createTeam(teamModel);
        await CretaAccountManager.userPropertyManagerHolder.createUserProperty(createModel: userModel);
        await CretaAccountManager.initUserProperty();
        LoginDialog.setShowExtraInfoDialog(true);
        if (kDebugMode) print('_signup.widget.doAfterSignup?.call()');
        //widget.doAfterSignup?.call();
        Navigator.of(widget.getBuildContext()).pop();
        //Routemaster.of(widget.context).push(AppRoutes.intro);
        logger.finest('goto user-info-page');
      }).onError((error, stackTrace) {
        String errMsg;
        if (error is HycopException) {
          HycopException ex = error;
          logger.severe(ex.message);
          errMsg = '계정 생성중 에러가 발생하였습니다. 관리자에 문의하세요.';
        } else {
          errMsg = 'Unknown DB Error !!!';
          logger.severe(errMsg);
        }
        showSnackBar(widget.getBuildContext.call(), errMsg);
        //widget.onErrorReport?.call(errMsg);
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '계정을 확인할 수 없습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      showSnackBar(widget.getBuildContext.call(), errMsg);
      //widget.onErrorReport?.call(errMsg);
    });
  }

  Future<void> _resetPassword(String email) async {
    logger.finest('_resetPassword pressed');

    if (email.isEmpty) {
      String errMsg = 'email is empty !!!';
      showSnackBar(widget.getBuildContext.call(), errMsg);
      //widget.onErrorReport?.call(errMsg);
      return;
    }

    AccountManager.resetPassword(email).then((value) async {
      String userId = value.$1;
      String secret = value.$2;
      CretaUtils.sendResetPasswordEmail(email, userId, secret);
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '비밀번호를 초기화할 수 없습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      showSnackBar(widget.getBuildContext.call(), errMsg);
      //widget.onErrorReport?.call(errMsg);
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
                showSnackBar(widget.getBuildContext.call(), '닉네임을 입력해주세요');
                //widget.onErrorReport?.call('닉네임을 입력해주세요');
                return;
              }
              if (email.isEmpty) {
                showSnackBar(widget.getBuildContext.call(), '이메일을 입력해주세요');
                //widget.onErrorReport?.call('이메일을 입력해주세요');
                return;
              }
              if (password.isEmpty) {
                showSnackBar(widget.getBuildContext.call(), '비밀번호를 입력해주세요');
                //widget.onErrorReport?.call('비밀번호를 입력해주세요');
                return;
              }
              if (password.compareTo(confirm) != 0) {
                showSnackBar(widget.getBuildContext.call(), '비밀번호를 확인해주세요');
                //widget.onErrorReport?.call('비밀번호를 확인해주세요');
                return;
              }
              bool agreeTerms = _checkboxSignupValueMap[stringAgreeTerms] ?? false;
              bool agreeUsingMarketing = _checkboxSignupValueMap[stringAgreeUsingMarketing] ?? false;
              if (agreeTerms == false) {
                showSnackBar(widget.getBuildContext.call(), '필수 항목을 동의해주세요');
                //widget.onErrorReport?.call('필수 항목을 동의해주세요');
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
                showSnackBar(widget.getBuildContext.call(), '이메일을 입력해주세요');
                //widget.onErrorReport?.call('이메일을 입력해주세요');
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
            sidePadding: CretaButtonSidePadding(left: 0, right: 11),
            onPressed: () {
              _loginByGoogle();
            },
          ),
          const SizedBox(height: 31),
          Container(width: 294, height: 2, color: CretaColor.text[200]),
          const SizedBox(height: 31),
          CretaTextField(
              textFieldKey: GlobalObjectKey('login-email'),
              controller: _loginEmailTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '이메일',
              autofillHints: const [AutofillHints.username],
              onEditComplete: (value) {}),
          const SizedBox(height: 20),
          CretaTextField(
              textFieldKey: GlobalObjectKey('login-password'),
              controller: _loginPasswordTextEditingController,
              width: 294,
              height: 30,
              value: '',
              hintText: '비밀번호',
              autofillHints: const [AutofillHints.password],
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {}),
          const SizedBox(height: 24),
          _isLoginProcessing
              ? BTN.line_blue_iwi_m(
                  width: 294,
                  widget: Snippet.showWaitSign(color: Colors.white, size: 16),
                  buttonColor: CretaButtonColor.skyTitle,
                  decoType: CretaButtonDeco.fill,
                  textColor: Colors.white,
                  onPressed: () {
                    TextInput.finishAutofillContext();
                    String id = _loginEmailTextEditingController.text;
                    String pwd = _loginPasswordTextEditingController.text;
                    setState(() {
                      _isLoginProcessing = true;
                      _login(id, pwd);
                    });
                  },
                )
              : BTN.line_blue_iti_m(
                  width: 294,
                  text: '로그인하기',
                  buttonColor: CretaButtonColor.skyTitle,
                  decoType: CretaButtonDeco.fill,
                  textColor: Colors.white,
                  onPressed: () {
                    TextInput.finishAutofillContext();
                    String id = _loginEmailTextEditingController.text;
                    String pwd = _loginPasswordTextEditingController.text;
                    setState(() {
                      _isLoginProcessing = true;
                      _login(id, pwd);
                    });
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
            padding: (!kDebugMode)
                ? const EdgeInsets.fromLTRB(111, 0, 110, 0)
                : const EdgeInsets.fromLTRB(111 - 20, 0, 110 - 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '아직 회원이 아니신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                //Expanded(child: Container()),
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
                if (kDebugMode)
                  InkWell(
                    onTap: () {
                      String email = _loginEmailTextEditingController.text;
                      List<String> emailList = [email];
                      CretaAccountManager.userPropertyManagerHolder.getUserPropertyFromEmail(emailList).then((value) {
                        if (value.isEmpty) {
                          showSnackBar(widget.context, '가입된 회원이 아닙니다');
                          return;
                        }
                        UserPropertyModel userModel = value[0];
                        // creta_user_property
                        CretaAccountManager.userPropertyManagerHolder.removeToDB(userModel.mid);
                        // hycop_users
                        String hycopUserId = 'user=${userModel.parentMid.value}';
                        UserPropertyManager manager = UserPropertyManager(tableName: 'hycop_users');
                        manager.removeToDB(hycopUserId);
                      });
                    },
                    child: Text(
                      '회원탈퇴',
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
    //return AutofillGroup(
    // => 웹 자동완성을 활용하기 위해서 AutofillGroup 필요.
    // => flutter 버그 때문인지 AutofillGroup를 사용하면
    //    build시에 SearchTextField에서 onSubmitted가 호출되면서 setState가 호출되고 오류가 발생.
    // => 위 버그가 해결되기 전까지 AutofillGroup 은 막아둠
    return SizedBox(
      child: SizedBox(
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
    //this.onErrorReport,
    required this.getBuildContext,
  });
  final BuildContext context;
  final Size size; // 406 x 394
  //final Function(String)? onErrorReport;
  final Function getBuildContext;

  @override
  State<ExtraInfoDialog> createState() => _ExtraInfoDialogState();

  static bool _popAfterClose = true;
  static void setPopAfterClose(bool popAfterClose) => (_popAfterClose = popAfterClose);
  static void popupDialog({
    required BuildContext context,
    // Function? doAfterLogin,
    // Function(String)? onErrorReport,
    required Function getBuildContext,
  }) {
    if (kDebugMode) print('ExtraInfoDialog.popupDialog');
    _popAfterClose = true;
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
          //onErrorReport: onErrorReport,
          getBuildContext: getBuildContext,
        ),
      ),
    ).then((value) {
      if (kDebugMode) print('ExtraInfoDialog.showDialog.then($_popAfterClose)');
      if (_popAfterClose) {
        //Navigator.of(getBuildContext.call()).pop();
      }
      if (kDebugMode) print('ExtraInfoDialog.Routemaster');
      //Routemaster.of(getBuildContext.call()).push(AppRoutes.intro);
      if (AccountManager.currentLoginUser.isLoginedUser) {
        //String path = Uri.base.path;
        String path = LoginDialog.nextPageAfterLoginSuccess;
        if (path.isEmpty) {
          path = Uri.base.path;
        }
        Routemaster.of(getBuildContext.call()).push(path);
      } else {
        // do nothing
      }
      //doAfterLogin?.call();
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
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.usingPurpose = BookType.fromInt(usingPurpose);
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.genderType = GenderType.fromInt(genderType);
    // LoginPage.userPropertyManagerHolder!.userPropertyModel!.birthYear = birthYear;
    // //LoginPage.userPropertyManagerHolder!.updateModel(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
    // LoginPage.userPropertyManagerHolder!.setToDB(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
    ExtraInfoDialog.setPopAfterClose(false);
    Navigator.of(widget.context).pop();
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
                      showSnackBar(widget.context, '성별을 선택해주세요');
                      //widget.onErrorReport?.call('성별을 선택해주세요');
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

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

class LoginDialogEx extends StatefulWidget {
  const LoginDialogEx({
    super.key,
    required this.context,
    required this.size,
    required this.getBuildContext,
    this.loginPageState = LoginPageState.login,
  });
  final BuildContext context;
  final Size size;
  final Function getBuildContext;
  final LoginPageState loginPageState;

  @override
  State<LoginDialogEx> createState() => _LoginDialogExState();

  static bool _showExtraInfoDialog = false;
  static String _nextPageAfterLoginSuccess = '';
  static void setShowExtraInfoDialog(bool show) {
    if (kDebugMode) print('setShowExtraInfoDialog($show)');
    _showExtraInfoDialog = show;
  }

  static void popupDialog({
    required BuildContext context,
    required Function getBuildContext,
    LoginPageState loginPageState = LoginPageState.login,
    String? nextPageAfterLoginSuccess, //AppRoutes.communityHome,
    Function? onAfterLogin, //skpark add
  }) {
    _showExtraInfoDialog = false;
    _nextPageAfterLoginSuccess = nextPageAfterLoginSuccess ?? Uri.base.path;
    showDialog(
      context: context,
      builder: (context) => CretaStackDialog(
        key: GlobalObjectKey('LoginDialogEx.LoginDialogEx'),
        width: 717.0,
        height: 568.0,
        //title: '',
        //crossAxisAlign: CrossAxisAlignment.center,
        //hideTopSplitLine: true,
        content: LoginDialogEx(
          context: context,
          size: Size(717, 568),
          getBuildContext: getBuildContext,
          loginPageState: loginPageState,
        ),
      ),
    ).then((value) {
      CretaAccountManager.experienceWithoutLogin = false; //skpark add
      if (kDebugMode) print('ExtraInfoDialog.popupDialog($_showExtraInfoDialog)');
      if (_showExtraInfoDialog) {
        if (kDebugMode) print('if(_showExtraInfoDialog)');
        ExtraInfoDialog.popupDialog(
          context: getBuildContext.call(),
          getBuildContext: getBuildContext,
        );
        if (AccountManager.currentLoginUser.isLoginedUser) {
          // 로그인에 성공했을때,  아래 변수를 초기화 해주어야 함.
          CretaAccountManager.experienceWithoutLogin = false; //skpark add
          onAfterLogin?.call();
        }
      } else {
        //Routemaster.of(getBuildContext.call()).push(AppRoutes.intro);
        if (AccountManager.currentLoginUser.isLoginedUser) {
          // 로그인에 성공했을때,  아래 변수를 초기화 해주어야 함.
          CretaAccountManager.experienceWithoutLogin = false; //skpark add
          onAfterLogin?.call();
          Routemaster.of(getBuildContext.call()).push(_nextPageAfterLoginSuccess);
        } else {
          // do nothing
        }
      }
    });
  }
}

class _LoginDialogExState extends State<LoginDialogEx> {
  static const String materialIconEncrypted =
      '<svg viewBox="0 0 94 118" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M38.2507 76.5003H55.7507L52.3965 57.6878C54.3409 56.7156 55.8722 55.3059 56.9902 53.4587C58.1083 51.6114 58.6673 49.5698 58.6673 47.3337C58.6673 44.1253 57.525 41.3788 55.2402 39.0941C52.9555 36.8094 50.209 35.667 47.0007 35.667C43.7923 35.667 41.0458 36.8094 38.7611 39.0941C36.4763 41.3788 35.334 44.1253 35.334 47.3337C35.334 49.5698 35.893 51.6114 37.0111 53.4587C38.1291 55.3059 39.6604 56.7156 41.6048 57.6878L38.2507 76.5003ZM47.0007 117.334C33.4868 113.931 22.3305 106.177 13.5319 94.0732C4.73329 81.9691 0.333984 68.5281 0.333984 53.7503V18.167L47.0007 0.666992L93.6673 18.167V53.7503C93.6673 68.5281 89.268 81.9691 80.4694 94.0732C71.6708 106.177 60.5145 113.931 47.0007 117.334ZM47.0007 105.084C57.1118 101.875 65.4729 95.4587 72.084 85.8337C78.6951 76.2087 82.0007 65.5142 82.0007 53.7503V26.1878L47.0007 13.0628L12.0007 26.1878V53.7503C12.0007 65.5142 15.3062 76.2087 21.9173 85.8337C28.5284 95.4587 36.8895 101.875 47.0007 105.084Z" fill="#E7EFFD"/></svg>';
  static const String stringAgreeTerms = '(필수) 크레타 이용약관 동의';
  static const String stringAgreeUsingMarketing = '(선택) 마케팅 정보 발송 동의';

  final Map<String, bool> _checkboxSignupValueMap = {
    stringAgreeTerms: false,
    stringAgreeUsingMarketing: false,
  };

  final Map<String, bool> _checkboxLoginValueMap = {
    '로그인 상태 유지 ': true,
  };

  final double _leftPaneWidth = 311;
  double get _rightPaneWidth => (widget.size.width - 311);

  final _loginEmailTextEditingController = TextEditingController();
  final _loginPasswordTextEditingController = TextEditingController();

  final _signupNicknameTextEditingController = TextEditingController();
  final _signupEmailTextEditingController = TextEditingController();
  final _signupPasswordTextEditingController = TextEditingController();
  final _signupPasswordConfirmTextEditingController = TextEditingController();

  final _resetEmailTextEditingController = TextEditingController();

  late LoginPageState _currentPageState;
  bool _isLoginProcessing = false;
  String _emailErrorMessage = '';
  String _loginErrorMessage = '';
  String _nicknameErrorMessage = '';
  String _passwordErrorMessage = '';
  String _requirementsErrorMessage = '';
  String _snsLoginErrorMessage = '';

  String _notVerifyUserId = '';
  String _notVerifyEmail = '';
  String _notVerifyNickname = '';
  String _notVerifySecret = '';


  @override
  void initState() {
    super.initState();
    _currentPageState = widget.loginPageState;
  }


  void _moveToPageState(LoginPageState newState) {
    setState(() {
      _setErrorMessage();
      _currentPageState = newState;
      _isLoginProcessing = false;
    });
  }


  void _setErrorMessage({
    String? emailErrorMessage,
    String? loginErrorMessage,
    String? nicknameErrorMessage,
    String? passwordErrorMessage,
    String? requirementsErrorMessage,
    String? snsLoginErrorMessage,
  }) {
    _emailErrorMessage = emailErrorMessage ?? '';
    _loginErrorMessage = loginErrorMessage ?? '';
    _nicknameErrorMessage = nicknameErrorMessage ?? '';
    _passwordErrorMessage = passwordErrorMessage ?? '';
    _requirementsErrorMessage = requirementsErrorMessage ?? '';
    _snsLoginErrorMessage = snsLoginErrorMessage ?? '';
  }


  Future<void> _login(String email, String password) async {
    logger.finest('_login');
    await CretaAccountManager.logout(doGuestLogin: false);
    AccountManager.login(email, password).then((value) {
      HycopFactory.setBucketId();
      CretaAccountManager.initUserProperty().then((value) async {
        if (value) {
          if (CretaAccountManager.getUserProperty?.verified ?? false) {
            Navigator.of(widget.context).pop();
          }
          else {
            _notVerifyUserId = CretaAccountManager.currentLoginUser.userId;
            _notVerifyEmail = CretaAccountManager.currentLoginUser.email;
            _notVerifyNickname = CretaAccountManager.currentLoginUser.name;
            _notVerifySecret = CretaAccountManager.currentLoginUser.secret;
            await CretaAccountManager.logout();
            _moveToPageState(LoginPageState.verifyEmail);
          }
        } else {
          throw HycopUtils.getHycopException(defaultMessage: 'not exist userproperty !!!');
        }
      });
    }).onError((error, stackTrace) async {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '로그인에 실패하였습니다. 가입된 정보를 확인해보세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      setState(() {
        _setErrorMessage(loginErrorMessage: errMsg);
        _isLoginProcessing = false;
      });
      await CretaAccountManager.logout();
    });
  }


  Future<void> _loginByGoogle() async {
    logger.finest('_loginByGoogle');
    await CretaAccountManager.logout(doGuestLogin: false);
    AccountManager.createAccountByGoogle(myConfig!.config.googleOAuthCliendId).then((value) {
      HycopFactory.setBucketId();
      CretaAccountManager.userPropertyManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('email', QueryValue(value: AccountManager.currentLoginUser.email));
      CretaAccountManager.userPropertyManagerHolder.queryByAddedContitions().then((value) async {
        bool isNewUser = value.isEmpty;
        if (isNewUser) {
          // create model objects
          UserPropertyModel userModel =
              CretaAccountManager.userPropertyManagerHolder.makeCurrentNewUserProperty(
                agreeUsingMarketing: true,
                verified: true,
              );
          TeamModel teamModel = CretaAccountManager.teamManagerHolder.getNewTeam(
            createAndSetToCurrent: true,
            username: AccountManager.currentLoginUser.name,
            userEmail: userModel.email,
          );
          ChannelModel teamChannelModel =
              CretaAccountManager.channelManagerHolder.makeNewChannel(teamId: teamModel.mid);
          ChannelModel myChannelModel =
              CretaAccountManager.channelManagerHolder.makeNewChannel(userId: userModel.email);
          userModel.channelId = myChannelModel.mid;
          teamModel.channelId = teamChannelModel.mid;
          userModel.channelId = myChannelModel.mid;
          userModel.teams = [teamModel.mid];
          // create to DB
          await CretaAccountManager.channelManagerHolder.createChannel(teamChannelModel);
          await CretaAccountManager.channelManagerHolder.createChannel(myChannelModel);
          await CretaAccountManager.teamManagerHolder.createTeam(teamModel);
          await CretaAccountManager.userPropertyManagerHolder.createUserProperty(createModel: userModel);
          await CretaAccountManager.initUserProperty();
          LoginDialogEx.setShowExtraInfoDialog(true);
        }
        CretaAccountManager.initUserProperty().then((value) {
          if (value) {
            Navigator.of(widget.context).pop();
          } else {
            throw HycopUtils.getHycopException(defaultMessage: 'not exist userproperty !!!');
          }
        });
      });
    }).onError((error, stackTrace) async {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '구글 계정으로 로그인에 실패하였습니다.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      setState(() {
        _setErrorMessage(snsLoginErrorMessage: errMsg);
        _isLoginProcessing = false;
      });
      await CretaAccountManager.logout();
    });
  }


  Future<void> _signup(String nickname, String email, String password, bool agreeUsingMarketing) async {
    logger.finest('_signup');
    await AccountManager.isExistAccount(email).then((value) {
      AccountSignUpType accountSignUpType = value ?? AccountSignUpType.none;
      if (accountSignUpType != AccountSignUpType.none) {
        setState(() {
          _setErrorMessage(emailErrorMessage: '이미 가입된 이메일입니다.');
          _isLoginProcessing = false;
        });
        return;
      }
    });
    await CretaAccountManager.logout(doGuestLogin: false).then((value) {
      Map<String, dynamic> userData = {};
      userData['name'] = nickname;
      userData['email'] = email;
      userData['password'] = password;
      _notVerifySecret = HycopUtils.genUuid(includeDash: false);
      userData['secret'] = _notVerifySecret;
      logger.finest('register start');
      AccountManager.createAccount(userData).then((value) async {
        logger.finest('register end');
        // create model objects
        UserPropertyModel userModel = CretaAccountManager.userPropertyManagerHolder
            .makeCurrentNewUserProperty(agreeUsingMarketing: agreeUsingMarketing);
        TeamModel teamModel = CretaAccountManager.teamManagerHolder.getNewTeam(
          createAndSetToCurrent: true,
          username: nickname,
          userEmail: userModel.email,
        );
        ChannelModel teamChannelModel = CretaAccountManager.channelManagerHolder.makeNewChannel(teamId: teamModel.mid);
        ChannelModel myChannelModel = CretaAccountManager.channelManagerHolder.makeNewChannel(userId: userModel.email);
        teamModel.channelId = teamChannelModel.mid;
        userModel.channelId = myChannelModel.mid;
        userModel.teams = [teamModel.mid];
        // create to DB
        await CretaAccountManager.channelManagerHolder.createChannel(teamChannelModel);
        await CretaAccountManager.channelManagerHolder.createChannel(myChannelModel);
        await CretaAccountManager.teamManagerHolder.createTeam(teamModel);
        await CretaAccountManager.userPropertyManagerHolder.createUserProperty(createModel: userModel);
        await CretaAccountManager.initUserProperty();
        _notVerifyUserId = CretaAccountManager.currentLoginUser.userId;
        _notVerifyEmail = CretaAccountManager.currentLoginUser.email;
        _notVerifyNickname = CretaAccountManager.currentLoginUser.name;
        _notVerifySecret = CretaAccountManager.currentLoginUser.secret;
        _sendVerifyEmail(_notVerifyUserId, _notVerifyEmail, _notVerifySecret);
        await CretaAccountManager.logout();
        _moveToPageState(LoginPageState.verifyEmail);
      }).onError((error, stackTrace) async {
        String errMsg;
        if (error is HycopException) {
          HycopException ex = error;
          logger.severe(ex.message);
          errMsg = '계정 생성중 에러가 발생하였습니다. 관리자에 문의하세요.';
        } else {
          errMsg = 'Unknown DB Error !!!';
          logger.severe(errMsg);
        }
        setState(() {
          _setErrorMessage(loginErrorMessage: errMsg);
          _isLoginProcessing = false;
        });
        await CretaAccountManager.logout();
      });
    }).onError((error, stackTrace) async {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '계정을 확인할 수 없습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      setState(() {
        _setErrorMessage(loginErrorMessage: errMsg);
        _isLoginProcessing = false;
      });
      await CretaAccountManager.logout();
    });
  }


  Future<void> _resetPassword(String email) async {
    logger.finest('_resetPassword pressed');
    if (email.isEmpty) {
      setState(() {
        _setErrorMessage(loginErrorMessage: 'email is empty !!!');
        _isLoginProcessing = false;
      });
      return;
    }
    AccountManager.resetPassword(email).then((value) async {
      String userId = value.$1;
      String secret = value.$2;
      if (userId.isEmpty) {
        setState(() {
          _setErrorMessage(emailErrorMessage: 'SNS계정으로 가입하신 회원입니다.');
          _isLoginProcessing = false;
        });
      } else {
        bool ret = (secret.isEmpty) ? true : await CretaUtils.sendResetPasswordEmail(email, userId, secret);
        setState(() {
          _setErrorMessage(
            emailErrorMessage: ret ? '이메일을 발송하였으니 메일함을 확인하세요.' : '이메일 발송에 실패하였습니다.',
          );
          _isLoginProcessing = false;
        });
      }
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '비밀번호를 초기화할 수 없습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      setState(() {
        _setErrorMessage(loginErrorMessage: errMsg);
        _isLoginProcessing = false;
      });
    });
  }


  Future<bool> _sendVerifyEmail(String userId, String email, String secret) async {
    logger.finest('_sendVerifyEmail');
    await CretaUtils.sendVerifyEmail(userId, email, secret).then((value) {
      setState(() {
        _setErrorMessage(emailErrorMessage: '이메일 발송에 실패하였습니다.');
        _isLoginProcessing = false;
      });
    }).onError((error, stackTrace) {
      String errMsg;
      if (error is HycopException) {
        HycopException ex = error;
        logger.severe(ex.message);
        errMsg = '이메일을 발송할 수 없습니다. 관리자에 문의하세요.';
      } else {
        errMsg = 'Unknown DB Error !!!';
        logger.severe(errMsg);
      }
      setState(() {
        _setErrorMessage(loginErrorMessage: errMsg);
        _isLoginProcessing = false;
      });
    });
    return true;
  }


  List<Widget> _getLeftPaneForCommonHeader() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(40, 96, 0, 0),
        child: Image(
          image: AssetImage("assets/creta_logo_blue.png"),
          width: 100,
          height: 26,
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 19, 0, 0),
        child: Text(
          '크레타에 오신 것을 환영합니다.',
          style: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
        child: Text(
          '크레타에서 상상력을 마음껏 펼쳐보세요.',
          style: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]),
        ),
      ),
    ];
  }


  List<Widget> _getLeftPaneForCommonBody() {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(32, 160, 0, 0),
        child: Container(
          width: 247,
          height: 1.0,
          color: CretaColor.text[200], //Colors.grey.shade200,
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 27, 0, 0),
        child: Text(
          '팀 요금제에서는 모든 편집 기능과',
          style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
        child: Text(
          '더 효율적인 팀 협업을 지원합니다.',
          style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 19, 0, 0),
        child: BTN.line_blue_t_m(
          text: '요금제 보기',
          textStyle: CretaFont.buttonSmall.copyWith(color: CretaColor.text[400]),
          width: 89 - 38,
          height: 29,
          onPressed: () {},
        ),
      ),
    ];
  }


  Widget _getLeftPaneForSignup() {
    return Container(
      width: _leftPaneWidth,
      //height: ,
      color: CretaColor.text[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getLeftPaneForCommonHeader(), // 로고+환영합니다+펼쳐보세요
          ..._getLeftPaneForCommonBody(), // 라인+팀요금제+보기버튼
          Padding(
            padding: EdgeInsets.fromLTRB(32, 23, 0, 0),
            child: Container(
              width: 247,
              height: 1.0,
              color: CretaColor.text[200], //Colors.grey.shade200,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(61, 20, 0, 0),
            child: Row(
              children: [
                Text(
                  '이미 회원이신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(width: 8),
                BTN.line_blue_t_m(
                  text: '로그인하기',
                  //width: 89 - 38 + 6,
                  height: 32,
                  onPressed: () {
                    _moveToPageState(LoginPageState.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _getLeftPaneForResetPassword() {
    return Container(
      width: 311,
      //height: ,
      color: CretaColor.text[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getLeftPaneForCommonHeader(), // 로고+환영합니다+펼쳐보세요
          ..._getLeftPaneForCommonBody(), // 라인+팀요금제+보기버튼
          Padding(
            padding: EdgeInsets.fromLTRB(32, 24, 0, 0),
            child: Container(
              width: 247,
              height: 2.0,
              color: CretaColor.text[200], //Colors.grey.shade200,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(61, 20, 0, 0),
            child: Row(
              children: [
                Text(
                  '이미 회원이 아니신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(width: 8),
                BTN.line_blue_t_m(
                  text: '회원가입',
                  //width: 77,
                  height: 32,
                  onPressed: () {
                    _moveToPageState(LoginPageState.singup);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _getLeftPaneForLogin() {
    return Container(
      width: 311,
      //height: ,
      color: CretaColor.text[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._getLeftPaneForCommonHeader(), // 로고+환영합니다+펼쳐보세요
          Padding(
            padding: EdgeInsets.fromLTRB(32, 294, 0, 0),
            child: Container(
              width: 247,
              height: 1.0,
              color: CretaColor.text[200], //Colors.grey.shade200,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(36, 20, 0, 0),
            child: Row(
              children: [
                Text(
                  '이미 회원이 아니신가요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(width: 8),
                BTN.line_blue_t_m(
                  text: '이메일 회원가입',
                  //width: 82, // 114,
                  height: 32,
                  onPressed: () {
                    _moveToPageState(LoginPageState.singup);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _getLeftPane() {
    switch (_currentPageState) {
      case LoginPageState.singup:
      case LoginPageState.verifyEmail:
        return _getLeftPaneForSignup();
      case LoginPageState.resetPassword:
        return _getLeftPaneForResetPassword();
      case LoginPageState.login:
        return _getLeftPaneForLogin();
    }
  }


  Widget _getRightPaneForSignup() {
    return SizedBox(
      //width: ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Text(
              '이메일로 회원가입',
              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 31, 0, 0),
            child: Text(
              '닉네임',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('signup-nickname'),
              controller: _signupNicknameTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '닉네임 입력',
              autofillHints: const [AutofillHints.name],
              onEditComplete: (value) {},
              fixedOutlineColor: _nicknameErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
            child: Text(
              _nicknameErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 32 - 23, 0, 0),
            child: Text(
              '이메일',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('signup-email'),
              controller: _signupEmailTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '이메일 주소 입력',
              autofillHints: const [AutofillHints.email],
              onEditComplete: (value) {},
              fixedOutlineColor: _emailErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: Text(
              _emailErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 32 - 22, 0, 0),
            child: Text(
              '비밀번호',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('signup-password'),
              controller: _signupPasswordTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '비밀번호 (6자 ~ 16자, 영문/숫자 필수)',
              autofillHints: const [AutofillHints.password],
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {},
              fixedOutlineColor: _passwordErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
            child: Text(
              _passwordErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 32 - 23, 0, 0),
            child: Text(
              '비밀번호 확인',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('signup-password-confirm'),
              controller: _signupPasswordConfirmTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '비밀번호 (6자 ~ 16자, 영문/숫자 필수)',
              autofillHints: const [AutofillHints.password],
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {},
              fixedOutlineColor: _passwordErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(36, 28, 0, 0),
            child: SizedBox(
              width: 304,
              child: CretaCheckbox(
                density: 8,
                valueMap: _checkboxSignupValueMap,
                onSelected: (title, value, nvMap) {
                  logger.finest('selected $title=$value');
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 1, 0, 0),
            child: Text(
              _requirementsErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
            child: _isLoginProcessing
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
                    text: '회원가입',
                    buttonColor: CretaButtonColor.skyTitle,
                    decoType: CretaButtonDeco.fill,
                    textColor: Colors.white,
                    onPressed: () {
                      TextInput.finishAutofillContext();
                      String nickname = _signupNicknameTextEditingController.text;
                      String id = _signupEmailTextEditingController.text;
                      String pwd = _signupPasswordTextEditingController.text;
                      String pwdConf = _signupPasswordConfirmTextEditingController.text;
                      bool agreeTerms = _checkboxSignupValueMap[stringAgreeTerms] ?? false;
                      bool agreeUsingMarketing = _checkboxSignupValueMap[stringAgreeUsingMarketing] ?? false;
                      setState(() {
                        if (nickname.isEmpty) {
                          _setErrorMessage(nicknameErrorMessage: '닉네임을 확인하세요.');
                        } else if (EmailValidator.validate(id) == false) {
                          _setErrorMessage(emailErrorMessage: '올바른 이메일 주소를 입력하세요.');
                        } else if (pwd.isEmpty || pwd != pwdConf) {
                          _setErrorMessage(passwordErrorMessage: '비밀번호를 확인하세요.');
                        } else if (agreeTerms == false) {
                          _setErrorMessage(requirementsErrorMessage: '필수 항목을 동의해주세요.');
                        } else {
                          _setErrorMessage();
                          _isLoginProcessing = true;
                          _signup(nickname, id, pwd, agreeUsingMarketing);
                        }
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }


  Widget _getRightPaneForLogin() {
    //return AutofillGroup(
    // => 웹 자동완성을 활용하기 위해서 AutofillGroup 필요.
    // => flutter 버그 때문인지 AutofillGroup를 사용하면
    //    build시에 SearchTextField에서 onSubmitted가 호출되면서 setState가 호출되고 오류가 발생.
    // => 위 버그가 해결되기 전까지 AutofillGroup 은 막아둠
    return SizedBox(
      //width: _rightPaneWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Text(
              '로그인',
              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 77, 0, 0),
            child: Text(
              '이메일',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('login-email'),
              controller: _loginEmailTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '이메일 주소 입력',
              autofillHints: const [AutofillHints.email],
              onEditComplete: (value) {},
              fixedOutlineColor: _emailErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
            child: Text(
              _emailErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 31 - 22, 0, 0),
            child: Text(
              '비밀번호',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('login-password'),
              controller: _loginPasswordTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '비밀번호 (6자 ~ 16자, 영문/숫자 필수)',
              autofillHints: const [AutofillHints.password],
              textType: CretaTextFieldType.password,
              onEditComplete: (value) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
            child: Text(
              _loginErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 32 - 22, 0, 0),
            child: _isLoginProcessing
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
                    text: '로그인',
                    buttonColor: CretaButtonColor.skyTitle,
                    decoType: CretaButtonDeco.fill,
                    textColor: Colors.white,
                    onPressed: () {
                      String id = _loginEmailTextEditingController.text;
                      String pwd = _loginPasswordTextEditingController.text;
                      setState(() {
                        if (EmailValidator.validate(id)) {
                          TextInput.finishAutofillContext();
                          _setErrorMessage();
                          _isLoginProcessing = true;
                          _login(id, pwd);
                        } else {
                          _setErrorMessage(emailErrorMessage: '올바른 이메일 주소를 입력하세요.');
                        }
                      });
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35, 15, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CretaCheckbox(
                  valueMap: _checkboxLoginValueMap,
                  onSelected: (title, value, nvMap) {
                    logger.finest('selected $title=$value');
                  },
                ),
                SizedBox(width: 155 - 6 - 15 - 60),
                if (!kDebugMode) SizedBox(width: 60),
                if (kDebugMode)
                  InkWell(
                    onTap: () {
                      String email = _loginEmailTextEditingController.text;
                      List<String> emailList = [email];
                      CretaAccountManager.userPropertyManagerHolder.getUserPropertyFromEmail(emailList).then((value) async {
                        if (value.isEmpty) {
                          showSnackBar(widget.context, '가입된 회원이 아닙니다');
                          return;
                        }
                        UserPropertyModel userModel = value[0];
                        if(userModel.teams.isNotEmpty) {
                          AbsExModel? model = await CretaAccountManager.teamManagerHolder.getFromDB(userModel.teams[0]);
                          if (model != null) {
                            TeamModel teamModel = model as TeamModel;
                            await CretaAccountManager.channelManagerHolder.removeToDB(teamModel.channelId);
                            await CretaAccountManager.teamManagerHolder.removeToDB(teamModel.getMid);
                          }
                        }
                        await CretaAccountManager.channelManagerHolder.removeToDB(userModel.channelId);
                        await CretaAccountManager.userPropertyManagerHolder.removeToDB(userModel.mid);
                        // hycop_users
                        String hycopUserId = 'user=${userModel.parentMid.value}';
                        UserPropertyManager manager = UserPropertyManager(tableName: 'hycop_users');
                        manager.removeToDB(hycopUserId);
                      });
                    },
                    child: SizedBox(
                      width: 60,
                      child: Text(
                        '회원탈퇴',
                        style: CretaFont.bodyESmall.copyWith(color: CretaColor.primary[400]),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: InkWell(
                    onTap: () {
                      _moveToPageState(LoginPageState.resetPassword);
                      ////////////////////////////////////////////////////////////////////////////////////
                      // _notVerifyNickname = '테스트';
                      // _notVerifyEmail = 'test@ttt.com';
                      // _moveToPageState(LoginPageState.verifyEmail);
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
          Padding(
            padding: EdgeInsets.fromLTRB(40, 28, 0, 0),
            child: Container(
              width: 326,
              height: 1.0,
              color: CretaColor.text[200], //Colors.grey.shade200,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(123, 30, 0, 0),
            child: Text(
              'SNS 계정으로 가입 및 로그인하기',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(123, 24, 0, 0),
            child: SizedBox(
              width: 159,
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _setErrorMessage(snsLoginErrorMessage: '아직 지원하지 않습니다.');
                        _isLoginProcessing = false;
                      });
                    },
                    child: Image(width: 32, height: 32, image: AssetImage('assets/social/facebook.png')),
                  ),
                  InkWell(
                    onTap: () {
                      _loginByGoogle();
                    },
                    child: SvgPicture.asset('assets/google__g__logo.svg', fit: BoxFit.contain, width: 32, height: 32),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _setErrorMessage(snsLoginErrorMessage: '아직 지원하지 않습니다.');
                        _isLoginProcessing = false;
                      });
                    },
                    child: Image(width: 32, height: 32, image: AssetImage('assets/social/kakaotalk.png')),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: SizedBox(
              width: _rightPaneWidth,
              child: Center(
                child: Text(
                  _snsLoginErrorMessage,
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRightPaneForVerifyEmail() {
    return SizedBox(
      //width: _rightPaneWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Text(
              '이메일 인증',
              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 77, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _notVerifyNickname,
                      style: CretaFont.bodyESmall.copyWith(color: CretaColor.primary[400]),
                    ),
                    Text(
                      ' 님, 안녕하세요',
                      style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '크레타에 오신 것을 환영합니다.',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(height: 38),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _notVerifyEmail,
                      style: CretaFont.bodyESmall.copyWith(color: CretaColor.primary[400]),
                    ),
                    Text(
                      ' 주소로 인증 메일이 발송되었습니다.',
                      style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '이메일의 인증 버튼을 눌러 메일 주소를 인증하시면',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(height: 8),
                Text(
                  '회원가입이 완료됩니다.',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(134, 23, 0, 0),
            child: Icon(
              Icons.mark_email_read_outlined,
              color: CretaColor.primary[100],
              size: 140,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(95, 30, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '메일이 도착하기 않으셨나요?',
                  style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    _sendVerifyEmail(_notVerifyUserId, _notVerifyEmail, _notVerifySecret);
                  },
                  child:
                  Text(
                    '재발송하기',
                    style: CretaFont.bodyESmall.copyWith(color: CretaColor.primary[400]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 16, 0, 0),
            child: BTN.line_blue_iti_m(
              width: 326,
              text: '로그인 하기',
              buttonColor: CretaButtonColor.skyTitle,
              decoType: CretaButtonDeco.fill,
              textColor: Colors.white,
              onPressed: () {
                _moveToPageState(LoginPageState.login);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRightPaneForResetPassword() {
    return SizedBox(
      //width: _rightPaneWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Text(
              '비밀번호 변경 URL 전송',
              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[700]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 77, 0, 0),
            child: SizedBox(
              width: _rightPaneWidth,
              //height: ,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '가입한 이메일 주소로 ',
                        style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                      ),
                      Text(
                        '비밀번호 변경 URL',
                        style: CretaFont.bodyESmall.copyWith(color: CretaColor.primary[400]),
                      ),
                      Text(
                        '을 알려드립니다.',
                        style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '로그인 후 비밀번호를 꼭 변경해주세요.',
                    style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[700]),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 22, 0, 0),
            child: Text(
              '이메일',
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.text[400]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 7, 0, 0),
            child: CretaTextField(
              textFieldKey: GlobalObjectKey('reset-email'),
              controller: _resetEmailTextEditingController,
              width: 326,
              height: 30,
              value: '',
              hintText: '이메일 주소 입력',
              autofillHints: const [AutofillHints.email],
              onEditComplete: (value) {},
              fixedOutlineColor: _emailErrorMessage.isNotEmpty ? CretaColor.stateCritical : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 0, 0),
            child: Text(
              _emailErrorMessage,
              style: CretaFont.bodyESmall.copyWith(color: CretaColor.stateCritical),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(156, 57 - 22, 0, 0),
            child: SvgPicture.string(materialIconEncrypted, width: 94, height: 117),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 72, 0, 0),
            child: _isLoginProcessing
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
                    text: '전송',
                    buttonColor: CretaButtonColor.skyTitle,
                    decoType: CretaButtonDeco.fill,
                    textColor: Colors.white,
                    onPressed: () {
                      String email = _resetEmailTextEditingController.text;
                      setState(() {
                        if (EmailValidator.validate(email)) {
                          TextInput.finishAutofillContext();
                          _setErrorMessage();
                          _isLoginProcessing = true;
                          _resetPassword(email);
                        } else {
                          _setErrorMessage(emailErrorMessage: '올바른 이메일 주소를 입력하세요.');
                        }
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getRightPane() {
    switch (_currentPageState) {
      case LoginPageState.singup:
        return _getRightPaneForSignup();
      case LoginPageState.verifyEmail:
        return _getRightPaneForVerifyEmail();
      case LoginPageState.resetPassword:
        return _getRightPaneForResetPassword();
      case LoginPageState.login:
        return _getRightPaneForLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Row(
          children: [
            _getLeftPane(),
            _getRightPane(),
          ],
        ),
      ),
    );
  }
}
