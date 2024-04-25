import 'dart:typed_data';
import 'package:creta_common/common/creta_common_utils.dart';

import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:image_picker/image_picker.dart';

import '../../../lang/creta_mypage_lang.dart';

class EditBannerImgPopUp extends StatefulWidget {
  final Uint8List bannerImgBytes;
  final XFile selectedImg;
  const EditBannerImgPopUp({super.key, required this.bannerImgBytes, required this.selectedImg});

  @override
  State<EditBannerImgPopUp> createState() => _EditBannerImgPopUpState();
}

class _EditBannerImgPopUpState extends State<EditBannerImgPopUp> {
  Offset _position = const Offset(0, 20);
  int cropWidth = 0;
  int cropHeight = 0;
  int cropY = 0;
  double targetRatio = 5.0 / 1.0;

  @override
  Widget build(BuildContext context) {
    return CretaDialog(
        width: 897,
        height: 518,
        title: CretaMyPageLang["backgroundImgSetting"], //'배경 이미지 설정',
        content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                  width: 865,
                  height: 375,
                  margin: const EdgeInsets.only(top: 20.0, left: 16.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.memory(widget.bannerImgBytes).image, fit: BoxFit.cover))),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: _position.dy, left: 16.0),
                  child: Container(
                    width: 865,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: CretaColor.primary, width: 1.0),
                    ),
                  ),
                ),
                onPanUpdate: (details) {
                  if (details.localPosition.dy < 200 && details.localPosition.dy > 20) {
                    _position = details.localPosition;
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Container(
              width: 897,
              height: 1,
              color: Colors.grey.shade200,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 826.0),
              child: BTN.fill_blue_t_m(
                  text: CretaMyPageLang["OK"], //'완료',
                  width: 55,
                  onPressed: () {
                    Uint8List cropImgBytes = CretaCommonUtils.cropImage(widget.bannerImgBytes,
                        Offset(0, _position.dy + 20), 5, const Size(865, 375));

                    // 업로드
                    HycopFactory.storage!
                        .uploadFile(
                            widget.selectedImg.name, widget.selectedImg.mimeType!, cropImgBytes,
                            usageType: "banner")
                        .then((fileModel) {
                      if (fileModel != null) {
                        CretaAccountManager.getChannel!.bannerImgUrl = fileModel.url;
                        CretaAccountManager.setChannelBannerImg(CretaAccountManager.getChannel!);
                        Navigator.of(context).pop();
                      }
                    });
                  }))
        ]));
  }
}
