import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

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
    for (var element in CretaMyPageLang['themeList']!) {
      themeItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set initPage dropdown menu item
    for (var element in CretaMyPageLang['initPageList']!) {
      initPageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set cookie dropdown menu item
    for (var element in CretaMyPageLang['cookieList']!) {
      cookieItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManager, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
              child: widget.width > 600
                  ? Padding(
                      padding: EdgeInsets.only(top: 72, left: widget.width * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CretaMyPageLang['settings']!,
                              style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                          MyPageCommonWidget.divideLine(
                              width: widget.width * .6,
                              padding: const EdgeInsets.only(top: 22, bottom: 32)),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['myNotice'], //"내 알림",
                                    style: CretaFont.titleELarge),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(CretaMyPageLang['pushNotice'], //"푸시 알림",
                                            style: CretaFont.titleMedium),
                                        const SizedBox(height: 25),
                                        Text(CretaMyPageLang['emailNotice'], //"이메일 알림",
                                            style: CretaFont.titleMedium)
                                      ],
                                    ),
                                    const SizedBox(width: 200),
                                    Column(
                                      children: [
                                        CretaToggleButton(
                                          defaultValue:
                                              userPropertyManager.userPropertyModel!.usePushNotice,
                                          onSelected: (value) {
                                            userPropertyManager.userPropertyModel!.usePushNotice =
                                                value;
                                            userPropertyManager
                                                .setToDB(userPropertyManager.userPropertyModel!);
                                          },
                                        ),
                                        const SizedBox(height: 16.0),
                                        CretaToggleButton(
                                          defaultValue:
                                              userPropertyManager.userPropertyModel!.useEmailNotice,
                                          onSelected: (value) {
                                            userPropertyManager.userPropertyModel!.useEmailNotice =
                                                value;
                                            userPropertyManager
                                                .setToDB(userPropertyManager.userPropertyModel!);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          MyPageCommonWidget.divideLine(
                              width: widget.width * .6,
                              padding: const EdgeInsets.only(top: 27, bottom: 32)),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['mySetting'], //"내 설정",
                                    style: CretaFont.titleELarge),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    Text(CretaMyPageLang['theme'], //"테마",
                                        style: CretaFont.titleMedium),
                                    const SizedBox(width: 245.0),
                                    CretaWidgetDropDown(
                                        items: themeItemList,
                                        defaultValue:
                                            userPropertyManager.userPropertyModel!.theme.index,
                                        width: 200.0,
                                        height: 32.0,
                                        onSelected: (value) {
                                          userPropertyManager.userPropertyModel!.theme =
                                              ThemeType.fromInt(value);
                                          userPropertyManager
                                              .setToDB(userPropertyManager.userPropertyModel!);
                                        })
                                  ],
                                ),
                                const SizedBox(height: 14.0),
                                Text(CretaMyPageLang['themeTip']!,
                                    style: CretaFont.bodySmall
                                        .copyWith(color: CretaColor.text.shade400)),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(CretaMyPageLang['initPage']!,
                                        style: CretaFont.titleMedium),
                                    const SizedBox(width: 200.0),
                                    CretaWidgetDropDown(
                                        items: initPageItemList,
                                        defaultValue:
                                            userPropertyManager.userPropertyModel!.initPage.index,
                                        width: 200.0,
                                        height: 32.0,
                                        onSelected: (value) {
                                          userPropertyManager.userPropertyModel!.initPage =
                                              InitPageType.fromInt(value);
                                          userPropertyManager
                                              .setToDB(userPropertyManager.userPropertyModel!);
                                        })
                                  ],
                                ),
                                const SizedBox(height: 14.0),
                                Text(CretaMyPageLang['initPageTip']!,
                                    style: CretaFont.bodySmall
                                        .copyWith(color: CretaColor.text.shade400)),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(CretaMyPageLang['cookieSetting']!,
                                        style: CretaFont.titleMedium),
                                    const SizedBox(width: 213.0),
                                    CretaWidgetDropDown(
                                        items: cookieItemList,
                                        defaultValue:
                                            userPropertyManager.userPropertyModel!.cookie.index,
                                        width: 200.0,
                                        height: 32.0,
                                        onSelected: (value) {
                                          userPropertyManager.userPropertyModel!.cookie =
                                              CookieType.fromInt(value);
                                          userPropertyManager
                                              .setToDB(userPropertyManager.userPropertyModel!);
                                        })
                                  ],
                                ),
                                const SizedBox(height: 14.0),
                                Text(CretaMyPageLang['cookieSettingTip']!,
                                    style: CretaFont.bodySmall
                                        .copyWith(color: CretaColor.text.shade400))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
        );
      },
    );
  }
}
