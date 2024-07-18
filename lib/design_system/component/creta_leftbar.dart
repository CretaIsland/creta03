// ignore_for_file: depend_on_referenced_packages

import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';
//import 'package:creta_common/lang/creta_lang.dart';
import '../../data_io/enterprise_manager.dart';
import '../../lang/creta_commu_lang.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../../vertical_app_bar.dart';
import '../buttons/creta_button_wrapper.dart';
import '../buttons/creta_tapbar_button.dart';
import 'package:creta_common/common/creta_color.dart';
import '../menu/creta_popup_menu.dart';
//import '../../pages/login_page.dart';
import '../../pages/login/creta_account_manager.dart';
import '../../routes.dart';
//import 'snippet.dart';

class CretaLeftBar extends StatefulWidget {
  final List<CretaMenuItem> menuItem;
  final double height;
  final double width;
  final String? gotoButtonTitle;
  final Function? gotoButtonPressed;
  final String? gotoButtonTitle2;
  final Function? gotoButtonPressed2;
  final bool isIconText;
  final Function? onFoldButtonPressed;

  const CretaLeftBar({
    super.key,
    required this.menuItem,
    required this.width,
    required this.height,
    this.gotoButtonTitle,
    this.gotoButtonPressed,
    this.gotoButtonTitle2,
    this.gotoButtonPressed2,
    this.isIconText = false,
    this.onFoldButtonPressed,
  });

  @override
  State<CretaLeftBar> createState() => _CretaLeftBarState();
}

class _CretaLeftBarState extends State<CretaLeftBar> {
  Widget _getCretaTapBarButton(CretaMenuItem item) {
    //print('_getCretaTapBarButton==============${item.caption}');
    return CretaTapBarButton(
        width: 195,
        height: 50,
        iconData: item.iconData,
        selected: item.selected,
        caption: item.caption,
        iconSize: item.iconSize,
        isIconText: item.isIconText,
        leftPadding: 10,
        onPressed: () {
          setState(() {
            for (var ele in widget.menuItem) {
              ele.selected = false;
            }
            item.selected = true;
            logger.finest('selected chaged');
          });
          item.onPressed?.call();
        });
  }

  BoolEventController? _foldReceiveEvent;

  @override
  void initState() {
    super.initState();

    final BoolEventController foldReceiveEvent = Get.find(tag: 'link-widget-to-property');
    _foldReceiveEvent = foldReceiveEvent;
  }

  @override
  Widget build(BuildContext context) {
    // String logoUrl = (CretaAccountManager.currentLoginUser.isLoginedUser)
    //     ? AppRoutes.communityHome
    //     : AppRoutes.intro;
    return StreamBuilder<bool>(
        stream: _foldReceiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is Offset) {
            VerticalAppBar.fold = snapshot.data!;
          }
          if (VerticalAppBar.fold == false) {
            //print('==========================================');
            CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
          }
          return _leftBar();
        });
  }

  Widget _leftBar() {
    final Size displaySize = MediaQuery.of(context).size;

    if (VerticalAppBar.fold == true) {
      return const SizedBox.shrink();
    }

    bool hasTwoButton = (widget.gotoButtonTitle2 != null && widget.gotoButtonPressed2 != null);

    double userMenuHeight = widget.height -
        CretaComponentLocation.TabBar.padding.top -
        CretaComponentLocation.TabBar.padding.bottom;
    if (userMenuHeight > CretaComponentLocation.UserMenuInTabBar.height) {
      userMenuHeight = CretaComponentLocation.UserMenuInTabBar.height;
    }
    String channelId = CretaAccountManager.getUserProperty?.channelId ?? '';
    String channelLinkUrl = '${AppRoutes.channel}?$channelId';

    //print('_leftBar: ============================');

    String enterprise = CretaAccountManager.getUserProperty?.enterprise ?? '';

    return Container(
      width: CretaComponentLocation.TabBar.width,
      height: widget.height,
      color: CretaColor.text[100],
      padding: CretaComponentLocation.TabBar.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Snippet.titleLogoBar(logoUrl),
          //     BTN.fill_gray_i_m(onPressed: () {}, icon: Icons.keyboard_double_arrow_left_outlined)
          //   ],
          // ),
          Align(
              alignment: Alignment.centerRight,
              child: BTN.fill_gray_i_m(
                tooltip: CretaLang['fold']!,
                onPressed: () {
                  setState(() {
                    VerticalAppBar.fold = true;
                    CretaComponentLocation.TabBar.width = 0;
                  });
                  widget.onFoldButtonPressed?.call();
                },
                icon: Icons.keyboard_double_arrow_left_outlined,
              )),
          const SizedBox(height: 36),

          Expanded(
            child: ListView.builder(
                padding: CretaComponentLocation.ListInTabBar.padding,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Wrap(
                    direction: Axis.vertical,
                    spacing: 8, // <-- Spacing between children
                    children: widget.menuItem
                        .map((item) => (item.linkUrl == null)
                            ? _getCretaTapBarButton(item)
                            : Link(
                                uri: Uri.parse(item.linkUrl!),
                                builder: (context, function) {
                                  return InkWell(
                                    onTap: () => {},
                                    child: _getCretaTapBarButton(item),
                                  );
                                }))
                        .toList(),
                  );
                }),
          ),

          //하단 사용자 메뉴

          if (displaySize.height > 400)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                //color: Colors.amberAccent,
                // crop
                borderRadius: BorderRadius.circular(19.2),
              ),
              clipBehavior: Clip.antiAlias, // crop method
              width: CretaComponentLocation.UserMenuInTabBar.width,
              height: hasTwoButton
                  ? userMenuHeight + 76
                  : userMenuHeight, //CretaComponentLocation.UserMenuInTabBar.height,
              padding: const EdgeInsets.fromLTRB(
                  4, 20, 4, 20), //CretaComponentLocation.UserMenuInTabBar.padding,
              child: ListView.builder(
                  //padding: EdgeInsets.fromLTRB(leftMenuViewLeftPane, leftMenuViewTopPane, 0, 0),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Link(
                            uri: Uri.parse(channelLinkUrl),
                            builder: (context, function) {
                              return BTN.fill_gray_l_profile(
                                width: 195,
                                text: AccountManager.currentLoginUser.name,
                                subText: EnterpriseManager.isEnterpriseUser(enterprise : enterprise)
                                    ? CretaAccountManager.getEnterprise == null
                                        ? enterprise
                                        : CretaAccountManager.getEnterprise!.name
                                    : '${CretaCommuLang["subscriber"]!} ${CretaAccountManager.getChannel?.followerCount ?? 0}',
                                image: const AssetImage('assets/creta_default.png'),
                                onPressed: () {
                                  if (channelId.isNotEmpty) {
                                    Routemaster.of(context).push(channelLinkUrl);
                                  }
                                },
                              );
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        if (widget.gotoButtonTitle != null && widget.gotoButtonPressed != null)
                          BTN.fill_blue_ti_el(
                            icon: Icons.arrow_forward_outlined,
                            text: widget.gotoButtonTitle!,
                            onPressed: widget.gotoButtonPressed!,
                          ),
                        if (hasTwoButton)
                          const SizedBox(
                            height: 20,
                          ),
                        if (hasTwoButton)
                          BTN.fill_blue_ti_el(
                            icon: Icons.arrow_forward_outlined,
                            text: widget.gotoButtonTitle2!,
                            onPressed: widget.gotoButtonPressed2!,
                          ),
                      ],
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
