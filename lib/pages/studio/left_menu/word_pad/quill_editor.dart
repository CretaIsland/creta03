import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../studio_variables.dart';

class QuillPlayerWidget extends StatefulWidget {
  final ContentsModel document;
  const QuillPlayerWidget({super.key, required this.document});

  @override
  State<QuillPlayerWidget> createState() => _QuillPlayerWidgetState();
}

class _QuillPlayerWidgetState extends State<QuillPlayerWidget> {
  // [controller] --> create a QuillEditorController to access the editor method
  late QuillEditorController controller;
  bool _isCreated = false;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle =
      const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal);
  final _hintTextStyle =
      const TextStyle(fontSize: 18, color: Colors.black12, fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();
    controller = QuillEditorController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: StudioVariables.isPreview == false
                ? ToolBar(
                    toolBarColor: _toolbarColor,
                    padding: const EdgeInsets.all(8),
                    iconSize: 25,
                    iconColor: _toolbarIconColor,
                    activeIconColor: CretaColor.primary,
                    controller: controller,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //direction: Axis.vertical,
                    customButtons: [
                      InkWell(
                          onTap: () => unFocusEditor(),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.black,
                          )),
                      InkWell(
                          onTap: () async {
                            var selectedText = await controller.getSelectedText();
                            debugPrint('selectedText $selectedText');
                            var selectedHtmlText = await controller.getSelectedHtmlText();
                            debugPrint('selectedHtmlText $selectedHtmlText');
                          },
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.black,
                          )),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: QuillHtmlEditor(
              text: "<h1>Hello</h1>This is a quill html editor example 😊",
              hintText: 'Hint text goes here',
              controller: controller,
              isEnabled: true,
              minHeight: 500,
              textStyle: _editorTextStyle,
              hintTextStyle: _hintTextStyle,
              hintTextAlign: TextAlign.start,
              padding: const EdgeInsets.only(left: 10, top: 10),
              hintTextPadding: const EdgeInsets.only(left: 20),
              backgroundColor: _backgroundColor,
              onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
              onTextChanged: (text) {
                //if (_isCreated == false && text == widget.document.remoteUrl) return;
                if (_isCreated == false) return;
                bool textChanged = (text != widget.document.remoteUrl);
                debugPrint('onTextChanged has been invoked $text, ${widget.document.remoteUrl}');
                widget.document.remoteUrl = text;
                if (textChanged) {
                  debugPrint('saved :  ${widget.document.remoteUrl!}');
                  widget.document.filter.set(widget.document.filter.value == ImageFilterType.bright
                      ? ImageFilterType.cold
                      : ImageFilterType.bright);
                  //widget.document.save();
                }
              },
              onEditorCreated: () {
                debugPrint('Editor has been loaded ${widget.document.remoteUrl!}');
                setHtmlText(widget.document.remoteUrl!);
                _isCreated = true;
              },
              onEditorResized: (height) => debugPrint('Editor resized $height'),
              onSelectionChanged: (sel) => debugPrint('index ${sel.index}, range ${sel.length}'),
            ),
          ),
        ],
      ),
    );
  }

  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  void unFocusEditor() => controller.unFocus();
}
