// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/model/creta_model.dart';
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

  final Widget Function(CretaModel model, int index, String key) button1;
  final Widget Function(CretaModel model, String key) button2;

  final String selectedNode;

  TreeView({
    Key? key,
    required this.selectedNode,
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
          child: _TreeViewData(
            selectedNode,
            controller,
            shrinkWrap: shrinkWrap,
            primary: primary,
            physics: physics,
            button1: button1,
            button2: button2,
          ),
        );

  static TreeView? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType(aspect: TreeView);

  static Set<String> shiftNodeSet = {};
  static Set<String> ctrlNodeSet = {};
  bool isMultiSelected(String key) {
    return TreeView.shiftNodeSet.lookup(key) != null || TreeView.ctrlNodeSet.lookup(key) != null;
  }

  int getMultiSelectedLength() {
    return TreeView.shiftNodeSet.length + TreeView.ctrlNodeSet.length;
  }

  // void _foldByType(ContaineeEnum keyType, List<Node> nodes) {
  //   for (var ele in nodes) {
  //     if (ele.keyType == keyType) {
  //       ele.expanded = false;
  //     } else {
  //       _foldByType(keyType, ele.children);
  //     }
  //   }
  // }

  void _setBeeween(
    ContaineeEnum keyType,
    String firstKey,
    String lastKey,
  ) {
    bool matched = false;
    if (lastKey == firstKey) {
      return;
    }
    for (var ele in LeftMenuPage.nodeKeys.keys) {
      if (matched == false) {
        if (ele == lastKey) {
          // firstKey 가 나오기전에 lastKey 가 먼저나온것은 순서가 바뀐것이다.
          break;
        }
        if (ele == firstKey) {
          matched = true;
        }
        continue;
      }
      if (ele == lastKey) {
        TreeView.shiftNodeSet.add(ele);
        return;
      }
      if (keyType == LeftMenuPage.nodeKeys[ele]) {
        TreeView.shiftNodeSet.add(ele);
      }
    }
    if (matched == false) {
      // match 된것이 없다면, 위 아래가 바뀐것이다.
      _setBeeween(keyType, lastKey, firstKey);
    }

    return;
  }

  bool setMultiSelected(Node node) {
    if (StudioVariables.isShiftPressed == true) {
      if (TreeView.ctrlNodeSet.isNotEmpty) {
        // 타입이 다르면 선택이 안되야 한다.
        if (StudioVariables.selectedKeyType != node.keyType) {
          //print('keyType is different');
          return false;
        }

        // 현재 shift key 와 가까운 쪽에 있는 key 를 남기고 모두 지워야 한다.
        // 가장 가까운 key 를 얻는 함수
        String? ctrlKey = _getMostClosedCtrl(node.key);

        TreeView.ctrlNodeSet.clear();
        TreeView.shiftNodeSet.clear();
        StudioVariables.selectedKeyType = node.keyType;
        TreeView.shiftNodeSet.add(node.key);
        if (ctrlKey != null) {
          TreeView.shiftNodeSet.add(ctrlKey);
          _setBeeween(
            StudioVariables.selectedKeyType,
            ctrlKey,
            node.key,
          );
          return true;
        } else {
          logger.severe('_getMostCloseCtrl return null');
        }

        return false;
      } else if (controller.selectedKey != null && controller.selectedKey!.isNotEmpty) {
        TreeView.shiftNodeSet.clear();
        StudioVariables.selectedKeyType = node.keyType;
        TreeView.shiftNodeSet.add(node.key);
        TreeView.shiftNodeSet.add(controller.selectedKey!);

        _setBeeween(
          StudioVariables.selectedKeyType,
          controller.selectedKey!,
          node.key,
        );
        //}
        return true;
      }
    }
    if (StudioVariables.isCtrlPressed) {
      // 이미 있으면 해제해야 한다.
      if (TreeView.ctrlNodeSet.contains(node.key)) {
        TreeView.ctrlNodeSet.remove(node.key);
        return true;
      }
      if (TreeView.shiftNodeSet.contains(node.key)) {
        TreeView.shiftNodeSet.remove(node.key);
        return true;
      }
      if (controller.selectedKey != null && controller.selectedKey!.isNotEmpty) {
        if (TreeView.ctrlNodeSet.isEmpty) {
          StudioVariables.selectedKeyType = Node.genKeyType(controller.selectedKey!);
          TreeView.ctrlNodeSet.add(controller.selectedKey!);
        }
      }
      if (TreeView.ctrlNodeSet.isNotEmpty) {
        if (StudioVariables.selectedKeyType != node.keyType) {
          // 타입이 다르면 add 되지 않는다.
          //print('keyType is different');
          return false;
        }
      }
      StudioVariables.selectedKeyType = node.keyType;
      TreeView.ctrlNodeSet.add(node.key);
    }

    //return changed;
    return false;
  }

  String? getLastKey(Set<String> targetSet) {
    List<String> retval = [];
    for (var ele in LeftMenuPage.nodeKeys.keys) {
      if (targetSet.contains(ele)) {
        retval.add(ele);
      }
    }
    return retval.last;
  }

  String? getFirstKey(Set<String> targetSet) {
    for (var ele in LeftMenuPage.nodeKeys.keys) {
      if (targetSet.contains(ele)) {
        return ele;
      }
    }
    return null;
  }

  String? _getMostClosedCtrl(String key) {
    //무조건 제일 나중에 찍은것을 기준으로 한다.
    return TreeView.ctrlNodeSet.last;
    // String? lastKey = getLastKey(TreeView.ctrlNodeSet);
    // String? firstKey = getFirstKey(TreeView.ctrlNodeSet);
    // for (var ele in LeftMenuPage.nodeKeys.keys) {
    //   if (lastKey != null && ele == lastKey) {
    //     // firstKey 가 나오기전에 lastKey key 가 ctrlNodeSet 아래에 있다는 뜻이다.
    //     return lastKey;
    //   }
    //   if (firstKey != null && ele == key) {
    //     // 라스트키가 나오기 전에, key 가 나왔다.  ctrlNodeSet 위에 있다는 뜻이다.
    //     return firstKey;
    //   }
    // }
    // return null;
  }

  void clearMultiSelected() {
    TreeView.shiftNodeSet.clear();
    TreeView.ctrlNodeSet.clear();
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
  final String selectedNode;
  final TreeViewController _controller;
  final bool? shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;
  final Widget Function(CretaModel model, int index, String key) button1;
  final Widget Function(CretaModel model, String key) button2;

  const _TreeViewData(
    this.selectedNode,
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
