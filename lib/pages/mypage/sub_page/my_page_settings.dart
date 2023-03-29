import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_toggle_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/menu/creta_widget_drop_down.dart';


class MyPageSettings extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageSettings({super.key, required this.width, required this.height});

  @override
  State<MyPageSettings> createState() => _MyPageSettingsState();
}

class _MyPageSettingsState extends State<MyPageSettings> {

  List<Widget> themeDropdownItem = [];
  List<Widget> startpageDropdownItem = [];
  List<Widget> cookieDropdownItem = [];


  @override
  void initState() {
    super.initState();
    for (var element in CretaMyPageLang.themeItem) {
      themeDropdownItem.add(Text(element));
    }
    for (var element in CretaMyPageLang.startPageItem) {
      startpageDropdownItem.add(Text(element));
    }
    for (var element in CretaMyPageLang.cookieItem) {
      cookieDropdownItem.add(Text(element));
    }
  }


 Widget divideLine(double topMargin, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      height: 1,
      color: Colors.grey.shade200,
    );
  }


  Widget mainContainer(Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: widget.width < 700 ? Container() : SizedBox( 
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 165.0, top: 72.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CretaMyPageLang.settings, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
              divideLine(20.0, 38.0),
              Text(CretaMyPageLang.myNotice, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 22, color: CretaColor.text)),
              const SizedBox(height: 32),
              Row(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(CretaMyPageLang.pushNotice, style: CretaFont.titleMedium),
                      const SizedBox(height: 30),  
                      Text(CretaMyPageLang.emailNotice, style: CretaFont.titleMedium),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CretaToggleButton(onSelected: (value) {}, defaultValue: true),
                      const SizedBox(height: 16),  
                      CretaToggleButton(onSelected: (value) {}, defaultValue: true)
                    ],
                  ),
                ],
              ),
              divideLine(27.0, 30.0),
              Text(CretaMyPageLang.mySettings, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 22, color: CretaColor.text)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text(CretaMyPageLang.theme, style: CretaFont.titleMedium),
                  const SizedBox(width: 245.0),
                  CretaWidgetDropDown(
                    items: themeDropdownItem, 
                    defaultValue: 0, 
                    onSelected: (value) {},
                    width: 134,
                  )
                ],
              ),
              const SizedBox(height: 14),
              Text(CretaMyPageLang.themeGuidePhrase, style: CretaFont.bodySmall),
              const SizedBox(height: 23),
              Row(
                children: [
                  Text(CretaMyPageLang.startPage, style: CretaFont.titleMedium),
                  const SizedBox(width: 199.0),
                  CretaWidgetDropDown(
                    items: startpageDropdownItem, 
                    defaultValue: 0, 
                    onSelected: (value) {},
                    width: 134,
                  )
                ],
              ),
              const SizedBox(height: 14),
              Text(CretaMyPageLang.startPageGuidePhrase, style: CretaFont.bodySmall),
              const SizedBox(height: 23),
              Row(
                children: [
                  Text(CretaMyPageLang.setCookie, style: CretaFont.titleMedium),
                  const SizedBox(width: 213.0),
                  CretaWidgetDropDown(
                    items: cookieDropdownItem, 
                    defaultValue: 0, 
                    onSelected: (value) {},
                    width: 134,
                  )
                ],
              ),
              const SizedBox(height: 14),
              Text(CretaMyPageLang.setCookieGuidePhrase, style: CretaFont.bodySmall),
              widget.height > 692 ? SizedBox(height: widget.height - 692 / 2) : Container()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainContainer(Size(widget.width, widget.height));
  }
}