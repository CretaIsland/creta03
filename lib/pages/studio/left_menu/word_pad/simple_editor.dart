import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

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
    this.editorStyle,
  });

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
          return FloatingToolbar(
            items: [
              paragraphItem,
              ...headingItems,
              ...markdownFormatItems,
              quoteItem,
              bulletedListItem,
              numberedListItem,
              linkItem,
              buildTextColorItem(
                //colorOptions: _generateTextColorOptions(), //skpark
                frameKey: widget.frameKey, //skpark
              ),
              buildHighlightColorItem(
                //colorOptions: _generateTextColorOptions(), //skpark
                frameKey: widget.frameKey, //skpark
              )
            ],
            editorState: editorState,
            scrollController: scrollController,
            frameKey: widget.frameKey, //skpark
            child: _buildDesktopEditor(
              context,
              editorState,
              scrollController,
            ),
          );
          // return Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       color: Colors.amber,
          //       height: 32,
          //     ),
          //     ToolbarWidget(
          //       items: [
          //         paragraphItem,
          //         ...headingItems,
          //         ...markdownFormatItems,
          //         quoteItem,
          //         bulletedListItem,
          //         numberedListItem,
          //         linkItem,
          //         buildTextColorItem(),
          //         buildHighlightColorItem()
          //       ],
          //       editorState: editorState,
          //       backgroundColor: Colors.black,
          //     ),
          //     SizedBox(
          //       height: 240,
          //       child: _buildDesktopEditor(
          //         context,
          //         editorState,
          //         scrollController,
          //       ),
          //     ),
          //   ],
          // );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // List<ColorOption> _generateTextColorOptions() {
  //   return [
  //     ColorOption(
  //       colorHex: Colors.grey.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorGray,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.brown.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorBrown,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.yellow.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorYellow,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.green.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorGreen,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.blue.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorBlue,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.purple.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorPurple,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.pink.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorPink,
  //     ),
  //     ColorOption(
  //       colorHex: Colors.red.toHex(),
  //       name: AppFlowyEditorLocalizations.current.fontColorRed,
  //     ),
  //   ];
  // }

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
}

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
