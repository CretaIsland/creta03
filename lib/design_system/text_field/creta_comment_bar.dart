// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/community_sample_data.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';
//import 'package:hycop/hycop.dart';
//import 'package:flutter/material.dart';
//import 'package:outline_search_bar/outline_search_bar.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';

class CretaCommentBar extends StatefulWidget {
  final double? width;
  //final double height;
  final Widget? thumb;
  final CretaCommentData data;
  final void Function(String value) onSearch;
  final String hintText;
  final bool showEditButton;

  const CretaCommentBar({
    super.key,
    required this.data,
    required this.onSearch,
    required this.hintText,
    this.width,
    this.thumb,
    //this.height = 56,
    this.showEditButton = false,
  });

  @override
  State<CretaCommentBar> createState() => _CretaCommentBarState();
}

class _CretaCommentBarState extends State<CretaCommentBar> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  //String _searchValue = '';
  //bool _hover = false;
  //bool _clicked = false;
  //late bool _showEditButton;
  bool _showMoreButton = true;

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
    //_showEditButton = widget.showEditButton;
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

  int lineCount = 1;

  @override
  Widget build(BuildContext context) {
    double textWidth = (widget.thumb != null) ? widget.width! - 16 - 16 - 40 - 8 : widget.width! - 16 - 16;

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
        child: Container(
          width: widget.width,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            // crop
            borderRadius: BorderRadius.circular(30),
            //color: (_colorCount % 2 == 0) ? CretaColor.text[100] : CretaColor.text[300],
          ),
          clipBehavior: Clip.none, //Clip.antiAlias,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getProfileImage(),
              //Container(
              SizedBox(
                width: textWidth,
                //color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name & date & edit-button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        BTN.fill_gray_t_es(text: '수정하기', onPressed: () {}, width: 61),
                        SizedBox(width: 8),
                        BTN.fill_gray_t_es(text: '삭제하기', onPressed: () {}, width: 61),
                      ],
                    ),
                    // spacing
                    SizedBox(height: 3),
                    // comment
                    (line > 2 && _showMoreButton)
                        ? SizedBox(
                            height: 19 * 2,
                            child: Text(
                              widget.data.comment,
                              style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                              overflow: TextOverflow.fade,
                              maxLines: 100,
                            ),
                          )
                        : Text(
                            widget.data.comment,
                            style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
                            overflow: TextOverflow.visible,
                            maxLines: 100,
                          ),
                    //(line > 2 && _showMoreButton) ? SizedBox(height: 8) : Container(),
                    (line > 2 && _showMoreButton)
                        ? BTN.fill_gray_t_es(
                            text: '자세히 보기',
                            onPressed: () {
                              setState(() {
                                _showMoreButton = false;
                              });
                            },
                            width: 81,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
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
    // //       logger.info('search $_searchValue');
    // //       widget.onSearch(_searchValue);
    // //     }),
    // //     onTapOutside: (event) {
    // //       logger.info('onTapOutside($_searchValue)');
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
    //             logger.info('search $_searchValue');
    //             widget.onSearch(_searchValue);
    //           }),
    //           onTapOutside: (event) {
    //             logger.info('onTapOutside($_searchValue)');
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
