import 'package:get/get.dart';
import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

import 'design_system/buttons/creta_button_wrapper.dart';
import 'design_system/component/snippet.dart';
import 'pages/studio/studio_getx_controller.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double xStart = 0;
    double xEnd = CretaConst.verticalAppbarWidth;
    double xWing = xEnd - 15;

    double yStart = 0;
    double yEnd = size.height;

    double yFirstButton = _buttonStartPoint();
    double yFirstButtonWingStart = yFirstButton + 15;
    double yFirstArcEnd = yFirstButtonWingStart + 2;
    double yFirstButtonWingEnd = yFirstArcEnd + 15;

    Paint paint = Paint()
      ..color = CretaColor.primary
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(xEnd, yStart);
    path.lineTo(xEnd, yFirstButton);
    path.quadraticBezierTo(xEnd, yFirstButtonWingStart, xWing, yFirstButtonWingStart);
    path.arcToPoint(Offset(xWing, yFirstArcEnd),
        radius: const Radius.circular(2), clockwise: false);
    path.quadraticBezierTo(xEnd, yFirstArcEnd, xEnd, yFirstButtonWingEnd);
    path.lineTo(xEnd, yEnd);
    path.lineTo(xStart, yEnd);
    path.lineTo(xStart, yStart);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double _buttonStartPoint() {
    switch (VerticalAppBar.appBarSelected) {
      case VerticalAppBarType.community:
        return 100;
      case VerticalAppBarType.studio:
        return 100 + 14 + 50;
      case VerticalAppBarType.device:
        return 100 + 14 + 50 + 14 + 50;
      case VerticalAppBarType.admin:
        return 100 + 14 + 50 + 14 + 50 + 14 + 50;
    }
  }
}

enum VerticalAppBarType { community, studio, device, admin }

class VerticalAppBar extends StatefulWidget {
  static VerticalAppBarType appBarSelected = VerticalAppBarType.community;
  static bool fold = false;

  final Function onFoldButtonPressed;

  const VerticalAppBar({super.key, required this.onFoldButtonPressed});

  @override
  State<VerticalAppBar> createState() => _VerticalAppBarState();
}

class _VerticalAppBarState extends State<VerticalAppBar> {
  BoolEventController? _foldSendEvent;

  @override
  void initState() {
    super.initState();
    final BoolEventController foldSendEvent = Get.find(tag: 'vertical-app-bar-to-creta-left-bar');
    _foldSendEvent = foldSendEvent;
  }

  @override
  Widget build(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    return Container(
        //padding: const EdgeInsets.only(top: 20),
        width: CretaConst.verticalAppbarWidth,
        color: displaySize.height > 200 ? CretaColor.text[100] : CretaColor.primary,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (displaySize.height > 200)
              CustomPaint(
                  size: Size(CretaConst.verticalAppbarWidth, displaySize.height),
                  painter: MyCustomPainter()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //const SizedBox(height: 20),
                Column(
                  children: [
                    if (displaySize.height > 100) titleLogoVertical(),
                    //const SizedBox(height: 32),
                    if (displaySize.height > 200) communityLogo(context),
                    if (displaySize.height > 250) const SizedBox(height: 12),
                    if (displaySize.height > 250) studioLogo(context),
                    if (displaySize.height > 300) const SizedBox(height: 12),
                    if (displaySize.height > 300) deviceLogo(context),
                    if (displaySize.height > 350) const SizedBox(height: 12),
                    if (displaySize.height > 350) adminLogo(context),
                  ],
                ),
                if (displaySize.height > 450) _userInfoList(displaySize),
              ],
            ),
          ],
        ));
  }

  Widget titleLogoVertical() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/creta_logo_only_white.png'),
            //width: 120,
            height: 20,
          ),
          Text(
            CretaVars.serviceTypeString(),
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget communityLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          size: const Size(40, 40),
          iconSize: 24,
          icon: Icons.language,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.communityHome);
            VerticalAppBar.appBarSelected = VerticalAppBarType.community;
            VerticalAppBar.fold = false;
            CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
            _foldSendEvent?.sendEvent(false);
            widget.onFoldButtonPressed();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Community", //CretaDeviceLang.community,
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget studioLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.edit_note_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.studioBookGridPage);
            VerticalAppBar.appBarSelected = VerticalAppBarType.studio;
            VerticalAppBar.fold = false;
            CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
            _foldSendEvent?.sendEvent(false);
            widget.onFoldButtonPressed();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Studio", //CretaDeviceLang.studio,
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget deviceLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.tv_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.deviceMainPage);
            VerticalAppBar.appBarSelected = VerticalAppBarType.device;
            VerticalAppBar.fold = false;
            _foldSendEvent?.sendEvent(false);
            CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
            widget.onFoldButtonPressed();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Device", //CretaDeviceLang.device,
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget adminLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.admin_panel_settings_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.adminMainPage);
            VerticalAppBar.appBarSelected = VerticalAppBarType.admin;
            VerticalAppBar.fold = false;
            _foldSendEvent?.sendEvent(false);
            CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
            widget.onFoldButtonPressed();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Admin", //CretaDeviceLang.admin,
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _userInfoList(Size displaySize) {
    return Padding(
      padding: EdgeInsets.only(bottom: displaySize.height > 600 ? 152 : 50),
      child: Column(
        children: (!AccountManager.currentLoginUser.isLoginedUser)
            ? [
                Snippet.loginButton(context: context, getBuildContext: () {}),
                Snippet.signUpButton(context: context, getBuildContext: () {}),
              ]
            : [
                Snippet.notiBell(context: context),
                const SizedBox(height: 10),
                Snippet.smallUserInfo(context: context),
              ],
      ),
    );
  }
}
