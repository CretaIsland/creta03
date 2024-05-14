// ignore_for_file: deprecated_member_use

import 'dart:convert';
//import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../../../../pages/studio/containees/containee_nofifier.dart';
import '../tree_node.dart';
import '../utilities.dart';

/// Defines the data used to display a [TreeNode].
///
/// Used by [TreeView] to display a [TreeNode].
///
/// This object allows the creation of key, label and icon to display
/// a node on the [TreeView] widget. The key and label properties are
/// required. The key is needed for events that occur on the generated
/// [TreeNode]. It should always be unique.
class Node<T> {
  /// The unique string that identifies this object.
  final String key;

  /// The string value that is displayed on the [TreeNode].
  final String label;

  /// An optional icon that is displayed on the [TreeNode].
  final IconData? icon;

  /// An optional color that will be applied to the icon for this node.
  final Color? iconColor;

  /// An optional color that will be applied to the icon when this node
  /// is selected.
  final Color? selectedIconColor;

  /// The open or closed state of the [TreeNode]. Applicable only if the
  /// node is a parent
  bool expanded = false;

  /// Generic data model that can be assigned to the [TreeNode]. This makes
  /// it useful to assign and retrieve data associated with the [TreeNode]
  final T? data;

  /// The sub [Node]s of this object.
  final List<Node> children;

  /// Force the node to be a parent so that node can show expander without
  /// having children node.
  final bool parent;
  final String root;

  final ContaineeEnum keyType;

  Node({
    required this.key,
    required this.label,
    required this.root,
    required this.keyType,
    this.children = const [],
    this.expanded = false,
    this.parent = false,
    this.icon,
    this.iconColor,
    this.selectedIconColor,
    this.data,
  });

  static ContaineeEnum genKeyType(String key) {
    if (key.contains("contents=") == true) return ContaineeEnum.Contents;
    if (key.contains("frame=") == true) return ContaineeEnum.Frame;
    if (key.contains("page=") == true) return ContaineeEnum.Page;
    return ContaineeEnum.Book;
  }

  static String extractMid(String key, String prefix) {
    int pos = key.indexOf(prefix);
    return key.substring(pos, pos+prefix.length + 36);
  }

  /// Creates a [Node] from a string value. It generates a unique key.
  static Node<T> fromLabel<T>(String label, String root, ContaineeEnum keyType) {
    String key = Utilities.generateRandom();
    return Node<T>(
      key: '${key}_$label',
      keyType: keyType,
      label: label,
      root: root,
    );
  }

  /// Creates a [Node] from a Map<String, dynamic> map. The map
  /// should contain a "label" value. If the key value is
  /// missing, it generates a unique key.
  /// If the expanded value, if present, can be any 'truthful'
  /// value. Excepted values include: 1, yes, true and their
  /// associated string values.
  static Node<T> fromMap<T>(Map<String, dynamic> map) {
    String? key = map['key'];
    String label = map['label'];
    ContaineeEnum keyType = ContaineeEnum.fromInt(map['keyType'] ?? 0);
    String root = map['root'];
    var data = map['data'];
    List<Node> children = [];
    key ??= Utilities.generateRandom();
    // if (map['icon'] != null) {
    // int _iconData = int.parse(map['icon']);
    // if (map['icon'].runtimeType == String) {
    //   _iconData = int.parse(map['icon']);
    // } else if (map['icon'].runtimeType == double) {
    //   _iconData = (map['icon'] as double).toInt();
    // } else {
    //   _iconData = map['icon'];
    // }
    // _icon = const IconData(_iconData);
    // }
    if (keyType == ContaineeEnum.None) {
      keyType = genKeyType(key);
    }

    if (map['children'] != null) {
      List<Map<String, dynamic>> childrenMap = List.from(map['children']);
      children = childrenMap.map((Map<String, dynamic> child) => Node.fromMap(child)).toList();
    }
    return Node<T>(
      key: key,
      keyType: keyType,
      label: label,
      data: data,
      expanded: Utilities.truthful(map['expanded']),
      parent: Utilities.truthful(map['parent']),
      children: children,
      root: root,
    );
  }

  /// Creates a copy of this object but with the given fields
  /// replaced with the new values.
  Node<T> copyWith({
    String? key,
    ContaineeEnum? keyType,
    String? label,
    List<Node>? children,
    bool? expanded,
    bool? parent,
    IconData? icon,
    Color? iconColor,
    Color? selectedIconColor,
    T? data,
    String? root,
  }) =>
      Node<T>(
        key: key ?? this.key,
        keyType: keyType ?? this.keyType,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        iconColor: iconColor ?? this.iconColor,
        selectedIconColor: selectedIconColor ?? this.selectedIconColor,
        expanded: expanded ?? this.expanded,
        parent: parent ?? this.parent,
        children: children ?? this.children,
        data: data ?? this.data,
        root: root ?? this.root,
      );

  /// Whether this object has children [Node].
  bool get isParent => children.isNotEmpty || parent;

  /// Whether this object has a non-null icon.
  bool get hasIcon => icon != null && icon != null;

  /// Whether this object has data associated with it.
  bool get hasData => data != null;

  /// Map representation of this object
  Map<String, dynamic> get asMap {
    Map<String, dynamic> map = {
      "key": key,
      "keyType": keyType.index,
      "label": label,
      "root": root,
      "icon": icon?.codePoint,
      "iconColor": iconColor?.toString(),
      "selectedIconColor": selectedIconColor?.toString(),
      "expanded": expanded,
      "parent": parent,
      "children": children.map((Node child) => child.asMap).toList(),
    };
    if (data != null) {
      map['data'] = data as T;
    }
    //: figure out a means to check for getter or method on generic to include map from generic
    return map;
  }

  @override
  String toString() {
    return const JsonEncoder().convert(asMap);
  }

  @override
  int get hashCode {
    return hashValues(
      key,
      keyType,
      label,
      root,
      icon,
      iconColor,
      selectedIconColor,
      expanded,
      parent,
      children,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Node &&
        other.key == key &&
        other.keyType == keyType &&
        other.label == label &&
        other.root == root &&
        other.icon == icon &&
        other.iconColor == iconColor &&
        other.selectedIconColor == selectedIconColor &&
        other.expanded == expanded &&
        other.parent == parent &&
        other.data.runtimeType == T &&
        other.children.length == children.length;
  }
}
