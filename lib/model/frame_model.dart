// ignore_for_file: must_be_immutable

// import 'package:hycop/common/util/util.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../lang/creta_studio_lang.dart';
import 'app_enums.dart';
import 'creta_model.dart';
import 'creta_style_mixin.dart';

// ignore: camel_case_types
class FrameModel extends CretaModel with CretaStyleMixin {
  late UndoAble<String> name;
  late UndoAble<String> bgUrl;
  late UndoAble<double> posX;
  late UndoAble<double> posY;
  late UndoAble<double> angle;
  FrameType frameType = FrameType.none;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        posX,
        posY,
        angle,
        frameType,
        ...super.propsMixin,
      ];
  FrameModel(String pmid) : super(pmid: pmid, type: ExModelType.frame, parent: '') {
    name = UndoAble<String>('', mid);
    bgUrl = UndoAble<String>('', mid);
    posX = UndoAble<double>(0, mid);
    posY = UndoAble<double>(0, mid);
    angle = UndoAble<double>(0, mid);
    frameType = FrameType.none;
    super.initMixin(mid);
  }

  FrameModel.makeSample(double porder, String pid, {FrameType pType = FrameType.none})
      : super(pmid: '', type: ExModelType.frame, parent: pid) {
    super.makeSampleMixin(mid);
    order = UndoAble<double>(porder, mid);
    name = UndoAble<String>('${CretaStudioLang.noNameframe} ${order.value.toString()}', mid);
    bgUrl = UndoAble<String>('', mid);
    posX = UndoAble<double>(100, mid);
    posY = UndoAble<double>(100, mid);
    angle = UndoAble<double>(0, mid);
    width = UndoAble<double>(200, mid);
    height = UndoAble<double>(200, mid);
    frameType = pType;
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    FrameModel srcFrame = src as FrameModel;
    name = UndoAble<String>(srcFrame.name.value, mid);
    bgUrl = UndoAble<String>(srcFrame.bgUrl.value, mid);
    posX = UndoAble<double>(srcFrame.posX.value, mid);
    posY = UndoAble<double>(srcFrame.posY.value, mid);
    angle = UndoAble<double>(srcFrame.angle.value, mid);
    frameType = srcFrame.frameType;
    super.copyFromMixin(mid, srcFrame);
    logger.finest('FrameCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    bgUrl.set(map["bgUrl"] ?? '', save: false, noUndo: true);

    double x = map["posX"] ?? 0;
    double y = map["posY"] ?? 0;

    posX.set(x < 0 ? 0 : x, save: false, noUndo: true);
    posY.set(y < 0 ? 0 : y, save: false, noUndo: true);

    angle.set((map["angle"] ?? 0), save: false, noUndo: true);
    frameType = FrameType.fromInt(map["frameType"] ?? 0);
    super.fromMapMixin(map);
    logger.finest('${posX.value}, ${posY.value}');
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "bgUrl": bgUrl.value,
        "posX": posX.value,
        "posY": posY.value,
        "angle": angle.value,
        'frameType': frameType.index,
        ...super.toMapMixin(),
      }.entries);
  }
}
