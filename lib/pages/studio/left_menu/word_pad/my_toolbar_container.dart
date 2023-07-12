// ignore_for_file: unused_element

//import 'dart:math';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'my_toolbar.dart';

class MyToolbarContainerStyle {
  const MyToolbarContainerStyle({
    this.backgroundColor = Colors.black,
  });

  final Color backgroundColor;
}

/// A floating toolbar that displays at the top of the editor when the selection
///   and will be hidden when the selection is collapsed.
///
class MyToolbarContainer extends StatefulWidget {
  const MyToolbarContainer({
    super.key,
    required this.items,
    required this.editorState,
    required this.scrollController,
    required this.child,
    this.style = const MyToolbarContainerStyle(),
    required this.frameKey, //skpark
    this.dialogOffset, //skpark
  });

  final Offset? dialogOffset; //skpark
  final List<ToolbarItem> items;
  final EditorState editorState;
  final ScrollController scrollController;
  final Widget child;
  final MyToolbarContainerStyle style;
  final GlobalKey? frameKey; //skpark

  @override
  State<MyToolbarContainer> createState() => MyToolbarContainerState();
}

class MyToolbarContainerState extends State<MyToolbarContainer> with WidgetsBindingObserver {
  OverlayEntry? _toolbarContainer;
  MyToolbar? _toolbarWidget;

  EditorState get editorState => widget.editorState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    editorState.selectionNotifier.addListener(_onSelectionChanged);
    widget.scrollController.addListener(_onScrollPositionChanged);
  }

  @override
  void didUpdateWidget(MyToolbarContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.editorState != oldWidget.editorState) {
      editorState.selectionNotifier.addListener(_onSelectionChanged);
    }

    if (widget.scrollController != oldWidget.scrollController) {
      widget.scrollController.addListener(_onScrollPositionChanged);
    }
  }

  @override
  void dispose() {
    editorState.selectionNotifier.removeListener(_onSelectionChanged);
    widget.scrollController.removeListener(_onScrollPositionChanged);
    WidgetsBinding.instance.removeObserver(this);

    _clear();
    _toolbarWidget = null;

    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    _clear();
    _toolbarWidget = null;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    _showAfterDelay();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onSelectionChanged() {
    final selection = editorState.selection;
    final selectionType = editorState.selectionType;
    if (selection == null || selection.isCollapsed || selectionType == SelectionType.block) {
      _clear();
    } else {
      // uses debounce to avoid the computing the rects too frequently.
      _showAfterDelay(const Duration(milliseconds: 200));
    }
  }

  void _onScrollPositionChanged() {
    final offset = widget.scrollController.offset;
    Log.toolbar.debug('offset = $offset');

    _clear();

    //  optimize the toolbar showing logic, making it more smooth.
    // A quick idea: based on the scroll controller's offset to display the toolbar.
    _showAfterDelay(Duration.zero);
  }

  final String _debounceKey = 'show the toolbar';
  void _clear() {
    Debounce.cancel(_debounceKey);

    _toolbarContainer?.remove();
    _toolbarContainer = null;
  }

  void _showAfterDelay([Duration duration = Duration.zero]) {
    // uses debounce to avoid the computing the rects too frequently.
    Debounce.debounce(
      _debounceKey,
      duration,
      () {
        _clear(); // clear the previous toolbar.
        _showToolbar();
      },
    );
  }

  void _showToolbar() {
    if (editorState.selection?.isCollapsed ?? true) {
      return;
    }
    final rects = editorState.selectionRects();
    if (rects.isEmpty) {
      return;
    }

    //Offset offset = _findFrameOffset(); //skpark

    //final rect = _findSuitableRect(rects);
    //final ((double, double?, double?) top, left, right) = calculateToolbarOffset(rect);

    Offset barOffset = widget.dialogOffset != null ? widget.dialogOffset! : Offset.zero;

    _toolbarContainer = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: barOffset.dy + 10, //max(0, top) - floatingToolbarHeight - offset.dy, //skpark
          left: barOffset.dx + 10, //left! - offset.dx, //skprak
          //right: right,  //skpark
          child: _buildToolbar(context),
        );
      },
    );
    Overlay.of(context).insert(_toolbarContainer!);
  }

  Widget _buildToolbar(BuildContext context) {
    _toolbarWidget ??= MyToolbar(
      items: widget.items,
      editorState: editorState,
      backgroundColor: widget.style.backgroundColor,
    );
    return _toolbarWidget!;
  }

  Rect _findSuitableRect(Iterable<Rect> rects) {
    assert(rects.isNotEmpty);

    final editorOffset = editorState.renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    // find the min offset with non-negative dy.
    final rectsWithNonNegativeDy = rects.where(
      (element) => element.top >= editorOffset.dy,
    );
    if (rectsWithNonNegativeDy.isEmpty) {
      // if all the rects offset is negative, then the selection is not visible.
      return Rect.zero;
    }

    final minRect = rectsWithNonNegativeDy.reduce((min, current) {
      if (min.top < current.top) {
        return min;
      } else if (min.top == current.top) {
        return min.top < current.top ? min : current;
      } else {
        return current;
      }
    });

    return minRect;
  }

  // (double top, double? left, double? right) calculateToolbarOffset(Rect rect) {
  //   final editorOffset = editorState.renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  //   final editorSize = editorState.renderBox?.size ?? Size.zero;
  //   final editorRect = editorOffset & editorSize;
  //   final editorCenter = editorRect.center;
  //   final left = (rect.left - editorCenter.dx).abs();
  //   final right = (rect.right - editorCenter.dx).abs();
  //   final width = editorSize.width;
  //   final threshold = width / 3.0;
  //   final top = rect.top < floatingToolbarHeight ? rect.bottom + floatingToolbarHeight : rect.top;
  //   if (rect.left >= threshold && rect.right <= threshold * 2.0) {
  //     // show in center
  //     return (top, threshold, null);
  //   } else if (left >= right) {
  //     // show in left
  //     return (top, rect.left, null);
  //   } else {
  //     // show in right
  //     return (top, null, editorRect.right - rect.right);
  //   }
  // }

  Offset _findFrameOffset() {
    //skpark
    if (widget.frameKey == null) {
      return Offset.zero;
    }
    final RenderBox? box = widget.frameKey!.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Offset.zero;

    return box.localToGlobal(Offset.zero);
  }
}
