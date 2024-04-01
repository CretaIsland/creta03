import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'design_system/buttons/creta_button_wrapper.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double xStart = 0;
    double xEnd = CretaConst.verticalAppbarWidth;
    double xWing = xEnd - 15;

    double yStart = 0;
    double yEnd = size.height;

    double yFirstButton = 98;
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
}

enum VerticalAppBarType { community, studio, device }

class VerticalAppBar extends StatefulWidget {
  static VerticalAppBarType appBarSelected = VerticalAppBarType.community;

  const VerticalAppBar({super.key});

  @override
  State<VerticalAppBar> createState() => _VerticalAppBarState();
}

class _VerticalAppBarState extends State<VerticalAppBar> {
  @override
  Widget build(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    return Container(
        //padding: const EdgeInsets.only(top: 20),
        width: CretaConst.verticalAppbarWidth,
        color: CretaColor.text[100],
        child: Stack(
          children: [
            CustomPaint(
                size: Size(CretaConst.verticalAppbarWidth, displaySize.height),
                painter: MyCustomPainter()),
            Column(
              children: [
                const SizedBox(height: 20),
                titleLogoVertical(),
                const SizedBox(height: 32),
                communityLogo(context),
                const SizedBox(height: 12),
                studioLogo(context),
                const SizedBox(height: 12),
                deviceLogo(context),
              ],
            ),
          ],
        ));
  }

  static Widget titleLogoVertical() {
    return Column(
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
    );
  }

  Widget communityLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.language,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.communityHome);
            VerticalAppBar.appBarSelected = VerticalAppBarType.community;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Community",
            style: CretaFont.logoStyle.copyWith(fontSize: 12, color: Colors.white),
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
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.studioBookGridPage);
            VerticalAppBar.appBarSelected = VerticalAppBarType.studio;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Studio",
            style: CretaFont.logoStyle.copyWith(fontSize: 12, color: Colors.white),
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
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.deviceMainPage);
            VerticalAppBar.appBarSelected = VerticalAppBarType.device;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: Text(
            "Device",
            style: CretaFont.logoStyle.copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
