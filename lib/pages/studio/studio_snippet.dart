import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/model/file_model.dart';

import '../../common/creta_utils.dart';
import '../../data_io/contents_manager.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
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

    FileModel? fileModel = await HycopFactory.storage!.uploadFile(uniqFileName, model.mime, blob);

    if (fileModel != null) {
      //// modelList 가 그사이 갱신되었을 수가 있기 때문에, 다시 가져온다.
      //ContentsModel? reModel = contentsManager.getModel(model.mid) as ContentsModel?;
      //reModel ??= model;
      // reModel.remoteUrl = fileModel.fileView;
      // reModel.thumbnail = fileModel.thumbnailUrl;
      // reModel.url = initUrl;
      // logger.info('uploaded url = ${reModel.url}');
      // logger.info('uploaded fileName = ${reModel.name}');
      // logger.info('uploaded remoteUrl = ${reModel.remoteUrl!}');
      // logger.info('uploaded aspectRatio = ${reModel.aspectRatio.value}');
      //model.save(); //<-- save 는 지연되므로 setToDB 를 바로 호출하는 것이 바람직하다.
      //await contentsManager.setToDB(reModel);

      model.remoteUrl = fileModel.fileView;
      model.thumbnail = fileModel.thumbnailUrl;
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
    contentsManager.sendEvent?.sendEvent(model);
  }

  static List<CretaMenuItem> getCopyRightListItem(
      {required CopyRightType defaultValue, required void Function(CopyRightType) onChanged}) {
    return [
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[1],
          onPressed: () {
            onChanged(CopyRightType.free);
          },
          selected: defaultValue == CopyRightType.free),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[2],
          onPressed: () {
            onChanged(CopyRightType.nonComertialsUseOnly);
          },
          selected: defaultValue == CopyRightType.nonComertialsUseOnly),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[3],
          onPressed: () {
            onChanged(CopyRightType.openSource);
          },
          selected: defaultValue == CopyRightType.openSource),
      CretaMenuItem(
          caption: CretaStudioLang.copyWrightList[4],
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
          caption: CretaLang.basicBookPermissionFilter[1],
          onPressed: () {
            onChanged(PermissionType.owner);
          },
          selected: defaultValue == PermissionType.owner),
      CretaMenuItem(
          caption: CretaLang.basicBookPermissionFilter[2],
          onPressed: () {
            onChanged(PermissionType.writer);
          },
          selected: defaultValue == PermissionType.writer),
      CretaMenuItem(
          caption: CretaLang.basicBookPermissionFilter[3],
          onPressed: () {
            onChanged(PermissionType.reader);
          },
          selected: defaultValue == PermissionType.reader),
    ];
  }

  static List<CretaMenuItem> getFontListItem(
      {required String defaultValue, required void Function(String) onChanged}) {
    return CretaLang.fontStringList.map(
      (fontStr) {
        String font = CretaUtils.getFontFamily(fontStr);
        logger.info('font=$font');
        return CretaMenuItem(
            caption: fontStr,
            fontFamily: font,
            onPressed: () {
              onChanged(font);
            },
            selected: defaultValue == font);
      },
    ).toList();
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
        String? fontStr = StudioConst.fontWeightInt2Str[weight];
        return CretaMenuItem(
            caption: fontStr!,
            fontFamily: font,
            fontWeight: StudioConst.fontWeight2Type[weight],
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
  }) {
    logger.finest('_showTitletext $title');
    height ??= 32;
    width ??= StudioVariables.displayWidth * 0.25;

    return CretaLabelTextEditor(
      textFieldKey: GlobalKey<CretaLabelTextEditorState>(),
      alwaysEditable: alwaysEditable,
      height: height,
      width: width,
      text: title,
      textStyle: CretaFont.titleLarge,
      align: TextAlign.center,
      onEditComplete: onEditComplete,
      onLabelHovered: () {},
    );
  }
}
