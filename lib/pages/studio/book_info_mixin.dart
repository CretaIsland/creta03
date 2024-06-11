import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/text_field/creta_text_field.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'studio_snippet.dart';

mixin BookInfoMixin {
  double horizontalPadding = 19;

  //List<String> hashTagList = [];
  late TextStyle titleStyle;
  late TextStyle dataStyle;

  List<Widget> bookTitle(
      {required BookModel? model,
      required void Function(String) onEditComplete,
      bool alwaysEdit = false}) {
    if (model == null) {
      return [Container()];
    }
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaLang['cretaBookName']!, style: CretaFont.titleSmall),
      ),
      StudioSnippet.showTitleText(
        alwaysEditable: alwaysEdit,
        title: model.name.value,
        onEditComplete: (value) {
          model.name.set(value);
          onEditComplete.call(value);
        },
      ),
    ];
  }

  List<Widget> description(
      {required BookModel? model, required void Function(String) onEditComplete}) {
    if (model == null) {
      return [Container()];
    }
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaStudioLang['description']!, style: CretaFont.titleSmall),
      ),
      CretaTextField.long(
        width: 393,
        maxLines: 10,
        radius: 12,
        hintText: '',
        textFieldKey: GlobalKey(),
        keyboardType: TextInputType.multiline,
        onEditComplete: (String value) {
          model.description.set(value);
          onEditComplete.call(value);
        },
        value: model.description.value,
      ),
    ];
  }

  // List<Widget> hashTag({
  //   required AbsExModel model,
  //   required double minTextFieldWidth,
  //   required void Function(String) onTagChanged,
  //   required void Function(String) onSubmitted,
  //   required void Function(int) onDeleted,
  //   double top = 24,
  // }) {
  //   logger.fine('...hashTagList=$hashTagList');
  //   return [
  //     Padding(
  //       padding: EdgeInsets.only(top: top, bottom: 12),
  //       child: Text(CretaStudioLang['hashTab']!, style: CretaFont.titleSmall),
  //     ),
  //     TagEditor(
  //       textFieldHeight: 36,
  //       minTextFieldWidth: minTextFieldWidth,
  //       tagSpacing: 0,
  //       textStyle: CretaFont.buttonMedium,
  //       length: hashTagList.length,
  //       delimiters: const [',', ' '],
  //       hasAddButton: true,
  //       resetTextOnSubmitted: true,
  //       inputDecoration: InputDecoration(
  //         iconColor: CretaColor.text[200]!,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(30),
  //           borderSide: BorderSide(
  //             width: 1,
  //             color: CretaColor.text[200]!,
  //           ),
  //         ),
  //         //hintText: '당신의 크레타북에 적절한 검섹어 태그를 붙이세요',
  //       ),
  //       inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
  //       onTagChanged: (newValue) {
  //         hashTagList.add(newValue);
  //         String val = CretaCommonUtils.listToString(hashTagList);
  //         logger.finest('hashTag=$val');
  //         model.hashTag.set(val);
  //         onTagChanged.call(newValue);
  //         logger.finest('onTagChanged $newValue input');
  //       },
  //       onSubmitted: (outstandingValue) {
  //         hashTagList.add(outstandingValue);
  //         String val = CretaCommonUtils.listToString(hashTagList);
  //         logger.finest('hashTag=$val');
  //         model.hashTag.set(val);
  //         logger.finest('onSubmitted $outstandingValue input');
  //         onSubmitted.call(outstandingValue);
  //       },
  //       tagBuilder: (context, index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(
  //             right: 4,
  //             bottom: 4,
  //           ),
  //           child: CretaChip(
  //             index: index,
  //             label: hashTagList[index],
  //             onDeleted: (idx) {
  //               hashTagList.removeAt(index);
  //               String val = CretaCommonUtils.listToString(hashTagList);
  //               model.hashTag.set(val);
  //               logger.finest('onDelete $index');
  //               onDeleted.call(idx);
  //             },
  //           ),
  //         );
  //       },
  //     )
  //   ];
  // }

  Widget copyRight(BookModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang['copyRight']!, style: CretaFont.titleSmall),
          model.creator == AccountManager.currentLoginUser.email
              ? CretaDropDownButton(
                  selectedColor: CretaColor.text[700]!,
                  textStyle: CretaFont.bodyESmall,
                  width: 225,
                  height: 28,
                  itemHeight: 24,
                  dropDownMenuItemList: StudioSnippet.getCopyRightListItem(
                      defaultValue: model.copyRight.value,
                      onChanged: (val) {
                        model.copyRight.set(val);
                      }))
              : Text(CretaStudioLang['copyWrightList']![model.copyRight.value.index],
                  style: dataStyle),
        ],
      ),
    );
  }
}
