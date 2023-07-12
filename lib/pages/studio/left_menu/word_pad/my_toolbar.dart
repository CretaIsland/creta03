import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

const floatingToolbarHeight = 32.0;

class MyToolbar extends StatefulWidget {
  const MyToolbar({
    super.key,
    this.backgroundColor = Colors.black,
    required this.items,
    required this.editorState,
  });

  final List<ToolbarItem> items;
  final Color backgroundColor;
  final EditorState editorState;

  @override
  State<MyToolbar> createState() => _MyToolbarState();
}

class _MyToolbarState extends State<MyToolbar> {
  @override
  Widget build(BuildContext context) {
    var activeItems = _computeActiveItems();
    if (activeItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: floatingToolbarHeight,
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
        ),
      ),
    );
    // @override
    // Widget build(BuildContext context) {
    //   var activeItems = _computeActiveItems();
    //   if (activeItems.isEmpty) {
    //     print('active item is null');
    //     //return const SizedBox.shrink();
    //   }
    //   return Container(
    //     height: floatingToolbarHeight,
    //     color: widget.backgroundColor,
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: activeItems.map((item) {
    //         final builder = item.builder;
    //         return Center(
    //           child: builder!(context, widget.editorState),
    //         );
    //       }).toList(growable: false),
    //     ),
    //   );
  }

  Iterable<ToolbarItem> _computeActiveItems() {
    final activeItems =
        widget.items.where((e) => e.isActive?.call(widget.editorState) ?? false).toList();
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
