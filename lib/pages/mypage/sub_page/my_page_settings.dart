import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';



class MyPageSettings extends StatefulWidget {

  final double width;
  final double height;
  const MyPageSettings({super.key, required this.width, required this.height});

  @override
  State<MyPageSettings> createState() => _MyPageSettingsState();
}

class _MyPageSettingsState extends State<MyPageSettings> {

  // dropdown menu item
  List<Text> themeItemList = [];
  List<Text> initPageItemList = [];
  List<Text> cookieItemList = [];


  @override
  void initState() {
    super.initState();

    // set theme dropdown menu item
    for(var element in CretaMyPageLang.themeList) {
      themeItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set initPage dropdown menu item
    for(var element in CretaMyPageLang.initPageList) {
      initPageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set cookie dropdown menu item
    for(var element in CretaMyPageLang.cookieList) {
      cookieItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
  }


  Widget divideLine({double leftPadding = 0.0, double topPadding = 0.0, double rightPadding = 0.0, double bottomPadding = 0.0, double width = 10.0, double height = 1.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 400 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.settings,
                    style: const TextStyle(
                      fontFamily: 'Pretendard', 
                      fontWeight: CretaFont.semiBold, 
                      fontSize: 40, color: 
                      CretaColor.text
                    ),
                  ),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.myNotice,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CretaMyPageLang.pushNotice,
                                  style: CretaFont.titleMedium,
                                ),
                                const SizedBox(height: 25.0),
                                Text(
                                  CretaMyPageLang.emailNotice,
                                  style: CretaFont.titleMedium,
                                )
                              ],
                            ),
                            const SizedBox(width: 199.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaToggleButton(
                                  defaultValue: userPropertyManager.userPropertyModel!.usePushNotice,
                                  onSelected: (value) {
                                    userPropertyManager.userPropertyModel!.usePushNotice = value;
                                    userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                                  }, 
                                ),
                                const SizedBox(height: 16.0),
                                CretaToggleButton(
                                  defaultValue: userPropertyManager.userPropertyModel!.useEmailNotice,
                                  onSelected: (value) {
                                    userPropertyManager.userPropertyModel!.useEmailNotice = value;
                                    userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                                  }, 
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 27.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.mySetting,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 31.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.theme,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 245.0),
                            CretaWidgetDropDown(
                              items: themeItemList, 
                              defaultValue: userPropertyManager.userPropertyModel!.theme.index, 
                              width: 134.0,
                              height: 32.0,
                              onSelected: (value) {
                                userPropertyManager.userPropertyModel!.theme = ThemeType.fromInt(value);
                                userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(
                          CretaMyPageLang.themeTip,
                          style: CretaFont.bodySmall,
                        ),
                        const SizedBox(height: 23.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.initPage,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 199.0),
                            CretaWidgetDropDown(
                              items: initPageItemList, 
                              defaultValue: userPropertyManager.userPropertyModel!.initPage.index, 
                              width: 116.0,
                              height: 32.0,
                              onSelected: (value) {
                                userPropertyManager.userPropertyModel!.initPage = InitPageType.fromInt(value);
                                userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(
                          CretaMyPageLang.initPageTip,
                          style: CretaFont.bodySmall,
                        ),
                        const SizedBox(height: 23.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.cookieSetting,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 213.0),
                            CretaWidgetDropDown(
                              items: cookieItemList, 
                              defaultValue: userPropertyManager.userPropertyModel!.cookie.index, 
                              width: 120.0,
                              height: 32.0,
                              onSelected: (value) {
                                userPropertyManager.userPropertyModel!.cookie = CookieType.fromInt(value);
                                userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(
                          CretaMyPageLang.cookieSettingTip,
                          style: CretaFont.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120.0)
                ],
              ),
            ) : const SizedBox(),
          ),
        );
      },
    );
  }
}