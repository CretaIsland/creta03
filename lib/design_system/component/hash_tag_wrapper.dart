import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../../common/creta_utils.dart';
import '../../lang/creta_studio_lang.dart';
import '../creta_chip.dart';
import '../creta_color.dart';
import '../creta_font.dart';
import '../text_field/creta_text_field.dart';

class HashTagWrapper {
  HashTagWrapper();

  List<String> hashTagList = [];

  List<Widget> hashTag({
    required AbsExModel model,
    required double minTextFieldWidth,
    required void Function(String) onTagChanged,
    required void Function(String) onSubmitted,
    required void Function(int) onDeleted,
    bool hasTitle = true,
    double top = 24,
  }) {
    hashTagList = CretaUtils.jsonStringToList(model.hashTag.value);
    logger.fine('...hashTagList=$hashTagList');

    GlobalObjectKey key = GlobalObjectKey('hashTagTagEditor${model.mid}');
    FocusNode focusNode = FocusNode();
    //print('add focusNode hashTag');
    //CretaTextField.focusNodeMap[key] = focusNode;

    return [
      Padding(
        padding: EdgeInsets.only(top: top, bottom: 12),
        child: hasTitle
            ? Text(CretaStudioLang.hashTab, style: CretaFont.titleSmall)
            : const SizedBox.shrink(),
      ),
      TagEditor(
        key: key,
        focusNode: focusNode,
        textFieldHeight: 36,
        minTextFieldWidth: minTextFieldWidth,
        tagSpacing: 0,
        textStyle: CretaFont.buttonMedium,
        length: hashTagList.length,
        delimiters: const [',', ' '],
        hasAddButton: true,
        resetTextOnSubmitted: true,
        inputDecoration: InputDecoration(
          iconColor: CretaColor.text[200]!,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 1,
              color: CretaColor.text[200]!,
            ),
          ),
          //hintText: '당신의 크레타북에 적절한 검섹어 태그를 붙이세요',
        ),
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
        onTagChanged: (newValue) {
          hashTagList.add(newValue);
          String val = CretaUtils.listToString(hashTagList);
          logger.finest('hashTag=$val');
          model.hashTag.set(val);
          onTagChanged.call(newValue);
          logger.finest('onTagChanged $newValue input');
        },
        onSubmitted: (outstandingValue) {
          hashTagList.add(outstandingValue);
          String val = CretaUtils.listToString(hashTagList);
          logger.finest('hashTag=$val');
          model.hashTag.set(val);
          logger.finest('onSubmitted $outstandingValue input');
          onSubmitted.call(outstandingValue);
        },
        tagBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 4,
              bottom: 4,
            ),
            child: CretaChip(
              index: index,
              label: hashTagList[index],
              onDeleted: (idx) {
                hashTagList.removeAt(index);
                String val = CretaUtils.listToString(hashTagList);
                model.hashTag.set(val);
                logger.finest('onDelete $index');
                onDeleted.call(idx);
              },
            ),
          );
        },
        disposer: () {
          logger.info('disposer called');
          CretaTextField.mainFocusNode?.requestFocus();
        },
      )
    ];
  }
}
