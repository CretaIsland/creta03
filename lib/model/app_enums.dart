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

enum BookType {
  none,
  presentaion,
  signage,
  board,
  end;

  static int validCheck(int val) => (val > end.index || val < none.index) ? none.index : val;
  static BookType fromInt(int? val) => BookType.values[validCheck(val ?? none.index)];
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
