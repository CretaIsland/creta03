import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/model/file_model.dart';

import '../../data_io/contents_manager.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';

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

    String uniqFileName = '${name}_${model.bytes}$ext';

    FileModel? fileModel = await HycopFactory.storage!.uploadFile(uniqFileName, model.mime, blob);

    if (fileModel != null) {
      // modelList 가 그사이 갱신되었을 수가 있기 때문에, 다시 가져온다.
      ContentsModel? reModel = contentsManager.getModel(model.mid) as ContentsModel?;
      reModel ??= model;
      reModel.remoteUrl = fileModel.fileView;
      logger.info('uploaded url = ${reModel.url}');
      logger.info('uploaded fileName = ${reModel.name}');
      logger.info('uploaded remoteUrl = ${reModel.remoteUrl!}');
      logger.info('uploaded aspectRatio = ${reModel.aspectRatio.value}');
      //model.save(); //<-- save 는 지연되므로 setToDB 를 바로 호출하는 것이 바람직하다.
      await contentsManager.setToDB(reModel);
    } else {
      logger.severe('upload failed ${model.file!.name}');
    }
  }
}
