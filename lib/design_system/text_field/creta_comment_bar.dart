// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/community_sample_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';
//import 'package:hycop/hycop.dart';
//import 'package:flutter/material.dart';
//import 'package:outline_search_bar/outline_search_bar.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';

class CretaCommentBar extends StatefulWidget {
  final double? width;
  //final double height;
  final Widget? thumb;
  final CretaCommentData data;
  final void Function(String value) onAddComment;
  final String hintText;
  final bool showEditButton;
  final void Function(CretaCommentData data)? onAddReply;
  final void Function(CretaCommentData data)? onShowReplyList;
  final bool editModeOnly;

  const CretaCommentBar({
    super.key,
    required this.data,
    required this.onAddComment,
    required this.hintText,
    this.width,
    this.thumb,
    //this.height = 56,
    this.showEditButton = false,
    this.onAddReply,
    this.onShowReplyList,
    this.editModeOnly = false,
  });

  @override
  State<CretaCommentBar> createState() => _CretaCommentBarState();
}

class _CretaCommentBarState extends State<CretaCommentBar> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  String _searchValue = '';
  //bool _hover = false;
  bool _clicked = false;
  //late bool _showEditButton;
  bool _showMoreButton = true;
  late bool _isEditMode;

  //static int colorCount = 0;
  //late int _colorCount;

  @override
  void initState() {
    //_colorCount = colorCount++;
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      if (_focusNode!.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    _controller.text = widget.data.comment;
    //_showEditButton = widget.showEditButton;
    _isEditMode = widget.editModeOnly;
    super.initState();
  }

  Widget _getProfileImage() {
    if (widget.thumb == null) {
      return Container();
    }
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: BoxDecoration(
        // crop
        borderRadius: BorderRadius.circular(20),
        color: Colors.yellow,
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.thumb,
    );
  }

  Widget _getTextFieldWidget(double textWidth, int line) {
    return Expanded(
      child: CupertinoTextField(
        inputFormatters: [
          //LengthLimitingTextInputFormatter(10),
          TextInputFormatter.withFunction((oldValue, newValue) {
            int newLines = newValue.text.split('\n').length;
            if (newLines > 10) {
              return oldValue;
            } else {
              return newValue;
            }
          }),
        ],
        maxLength: 500,
        minLines: 1,
        maxLines: 10,
        keyboardType: TextInputType.multiline,
        focusNode: _focusNode,
        //padding: EdgeInsetsDirectional.fromSTEB(18, top, end, bottom)
        enabled: true,
        autofocus: true,
        decoration: BoxDecoration(
          color: CretaColor.text[100]!, //_clicked
          // ? Colors.white
          // : _hover
          //     ? CretaColor.text[200]!
          //     : CretaColor.text[100]!,
          border: null, //_clicked ? Border.all(color: CretaColor.primary) : null,
          borderRadius: BorderRadius.circular(24),
        ),
        //padding: EdgeInsetsDirectional.all(0),
        controller: _controller,
        placeholder: _clicked ? null : widget.hintText,
        placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
        // prefixInsets: EdgeInsetsDirectional.only(start: 18),
        // prefixIcon: Container(),
        style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
        // suffixInsets: EdgeInsetsDirectional.only(end: 18),
        // suffixIcon: Icon(CupertinoIcons.search),
        suffixMode: OverlayVisibilityMode.always,
        onChanged: (value) {
          _searchValue = value;
          // int line = _searchValue.split('\n').length - 1;
          // if (line != lineCount) {
          //   setState(() {
          //     lineCount = line;
          //   });
          // }
        },
        onSubmitted: ((value) {
          _searchValue = value;
          if (kDebugMode) print('onSubmitted=$_searchValue');
          //logger.info('search $_searchValue');
          //widget.onSearch(_searchValue);
        }),
        onTapOutside: (event) {
          //logger.fine('onTapOutside($_searchValue)');
        },
        // onSuffixTap: () {
        //   _searchValue = _controller.text;
        //   logger.finest('search $_searchValue');
        //   widget.onSearch(_searchValue);
        // },
        onTap: () {
          setState(() {
            _clicked = true;
          });
        },
      ),
    );
  }

  Widget _getTextWidget(double textWidth, int line) {
    return SizedBox(
      width: textWidth,
      //color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name & date & edit-button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.data.name,
                style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 11),
              Text(
                '하루 전',
                style: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]),
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(child: Container()),
              BTN.fill_gray_t_es(
                text: '수정하기',
                onPressed: () {
                  setState(() {
                    _isEditMode = true;
                    _controller.text = widget.data.comment;
                  });
                },
                width: 61,
                buttonColor: CretaButtonColor.gray100light,
              ),
              SizedBox(width: 8),
              BTN.fill_gray_t_es(
                text: '삭제하기',
                onPressed: () {},
                width: 61,
                buttonColor: CretaButtonColor.gray100light,
              ),
            ],
          ),
          // spacing
          SizedBox(height: 1),
          // comment
          (line <= 3 || _showMoreButton == false)
              ? Text(
                  widget.data.comment,
                  style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                  overflow: TextOverflow.visible,
                  maxLines: 100,
                )
              : SizedBox(
                  height: 19 * 2,
                  child: Text(
                    widget.data.comment,
                    style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                    overflow: TextOverflow.fade,
                    maxLines: 100,
                  ),
                ),
          // show more button
          (line <= 3 || _showMoreButton == false)
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: BTN.fill_gray_t_es(
                    text: '자세히 보기',
                    onPressed: () {
                      setState(() {
                        _showMoreButton = false;
                      });
                    },
                    width: 81,
                    buttonColor: CretaButtonColor.gray100light,
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double textWidth =
        (widget.thumb != null) ? widget.width! - 16 - 16 - 40 - 8 : widget.width! - 16 - 16;

    final span = TextSpan(text: widget.data.comment, style: CretaFont.bodyMedium);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: textWidth);
    final line = tp.computeLineMetrics().length;

    return MouseRegion(
        onExit: (val) {
          setState(() {
            //_hover = false;
            //_clicked = false;
          });
        },
        onEnter: (val) {
          setState(() {
            //_hover = true;
          });
        },
        child: Column(
          children: [
            // profile & text(field)
            Container(
              width: widget.width,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                // crop
                borderRadius: BorderRadius.circular(30),
                color: _isEditMode ? CretaColor.text[100] : null, //CretaColor.text[300],
              ),
              clipBehavior: Clip.hardEdge, //Clip.antiAlias,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // profile image
                  _getProfileImage(),
                  // text or textfield
                  (!_isEditMode)
                      ? _getTextWidget(textWidth, line)
                      : _getTextFieldWidget(textWidth, line),
                  // button
                  (!_isEditMode)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: BTN.fill_blue_t_m(
                            text: widget.editModeOnly ? '댓글 등록' : '댓글 수정',
                            width: 81,
                            onPressed: () {
                              setState(() {
                                if (!widget.editModeOnly) _isEditMode = false;
                                widget.data.comment = _controller.text;
                              });
                              widget.onAddComment.call(_controller.text);
                            },
                          ),
                        ),
                  (!_isEditMode || widget.editModeOnly)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: BTN.fill_blue_t_m(
                            text: '취소',
                            width: 81,
                            onPressed: () {
                              setState(() {
                                _isEditMode = false;
                                _controller.text = widget.data.comment;
                              });
                            },
                          ),
                        ),
                ],
              ),
            ),
            // buttons (add-reply, show-reply)
            (widget.onAddReply == null && widget.onShowReplyList == null)
                ? Container(height: 10)
                : Container(
                    padding: EdgeInsets.fromLTRB(64, 8, 0, 8),
                    child: Row(
                      children: [
                        (widget.onAddReply == null)
                            ? Container()
                            : Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: BTN.fill_gray_t_es(
                                  text: '답글달기',
                                  width: 61,
                                  buttonColor: CretaButtonColor.gray100light,
                                  onPressed: () {
                                    widget.onAddReply?.call(widget.data);
                                  },
                                ),
                              ),
                        (widget.onShowReplyList == null)
                            ? Container()
                            : BTN.fill_gray_t_es(
                                text: '답글 ${widget.data.replyList!.length}개',
                                width: null,
                                buttonColor: CretaButtonColor.gray100blue,
                                textColor: CretaColor.primary[400],
                                onPressed: () {
                                  widget.onShowReplyList?.call(widget.data);
                                },
                                tailIconData: widget.data.showReplyList
                                    ? Icons.arrow_drop_up_outlined
                                    : Icons.arrow_drop_down_outlined,
                                sidePaddingSize: 8,
                              ),
                      ],
                    ),
                  ),
          ],
        ));
    // child: Container(
    //   height: 56,
    //   width: widget.width,
    //   child: Expanded(
    //     child: CupertinoSearchTextField(
    //       focusNode: _focusNode,
    //       enabled: true,
    //       autofocus: true,
    //       decoration: BoxDecoration(
    //         color: CretaColor.text[200]!,//_clicked
    //             // ? Colors.white
    //             // : _hover
    //             // ? CretaColor.text[200]!
    //             // : CretaColor.text[100]!,
    //         border: null,//_clicked ? Border.all(color: CretaColor.primary) : null,
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //       //padding: EdgeInsetsDirectional.all(0),
    //       padding: EdgeInsetsDirectional.fromSTEB(8, 9, 0, 8),
    //       controller: _controller,
    //       placeholder: _clicked ? null : widget.hintText,
    //       placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
    //       prefixInsets: EdgeInsetsDirectional.only(start: 16),
    //       prefixIcon: Container(
    //         width: 40,
    //         height: 40,
    //         decoration: BoxDecoration(
    //           // crop
    //           borderRadius: BorderRadius.circular(20),
    //           color: Colors.yellow,
    //         ),
    //         clipBehavior: Clip.antiAlias,
    //         child: widget.thumb,
    //       ),
    //       style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
    //       suffixInsets: EdgeInsetsDirectional.only(end: 18),
    //       suffixIcon: BTN.fill_blue_t_m(
    //                 text: '댓글 등록',
    //                 width: 81,
    //                 onPressed: () {},
    //               ),
    //       //suffixIcon: Icon(CupertinoIcons.search),
    //       suffixMode: OverlayVisibilityMode.always,
    //       onSubmitted: ((value) {
    //         _searchValue = value;
    //         logger.finest('search $_searchValue');
    //         widget.onSearch(_searchValue);
    //       }),
    //       onSuffixTap: () {
    //         _searchValue = _controller.text;
    //         logger.finest('search $_searchValue');
    //         widget.onSearch(_searchValue);
    //       },
    //       onTap: () {
    //         setState(() {
    //           _clicked = true;
    //         });
    //       },
    //     ),
    //   ),
    // ),
    //
    // child: Container(
    //   //height: 56 - 17 + (lineCount * 17),
    //   width: widget.width,
    //   padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    //   decoration: BoxDecoration(
    //     // crop
    //     borderRadius: BorderRadius.circular(30),
    //     color: CretaColor.text[100],
    //   ),
    //   clipBehavior: Clip.antiAlias,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       // icon
    //       _getProfileImage(),
    //       Expanded(
    //         child: Text(
    //           widget.data.comment,
    //           style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
    //           overflow: TextOverflow.visible,
    //           maxLines: 100,
    //         ),
    //       ),
    //       // SizedBox(
    //       //   //width: widget.width! - 16 - 16 - 40 - 50,
    //       //   child: Column(
    //       //     crossAxisAlignment: CrossAxisAlignment.start,
    //       //     children: [
    //       //       // name
    //       //       Text(
    //       //         widget.data.name,
    //       //         style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
    //       //         overflow: TextOverflow.ellipsis,
    //       //       ),
    //       //       SizedBox(height: 8),
    //       //       // SizedBox(
    //       //       //   width: widget.width! - 16 - 16 - 40 - 8 - 61 - 8 - 61,
    //       //       //   child:
    //       //       // comment
    //       //       Text(
    //       //         widget.data.comment,
    //       //         style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
    //       //         overflow: TextOverflow.visible,
    //       //         maxLines: 100,
    //       //       ),
    //       //       //),
    //       //       //),
    //       //       //Expanded(child: Container()),
    //       //     ],
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // ));

    //
    // (widget.thumb == null)
    //     ? Container()
    //     : Container(
    //         width: 40,
    //         height: 40,
    //         decoration: BoxDecoration(
    //           // crop
    //           borderRadius: BorderRadius.circular(20),
    //           color: Colors.yellow,
    //         ),
    //         clipBehavior: Clip.antiAlias,
    //         child: widget.thumb,
    //       ),
    // (widget.thumb == null) ? SizedBox() : SizedBox(width: 8),
    // // Expanded(
    // //   child: TextField(
    // //     keyboardType: TextInputType.multiline,
    // //     maxLines: null,
    // //     autofocus: true,
    // //     enabled: true,
    // //     focusNode: _focusNode,
    // //     controller: _controller,
    // //     decoration: InputDecoration(
    // //       // color: CretaColor.text[100]!,//_clicked
    // //       //     // ? Colors.white
    // //       //     // : _hover
    // //       //     //     ? CretaColor.text[200]!
    // //       //     //     : CretaColor.text[100]!,
    // //       // border: null,//_clicked ? Border.all(color: CretaColor.primary) : null,
    // //       // borderRadius: BorderRadius.circular(24),
    // //       hintText: _clicked ? null : widget.hintText,
    // //       hintStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
    // //     ),
    // //     onChanged: (value) {
    // //       _searchValue = value;
    // //       int line = _searchValue.split('\n').length - 1;
    // //       if (line != lineCount ) {
    // //         setState(() {
    // //           lineCount = line;
    // //         });
    // //       }
    // //     },
    // //     onSubmitted: ((value) {
    // //       _searchValue = value;
    // //       //print(_searchValue);
    // //       logger.fine('search $_searchValue');
    // //       widget.onSearch(_searchValue);
    // //     }),
    // //     onTapOutside: (event) {
    // //       logger.fine('onTapOutside($_searchValue)');
    // //     },
    // //     onTap: () {
    // //       setState(() {
    // //         _clicked = true;
    // //       });
    // //     },
    // //   ),
    // // ),
    // _showEditButton
    //     ? Expanded(
    //   flex: 9,
    //       child: Row(
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   widget.data.name,
    //                   style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 SizedBox(height: 8),
    //                 // SizedBox(
    //                 //   width: widget.width! - 16 - 16 - 40 - 8 - 61 - 8 - 61,
    //                 //   child:
    //                   Text(
    //                     widget.data.comment,
    //                     style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
    //                     overflow: TextOverflow.visible,
    //                     maxLines: 100,
    //                   ),
    //                 //),
    //               ],
    //             ),
    //             //Expanded(child: Container()),
    //           ],
    //         ),
    //     )
    //     : Expanded(
    //         child: CupertinoTextField(
    //           minLines: 1,
    //           maxLines: null,
    //           keyboardType: TextInputType.multiline,
    //           focusNode: _focusNode,
    //           //padding: EdgeInsetsDirectional.fromSTEB(18, top, end, bottom)
    //           enabled: true,
    //           autofocus: true,
    //           decoration: BoxDecoration(
    //             color: CretaColor.text[100]!, //_clicked
    //             // ? Colors.white
    //             // : _hover
    //             //     ? CretaColor.text[200]!
    //             //     : CretaColor.text[100]!,
    //             border: null, //_clicked ? Border.all(color: CretaColor.primary) : null,
    //             borderRadius: BorderRadius.circular(24),
    //           ),
    //           //padding: EdgeInsetsDirectional.all(0),
    //           controller: _controller,
    //           placeholder: _clicked ? null : widget.hintText,
    //           placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
    //           // prefixInsets: EdgeInsetsDirectional.only(start: 18),
    //           // prefixIcon: Container(),
    //           style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
    //           // suffixInsets: EdgeInsetsDirectional.only(end: 18),
    //           // suffixIcon: Icon(CupertinoIcons.search),
    //           suffixMode: OverlayVisibilityMode.always,
    //           onChanged: (value) {
    //             _searchValue = value;
    //             // int line = _searchValue.split('\n').length - 1;
    //             // if (line != lineCount) {
    //             //   setState(() {
    //             //     lineCount = line;
    //             //   });
    //             // }
    //             final span = TextSpan(
    //                 text: _searchValue, style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!));
    //             final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    //             tp.layout(maxWidth: widget.width! - 16 - 8 - 8 - 16 - 40 - 81);
    //             final line = tp.computeLineMetrics().length;
    //             if (line != lineCount) {
    //               setState(() {
    //                 lineCount = line == 0 ? 1 : line;
    //                 //print('lineCount=$lineCount, widget.width=${widget.width}, width=${widget.width! - 16 - 8 - 8 - 16 - 40 - 81}');
    //               });
    //             }
    //           },
    //           onSubmitted: ((value) {
    //             _searchValue = value;
    //             //print(_searchValue);
    //             logger.fine('search $_searchValue');
    //             widget.onSearch(_searchValue);
    //           }),
    //           onTapOutside: (event) {
    //             logger.fine('onTapOutside($_searchValue)');
    //           },
    //           // onSuffixTap: () {
    //           //   _searchValue = _controller.text;
    //           //   logger.finest('search $_searchValue');
    //           //   widget.onSearch(_searchValue);
    //           // },
    //           onTap: () {
    //             setState(() {
    //               _clicked = true;
    //             });
    //           },
    //         ),
    //       ),
    // Expanded(
    //   flex: 1,
    //   child: Row(
    //     children: [
    //       BTN.fill_gray_t_es(text: '수정하기', onPressed: () {}, width: 61),
    //       SizedBox(width: 8),
    //       BTN.fill_gray_t_es(text: '삭제하기', onPressed: () {}, width: 61),
    //     ],
    //   ),
    // ),
    //
    // SizedBox(width: 8),
    // _showEditButton
    //     ? Container()
    //     : BTN.fill_blue_t_m(
    //         text: '댓글 등록',
    //         width: 81,
    //         onPressed: () {},
    //       ),
    //],
    //),
    //),
    //);
  }
}
