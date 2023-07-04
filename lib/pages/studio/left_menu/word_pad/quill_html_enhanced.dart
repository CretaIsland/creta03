import 'dart:async';

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../studio_variables.dart';

class QuillHtmlEnhanced extends StatefulWidget {
  final ContentsModel document;
  final Size size;
  const QuillHtmlEnhanced({super.key, required this.document, required this.size});
  @override
  State<QuillHtmlEnhanced> createState() => _QuillHtmlEnhancedState();
}

class _QuillHtmlEnhancedState extends State<QuillHtmlEnhanced> with TickerProviderStateMixin {
  String result = '';
  HtmlEditorController? _currentController;
  bool _isEditorFocused = true;

  late final AnimationController _controller =
      AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

  // late final Animation<double> _animation =
  //     CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
    _currentController = HtmlEditorController();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentController != null) {
      _controller.animateTo(1, duration: const Duration(milliseconds: 100));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // margin: _isEditorFocused ? const EdgeInsets.only(top: 16.0) : null,
              padding: _isEditorFocused ? const EdgeInsets.only(top: 84.0, left: 28.0) : null,
              width: widget.size.width,
              height: widget.size.height,
              decoration: BoxDecoration(
                color: CretaColor.text[100],
                // border: Border.all(
                //   color: CretaColor.text[700]!,
                //   width: 0.2,
                // ),
              ),
              child: HtmlEditor(
                controller: _currentController!,
                htmlEditorOptions: HtmlEditorOptions(
                  // hint: widget.document.remoteUrl,
                  initialText: widget.document.remoteUrl,
                  shouldEnsureVisible: false,
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.custom,
                ),
                callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                  debugPrint('html before change is $currentHtml');
                }, onChangeContent: (String? changed) {
                  debugPrint('content changed to $changed');
                  widget.document.remoteUrl = changed;
                  widget.document.filter.set(widget.document.filter.value == ImageFilterType.bright
                      ? ImageFilterType.cold
                      : ImageFilterType.bright);
                  debugPrint('onCompletedText is:  ${widget.document.remoteUrl}');
                }, onEnter: () {
                  debugPrint('enter/return pressed');
                }, onFocus: () {
                  debugPrint('editor focused');
                  setState(() {
                    _isEditorFocused = true;
                    resetTimeout();
                  });
                }, onBlur: () {
                  debugPrint('editor unfocused');
                }, onInit: () {
                  debugPrint('init');
                }),
              ),
            ),
            if (_isEditorFocused == true) _popupToolBox(),
            if (_isEditorFocused == true)
              Positioned(
                top: 72.0,
                left: widget.size.width / 2.0,
                child: InkWell(
                  child: Container(
                    width: 32.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: CretaColor.primary[200],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                    ),
                    child: BTN.fill_gray_i_m(
                      icon: Icons.keyboard_double_arrow_up,
                      buttonColor: CretaButtonColor.transparent,
                      onPressed: () {
                        debugPrint('-------Hidden button pressed-------');
                        setState(() {
                          setTimeout();
                          _isEditorFocused = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _popupToolBox() {
    return _currentController == null
        ? const SizedBox.shrink()
        : Center(
            child: Container(
              width: widget.size.width,
              decoration: BoxDecoration(color: CretaColor.primary[200]),
              // borderRadius: const BorderRadius.all(Radius.circular(32.0))),
              // child: ClipRRect(
              //   borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: StudioVariables.isPreview == false
                    ? ToolbarWidget(
                        controller: _currentController!,
                        callbacks: Callbacks(
                          onHiddenToolbar: () {
                            debugPrint('-------- Close btn pressed-------------');
                            setState(() {
                              setTimeout();
                              _isEditorFocused = false;
                            });
                          },
                        ),
                        htmlToolbarOptions: HtmlToolbarOptions(
                          toolbarPosition: ToolbarPosition.custom,
                          toolbarType: ToolbarType.nativeGrid,
                          onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                            debugPrint(
                                "button '${describeEnum(type)}' pressed, the current selected status is $status");
                            return true;
                          },
                          mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                            // debugPrint(url);
                            return true;
                          },
                          mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                            return true;
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
  }

  Timer? timer;

  void resetTimeout() {
    timer?.cancel();
    timer = null;
  }

  void setTimeout() {
    timer = Timer(const Duration(milliseconds: 100), () {
      if (_currentController != null) {
        _controller.reverse(from: 1).then((_) {
          if (mounted) {}
        });
      }
    });
  }
}
