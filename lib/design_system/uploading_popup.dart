import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:creta_common/lang/creta_lang.dart';
import '../pages/studio/studio_snippet.dart';
import 'creta_color.dart';
import 'creta_font.dart';

class UploadingPopup extends StatefulWidget {
  static Set<String> fileSet = {};
  static int _targetCount = 0;

  static GlobalObjectKey<UploadingPopupState> uploadPopupKey =
      const GlobalObjectKey<UploadingPopupState>('UploadingPopup');

  static void setUploadFileCount(int count) {
    _targetCount = count;
  }

  static void uploadStart(String filename) {
    if (fileSet.isEmpty) {
      _targetCount = 0;
    }
    _targetCount++;
    fileSet.add(filename);
    uploadPopupKey.currentState?.invalidate(true);
  }

  static void uploadEnd(String filename) {
    fileSet.remove(filename);
    if (fileSet.isEmpty) {
      _targetCount = 0;
    }
    uploadPopupKey.currentState?.invalidate(false);
  }

  const UploadingPopup({super.key});

  @override
  State<UploadingPopup> createState() => UploadingPopupState();
}

class UploadingPopupState extends State<UploadingPopup> {
  bool _isShow = false;
  void invalidate(bool isShow) {
    setState(() {
      _isShow = isShow;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isShow,
      child: Positioned(
        bottom: 20,
        right: 20,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: StudioSnippet.fullShadow(offset: 6, color: CretaColor.primary),
            borderRadius: BorderRadius.circular(16.4),
          ),
          height: 40,
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LoadingAnimationWidget.inkDrop(
                color: CretaColor.primary,
                size: 20,
              ),
              Text(
                  '${CretaLang.uploading}  ${UploadingPopup.fileSet.length}/${UploadingPopup._targetCount}',
                  style: CretaFont.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
