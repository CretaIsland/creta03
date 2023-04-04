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
  final String hintText;
  final void Function(CretaCommentData)? onClickedAdd; // 댓글등록
  final void Function(CretaCommentData)? onClickedRemove; // 삭제하기 (or 답글취소)
  final void Function(CretaCommentData)? onClickedModify; // 댓글수정 (or 답글등록)
  final void Function(CretaCommentData)? onClickedReply; // 답글달기
  final void Function(CretaCommentData)? onClickedShowReply; // 답글보기
  //final bool showEditButton;
  //final bool editModeOnly;

  const CretaCommentBar({
    super.key,
    this.width,
    this.thumb,
    //this.height = 56,
    required this.data,
    this.hintText = '',
    this.onClickedAdd,
    this.onClickedRemove,
    this.onClickedModify,
    this.onClickedReply,
    this.onClickedShowReply,
    //this.showEditButton = false,
    //this.editModeOnly = true,
  });

  @override
  State<CretaCommentBar> createState() => _CretaCommentBarState();
}

class _CretaCommentBarState extends State<CretaCommentBar> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  String _editingValue = '';
  //bool _hover = false;
  //bool _clicked = false;
  //late bool _showEditButton;
  bool _showMoreButton = true;
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      if (_focusNode!.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
    _editingValue = widget.data.comment;
    _controller.text = widget.data.comment;
    //_showEditButton = widget.showEditButton;
    _isEditMode = (widget.data.barType == CretaCommentBarType.addCommentMode ||
        widget.data.barType == CretaCommentBarType.addReplyMode);
  }

  Widget _getProfileImage() {
    if (widget.thumb == null) {
      return SizedBox.shrink();
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

  Widget _getTextFieldWidget(double textWidth) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 4),
          CupertinoTextField(
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
            autofocus: false,
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
            placeholder: widget.hintText, //_clicked ? null : widget.hintText,
            placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
            // prefixInsets: EdgeInsetsDirectional.only(start: 18),
            // prefixIcon: Container(),
            style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
            // suffixInsets: EdgeInsetsDirectional.only(end: 18),
            // suffixIcon: Icon(CupertinoIcons.search),
            suffixMode: OverlayVisibilityMode.always,
            onChanged: (value) {
              _editingValue = value;
              // int line = _searchValue.split('\n').length - 1;
              // if (line != lineCount) {
              //   setState(() {
              //     lineCount = line;
              //   });
              // }
            },
            onSubmitted: ((value) {
              _editingValue = value;
              if (kDebugMode) print('onSubmitted=$_editingValue');
              //logger.info('search $_searchValue');
              //widget.onSearch(_searchValue);
            }),
            onTapOutside: (event) {
              //logger.fine('onTapOutside($_searchValue)');
              setState(() {
                //_clicked = false;
                _focusNode?.unfocus();
              });
            },
            // onSuffixTap: () {
            //   _searchValue = _controller.text;
            //   logger.finest('search $_searchValue');
            //   widget.onSearch(_searchValue);
            // },
            onTap: () {
              setState(() {
                //_clicked = true;
              });
            },
          ),
        ],
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
                widget.data.nickname,
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
                onPressed: () {
                  setState(() {
                    if (kDebugMode) print('widget.onRemoveComment.call(${widget.data.mid})');
                    widget.onClickedRemove?.call(widget.data);
                  });
                },
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

  Widget _getAddCommentWidget() {
    double textWidth = widget.width! - 16 - 16 - 81 - 8;
    if (widget.thumb != null) textWidth -= (40 + 8);

    return Container(
      width: widget.width,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        // crop
        borderRadius: BorderRadius.circular(30),
        color: CretaColor.text[100],
      ),
      clipBehavior: Clip.hardEdge, //Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile image
          _getProfileImage(),
          // text or textfield
          _getTextFieldWidget(textWidth),
          // button
          Container(
            padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
            child: BTN.fill_blue_t_m(
              text: '댓글 등록',
              width: 81,
              onPressed: () {
                setState(() {
                  widget.data.comment = _controller.text;
                  _controller.text = '';
                });
                widget.onClickedAdd?.call(widget.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getReplyButtonWidget() {
    if (widget.data.barType == CretaCommentBarType.addCommentMode ||
        (widget.data.parentMid.isNotEmpty && widget.data.hasNoReply)) {
      return SizedBox(height: 10);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(64, 8, 0, 8),
      child: Row(
        children: [
          (widget.data.parentMid.isNotEmpty)
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: BTN.fill_gray_t_es(
                    text: '답글달기',
                    width: 61,
                    buttonColor: CretaButtonColor.gray100light,
                    onPressed: () {
                      if (kDebugMode) print('답글달기(${widget.data.nickname})');
                      widget.onClickedReply?.call(widget.data);
                    },
                  ),
                ),
          (widget.data.hasNoReply)
              ? Container()
              : BTN.fill_gray_t_es(
                  text: '답글 ${widget.data.replyList.length}개',
                  width: null,
                  buttonColor: CretaButtonColor.gray100blue,
                  textColor: CretaColor.primary[400],
                  onPressed: () {
                    widget.onClickedShowReply?.call(widget.data);
                  },
                  tailIconData:
                      widget.data.showReplyList ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined,
                  sidePaddingSize: 8,
                ),
        ],
      ),
    );
  }

  Widget _getCommentWidget() {
    double textWidth = widget.width! - 16 - 16;
    if (widget.thumb != null) textWidth -= (40 + 8);

    final span = TextSpan(text: widget.data.comment, style: CretaFont.bodyMedium);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: textWidth);
    final line = tp.computeLineMetrics().length;

    return Column(
      children: [
        // profile & text(field)
        Container(
          width: widget.width,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            // crop
            borderRadius: BorderRadius.circular(30),
            //color: _isEditMode ? CretaColor.text[100] : null, //CretaColor.text[300],
          ),
          clipBehavior: Clip.hardEdge, //Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile image
              _getProfileImage(),
              // text or textfield
              _getTextWidget(textWidth, line),
            ],
          ),
        ),
        // buttons (add-reply, show-reply)
        _getReplyButtonWidget(),
      ],
    );
  }

  Widget _getModifyCommentWidget() {
    double textWidth = widget.width! - 16 - 16 - 81 - 8 - 81 - 8;
    if (widget.thumb != null) textWidth -= (40 + 8);

    return Column(
      children: [
        // profile & text(field)
        Container(
          width: widget.width,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            // crop
            borderRadius: BorderRadius.circular(30),
            color: CretaColor.text[100], //CretaColor.text[300],
          ),
          clipBehavior: Clip.hardEdge, //Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // profile image
              _getProfileImage(),
              // text or textfield
              _getTextFieldWidget(textWidth),
              // button
              Container(
                padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                child: BTN.fill_blue_t_m(
                  text: '댓글 수정',
                  width: 81,
                  onPressed: () {
                    setState(() {
                      widget.data.comment = _controller.text;
                      _isEditMode = false;
                    });
                    widget.onClickedAdd?.call(widget.data);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
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
        _getReplyButtonWidget(),
      ],
    );
  }

  Widget _getAddReplyWidget() {
    double textWidth = widget.width! - 16 - 16 - 81 - 8 - 81 - 8;
    if (widget.thumb != null) textWidth -= (40 + 8);

    return Container(
      width: widget.width,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        // crop
        borderRadius: BorderRadius.circular(30),
        color: CretaColor.text[100], //CretaColor.text[300],
      ),
      clipBehavior: Clip.hardEdge, //Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile image
          _getProfileImage(),
          // text or textfield
          _getTextFieldWidget(textWidth),
          // button
          Container(
            padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
            child: BTN.fill_blue_t_m(
              text: '답글 등록',
              width: 81,
              onPressed: () {
                setState(() {
                  widget.data.barType = CretaCommentBarType.modifyCommentMode;
                  widget.data.comment = _controller.text;
                  _isEditMode = false;
                  widget.onClickedModify?.call(widget.data);
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
            child: BTN.fill_blue_t_m(
              text: '취소',
              width: 81,
              onPressed: () {
                widget.onClickedRemove?.call(widget.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getChildWidget() {
    if (widget.data.barType == CretaCommentBarType.addCommentMode) {
      return _getAddCommentWidget();
    }
    else if (widget.data.barType == CretaCommentBarType.modifyCommentMode) {
      if (_isEditMode) return _getModifyCommentWidget();
    }
    else if (widget.data.barType == CretaCommentBarType.addReplyMode) {
      return _getAddReplyWidget();
    }
    return _getCommentWidget();
  }

  @override
  Widget build(BuildContext context) {
    // double textWidth = (widget.thumb != null) ? widget.width! - 16 - 16 - 40 - 8 : widget.width! - 16 - 16;
    // if (_isEditMode) textWidth -= (81 + 8);
    // if (_isEditMode && widget.data.barType == CretaCommentBarType.modifyCommentMode) textWidth -= (81 + 8);
    //
    // final span = TextSpan(text: widget.data.comment, style: CretaFont.bodyMedium);
    // final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    // tp.layout(maxWidth: textWidth);
    // final line = tp.computeLineMetrics().length;

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
      child: _getChildWidget(),
/*
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile image
                _getProfileImage(),
                // text or textfield
                (!_isEditMode) ? _getTextWidget(textWidth, line) : _getTextFieldWidget(textWidth),
                // button
                (!_isEditMode)
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                        child: BTN.fill_blue_t_m(
                          text: (widget.data.barType != CretaCommentBarType.modifyCommentMode) ? '댓글 등록' : '댓글 수정',
                          width: 81,
                          onPressed: () {
                            setState(() {
                              widget.data.comment = _controller.text;
                              if (widget.data.barType != CretaCommentBarType.addCommentMode) {
                                _isEditMode = false;
                              } else {
                                _controller.text = '';
                              }
                            });
                            widget.onClickedAdd?.call(widget.data);
                          },
                        ),
                      ),
                (!_isEditMode || widget.data.barType == CretaCommentBarType.addCommentMode)
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                        child: BTN.fill_blue_t_m(
                          text: '취소',
                          width: 81,
                          onPressed: () {
                            if (widget.data.barType == CretaCommentBarType.addReplyMode) {
                              // Timer.periodic(
                              //   const Duration(milliseconds: 100),
                              //   (timer) {
                              //     timer.cancel();
                              widget.onClickedRemove?.call(widget.data);
                              //   },
                              // );
                            } else {
                              //widget.data.barType == CretaCommentBarType.modifyCommentMode
                              setState(() {
                                _isEditMode = false;
                                _controller.text = widget.data.comment;
                              });
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
          // buttons (add-reply, show-reply)
          (widget.data.barType == CretaCommentBarType.addCommentMode ||
                  (widget.data.parentMid.isNotEmpty && widget.data.hasNoReply))
              ? Container(height: 10)
              : Container(
                  padding: EdgeInsets.fromLTRB(64, 8, 0, 8),
                  child: Row(
                    children: [
                      (widget.data.parentMid.isNotEmpty)
                          ? Container()
                          : Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: BTN.fill_gray_t_es(
                                text: '답글달기',
                                width: 61,
                                buttonColor: CretaButtonColor.gray100light,
                                onPressed: () {
                                  if (kDebugMode) print('답글달기(${widget.data.nickname})');
                                  widget.onClickedReply?.call(widget.data);
                                },
                              ),
                            ),
                      (widget.data.hasNoReply)
                          ? Container()
                          : BTN.fill_gray_t_es(
                              text: '답글 ${widget.data.replyList.length}개',
                              width: null,
                              buttonColor: CretaButtonColor.gray100blue,
                              textColor: CretaColor.primary[400],
                              onPressed: () {
                                widget.onClickedShowReply?.call(widget.data);
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
      ),
*/
    );
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
