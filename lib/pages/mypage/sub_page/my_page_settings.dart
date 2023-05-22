import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/app_enums.dart';
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

  List<Text> themeItemList = [];
  List<Text> initPageItemList = [];
  List<Text> cookieItemList = [];

  
  @override
  void initState() {
    super.initState();

    // 테마 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.themeList) {
      themeItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 시작페이지 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.initPageList) {
      initPageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 쿠키 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.cookieList) {
      cookieItemList.add(Text(element, style: CretaFont.bodyMedium));
    }

  }


  // 구분선
  Widget divideLine({double leftPadding = 0, double topPadding = 0, double rightPadding = 0, double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding), 
      child: Container(
        width: widget.width * .7,
        height: 1,
        color: Colors.grey.shade200 ,
      ),
    );
  }

  Widget mainComponent() {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManagerHolder, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 450 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.settings, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.myNotice, style: CretaFont.titleELarge),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang.pushNotice, style: CretaFont.titleMedium),
                                const SizedBox(height: 25.0),
                                Text(CretaMyPageLang.emailNotice, style: CretaFont.titleMedium)
                              ],
                            ),
                            const SizedBox(width: 200.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaToggleButton(
                                  onSelected: (value) {
                                    userPropertyManagerHolder.userPropertyModel!.usePushNotice = value;
                                    userPropertyManagerHolder.setToDB(userPropertyManagerHolder.userPropertyModel!);
                                  }, 
                                  defaultValue: userPropertyManagerHolder.userPropertyModel!.usePushNotice
                                ),
                                const SizedBox(height: 16.0),
                                CretaToggleButton(
                                  onSelected: (value) {
                                    userPropertyManagerHolder.userPropertyModel!.useEmailNotice = value;
                                    userPropertyManagerHolder.setToDB(userPropertyManagerHolder.userPropertyModel!);
                                  }, 
                                  defaultValue: userPropertyManagerHolder.userPropertyModel!.useEmailNotice
                                )
                              ]
                            )
                          ]
                        )
                      ]
                    )
                  ),
                  divideLine(topPadding: 27.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.mySetting, style: CretaFont.titleELarge),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.theme, style: CretaFont.titleMedium),
                            const SizedBox(width: 245.0),
                            CretaWidgetDropDown(
                              width: 134.0,
                              items: themeItemList, 
                              defaultValue: userPropertyManagerHolder.userPropertyModel!.theme.index, 
                              onSelected: (value) {
                                userPropertyManagerHolder.userPropertyModel!.theme = ThemeType.fromInt(value);
                                userPropertyManagerHolder.setToDB(userPropertyManagerHolder.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(CretaMyPageLang.themeTip, style: CretaFont.bodySmall),
                        const SizedBox(height: 30.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.initPage, style: CretaFont.titleMedium),
                            const SizedBox(width: 199.0),
                            CretaWidgetDropDown(
                              width: 116.0,
                              items: initPageItemList, 
                              defaultValue: userPropertyManagerHolder.userPropertyModel!.initPage.index, 
                              onSelected: (value) {
                                userPropertyManagerHolder.userPropertyModel!.initPage = InitPageType.fromInt(value);
                                userPropertyManagerHolder.setToDB(userPropertyManagerHolder.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(CretaMyPageLang.initPageTip, style: CretaFont.bodySmall),
                        const SizedBox(height: 30.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.cookieSetting, style: CretaFont.titleMedium),
                            const SizedBox(width: 213.0),
                            CretaWidgetDropDown(
                              width: 120.0,
                              items: cookieItemList, 
                              defaultValue: userPropertyManagerHolder.userPropertyModel!.cookie.index, 
                              onSelected: (value) {
                                userPropertyManagerHolder.userPropertyModel!.cookie = CookieType.fromInt(value);
                                userPropertyManagerHolder.setToDB(userPropertyManagerHolder.userPropertyModel!);
                              }
                            )
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Text(CretaMyPageLang.cookieSettingTip, style: CretaFont.bodySmall),
                        const SizedBox(height: 150.0)
                      ]
                    )
                  )
                ]
              )
            ) : Container()
          )
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}