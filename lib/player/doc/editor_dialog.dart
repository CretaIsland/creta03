// ignore_for_file: must_be_immutable

import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';

class EditorDialog extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  String? cancelButtonText;
  String? okButtonText;
  final double okButtonWidth;
  final Function(String) onPressedOK;
  final Function? onPressedCancel;
  final Color? backgroundColor;
  final Offset dialogOffset;
  //final GlobalKey<State<StatefulWidget>>? frameKey;
  final Size frameSize;
  final void Function(String)? onChanged;
  //final void Function() onComplete;
  final String initialText;

  EditorDialog(
      {super.key,
      this.width = 387.0,
      this.height = 308.0,
      this.padding = const EdgeInsets.only(left: 32.0, right: 32.0),
      this.cancelButtonText, // = CretaLang['cancel']!,
      this.okButtonText, // = CretaLang['confirm']!,
      this.okButtonWidth = 55,
      this.backgroundColor,
      required this.dialogOffset,
      //required this.frameKey,
      required this.onPressedOK,
      required this.onChanged,
      required this.frameSize,
      required this.initialText,
      //required this.onComplete,
      this.onPressedCancel}) {
    cancelButtonText ??= CretaLang['cancel']!;
    okButtonText ??= CretaLang['confirm']!;
  }

  @override
  State<EditorDialog> createState() => _EditorDialogState();
}

class _EditorDialogState extends State<EditorDialog> {
  bool _isFullScreen = true;
  late HtmlEditorController controller;
  String _retval = '';

  @override
  void initState() {
    super.initState();
    //widget.player.afterBuild();
    controller = HtmlEditorController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return
        // BackdropFilter(
        //   filter: ImageFilter.blur(
        //     sigmaX: 3,
        //     sigmaY: 3,
        //   ),
        //   child:
        SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _titleArea(),
          Padding(
            padding: _isFullScreen
                ? const EdgeInsets.only(left: 8.0, right: 8.0)
                : const EdgeInsets.all(0.0),
            child: _htmlEditor(),
          ),
          _okAndCancelButtonArea(),
        ],
      ),
      //),
    );
  }

  Widget _titleArea() {
    return SizedBox(
      // 타이틀 Area
      height: 60,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Creta Text Editor', style: CretaFont.titleMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _trailButton(),
                    const SizedBox(
                      width: 10,
                    ),
                    _closeButton(context),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 10,
            indent: 20,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _okAndCancelButtonArea() {
    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Divider(
            height: 20,
            indent: 20,
            color: Colors.grey.shade200,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          //   child: Container(
          //     width: width,
          //     height: 1.0,
          //     color: Colors.grey.shade200,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //_translationButtonArea(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                BTN.line_red_t_m(
                    text: widget.cancelButtonText!,
                    onPressed: () {
                      if (widget.onPressedCancel != null) {
                        widget.onPressedCancel!.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    }),
                const SizedBox(width: 8.0),
                BTN.fill_red_t_m(
                    text: widget.okButtonText!,
                    width: widget.okButtonWidth,
                    onPressed: () {
                      widget.onPressedOK(_retval);
                    })
              ]),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _translationButtonArea() {
  //   return Align(
  //     alignment: Alignment.bottomRight,
  //     child: SizedBox(
  //       width: 220,
  //       child: CretaDropDownButton(
  //         align: MainAxisAlignment.start,
  //         selectedColor: CretaColor.text[700]!,
  //         textStyle: CretaFont.bodySmall,
  //         width: 200,
  //         height: 32,
  //         itemHeight: 24,
  //         dropDownMenuItemList: CretaCommonUtils.getLangItem(
  //             defaultValue: widget.model.lang.value,
  //             onChanged: (val) async {
  //               widget.model.lang.set(val);
  //               if (widget.model.remoteUrl != null) {
  //                 await _translate(widget.model.lang.value);
  //                 setState(() {});
  //               }
  //             }),
  //       ),
  //     ),
  //     // child: BTN.fill_color_t_m(
  //     //   onPressed: () {
  //     //     _translate();
  //     //     setState(
  //     //       () {},
  //     //     );
  //     //   },
  //     //   text: 'translate',
  //     //   width: 80,
  //     // ),
  //   );
  // }

  Widget _closeButton(BuildContext context) {
    return BTN.fill_gray_i_s(
        icon: Icons.close,
        onPressed: () {
          if (widget.onPressedCancel != null) {
            widget.onPressedCancel!.call();
          } else {
            Navigator.of(context).pop();
          }
        });
  }

  Widget _trailButton() {
    return BTN.fill_gray_i_s(
        tooltip: _isFullScreen ? CretaStudioLang['realSize']! : CretaStudioLang['maxSize']!,
        icon: _isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined,
        onPressed: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
          });
        });
  }

  // Widget _simpleEditor() {
  //   //print('widget.frameSize=(${widget.frameSize})');

  //   return  SimpleEditor(
  //       isViewer: false, //skpark
  //       dialogOffset: widget.dialogOffset, //skpark
  //       dialogSize: _isFullScreen ? Size(widget.width, widget.height - 200) : realSize, //skpark
  //       frameKey: widget.frameKey,
  //       jsonString: Future.value(widget.model.getURI()),
  //       //bgColor: widget.frameModel.bgColor1.value,
  //       bgColor: Colors.transparent,
  //       onEditorStateChange: (editorState) {
  //         //print('1-----------editorState changed ');
  //         //_onComplete(editorState);
  //       },
  //       onEditComplete: (editorState) {
  //         //print('onEditComplete1()');
  //         //_onComplete(editorState);
  //       },
  //       onChanged: (editorState) {
  //         widget.onChanged?.call(editorState);
  //       },
  //       onAttached: () {},
  //     ),
  //   );
  // }

  // Future<void> _translate(String lang) async {
  //   String? org = widget.model.remoteUrl;
  //   if (org == null || org.isEmpty) {
  //     return;
  //   }
  //   Map<String, dynamic> json = jsonDecode(org);
  //   // Find the items with "name" equal to "insert"
  //   await findItemsByName(
  //     json,
  //     'insert',
  //     transform: (input) async {
  //       Translation result = await input.translate(to: lang);
  //       return result.text;
  //     },
  //   );

  //   String decoded = jsonEncode(json);
  //   //print(decoded);

  //   widget.model.remoteUrl = decoded;
  //   //widget.onComplete.call();

  //   // Print the values of the "insert" items
  //   // for (var item in insertItems) {
  //   //   print(item.toString());
  //   // }
  // }

  // Future<void> findItemsByName(Map<String, dynamic> json, String name,
  //     {Future<String> Function(String input)? transform}) async {
  //   //_translateMap = {...json};
  //   //List<dynamic> result = [];
  //   Future<void> search(Map<String, dynamic> map) async {
  //     for (String key in map.keys) {
  //       var value = map[key];
  //       if (key == name) {
  //         //result.add(map[name]);
  //         if (transform != null) {
  //           map[name] = await transform(map[name]);
  //           //print(map[name]);
  //         }
  //       } else if (value is Map<String, dynamic>) {
  //         await search(value);
  //       } else if (value is List<dynamic>) {
  //         for (var item in value) {
  //           if (item is Map<String, dynamic>) {
  //             await search(item);
  //           }
  //         }
  //       }
  //     }
  //   }

  //   await search(json);
  // }

  Widget _htmlEditor() {
    Size realSize = Size(widget.width, widget.height - 200);
    // Size realSize = widget.frameSize;
    // if (_isFullScreen == false) {
    //   if (realSize.width > widget.width) {
    //     realSize = Size(widget.width, realSize.height);
    //   }
    //   if (realSize.height > widget.height - 200) {
    //     realSize = Size(realSize.width, widget.height - 200);
    //   }
    // }

    return HtmlEditor(
      controller: controller,
      htmlToolbarOptions: const HtmlToolbarOptions(
        toolbarItemHeight: 32,
        toolbarType: ToolbarType.nativeGrid,
        toolbarPosition: ToolbarPosition.aboveEditor,
        defaultToolbarButtons: [
          StyleButtons(),
          FontSettingButtons(fontSizeUnit: false),
          FontButtons(superscript: false, subscript: false),
          ColorButtons(),
          ListButtons(),
          ParagraphButtons(caseConverter: false, textDirection: false),
          //InsertButtons(),
          // OtherButtons(fullscreen: false, codeview: false),
        ],
      ),
      htmlEditorOptions: HtmlEditorOptions(
          //disabled: true,
          hint: "Type you Text here",
          initialText: widget.initialText,
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          width: _isFullScreen ? realSize.width - 200 : realSize.width),
      otherOptions: OtherOptions(
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: const Border.fromBorderSide(BorderSide(color: Colors.grey, width: 5))),
        height: realSize.height - 10,
      ),
      callbacks: Callbacks(
        onBeforeCommand: (value) {
          /// Called before certain commands are fired and the editor is in rich text view.
          /// There is currently no documentation on this parameter, thus it is
          /// unclear which commands this will fire before.
          ///This function will return the current HTML in the editor as an argument.
        },
        onChangeContent: (value) async {
          /// Called whenever the HTML content of the editor is changed and the editor
          /// is in rich text view.
          ///
          /// Note: This function also seems to be called if input is detected in the
          /// editor field but the content does not change.
          /// E.g. repeatedly pressing backspace when the field is empty
          /// will also trigger this callback.
          ///
          /// This function will return the current HTML in the editor as an argument.
          _retval = await controller.getText();
          //print('onChangeContent : $value');
        },
        onChangeCodeview: (value) {
          /// Called whenever the code of the editor is changed and the editor
          /// is in code view.
          ///
          /// Note: This function also seems to be called if input is detected in the
          /// editor field but the content does not change.
          /// E.g. repeatedly pressing backspace when the field is empty
          /// will also trigger this callback.
          ///
          /// This function will return the current code in the codeview as an argument.
        },
        onChangeSelection: (value) async {
          /// Called whenever the selection area of the editor is changed.
          ///
          /// It passes all the editor settings at the current selection as an argument.
          /// This can be used in custom toolbar item implementations, to update your
          /// toolbar item UI when the editor formatting changes.
          // 뭔가 속성이 변했을때 온다.  폰트를 빠꿨다던가...
          _retval = await controller.getText();
          //print('onChangeSelection: $_retval');
        },
        onDialogShown: () {
          /// Called whenever a dialog is shown in the editor. The dialogs will be either
          /// the link, image, video, or help dialogs.
        },
        onEnter: () async {
          /// Called whenever the enter/return key is pressed and the editor
          /// is in rich text view. There is currently no way to detect enter/return
          /// when the editor is in code view.
          ///
          /// Note: The onChange callback will also be triggered at the same time as
          /// this callback, please design your implementation accordingly.
          _retval = await controller.getText();
          //print('onChangeSelection: $_retval');
        },
        onFocus: () {
          /// Called whenever the rich text field gains focus. This will not be called
          /// when the code view editor gains focus, instead use [onBlurCodeview] for
          /// that.
          //print('onFocus:');
        },
        onBlur: () {
          /// Called whenever either the rich text field or the codeview field loses
          /// focus. This will also be triggered when switching from the rich text editor
          /// to the code view editor.
          ///
          /// Note: Due to the current state of webviews in Flutter, tapping outside
          /// the webview or dismissing the keyboard does not trigger this callback.
          /// This callback will only be triggered if the user taps on an empty space
          /// in the toolbar or switches the view mode of the editor.
          //print('offFocus:');
        },
        onBlurCodeview: () {
          /// Called whenever the code view either gains or loses focus (the Summernote
          /// docs say this will only be called when the code view loses focus but
          /// in my testing this is not the case). This will also be triggered when
          /// switching between the rich text editor and the code view editor.
          ///
          /// Note: Due to the current state of webviews in Flutter, tapping outside
          /// the webview or dismissing the keyboard does not trigger this callback.
          /// This callback will only be triggered if the user taps on an empty space
          /// in the toolbar or switches the view mode of the editor.
        },
        onImageLinkInsert: (value) {
          /// Called whenever an image is inserted via a link. The function passes the
          /// URL of the image inserted into the editor.
          ///
          /// Note: Setting this function overrides the default summernote image via URL
          /// insertion handler! This means you must manually insert the image using
          /// [controller.insertNetworkImage] in your callback function, otherwise
          /// nothing will be inserted into the editor!
        },
        onImageUpload: (value) {
          /// Called whenever an image is inserted via upload. The function passes the
          /// [FileUpload] class, containing the filename, size, MIME type, base64 data,
          /// and last modified information so you can upload it into your server.
          ///
          /// Note: Setting this function overrides the default summernote upload image
          /// insertion handler (base64 handler)! This means you must manually insert
          /// the image using [controller.insertNetworkImage] (for uploaded images) or
          /// [controller.insertHtml] (for base64 data) in your callback function,
          /// otherwise nothing will be inserted into the editor!
        },
        onImageUploadError: (FileUpload? file, String? name, UploadError error) {
          /// Called whenever an image is failed to be inserted via upload. The function
          /// passes the [FileUpload] class, containing the filename, size, MIME type,
          /// base64 data, and last modified information so you can do error handling.
        },
        onInit: () {
          /// Called whenever [InAppWebViewController.onLoadStop] is fired on mobile
          /// or when the [IFrameElement.onLoad] stream is fired on web. Note that this
          /// method will also be called on refresh on both platforms.
          ///
          /// You can use this method to set certain properties - e.g. set the editor
          /// to fullscreen mode - as soon as the editor is ready to accept these commands.
          //print('onInit:');
        },
        onKeyUp: (value) {
          /// Called whenever a key is released and the editor is in rich text view.
          ///
          /// This function will return the keycode for the released key as an argument.
          ///
          /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
          /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
          /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
          /// and those keys are released.
        },
        onKeyDown: (value) {
          /// Called whenever a key is downed and the editor is in rich text view.
          ///
          /// This function will return the keycode for the downed key as an argument.
          ///
          /// Note: The keycode [is broken](https://stackoverflow.com/questions/36753548/keycode-on-android-is-always-229)
          /// on Android, you will only ever receive 229, 8 (backspace), or 13 (enter)
          /// as a keycode. 8 and 13 only seem to be returned when the editor is empty
          /// and those keys are downed.
        },
        onMouseUp: () {
          /// Called whenever the mouse/finger is released and the editor is in rich text view.
        },
        onMouseDown: () {
          /// Called whenever the mouse/finger is downed and the editor is in rich text view.
        },
        onPaste: () {
          /// Called whenever text is pasted into the rich text field. This will not be
          /// called when text is pasted into the code view editor.
          ///
          /// Note: This will not be called when programmatically inserting HTML into
          /// the editor with [HtmlEditor.insertHtml].
        },
        onScroll: () {
          /// Called whenever the editor is scrolled and it is in rich text view.
          /// Editor scrolled is considered to be the editor box only, not the webview
          /// container itself. Thus, this callback will only fire when the content in
          /// the editor is longer than the editor height. This function can be called
          /// with an explicit scrolling action via the mouse, or also via implied
          /// scrolling, e.g. the enter key scrolling the editor to make new text visible.
          ///
          /// Note: This function will be repeatedly called while the editor is scrolled.
          /// Make sure to factor that into your implementation.
        },
      ),
      //Center(child: Text(model.remoteUrl!)),
      // child: MaterialApp(
      //   localizationsDelegates: const [
      //     AppFlowyEditorLocalizations.delegate,
      //   ],
      //   debugShowCheckedModeBanner: false,
      //   color: Colors.transparent,
      //   home: AppFlowyEditorWidget(
      //     key: GlobalObjectKey('AppFlowyEditorWidget${model.mid}'),
      //     model: model,
      //     frameModel: frameModel,
      //     frameKey: frameKey,
      //     size: realSize,
      //     onComplete: () {
      //       player!.acc.setToDB(model);
      //       setState(() {});
      //       //print('saved : ${model.remoteUrl}');
      //     },
      //   ),
      // ),
    );
  }
}
