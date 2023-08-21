// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import '../../../../model/creta_model.dart';
import '../../../../pages/studio/containees/containee_nofifier.dart';
import '../../../../pages/studio/left_menu/left_menu_page.dart';
import '../../../../pages/studio/studio_variables.dart';
import 'tree_view_controller.dart';
import 'tree_view_theme.dart';
import 'tree_node.dart';
import 'models/node.dart';

/// Defines the [TreeView] widget.
///
/// This is the main widget for the package. It requires a controller
/// and allows you to specify other optional properties that manages
/// the appearance and handle events.
///
/// ```dart
/// TreeView(
///   controller: _treeViewController,
///   allowParentSelect: false,
///   supportParentDoubleTap: false,
///   onExpansionChanged: _expandNodeHandler,
///   onNodeTap: (key) {
///     setState(() {
///       _treeViewController = _treeViewController.copyWith(selectedKey: key);
///     });
///   },
///   theme: treeViewTheme
/// ),
/// ```

// ignore: must_be_immutable
class TreeView extends InheritedWidget {
  /// The controller for the [TreeView]. It manages the data and selected key.
  final TreeViewController controller;

  /// The tap handler for a node. Passes the node key.
  final Function(String, int)? onNodeTap;
  final Function(String, int)? onNodeShiftTap;
  final Function(String, bool)? onNodeHover;

  /// Custom builder for nodes. Parameters are the build context and tree node.
  final Widget Function(BuildContext, Node)? nodeBuilder;

  /// The double tap handler for a node. Passes the node key.
  final Function(String)? onNodeDoubleTap;

  /// The expand/collapse handler for a node. Passes the node key and the
  /// expansion state.
  final Function(String, bool)? onExpansionChanged;

  /// The theme for [TreeView].
  final TreeViewTheme theme;

  /// Determines whether the user can select a parent node. If false,
  /// tapping the parent will expand or collapse the node. If true, the node
  /// will be selected and the use has to use the expander to expand or
  /// collapse the node.
  final bool allowParentSelect;

  /// How the [TreeView] should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the [TreeView] should be determined by the contents
  /// being viewed.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// Whether the [TreeView] is the primary scroll widget associated with the
  /// parent PrimaryScrollController..
  ///
  /// Defaults to true.
  final bool primary;

  /// Determines whether the parent node can receive a double tap. This is
  /// useful if [allowParentSelect] is true. This allows the user to double tap
  /// the parent node to expand or collapse the parent when [allowParentSelect]
  /// is true.
  /// ___IMPORTANT___
  /// _When true, the tap handler is delayed. This is because the double tap
  /// action requires a short delay to determine whether the user is attempting
  /// a single or double tap._
  final bool supportParentDoubleTap;

  final Widget Function(CretaModel model, int index) button1;
  final Widget Function(CretaModel model) button2;

  TreeView({
    Key? key,
    required this.controller,
    this.onNodeTap,
    this.onNodeShiftTap,
    this.onNodeHover,
    this.onNodeDoubleTap,
    this.physics,
    this.onExpansionChanged,
    this.allowParentSelect = false,
    this.supportParentDoubleTap = false,
    this.shrinkWrap = false,
    this.primary = true,
    this.nodeBuilder,
    required this.button1,
    required this.button2,
    TreeViewTheme? theme,
  })  : theme = theme ?? const TreeViewTheme(),
        super(
          key: key,
          child: _TreeViewData(controller,
              shrinkWrap: shrinkWrap,
              primary: primary,
              physics: physics,
              button1: button1,
              button2: button2),
        );

  static TreeView? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);

  final Set<String> _selectedNodeSet = {};
  //final ContaineeEnum _keyType = ContaineeEnum.None;
  bool isMultiSelected(String key) {
    return _selectedNodeSet.lookup(key) != null;
  }

  int getMultiSelectedLength() {
    return _selectedNodeSet.length;
  }

  void _foldByType(ContaineeEnum keyType, List<Node> nodes) {
    for (var ele in nodes) {
      if (ele.keyType == keyType) {
        ele.expanded = false;
      } else {
        _foldByType(keyType, ele.children);
      }
    }
  }

  void _setBeeween(
    ContaineeEnum keyType,
    String firstKey,
    String lastKey,
  ) {
    bool matched = false;
    for (var ele in LeftMenuPage.nodeKeys.keys) {
      if (matched == false) {
        if (ele == firstKey) {
          matched = true;
        }
        continue;
      }
      if (ele == lastKey) {
        _selectedNodeSet.add(ele);
        return;
      }
      if (keyType == LeftMenuPage.nodeKeys[ele]) {
        _selectedNodeSet.add(ele);
      }
    }
    return;
  }

  bool setMultiSelected(Node node) {
    if (StudioVariables.isShiftPressed == true) {
      if (StudioVariables.selectedKeyType != node.keyType) {
        StudioVariables.selectedKeyType = node.keyType;
        // 만약, keyType 이 Page,Frame 이면,  모두 닫는다.
        if (node.keyType == ContaineeEnum.Page || node.keyType == ContaineeEnum.Frame) {
          _foldByType(StudioVariables.selectedKeyType, LeftMenuPage.nodes);
        }
        _selectedNodeSet.clear();
        _selectedNodeSet.add(node.key);
        return true;
      }
      if (_selectedNodeSet.isNotEmpty) {
        // 마지작 키와 현재 선택된 키사이의 모든 key (단, 동일타입) 을 모두 선택한다.
        _setBeeween(
          StudioVariables.selectedKeyType,
          _selectedNodeSet.last,
          node.key,
        );
      }
      return true;
    }
    //return changed;
    return false;
  }

  void clearMultiSelected() {
    _selectedNodeSet.clear();
  }

  @override
  bool updateShouldNotify(TreeView oldWidget) {
    return oldWidget.controller.children != controller.children ||
        oldWidget.onNodeTap != onNodeTap ||
        oldWidget.onNodeHover != onNodeHover ||
        oldWidget.onExpansionChanged != onExpansionChanged ||
        oldWidget.theme != theme ||
        oldWidget.supportParentDoubleTap != supportParentDoubleTap ||
        oldWidget.allowParentSelect != allowParentSelect;
  }
}

class _TreeViewData extends StatefulWidget {
  final TreeViewController _controller;
  final bool? shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;
  final Widget Function(CretaModel model, int index) button1;
  final Widget Function(CretaModel model) button2;

  const _TreeViewData(
    this._controller, {
    this.shrinkWrap,
    this.primary,
    this.physics,
    required this.button1,
    required this.button2,
  });

  @override
  State<_TreeViewData> createState() => _TreeViewDataState();
}

class _TreeViewDataState extends State<_TreeViewData> {
  @override
  Widget build(BuildContext context) {
    ThemeData _parentTheme = Theme.of(context);
    return Theme(
      data: _parentTheme,
      child: ListView(
        shrinkWrap: widget.shrinkWrap!,
        primary: widget.primary,
        physics: widget.physics,
        padding: EdgeInsets.zero,
        children: _childrenNode(),
      ),
    );
  }

  List<Widget> _childrenNode() {
    int index = 0;
    return widget._controller.children.map((Node node) {
      //print('--- build _TreeViewData ${node.key} selectedRoot=${TreeNode.selectedRoot}');
      return TreeNode(
        index: index++,
        node: node,
        button1: widget.button1,
        button2: widget.button2,
      );
    }).toList();
  }
}
