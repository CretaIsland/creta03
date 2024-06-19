import 'dart:typed_data';

import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';

class MyPageCommonWidget {
  // 구분선
  static Widget divideLine(
      {required double width, double height = 1, EdgeInsets padding = EdgeInsets.zero}) {
    return Padding(
      padding: padding,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
      ),
    );
  }

  // 프로필 이미지
  static Widget profileImgComponent(
      {required double width,
      required double height,
      String profileImgUrl = "",
      Uint8List? profileImgBytes,
      required String userName,
      Color? replaceColor,
      BorderRadius? borderRadius,
      BoxShadow? boxShadow,
      Widget editBtn = const SizedBox.shrink()}) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: borderRadius,
            color: profileImgUrl.isEmpty && profileImgBytes == null ? replaceColor : null,
            image: profileImgUrl.isNotEmpty && profileImgBytes == null
                ? DecorationImage(image: NetworkImage(profileImgUrl), fit: BoxFit.cover)
                : profileImgBytes != null
                    ? DecorationImage(image: MemoryImage(profileImgBytes), fit: BoxFit.cover)
                    : null),
        child: Stack(
          children: [
            profileImgUrl.isNotEmpty || profileImgBytes != null
                ? const SizedBox.shrink()
                : Center(
                    child: Text(userName.substring(0, 1),
                        style: CretaFont.displayLarge.copyWith(
                            fontSize: 64, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
            editBtn
          ],
        ));
  }

  // 채널 배너 이미지
  static Widget channelBannerImgComponent(
      {
      //required double width,
      double height = 181,
      String bannerImgUrl = "",
      required void Function() onPressed}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
          image: bannerImgUrl.isNotEmpty
              ? DecorationImage(image: NetworkImage(bannerImgUrl), fit: BoxFit.cover)
              : null),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 32),
          child: BTN.opacity_gray_i_s(
              icon: const Icon(Icons.edit_outlined, color: Colors.white).icon!,
              onPressed: onPressed),
        ),
      ),
    );
  }

  // 채널 설명
  static Widget channelDescriptionComponent({
    //required double width,
    double height = 181,
  }) {
    return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: CretaTextField.long(
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            textFieldKey: GlobalKey(),
            value: CretaAccountManager.getChannel!.description,
            hintText: '채널 설명을 입력하세요',
            radius: 20,
            onEditComplete: (value) {
              CretaAccountManager.getChannel!.description = value;
              CretaAccountManager.setChannelDescription(CretaAccountManager.getChannel!);
            }));
  }
}
