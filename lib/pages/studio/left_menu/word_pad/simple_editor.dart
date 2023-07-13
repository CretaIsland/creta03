import 'dart:convert';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:intl/intl.dart';

import 'my_toolbar_container.dart';

class SimpleEditor extends StatefulWidget {
  const SimpleEditor({
    super.key,
    required this.jsonString,
    required this.onEditorStateChange,
    this.onChanged, //skpark
    this.onEditComplete, //skpark
    this.onAttached, //skpark
    this.frameKey, //skpark
    required this.bgColor, //skpark
    required this.isViewer, //skpark
    this.dialogOffset, //skpark
    this.dialogSize, //skpark
    this.editorStyle,
  });

  final bool isViewer; //skpark
  final Offset? dialogOffset; //skpark
  final Size? dialogSize; //skpark
  final Future<String> jsonString;
  //final ContentsModel model;
  final EditorStyle? editorStyle;
  final void Function(EditorState editorState) onEditorStateChange;
  final void Function(EditorState)? onChanged; //skpark
  final void Function(EditorState)? onEditComplete; //skpark
  final void Function()? onAttached; //skpark
  final GlobalKey? frameKey; //skpark
  final Color bgColor; //skpark

  @override
  State<SimpleEditor> createState() => _SimpleEditorState();
}

class _SimpleEditorState extends State<SimpleEditor> {
  late FocusNode _focusNode;

  void _onFocusChanged() {
    logger.info('_onFocusChanged-----------------------');
  }

  @override
  void initState() {
    logger.info('initState-----------------------');
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.jsonString,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          final editorState = EditorState(
            document: Document.fromJson(
              Map<String, Object>.from(
                json.decode(snapshot.data!),
              ),
            ),
          );
          //editorState.logConfiguration.handler = debugPrint;  //skpark
          //..level = LogLevel.off; //skpark
          //widget.onEditorStateChange(editorState);  //skpark
          final scrollController = ScrollController();
          return widget.isViewer
              ? _mainWidget(editorState, scrollController)
              : _withToolbar(editorState, scrollController);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _mainWidget(
    EditorState editorState,
    ScrollController scrollController,
  ) {
    return _buildDesktopEditor(
      context,
      editorState,
      scrollController,
    );
  }

  Widget _withToolbar(
    EditorState editorState,
    ScrollController scrollController,
  ) {
    //return MyToolbarContainer(
    return MyToolbarContainer(
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        _mybuildTextColorItem(
          colorOptions: _generateTextColorOptions(), //skpark
          frameKey: widget.frameKey, //skpark
          onChanged: widget.onChanged, //skpark
        ),
        _mybuildHighlightColorItem(
          colorOptions: _generateTextColorOptions(), //skpark
          frameKey: widget.frameKey, //skpark
          onChanged: widget.onChanged, //skpark
        )
      ],
      editorState: editorState,
      scrollController: scrollController,
      frameKey: widget.frameKey, //skpark
      dialogOffset: widget.dialogOffset, //skpark
      child: SizedBox(
        width: widget.dialogSize != null ? widget.dialogSize!.width : 800,
        height: widget.dialogSize != null ? widget.dialogSize!.height - 200 : 400,
        child: _mainWidget(editorState, scrollController),
      ),
    );
  }

  String get fontColorWhite {
    return Intl.message(
      'White',
      name: 'fontColorWhite',
      desc: '',
      args: [],
    );
  }

  List<ColorOption> _generateTextColorOptions() {
    return [
      ColorOption(
        colorHex: Colors.white.toHex(),
        name: fontColorWhite,
      ),
      ColorOption(
        colorHex: Colors.grey.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorGray,
      ),
      ColorOption(
        colorHex: Colors.brown.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorBrown,
      ),
      ColorOption(
        colorHex: Colors.yellow.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorYellow,
      ),
      ColorOption(
        colorHex: Colors.green.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorGreen,
      ),
      ColorOption(
        colorHex: Colors.blue.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorBlue,
      ),
      ColorOption(
        colorHex: Colors.purple.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorPurple,
      ),
      ColorOption(
        colorHex: Colors.pink.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorPink,
      ),
      ColorOption(
        colorHex: Colors.red.toHex(),
        name: AppFlowyEditorLocalizations.current.fontColorRed,
      ),
    ];
  }

  Widget _buildDesktopEditor(
    BuildContext context,
    EditorState editorState,
    ScrollController? scrollController,
  ) {
    final customBlockComponentBuilders = {
      ...standardBlockComponentBuilderMap,
      ImageBlockKeys.type: ImageBlockComponentBuilder(
        showMenu: true,
        menuBuilder: (node, _) {
          return const Positioned(
            right: 2,
            child: Text('Sample text'),
          );
        },
      )
    };
    return AppFlowyEditor.custom(
      editorState: editorState,
      scrollController: scrollController,
      blockComponentBuilders: customBlockComponentBuilders,
      commandShortcutEvents: standardCommandShortcutEvents,
      characterShortcutEvents: standardCharacterShortcutEvents,
      focusNode: _focusNode,
      onEditComplete: widget.onEditComplete, //skpark
      onChanged: widget.onChanged, //skpark
      onAttached: widget.onAttached, //skpark
      editorStyle: const EditorStyle.desktop(
        //skpark
        padding: EdgeInsets.all(10),
        //backgroundColor: widget.bgColor,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  ToolbarItem _mybuildTextColorItem({
    List<ColorOption>? colorOptions,
    GlobalKey? frameKey, //skpark
    void Function(EditorState)? onChanged, //skpark
  }) {
    return ToolbarItem(
      id: 'editor.textColor',
      group: 4,
      isActive: onlyShowInTextType,
      builder: (context, editorState) {
        String? textColorHex;
        final selection = editorState.selection!;
        final nodes = editorState.getNodesInSelection(selection);
        final isHighlight = nodes.allSatisfyInSelection(selection, (delta) {
          return delta.everyAttributes((attributes) {
            textColorHex = attributes[FlowyRichTextKeys.textColor];
            return (textColorHex != null);
          });
        });
        return IconItemWidget(
          iconName: 'toolbar/text_color',
          isHighlight: isHighlight,
          iconSize: const Size.square(14),
          tooltip: AppFlowyEditorLocalizations.current.textColor,
          onPressed: () {
            _myshowColorMenu(
              context,
              editorState,
              selection,
              currentColorHex: textColorHex,
              isTextColor: true,
              textColorOptions: colorOptions,
              frameKey: frameKey, //skpark
              onChanged: onChanged, //skpark
            );
          },
        );
      },
    );
  }

  ToolbarItem _mybuildHighlightColorItem({
    List<ColorOption>? colorOptions,
    GlobalKey? frameKey, //skpark
    void Function(EditorState)? onChanged, //skpark
  }) {
    return ToolbarItem(
      id: 'editor.highlightColor',
      group: 4,
      isActive: onlyShowInTextType,
      builder: (context, editorState) {
        String? highlightColorHex;

        final selection = editorState.selection!;
        final nodes = editorState.getNodesInSelection(selection);
        final isHighlight = nodes.allSatisfyInSelection(selection, (delta) {
          return delta.everyAttributes((attributes) {
            highlightColorHex = attributes[FlowyRichTextKeys.highlightColor];
            return highlightColorHex != null;
          });
        });
        return IconItemWidget(
          iconName: 'toolbar/highlight_color',
          iconSize: const Size.square(14),
          isHighlight: isHighlight,
          tooltip: AppFlowyEditorLocalizations.current.highlightColor,
          onPressed: () {
            _myshowColorMenu(
              context,
              editorState,
              selection,
              currentColorHex: highlightColorHex,
              isTextColor: false,
              highlightColorOptions: colorOptions,
              frameKey: frameKey, //skpark
              onChanged: onChanged, //skpark
            );
          },
        );
      },
    );
  }

  void _myshowColorMenu(
    BuildContext context,
    EditorState editorState,
    Selection selection, {
    String? currentColorHex,
    List<ColorOption>? textColorOptions,
    List<ColorOption>? highlightColorOptions,
    GlobalKey? frameKey, //skpark
    void Function(EditorState)? onChanged, //skpark
    required bool isTextColor,
  }) {
    OverlayEntry? overlay;

    void dismissOverlay() {
      overlay?.remove();
      overlay = null;
    }

    Offset menuOffset = widget.dialogOffset != null ? widget.dialogOffset! : Offset.zero;

    overlay = FullScreenOverlayEntry(
      top: menuOffset.dy + 48,
      left: menuOffset.dx + 256,
      builder: (context) {
        return ColorPicker(
          isTextColor: isTextColor,
          editorState: editorState,
          selectedColorHex: currentColorHex,
          colorOptions: isTextColor
              ? textColorOptions ?? generateTextColorOptions()
              : highlightColorOptions ?? generateHighlightColorOptions(),
          onSubmittedColorHex: (color) {
            isTextColor
                ? formatFontColor(
                    editorState,
                    color,
                  )
                : formatHighlightColor(
                    editorState,
                    color,
                  );
            onChanged?.call(editorState); //skpark
            dismissOverlay();
          },
          onDismiss: dismissOverlay,
        );
      },
    ).build();
    Overlay.of(context).insert(overlay!);
  }
}

/*
const floatingToolbarHeight = 32.0;

class ToolbarWidget extends StatefulWidget {
  const ToolbarWidget({
    super.key,
    this.backgroundColor = Colors.black,
    required this.items,
    required this.editorState,
  });

  final List<ToolbarItem> items;
  final Color backgroundColor;
  final EditorState editorState;

  @override
  State<ToolbarWidget> createState() => _ToolbarWidgetState();
}

class _ToolbarWidgetState extends State<ToolbarWidget> {
  // @override
  // Widget build(BuildContext context) {
  //   var activeItems = _computeActiveItems();
  //   if (activeItems.isEmpty) {
  //     return const SizedBox.shrink();
  //   }
  //   return Material(
  //     borderRadius: BorderRadius.circular(8.0),
  //     color: widget.backgroundColor,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: SizedBox(
  //         height: floatingToolbarHeight,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: activeItems.map((item) {
  //             final builder = item.builder;
  //             return Center(
  //               child: builder!(context, widget.editorState),
  //             );
  //           }).toList(growable: false),
  //         ),
  //       ),
  //     ),
  //   );
  @override
  Widget build(BuildContext context) {
    var activeItems = _computeActiveItems();
    if (activeItems.isEmpty) {
      //print('active item is null');
      //return const SizedBox.shrink();
    }
    return Container(
      height: floatingToolbarHeight,
      width: double.infinity,
      color: widget.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: activeItems.map((item) {
          final builder = item.builder;
          return Center(
            child: builder!(context, widget.editorState),
          );
        }).toList(growable: false),
      ),
    );
  }

  Iterable<ToolbarItem> _computeActiveItems() {
    final activeItems = widget.items;
    //widget.items.where((e) => e.isActive?.call(widget.editorState) ?? false).toList();
    if (activeItems.isEmpty) {
      return [];
    }
    // sort by group.
    activeItems.sort((a, b) => a.group.compareTo(b.group));
    // insert the divider.
    return activeItems
        .splitBetween((first, second) => first.group != second.group)
        .expand((element) => [...element, placeholderItem])
        .toList()
      ..removeLast();
  }
}
*/
