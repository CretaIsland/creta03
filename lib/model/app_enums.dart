//import 'dart:ui';
//
// enum ModelType {
//   none,
//   book,
//   page,
//   frame,
//   contents,
//   end;
//
//   static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
//   static ModelType fromInt(int? val) => ModelType.values[validCheck(val ?? none.index)];
// }

// ignore_for_file: constant_identifier_names

import 'dart:ui';

enum BookType {
  none,
  presentaion,
  signage,
  board,
  etc,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BookType fromInt(int? val) => BookType.values[validCheck(val ?? none.index)];
}

enum FrameType {
  none,
  latest,
  polygon,
  animation,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static FrameType fromInt(int? val) => FrameType.values[validCheck(val ?? none.index)];
}

enum CopyRightType {
  none,
  free,
  nonComertialsUseOnly,
  openSource,
  needPermition,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static CopyRightType fromInt(int? val) => CopyRightType.values[validCheck(val ?? none.index)];
}

enum PermissionType {
  none,
  owner, // 소유자
  editor, // 편집자
  viewer, // 뷰어
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static PermissionType fromInt(int? val) => PermissionType.values[validCheck(val ?? none.index)];
}

enum BookSort {
  none,
  name, // 이름순
  updateTime, // 최신순
  likeCount, // 좋아요순
  viewCount, // 조회수순
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BookSort fromInt(int? val) => BookSort.values[validCheck(val ?? none.index)];
}

// enum PageTransition {
//   none,
//   fadeIn,
//   fadeOut,
//   end;

//   static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
//   static PageTransition fromInt(int? val) => PageTransition.values[validCheck(val ?? none.index)];
// }

enum GradationType {
  none,
  top2bottom,
  bottom2top,
  left2right,
  right2left,
  leftTop2rightBottom,
  leftBottom2rightTop,
  rightBottom2leftTop,
  rightTop2leftBottom,
  in2out,
  out2in,
  topAndBottom,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static GradationType fromInt(int? val) => GradationType.values[validCheck(val ?? none.index)];
}

enum AnimationType {
  none(0),
  fadeIn(1),
  flip(2),
  shake(4),
  shimmer(8),
  end(999999);

  const AnimationType(this.value);
  final int value;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static AnimationType fromInt(int? val) => AnimationType.values[validCheck(val ?? none.index)];
  static List<AnimationType> toAniListFromInt(int val) {
    List<AnimationType> retval = [];
    for (int i = 1; i < end.index; i++) {
      if (val & AnimationType.values[i].value == AnimationType.values[i].value) {
        retval.add(AnimationType.values[i]);
      }
    }
    return retval;
  }
}

enum TextureType {
  none,
  glass,
  marble,
  wood,
  canvas,
  paper,
  hanji,
  leather,
  stone,
  grass,
  sand,
  drops,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static TextureType fromInt(int? val) => TextureType.values[validCheck(val ?? none.index)];
}

enum ImageFilterType {
  none,
  gay,
  warm,
  bright,
  dark,
  cold,
  vintage,
  romantic,
  tranquil,
  soft,
  Pleasant,
  elegant,
  sepia,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static ImageFilterType fromInt(int? val) => ImageFilterType.values[validCheck(val ?? none.index)];
}

enum ContentsFitType {
  none,
  cover,
  fill,
  free,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static ContentsFitType fromInt(int? val) => ContentsFitType.values[validCheck(val ?? none.index)];
}

// enum BorderPositionType {
//   none,
//   outSide,
//   inSide,
//   center,
//   end;

//   static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
//   static BorderPositionType fromInt(int? val) =>
//       BorderPositionType.values[validCheck(val ?? none.index)];
// }

enum BorderCapType {
  none,
  round,
  bevel,
  miter,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BorderCapType fromInt(int? val) => BorderCapType.values[validCheck(val ?? none.index)];
}

enum ShapeType {
  none,
  rectangle,
  circle,
  oval,
  triangle,
  star,
  diamond,
  //rhombus, // 마름모
  //parallelogram, // 평행사변형
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static ShapeType fromInt(int? val) => ShapeType.values[validCheck(val ?? none.index)];
}

enum EffectType {
  none,
  conffeti,
  snow,
  rain,
  bubble,
  star,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static EffectType fromInt(int? val) => EffectType.values[validCheck(val ?? none.index)];
}

enum DurationType {
  none,
  forever,
  untilContentsEnd,
  specified,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static DurationType fromInt(int? val) => DurationType.values[validCheck(val ?? none.index)];
}

// enum ContentsType {
//   none,
//   video,
//   image,
//   text,
//   sheet,
//   youtube,
//   instagram,
//   web,
//   pdf,
//   effect,
//   free,
//   end;

//   static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
//   static ContentsType fromInt(int? val) => ContentsType.values[validCheck(val ?? none.index)];
// }

enum TextAniType {
  none,
  tickerSide,
  tickerUpDown,
  rotate,
  fade,
  fidget,
  typewriter,
  wavy,
  colorize,
  textLiquidFill,
  bounce,
  shimmer,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static TextAniType fromInt(int? val) => TextAniType.values[validCheck(val ?? none.index)];
}

enum TextLineType {
  none,
  underline,
  overline,
  lineThrough,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static TextLineType fromInt(int? val) => TextLineType.values[validCheck(val ?? none.index)];

  static TextDecoration getTextDecoration(TextLineType value) {
    switch (value) {
      case TextLineType.none:
        return TextDecoration.none;
      case TextLineType.underline:
        return TextDecoration.underline;
      case TextLineType.overline:
        return TextDecoration.overline;
      case TextLineType.lineThrough:
        return TextDecoration.lineThrough;
      default:
        return TextDecoration.none;
    }
  }
}

enum PlayState {
  none,
  init,
  start,
  pause,
  stop,
  manualPlay,
  globalPause,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static PlayState fromInt(int? val) => PlayState.values[validCheck(val ?? none.index)];
}

// ==user property enum==
enum CretaGradeType {
  none,
  rookie,
  star,
  celebrity,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static CretaGradeType fromInt(int? val) => CretaGradeType.values[validCheck(val ?? none.index)];
}

enum RatePlanType {
  none,
  free,
  personalPay,
  teamPay,
  enterprise,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static RatePlanType fromInt(int? val) => RatePlanType.values[validCheck(val ?? none.index)];
}

enum CountryType{
  none,
  korea,
  usa,
  japan,
  china,
  vietnam,
  france,
  german,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static CountryType fromInt(int? val) => CountryType.values[validCheck(val ?? none.index)];
}

enum LanguageType {
  none,
  korean,
  english,
  japanese,
  chinese,
  vietnamese,
  french,
  germany,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static LanguageType fromInt(int? val) => LanguageType.values[validCheck(val ?? none.index)];
}

enum JobType {
  none,
  general,
  student,
  teacher,
  designer,
  developer,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static JobType fromInt(int? val) => JobType.values[validCheck(val ?? none.index)];
}

TextAlign intToTextAlign(int t) {
  switch (t) {
    case 0:
      return TextAlign.left;
    case 1:
      return TextAlign.right;
    case 2:
      return TextAlign.center;
    case 3:
      return TextAlign.justify;
    case 4:
      return TextAlign.start;
    case 5:
      return TextAlign.end;
    case 6:
  }
  return TextAlign.center;
}
