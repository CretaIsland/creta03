// ignore_for_file: prefer_const_constructors

//import 'package:creta03/pages/community/community_sample_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
//import 'package:hycop/hycop.dart';
//import 'package:flutter/material.dart';
//import 'package:outline_search_bar/outline_search_bar.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/model/app_enums.dart';
import '../../lang/creta_commu_lang.dart';
import '../../model/comment_model.dart';

class CretaCommentBar extends StatefulWidget {
  final double? width;
  //final double height;
  final Widget? thumb;
  final CommentModel data;
  final String hintText;
  final void Function(CommentModel)? onClickedAdd; // 댓글등록
  final void Function(CommentModel)? onClickedRemove; // 삭제하기 (or 답글취소)
  final void Function(CommentModel)? onClickedModify; // 댓글수정 (or 답글등록)
  final void Function(CommentModel)? onClickedReply; // 답글달기
  final void Function(CommentModel)? onClickedShowReply; // 답글보기

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
  });

  @override
  State<CretaCommentBar> createState() => _CretaCommentBarState();
}

class _CretaCommentBarState extends State<CretaCommentBar> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  String _editingValue = '';
  bool _hover = false;
  //bool _clicked = false;
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
    _isEditMode = (widget.data.barType == CommentBarType.addCommentMode ||
        widget.data.barType == CommentBarType.addReplyMode);
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
            },
            onSubmitted: ((value) {
              _editingValue = value;
              if (kDebugMode) print('onSubmitted=$_editingValue');
              //logger.fine('search $_searchValue');
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
                widget.data.name,
                style: CretaFont.titleSmall.copyWith(color: CretaColor.text[700]),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 11),
              Text(
                CretaCommonUtils.dateToDurationString(widget.data.createTime),
                style: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]),
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(child: Container()),
              (!_hover || widget.onClickedModify == null)
                  ? SizedBox(height: 20)
                  : BTN.fill_gray_t_es(
                      text: CretaCommuLang['modify'],
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
              (!_hover || widget.onClickedRemove == null)
                  ? SizedBox(height: 20)
                  : BTN.fill_gray_t_es(
                      text: CretaCommuLang['delete'],
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
                    text: CretaCommuLang['viewDetails'],
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
              text: CretaCommuLang['writeComment'],
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
    if (widget.data.barType == CommentBarType.addCommentMode ||
        (widget.data.parentId.isNotEmpty && widget.data.hasNoReply)) {
      return SizedBox(height: 10);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(64, 8, 0, 8),
      child: Row(
        children: [
          (widget.data.parentId.isNotEmpty ||
                  AccountManager.currentLoginUser.isLoginedUser == false)
              ? Container()
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: BTN.fill_gray_t_es(
                    text: CretaCommuLang['replyToComment'],
                    width: 61,
                    buttonColor: CretaButtonColor.gray100light,
                    onPressed: () {
                      if (kDebugMode) print('답글달기(${widget.data.name})');
                      widget.onClickedReply?.call(widget.data);
                    },
                  ),
                ),
          (widget.data.hasNoReply)
              ? Container()
              : BTN.fill_gray_t_es(
                  text: '${CretaCommuLang['reply']} ${widget.data.replyList.length}',
                  width: null,
                  buttonColor: CretaButtonColor.gray100blue,
                  textColor: CretaColor.primary[400],
                  onPressed: () {
                    widget.onClickedShowReply?.call(widget.data);
                  },
                  tailIconData: widget.data.showReplyList
                      ? Icons.arrow_drop_up_outlined
                      : Icons.arrow_drop_down_outlined,
                  sidePadding: CretaButtonSidePadding.fromLR(8, 8),
                ),
        ],
      ),
    );
  }

  Widget _getCommentWidget() {
    double textWidth = widget.width! - 16 - 16;
    if (widget.thumb != null) textWidth -= (40 + 8);

    // <!-- move to CretaUtils
    // final span = TextSpan(text: widget.data.comment, style: CretaFont.bodyMedium);
    // final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    // tp.layout(maxWidth: textWidth);
    // final line = tp.computeLineMetrics().length;
    // -->
    final line =
        CretaCommonUtils.getTextLineCount(widget.data.comment, CretaFont.bodyMedium, textWidth);

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
                  text: CretaCommuLang['editComment'],
                  width: 81,
                  onPressed: () {
                    setState(() {
                      widget.data.comment = _controller.text;
                      _isEditMode = false;
                    });
                    widget.onClickedModify?.call(widget.data);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                child: BTN.fill_blue_t_m(
                  text: CretaCommuLang['cancel'],
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

    return Column(
      children: [
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
                  text: CretaCommuLang['postReply'],
                  width: 81,
                  onPressed: () {
                    setState(() {
                      widget.data.barType = CommentBarType.modifyCommentMode;
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
                  text: CretaCommuLang['cancel'],
                  width: 81,
                  onPressed: () {
                    widget.onClickedRemove?.call(widget.data);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _getChildWidget() {
    if (widget.data.barType == CommentBarType.addCommentMode) {
      return _getAddCommentWidget();
    } else if (widget.data.barType == CommentBarType.modifyCommentMode) {
      if (_isEditMode) return _getModifyCommentWidget();
    } else if (widget.data.barType == CommentBarType.addReplyMode) {
      return _getAddReplyWidget();
    }
    return _getCommentWidget();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          _hover = false;
          //_clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          _hover = true;
        });
      },
      child: _getChildWidget(),
    );
  }
}
