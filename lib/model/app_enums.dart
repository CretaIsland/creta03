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

enum PageTransition {
  none,
  fadeIn,
  fadeOut,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static PageTransition fromInt(int? val) => PageTransition.values[validCheck(val ?? none.index)];
}

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
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static GradationType fromInt(int? val) => GradationType.values[validCheck(val ?? none.index)];
}
