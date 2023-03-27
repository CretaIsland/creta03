import 'dart:typed_data';

import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

import '../../../design_system/creta_color.dart';
class MyPageInfo extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageInfo({super.key, required this.width, required this.height});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {
  
  // 프로필 이미지를 받을 변수
  XFile? _pickedFile;
  Uint8List? _pickedFileBytes;

  // firebase storage
  FirebaseAppStorage? firebaseAppStorage;

  // dropdownmenu item
  List<Widget> countryDropDownItem = [];
  List<Widget> languageDropDownItem = [];
  List<Widget> jobDropDownItem = [];


  @override
  void initState() {
    super.initState();

    for (var element in CretaMyPageLang.countryList) {
      countryDropDownItem.add(Text(element));
    }
    for (var element in CretaMyPageLang.languageList) {
      languageDropDownItem.add(Text(element));
    }
    for (var element in CretaMyPageLang.jobList) {
      jobDropDownItem.add(Text(element));
    }

    firebaseAppStorage = FirebaseAppStorage();
    firebaseAppStorage!.initialize();
  }

  Widget divideLine(double topMargin, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget mainComponent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox( 
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 165.0, top: 72.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CretaMyPageLang.info, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
              divideLine(20, 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.infoField[0], style: CretaFont.titleMedium),
                  const SizedBox(width: 105.0),
                  Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.grey.shade200),
                          image: _pickedFileBytes == null ? null : DecorationImage(image: Image.memory(_pickedFileBytes!).image, fit: BoxFit.cover)
                        ),
                      ),
                      // 이미지 업로드 버튼
                      Padding(
                        padding: const EdgeInsets.only(left: 86, top: 152),
                        child: BTN.opacity_gray_i_s(
                          icon: Icons.photo_camera_outlined, 
                          onPressed: () async {
                            try {
                              final pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if(pickFile!=null) {
                                _pickedFile = pickFile;
                                pickFile.readAsBytes().then((bytes) {
                                  setState(() {
                                    _pickedFileBytes = bytes;
                                  });
                                });
                              }
                            } catch (error) {
                              logger.info(error);
                            }
                          }
                        ),
                      )
                    ]
                  )
                ],
              ),
             divideLine(20, 38),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(CretaMyPageLang.infoField[1], style: CretaFont.titleMedium),
                      const SizedBox(height: 30),  
                      Text(CretaMyPageLang.infoField[2], style: CretaFont.titleMedium),
                      const SizedBox(height: 30),
                      Text(CretaMyPageLang.infoField[3], style: CretaFont.titleMedium),
                      const SizedBox(height: 30),
                      Text(CretaMyPageLang.infoField[4], style: CretaFont.titleMedium),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("채서윤", style: CretaFont.titleMedium),
                      const SizedBox(height: 30),
                      Text("csy_0102@sqisoft.com", style: CretaFont.bodyMedium),
                      const SizedBox(height: 30),
                      Text("01012345678", style: CretaFont.bodyMedium),
                      const SizedBox(height: 30),
                      BTN.line_blue_t_m(
                        text: "비밀번호 변경", 
                        onPressed: () {
    
                        }
                      )
                    ],
                  ),
                ],
              ),
              divideLine(38, 38),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(CretaMyPageLang.infoField[5], style: CretaFont.titleMedium),
                      const SizedBox(height: 30),  
                      Text(CretaMyPageLang.infoField[6], style: CretaFont.titleMedium),
                      const SizedBox(height: 30),
                      Text(CretaMyPageLang.infoField[7], style: CretaFont.titleMedium),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CretaWidgetDropDown(
                        width: 120,
                        items: countryDropDownItem, 
                        defaultValue: 0, 
                        onSelected: (value) { }
                      ),
                      const SizedBox(height: 13),  
                      CretaWidgetDropDown(
                        width: 120,
                        items: languageDropDownItem, 
                        defaultValue: 0, 
                        onSelected: (value) { }
                      ),
                      const SizedBox(height: 13),  
                      CretaWidgetDropDown(
                        width: 120,
                        items: jobDropDownItem, 
                        defaultValue: 0, 
                        onSelected: (value) { }
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 47),
              BTN.fill_blue_t_el(
                text: "변경사항 저장", 
                onPressed: () async {
                  await firebaseAppStorage!.uploadFile("my_profile.jpg", _pickedFile!.mimeType.toString(), _pickedFileBytes!);
                }
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}