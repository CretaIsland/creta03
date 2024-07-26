// ignore_for_file: prefer_const_constructors

//import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:url_launcher/link.dart';

import '../../routes.dart';
import '../design_system/component/snippet.dart';
//import '../../design_system/text_field/creta_text_field.dart';
//import 'package:creta_common/common/creta_font.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../lang/creta_commu_lang.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    super.key,
    required this.userId,
    required this.secretKey,
  });

  final String userId;
  final String secretKey;

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isJobProcessing = false;
  bool _isVerified = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
  }

  void _doVerifyEmail() {
    setState(() {
      _isJobProcessing = true;
    });

    Map<String, dynamic> userData = {};
    HycopFactory.account!.getAccountInfo(widget.userId, userData).catchError((error) {
      setState(() {
        _isJobProcessing = false;
        _error = true;
      });
    }).then((value) {
      String secretKey = userData['secret'] ?? '';
      if (secretKey != widget.secretKey) {
        setState(() {
          _isJobProcessing = false;
          _error = true;
        });
        return;
      }
      // secretKey is match ==> change 'verified' to 'true'
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('parentMid', QueryValue(value: widget.userId));
      CretaAccountManager.userPropertyManagerHolder
          .addWhereClause('isRemoved', QueryValue(value: false));
      CretaAccountManager.userPropertyManagerHolder
          .queryByAddedContitions()
          .catchError((error, stackTrace) {
        setState(() {
          _isJobProcessing = false;
          _error = true;
        });
        throw HycopUtils.getHycopException(defaultMessage: 'verify email error !!!');
      }).then((modelList) {
        if (modelList.isEmpty) {
          setState(() {
            _isJobProcessing = false;
            _error = true;
          });
        } else {
          UserPropertyModel model = modelList[0] as UserPropertyModel;
          model.verified = true;
          CretaAccountManager.userPropertyManagerHolder
              .setToDB(model)
              .catchError((error, stackTrace) {
            setState(() {
              _isJobProcessing = false;
              _error = true;
            });
          }).then((value) {
            setState(() {
              _isJobProcessing = false;
              _error = false;
              _isVerified = true;
            });
          });
        }
      });
    });
  }

  BuildContext getBuildContext() {
    return context;
  }

  Widget _getVerifyButton() {
    return _isJobProcessing
        ? BTN.line_blue_iwi_m(
            width: 294,
            widget: CretaSnippet.showWaitSign(color: Colors.white, size: 16),
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () {},
          )
        : BTN.line_blue_iti_m(
            width: 200,
            text: CretaCommuLang["memberAuthentication"], //'회원 인증 하기',
            buttonColor: CretaButtonColor.skyTitle,
            decoType: CretaButtonDeco.fill,
            textColor: Colors.white,
            onPressed: () => _doVerifyEmail(),
          );
  }

  Widget _getVerifiedBody() {
    return Center(
      child: SizedBox(
        width: 450,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CretaCommuLang["memberAuthenticationCompleted"], //'회원 인증이 완료되었습니다.
            ),
            Text(
              CretaCommuLang["moveToCretaHomeAndLogin"], //'크레타 홈으로 이동한 후 로그인 하세요.
            ),
            BTN.line_blue_iti_m(
              width: 200,
              text: CretaCommuLang["moveToCretaHome"], //'크레타 홈으로 이동',
              buttonColor: CretaButtonColor.skyTitle,
              decoType: CretaButtonDeco.fill,
              textColor: Colors.white,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.intro);
              },
            ),
            Text(''),
          ],
        ),
      ),
    );
  }

  Widget _getNotVerifiedBody() {
    return Center(
      child: SizedBox(
        width: 450,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              CretaCommuLang["completeAuthenticationByClickingButton"], //'아래 버튼을 눌러 인증을 완료하세요.'
            ),
            Text(''),
            _getVerifyButton(),
            Text(_error
                ? CretaCommuLang["errorOccurredContactAdmin"] //'에러가 발생하였습니다. 관리자에 문의하세요'
                : ''),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    if (_isVerified) {
      return _getVerifiedBody();
    }
    return _getNotVerifiedBody();
  }

  @override
  Widget build(BuildContext context) {
    String logoUrl = (CretaAccountManager.currentLoginUser.isLoginedUser)
        ? AppRoutes.communityHome
        : AppRoutes.intro;
    double displayWidth = MediaQuery.of(context).size.width;
    //double displayHeight = MediaQuery.of(context).size.height;
    // return Snippet.CretaScaffoldOfCommunity(
    //   onFoldButtonPressed: () {
    //     setState(() {});
    //   },
    //
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
    //   child: _getBody(),
    // );
    return Scaffold(
      key: Snippet.communityScaffoldKey,
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
          Expanded(child: _getBody()),
        ],
      ),
    );
  }
}
