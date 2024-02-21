// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';
//import 'package:creta_common/lang/creta_lang.dart';
import '../buttons/creta_button_wrapper.dart';
import '../buttons/creta_tapbar_button.dart';
import '../creta_color.dart';
import '../menu/creta_popup_menu.dart';
import 'snippet.dart';
//import '../../pages/login_page.dart';
import '../../pages/login/creta_account_manager.dart';
import '../../routes.dart';

class CretaLeftBar extends StatefulWidget {
  final List<CretaMenuItem> menuItem;
  final double height;
  final double width;
  final String gotoButtonTitle;
  final Function gotoButtonPressed;
  final bool isIconText;

  const CretaLeftBar({
    super.key,
    required this.menuItem,
    required this.width,
    required this.height,
    required this.gotoButtonTitle,
    required this.gotoButtonPressed,
    this.isIconText = false,
  });

  @override
  State<CretaLeftBar> createState() => _CretaLeftBarState();
}

class _CretaLeftBarState extends State<CretaLeftBar> {
  Widget _getCretaTapBarButton(CretaMenuItem item) {
    return CretaTapBarButton(
        iconData: item.iconData,
        selected: item.selected,
        caption: item.caption,
        iconSize: item.iconSize,
        isIconText: item.isIconText,
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

  @override
  Widget build(BuildContext context) {
    double userMenuHeight = widget.height -
        CretaComponentLocation.TabBar.padding.top -
        CretaComponentLocation.TabBar.padding.bottom;
    if (userMenuHeight > CretaComponentLocation.UserMenuInTabBar.height) {
      userMenuHeight = CretaComponentLocation.UserMenuInTabBar.height;
    }
    String channelId = CretaAccountManager.getUserProperty?.channelId ?? '';
    String channelLinkUrl = '${AppRoutes.channel}?$channelId';
    return Container(
      width: CretaComponentLocation.TabBar.width,
      height: widget.height,
      color: CretaColor.text[100],
      padding: CretaComponentLocation.TabBar.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              // crop
              borderRadius: BorderRadius.circular(19.2),
            ),
            clipBehavior: Clip.antiAlias, // crop method
            width: CretaComponentLocation.UserMenuInTabBar.width,
            height: userMenuHeight, //CretaComponentLocation.UserMenuInTabBar.height,
            padding: CretaComponentLocation.UserMenuInTabBar.padding,
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
                              text: AccountManager.currentLoginUser.name,
                              subText:
                                  '구독자 ${CretaAccountManager.getChannel?.followerCount ?? 0}명', //CretaLang.billInfo,
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
                      BTN.fill_blue_ti_el(
                        icon: Icons.arrow_forward_outlined,
                        text: widget.gotoButtonTitle,
                        onPressed: widget.gotoButtonPressed,
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
