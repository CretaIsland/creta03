// ignore_for_file: prefer_const_constructors

import 'package:creta03/data_io/user_property_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

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
//import 'creta_account_manager.dart';

enum LoginPageState {
  login, // 로그인
  singup, // 회원가입
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
    String nextPageAfterLoginSuccess = '',//AppRoutes.communityHome,
  }) {
    _showExtraInfoDialog = false;
    LoginDialog.nextPageAfterLoginSuccess = nextPageAfterLoginSuccess;
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
          // doAfterLogin: doAfterLogin,
          // doAfterSignup: doAfterSignup,
          // onErrorReport: onErrorReport,
          getBuildContext: getBuildContext,
          loginPageState: loginPageState,
        ),
      ),
    ).then((value) {
      if (kDebugMode) print('ExtraInfoDialog.popupDialog($_showExtraInfoDialog)');
      if (_showExtraInfoDialog) {
        if (kDebugMode) print('if(_showExtraInfoDialog)');
        ExtraInfoDialog.popupDialog(
          context: getBuildContext.call(),
          // doAfterLogin: doAfterLogin,
          // onErrorReport: onErrorReport,
          getBuildContext: getBuildContext,
        );
      } else {
        //Routemaster.of(getBuildContext.call()).push(AppRoutes.intro);
        if (AccountManager.currentLoginUser.isLoginedUser) {
          // 로그인에 성공했을때,  아래 변수를 초기화 해주어야 함.
          CretaAccountManager.experienceWithoutLogin = false; //skpark add
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
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('isRemoved', QueryValue(value: false));
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('email', QueryValue(value: AccountManager.currentLoginUser.email));
      CretaAccountManager.userPropertyManagerHolder.queryByAddedContitions().then((value) async {
        bool isNewUser = value.isEmpty;
        if (isNewUser) {
          // create model objects
          UserPropertyModel userModel = CretaAccountManager.userPropertyManagerHolder
              .makeCurrentNewUserProperty(agreeUsingMarketing: true);
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
          await CretaAccountManager.userPropertyManagerHolder
              .createUserProperty(createModel: userModel);
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

  Future<void> _signup(
      String nickname, String email, String password, bool agreeUsingMarketing) async {
    logger.finest('_signup pressed');

    logger.finest('isExistAccount');
    AccountManager.isExistAccount(email).then((value) {
      if (value) {
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
        await CretaAccountManager.userPropertyManagerHolder
            .createUserProperty(createModel: userModel);
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

    AccountManager.resetPassword(email).then((value) {
      //
      // success
      //
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
              bool agreeUsingMarketing =
                  _checkboxSignupValueMap[stringAgreeUsingMarketing] ?? false;
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
                      CretaAccountManager.userPropertyManagerHolder
                          .getUserPropertyFromEmail(emailList)
                          .then((value) {
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
  final Map<String, int> _genderValueMap = {
    '남': GenderType.male.index,
    '여': GenderType.female.index
  };
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
            child: CretaStepper(
                totalSteps: ExtraInfoPageState.end.index, currentStep: _extraInfoPageState.index),
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
                child: Icon(Icons.fiber_manual_record_rounded,
                    color: Colors.white, size: stepSize / 2),
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
                child: Icon(Icons.fiber_manual_record_rounded,
                    color: CretaColor.text[300], size: stepSize / 2),
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
