import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/drawer_mixin.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'design_system/buttons/creta_button_wrapper.dart';
import 'pages/studio/studio_variables.dart';

class DrawerHandle extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isStudioEditor;
  const DrawerHandle({super.key, required this.scaffoldKey, this.isStudioEditor = false});

  @override
  State<DrawerHandle> createState() => DrawerHandleState();

  static GlobalObjectKey drawerMainKey = const GlobalObjectKey<DrawerHandleState>('DrawerHandle');
}

class DrawerHandleState extends State<DrawerHandle> with DrawerMixin {
  @override
  void initState() {
    super.initState();
    initMixin(context);
  }

  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '--------------------------${CretaAccountManager.getEnterprise!.imageUrl}-----------------------');
    return Drawer(
      //backgroundColor: CretaColor.primary,
      shadowColor: Colors.grey,
      surfaceTintColor: Colors.grey,
      elevation: 5,
      width: CretaConst.menuHandleWidth,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: _shirinkWidget(),
        ),
      ),
    );
  }

  List<Widget> _shirinkWidget() {
    return [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: CretaColor.primary,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: BTN.fill_blue_i_l(
                      size: const Size(32, 32),
                      iconSize: 24,
                      icon: widget.isStudioEditor
                          ? Icons.keyboard_double_arrow_left_outlined
                          : Icons.keyboard_double_arrow_right_outlined,
                      onPressed: () {
                        widget.isStudioEditor
                            ? widget.scaffoldKey.currentState?.closeDrawer()
                            : widget.scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Snippet.serviceTypeLogo(true),
                  ),
                ],
              ),
            ),
            ...List.generate(topMenuItems.length, (index) {
              var topItem = topMenuItems[index];
              return

                  //Snippet.TooltipWrapper(
                  //preferredDirection: AxisDirection.up,
                  //fgColor: Colors.white,
                  //bgColor: Colors.grey[400]!,
                  //tooltip: topItem.caption,
                  // child:
                  ListTile(
                title: Icon(topItem.iconData),
                // subtitle: Text(topItem.caption,
                //     style: CretaFont.logoStyle.copyWith(
                //       fontSize: 12,
                //       color: CretaColor.text[400]!,
                //     )),
                onTap: topItem.onPressed,
                //),
              );
            }),
            //Snippet.TooltipWrapper(
            //preferredDirection: AxisDirection.up,
            //fgColor: Colors.white,
            //bgColor: Colors.grey[400]!,
            //tooltip: "logout",
            //child:
            ListTile(
              title: const Icon(Icons.exit_to_app), // 로그아웃 아이콘
              onTap: () {
                StudioVariables.selectedBookMid = '';
                CretaAccountManager.logout()
                    .then((value) => Routemaster.of(context).push(AppRoutes.login));
              },
              //),
            ),
          ],
        ),
      ),
      //const Spacer(),
      // Padding(
      //   padding: const EdgeInsets.only(bottom: 24.0),
      //   child: Center(child: _userInfoButton()),
      // ),
    ];
  }
}
