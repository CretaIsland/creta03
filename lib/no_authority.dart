import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

import 'design_system/buttons/creta_button.dart';
import 'design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'routes.dart';

class NoAuthority extends StatelessWidget {
  const NoAuthority({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLogin = AccountManager.currentLoginUser.isLoginedUser;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                CretaLang['noAuth']!,
                style: CretaFont.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: BTN.fill_blue_t_l(
                //key: GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'),
                buttonColor: CretaButtonColor.blue,
                //fgColor: CretaColor.text[700]!,
                width: 300,
                height: 36,
                text: isLogin ? CretaLang['gotoCommunity']! : CretaLang['home']!,
                //image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                //image:
                //    NetworkImage(LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg),
                textStyle: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]),
                onPressed: () {
                  Routemaster.of(context).push(isLogin ? AppRoutes.communityHome : AppRoutes.intro);
                  return;
                  //return const Redirect(AppRoutes.intro);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
