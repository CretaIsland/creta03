import 'package:creta_common/common/creta_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/model/file_model.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../data_io/contents_manager.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/uploading_popup.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../login/creta_account_manager.dart';
import 'studio_constant.dart';
import 'studio_variables.dart';

enum ShadowDirection {
  rightBottum,
  leftTop,
  rightTop,
  leftBottom,
}

class StudioSnippet {
  static List<BoxShadow> basicShadow(
      {ShadowDirection direction = ShadowDirection.rightBottum,
      double offset = 4,
      Color color = Colors.grey,
      double opacity = 0.2}) {
    Offset value = Offset.zero;

    switch (direction) {
      case ShadowDirection.rightBottum:
        value = Offset(offset, offset);
        break;
      case ShadowDirection.leftTop:
        value = Offset(-offset, -offset);
        break;
      case ShadowDirection.rightTop:
        value = Offset(-offset, offset);
        break;
      case ShadowDirection.leftBottom:
        value = Offset(offset, -offset);
        break;
    }

    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: value,
      )
    ];
  }

  static fullShadow({double offset = 4, Color color = Colors.grey, double opacity = 0.2}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(offset, offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(-offset, -offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(offset, -offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(-offset, offset),
      )
    ];
  }

  static Widget rotateWidget({required Widget child, int turns = 2}) {
    return RotatedBox(quarterTurns: turns, child: child);
  }

  static Gradient? gradient(GradationType currentType, Color color1, Color color2) {
    if (currentType == GradationType.none) {
      return null;
    }
    if (currentType == GradationType.in2out) {
      return RadialGradient(colors: [color1, color2]);
    }
    if (currentType == GradationType.out2in) {
      return RadialGradient(colors: [color2, color1]);
    }
    if (currentType == GradationType.topAndBottom) {
      return LinearGradient(
          begin: beginAlignment(currentType),
          end: endAlignment(currentType),
          colors: [color1, color2, color2, color1]);
    }
    if (currentType == GradationType.middle) {
      return LinearGradient(
          begin: beginAlignment(currentType),
          end: endAlignment(currentType),
          colors: [color2, color1, color1, color2]);
    }
    return LinearGradient(
        begin: beginAlignment(currentType),
        end: endAlignment(currentType),
        colors: [color1, color2]);
  }

  static Alignment beginAlignment(GradationType currentType) {
    switch (currentType) {
      case GradationType.top2bottom:
        return Alignment.topCenter;
      case GradationType.bottom2top:
        return Alignment.bottomCenter;
      case GradationType.left2right:
        return Alignment.centerLeft;
      case GradationType.right2left:
        return Alignment.centerRight;
      case GradationType.leftTop2rightBottom:
        return Alignment.topLeft;
      case GradationType.leftBottom2rightTop:
        return Alignment.bottomLeft;
      case GradationType.rightBottom2leftTop:
        return Alignment.bottomRight;
      case GradationType.rightTop2leftBottom:
        return Alignment.topRight;
      default:
        return Alignment.topCenter;
    }
  }

  static Alignment endAlignment(GradationType currentType) {
    switch (currentType) {
      case GradationType.top2bottom:
        return Alignment.bottomCenter;
      case GradationType.bottom2top:
        return Alignment.topCenter;
      case GradationType.left2right:
        return Alignment.centerRight;
      case GradationType.right2left:
        return Alignment.centerLeft;
      case GradationType.leftTop2rightBottom:
        return Alignment.bottomRight;
      case GradationType.leftBottom2rightTop:
        return Alignment.topRight;
      case GradationType.rightBottom2leftTop:
        return Alignment.topLeft;
      case GradationType.rightTop2leftBottom:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomCenter;
    }
  }

  static Future<void> uploadFile(
    ContentsModel model,
    ContentsManager contentsManager,
    Uint8List blob,
    //{required void Function(ContentsModel model) onUploaded,}
  ) async {
    // 파일명을 확장자와 파일명으로 분리함.
    int pos = model.file!.name.lastIndexOf('.');
    String name = '';
    String ext = '';
    if (pos > 0) {
      name = model.file!.name.substring(0, pos);
      ext = model.file!.name.substring(pos);
    } else if (pos == 0) {
      name = '';
      ext = model.file!.name;
    } else {
      name = model.file!.name;
      ext = '';
    }

    //String initUrl = model.url;
    String uniqFileName = '${name}_${model.bytes}$ext';

    UploadingPopup.uploadStart(model.name);
    await Future.delayed(const Duration(milliseconds: 200)); //  upload 중 다이얼로그가 화면에 나올 수 있도록
    FileModel? fileModel = await HycopFactory.storage!.uploadFile(uniqFileName, model.mime, blob);

    if (fileModel != null) {
      //// modelList 가 그사이 갱신되었을 수가 있기 때문에, 다시 가져온다.
      //ContentsModel? reModel = contentsManager.getModel(model.mid) as ContentsModel?;
      //reModel ??= model;
      // reModel.remoteUrl = fileModel.fileView;
      // reModel.thumbnail = fileModel.thumbnailUrl;
      // reModel.url = initUrl;
      // logger.fine('uploaded url = ${reModel.url}');
      // logger.fine('uploaded fileName = ${reModel.name}');
      // logger.fine('uploaded remoteUrl = ${reModel.remoteUrl!}');
      // logger.fine('uploaded aspectRatio = ${reModel.aspectRatio.value}');
      //model.save(); //<-- save 는 지연되므로 setToDB 를 바로 호출하는 것이 바람직하다.
      //await contentsManager.setToDB(reModel);

      model.remoteUrl = fileModel.url;
      model.thumbnailUrl = fileModel.thumbnailUrl;

      logger.info('uploaded url = ${model.url}');
      logger.info('uploaded fileName = ${model.name}');
      logger.info('uploaded remoteUrl = ${model.remoteUrl!}');
      logger.info('uploaded aspectRatio = ${model.aspectRatio.value}');
      //model.save(); //<-- save 는 지연되므로 setToDB 를 바로 호출하는 것이 바람직하다.
      await contentsManager.setToDB(model);
    } else {
      logger.severe('upload failed ${model.file!.name}');
    }
    logger.info('send event to property');
    logger.info('uploaded thumbnailUrl = ${model.thumbnailUrl}');
    UploadingPopup.uploadEnd(model.name);
    //print('uploading end -----------------------------------------------------------------');
    contentsManager.printIt();

    // skpark 이상한 버그가 있다.  modelist 에 같은놈이 있다.
    // 이는 CretaBook 을 신규로 만들고, 콘텐츠를 업로드하는 경우에만 발생한다.
    // 어쩔 수 없이 임시로 같은놈에게도 같은 값을 할당해 준다.
    // 나중에 같은 놈이 생기지 않도록 수정해야 한다.
    for (var ele in contentsManager.modelList) {
      ContentsModel founded = ele as ContentsModel;
      if (founded.mid == model.mid) {
        founded.remoteUrl = model.remoteUrl;
        founded.thumbnailUrl = model.thumbnailUrl;
        contentsManager.sendEvent?.sendEvent(founded);
      }
    }
    contentsManager.printIt();
  }

  static List<CretaMenuItem> getCopyRightListItem(
      {required CopyRightType defaultValue, required void Function(CopyRightType) onChanged}) {
    return [
      CretaMenuItem(
          caption: CretaStudioLang['copyWrightList']![1],
          onPressed: () {
            onChanged(CopyRightType.free);
          },
          selected: defaultValue == CopyRightType.free),
      CretaMenuItem(
          caption: CretaStudioLang['copyWrightList']![2],
          onPressed: () {
            onChanged(CopyRightType.nonComertialsUseOnly);
          },
          selected: defaultValue == CopyRightType.nonComertialsUseOnly),
      CretaMenuItem(
          caption: CretaStudioLang['copyWrightList']![3],
          onPressed: () {
            onChanged(CopyRightType.openSource);
          },
          selected: defaultValue == CopyRightType.openSource),
      CretaMenuItem(
          caption: CretaStudioLang['copyWrightList']![4],
          onPressed: () {
            onChanged(CopyRightType.needPermition);
          },
          selected: defaultValue == CopyRightType.needPermition),
    ];
  }

  static List<CretaMenuItem> getPermitionListItem(
      {required PermissionType defaultValue, required void Function(PermissionType) onChanged}) {
    return [
      CretaMenuItem(
          caption: CretaLang['basicBookPermissionFilter']![1],
          onPressed: () {
            onChanged(PermissionType.owner);
          },
          selected: defaultValue == PermissionType.owner),
      CretaMenuItem(
          caption: CretaLang['basicBookPermissionFilter']![2],
          onPressed: () {
            onChanged(PermissionType.writer);
          },
          selected: defaultValue == PermissionType.writer),
      CretaMenuItem(
          caption: CretaLang['basicBookPermissionFilter']![3],
          onPressed: () {
            onChanged(PermissionType.reader);
          },
          selected: defaultValue == PermissionType.reader),
    ];
  }

  static List<CretaMenuItem> getPublishPermitionListItem(
      {required PermissionType defaultValue, required void Function(PermissionType) onChanged}) {
    return [
      CretaMenuItem(
          caption: CretaLang['publishBookPermissionFilter']![0],
          onPressed: () {
            onChanged(PermissionType.reader);
          },
          selected: defaultValue == PermissionType.reader),
      CretaMenuItem(
          caption: CretaLang['publishBookPermissionFilter']![1],
          onPressed: () {
            onChanged(PermissionType.writer);
          },
          selected: defaultValue == PermissionType.writer),
    ];
  }

  static List<CretaMenuItem> getFontListItem(
      {required String defaultValue, required void Function(String) onChanged}) {
    //print('fontStringList=${CretaLang['fontStringList']!}');
    return [
      ...CretaLang['fontStringList']!.map(
        (fontStr) {
          //print('fontStr=$fontStr');
          String font = CretaCommonUtils.getFontFamily(fontStr);
          //print('font=$font');
          return CretaMenuItem(
              caption: fontStr,
              fontFamily: font,
              onPressed: () {
                onChanged(font);
              },
              selected: defaultValue == font);
        },
      ).toList()
    ];
  }

  static List<CretaMenuItem> getFontWeightListItem({
    required String font,
    required int defaultValue,
    required void Function(int) onChanged,
  }) {
    List<int>? weightList = StudioConst.fontWeightListMap[font];
    weightList ??= [400];

    return weightList.map(
      (weight) {
        String? fontStr = CretaConst.fontWeightInt2Str[weight];
        return CretaMenuItem(
            caption: fontStr!,
            fontFamily: font,
            fontWeight: CretaConst.fontWeight2Type[weight],
            onPressed: () {
              onChanged(weight);
            },
            selected: defaultValue == weight);
      },
    ).toList();
  }

  static Widget showTitleText({
    required String title,
    required void Function(String) onEditComplete,
    double? height,
    double? width,
    bool alwaysEditable = false,
    TextStyle? textStyle,
  }) {
    textStyle ??= CretaFont.titleLarge;
    logger.finest('_showTitletext $title');
    height ??= 32;
    width ??= StudioVariables.displayWidth * 0.25;

    return CretaLabelTextEditor(
      textFieldKey: GlobalKey<CretaLabelTextEditorState>(),
      alwaysEditable: alwaysEditable,
      height: height,
      width: width,
      text: title,
      maxLine: 2,
      textStyle: textStyle,
      align: TextAlign.center,
      onEditComplete: onEditComplete,
      onLabelHovered: () {},
    );
  }

  static Divider smallDivider(
      {double height = 4, thickness = 1, double indent = 24, double endIndent = 24}) {
    return Divider(
      height: height,
      thickness: thickness,
      color: CretaColor.text[200]!,
      indent: indent,
      endIndent: endIndent,
    );
  }

  static double getMenuBarHeight() {
    if (CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language ==
        LanguageType.japanese) {
      return LayoutConst.innerMenuBarHeight * 2;
    }
    if (CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language ==
        LanguageType.english) {
      return LayoutConst.innerMenuBarHeight * 2;
    }
    return LayoutConst.innerMenuBarHeight;
  }
}
