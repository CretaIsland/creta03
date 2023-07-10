import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/studio/left_menu/word_pad/simple_editor.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';

enum ExportFileType {
  documentJson,
  markdown,
  html,
  delta,
}

extension on ExportFileType {
  String get extension {
    switch (this) {
      case ExportFileType.documentJson:
      case ExportFileType.delta:
        return 'json';
      case ExportFileType.markdown:
        return 'md';
      case ExportFileType.html:
        return 'html';
    }
  }
}

class AppFlowyEditorWidget extends StatefulWidget {
  final ContentsModel model;
  final FrameModel frameModel;
  final Size size;
  final void Function() onComplete;
  final GlobalKey? frameKey;
  const AppFlowyEditorWidget({
    super.key,
    required this.model,
    required this.frameModel,
    required this.size,
    required this.onComplete,
    required this.frameKey,
  });

  @override
  State<AppFlowyEditorWidget> createState() => _AppFlowyEditorWidgetState();
}

class _AppFlowyEditorWidgetState extends State<AppFlowyEditorWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final bool _isHover = false;

  // ignore: unused_field
  late WidgetBuilder _widgetBuilder;
  late EditorState _editorState;
  late Future<String> _jsonString;

  bool _showAppBar = true;

  // = (widget.focusNode ?? FocusNode())..addListener(_onFocusChanged);
  // skpark
  void _onComplete(EditorState editorState) {
    //print('_onComplete-------------------');
    _editorState = editorState;
    widget.model.remoteUrl = jsonEncode(editorState.document.toJson());
    //print('*******${widget.model.remoteUrl}******');
    _jsonString = Future.value(widget.model.remoteUrl);
    widget.onComplete.call();
  }

  @override
  void initState() {
    //print('------------------------------initState-------------------------');
    super.initState();
    // _jsonString =
    //     Future.value(widget.model.getURI()); //rootBundle.loadString('assets/example.json');
    // _widgetBuilder = (context) => SimpleEditor(
    //       jsonString: _jsonString,
    //       onEditorStateChange: (editorState) {
    //         print('1-----------editorState changed ');
    //         _onComplete(editorState);
    //       },
    //       onEditComplete: (editorState) {
    //         print('onEditComplete1()');
    //         _onComplete(editorState);
    //       },
    //       onChanged: (editorState) {
    //         //print('onChanged1(${editorState.document.toJson()})');
    //       },
    //     );
  }

  // @override
  // void reassemble() {
  //   super.reassemble();

  //   _widgetBuilder = (context) => SimpleEditor(
  //         jsonString: _jsonString,
  //         onEditorStateChange: (editorState) {
  //           logger.info('2-----------editorState changed,');
  //           _onComplete(editorState);
  //         },
  //         onEditComplete: (editorState) {
  //           print('onEditComplete2()');
  //           _onComplete(editorState);
  //         },
  //         onChanged: (editorState) {
  //           print('onChanged2(${editorState.document.toJson()})');
  //         },
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return StudioVariables.isPreview ? _viewMode() : _editMode();
  }

  Widget _editMode() {
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: PlatformExtension.isDesktopOrWeb,
        backgroundColor: Colors.transparent, //skpark
        //drawer: _buildDrawer(context),  //skpark
        appBar: _showAppBar
            ? AppBar(
                toolbarHeight: 36,
                backgroundColor: CretaColor.primary,
                surfaceTintColor: Colors.transparent,
                title: const Text('Creta Word Pad(줄바꿈:Shift+Enter, 저장: Enter)'),
                actions: [
                  BTN.fill_blue_i_m(
                    icon: Icons.arrow_upward_outlined,
                    onPressed: () {
                      setState(
                        () {
                          _showAppBar = false;
                        },
                      );
                    },
                  )
                ],
              )
            : null,
        body: _showAppBar
            ? SafeArea(child: _buildBody(context))
            : Stack(
                children: [
                  SafeArea(child: _buildBody(context)),
                  Align(
                    alignment: Alignment.topRight,
                    child: BTN.fill_gray_i_m(
                      icon: Icons.arrow_downward_outlined,
                      onPressed: () {
                        setState(
                          () {
                            _showAppBar = true;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  Widget _viewMode() {
    return SafeArea(child: _buildBody(context));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       key: _scaffoldKey,
  //       children: [
  //         SafeArea(child: _buildBody(context)),
  //         MouseRegion(
  //           onEnter: (e) {
  //             setState(() {
  //               _isHover = true;
  //             });
  //           },
  //           onExit: (e) {
  //             setState(() {
  //               _isHover = false;
  //             });
  //           },
  //           child: _isHover
  //               ? Container(
  //                   height: 36,
  //                   width: double.infinity,
  //                   color: CretaColor.primary.withOpacity(0.75),
  //                   child: Center(child: Text('Creta Text Editor', style: CretaFont.titleMedium)),
  //                 )
  //               : const SizedBox.shrink(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    //_widgetBuilder(context);
    _jsonString =
        Future.value(widget.model.getURI()); //rootBundle.loadString('assets/example.json');
    return SimpleEditor(
      frameKey: widget.frameKey,
      jsonString: _jsonString,
      //bgColor: widget.frameModel.bgColor1.value,
      bgColor: Colors.transparent,
      onEditorStateChange: (editorState) {
        //print('1-----------editorState changed ');
        _onComplete(editorState);
      },
      onEditComplete: (editorState) {
        //print('onEditComplete1()');
        _onComplete(editorState);
      },
      onAttached: () {
        // setState(() {
        //   _showAppBar = true;
        // });
        //print('attached --------------------------');
      },
      onChanged: (editorState) {
        //print('onChanged1(${editorState.document.toJson()})');
      },
    );
  }

  // ignore: unused_element
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: Image.asset(
              'assets/icon.png',
              fit: BoxFit.fill,
            ),
          ),

          // AppFlowy Editor Demo
          _buildSeparator(context, 'AppFlowy Editor Demo'),
          _buildListTile(context, 'With Example.json', () {
            final jsonString = rootBundle.loadString('assets/example.json');
            _loadEditor(context, jsonString);
          }),
          _buildListTile(context, 'With Example.html', () async {
            final htmlString = await rootBundle.loadString('assets/example.html');
            final html = htmlToDocument(htmlString);
            // final html = HTMLToNodesConverter(htmlString).toDocument();
            final jsonString = Future<String>.value(
              jsonEncode(
                html.toJson(),
              ).toString(),
            );
            if (mounted) {
              _loadEditor(context, jsonString);
            }
          }),
          _buildListTile(context, 'With Empty Document', () {
            final jsonString = Future<String>.value(
              jsonEncode(
                EditorState.blank(withInitialText: true).document.toJson(),
              ).toString(),
            );
            _loadEditor(context, jsonString);
          }),

          // Encoder Demo
          _buildSeparator(context, 'Export To X Demo'),
          _buildListTile(context, 'Export To JSON', () {
            _exportFile(_editorState, ExportFileType.documentJson);
          }),
          _buildListTile(context, 'Export to Markdown', () {
            _exportFile(_editorState, ExportFileType.markdown);
          }),

          // Decoder Demo
          _buildSeparator(context, 'Import From X Demo'),
          _buildListTile(context, 'Import From Document JSON', () {
            _importFile(ExportFileType.documentJson);
          }),
          _buildListTile(context, 'Import From Markdown', () {
            _importFile(ExportFileType.markdown);
          }),
          _buildListTile(context, 'Import From Quill Delta', () {
            _importFile(ExportFileType.delta);
          }),

          // Theme Demo
          _buildSeparator(context, 'Theme Demo'),
          _buildListTile(context, 'Built In Dark Mode', () {
            _jsonString = Future<String>.value(
              jsonEncode(_editorState.document.toJson()).toString(),
            );
            setState(() {});
          }),
          _buildListTile(context, 'Custom Theme', () {
            _jsonString = Future<String>.value(
              jsonEncode(_editorState.document.toJson()).toString(),
            );
            setState(() {
              // todo: implement it
            });
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String text,
    VoidCallback? onTap,
  ) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 16),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }

  Widget _buildSeparator(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _loadEditor(
    BuildContext context,
    Future<String> jsonString,
  ) async {
    final completer = Completer<void>();
    _jsonString = jsonString;
    setState(
      () {
        //print('-----------------------------_loadEditor-------------------');
        _widgetBuilder = (context) => SimpleEditor(
              //bgColor: widget.frameModel.bgColor1.value,
              bgColor: Colors.transparent,
              jsonString: _jsonString,
              onEditorStateChange: (editorState) {
                _editorState = editorState;
              },
            );
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completer.complete();
    });
    return completer.future;
  }

  void _exportFile(
    EditorState editorState,
    ExportFileType fileType,
  ) async {
    var result = '';

    switch (fileType) {
      case ExportFileType.documentJson:
        result = jsonEncode(editorState.document.toJson());
        break;
      case ExportFileType.markdown:
        result = documentToMarkdown(editorState.document);
        break;
      case ExportFileType.html:
      case ExportFileType.delta:
        throw UnimplementedError();
    }

    if (!kIsWeb) {
      final path = await FilePicker.platform.saveFile(
        fileName: 'document.${fileType.extension}',
      );
      if (path != null) {
        await File(path).writeAsString(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('This document is saved to the $path'),
            ),
          );
        }
      }
    } else {
      final blob = html.Blob([result], 'text/plain', 'native');
      html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute('download', 'document.${fileType.extension}')
        ..click();
    }
  }

  void _importFile(ExportFileType fileType) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: [fileType.extension],
      type: FileType.custom,
    );
    var plainText = '';
    if (!kIsWeb) {
      final path = result?.files.single.path;
      if (path == null) {
        return;
      }
      plainText = await File(path).readAsString();
    } else {
      final bytes = result?.files.first.bytes;
      if (bytes == null) {
        return;
      }
      plainText = const Utf8Decoder().convert(bytes);
    }

    var jsonString = '';
    switch (fileType) {
      case ExportFileType.documentJson:
        jsonString = plainText;
        break;
      case ExportFileType.markdown:
        jsonString = jsonEncode(markdownToDocument(plainText).toJson());
        break;
      case ExportFileType.delta:
        final delta = Delta.fromJson(jsonDecode(plainText));
        final document = quillDeltaEncoder.convert(delta);
        jsonString = jsonEncode(document.toJson());
        break;
      case ExportFileType.html:
        throw UnimplementedError();
    }

    if (mounted) {
      _loadEditor(context, Future<String>.value(jsonString));
    }
  }
}