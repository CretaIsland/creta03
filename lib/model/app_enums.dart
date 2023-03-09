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

enum CopyWrightType {
  none,
  free,
  nonComertialsUseOnly,
  openSource,
  needPermition,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static CopyWrightType fromInt(int? val) => CopyWrightType.values[validCheck(val ?? none.index)];
}

enum BookSort {
  none,
  name,
  updateTime,
  likeCount,
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

enum BorderPositionType {
  none,
  outSide,
  inSide,
  center,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BorderPositionType fromInt(int? val) =>
      BorderPositionType.values[validCheck(val ?? none.index)];
}
