// ignore_for_file: library_private_types_in_public_api

import 'dart:math' show pi;

import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../pages/studio/containees/containee_nofifier.dart';
import '../../../../pages/studio/left_menu/left_menu_page.dart';
import '../../../../pages/studio/studio_variables.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../menu/creta_popup_menu.dart';
import 'tree_view.dart';
import 'tree_view_theme.dart';
import 'expander_theme_data.dart';
import 'models/node.dart';
import '../../../../../design_system/component/creta_right_mouse_menu.dart';

const double _kBorderWidth = 0.75;

/// Defines the [TreeNode] widget.
///
/// This widget is used to display a tree node and its children. It requires
/// a single [Node] value. It uses this node to display the state of the
/// widget. It uses the [TreeViewTheme] to handle the appearance and the
/// [TreeView] properties to handle to user actions.
///
/// __This class should not be used directly!__
/// The [TreeView] and [TreeViewController] handlers the data and rendering
/// of the nodes.
class TreeNode extends StatefulWidget {
  //static String? selectedRoot;

  /// The node object used to display the widget state
  final Node node;
  final int index;
  final Widget Function(CretaModel model, int index, String key) button1;
  final Widget Function(CretaModel model, String key) button2;

  const TreeNode(
      {Key? key,
      required this.index,
      required this.node,
      required this.button1,
      required this.button2})
      : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;
  bool _isHover = false;
  TreeView? treeView;

  //bool _isMultiSelected = false;
  bool _isMultiSelected() {
    return treeView!.isMultiSelected(widget.node.key);
  }

  int _getMultiSelectedLength() {
    return treeView!.getMultiSelectedLength();
  }

  @override
  void initState() {
    //print('treeNode initState');
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TreeView? treeView = TreeView.of(context);
    _controller.duration = treeView!.theme.expandSpeed;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TreeNode oldWidget) {
    if (widget.node.expanded != oldWidget.node.expanded) {
      setState(() {
        _isExpanded = widget.node.expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
      });
    } else if (widget.node != oldWidget.node) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleExpand(TapDownDetails details) {
    treeView ??= TreeView.of(context);

    setState(() {
      _isExpanded = !_isExpanded;
      //print('_handleExpand ($_isExpanded)-------------------------------------------------');
      widget.node.expanded = _isExpanded; //skpark 삼각형 모양이 안바뀌길래 넣어봤는데, 됨...신기..
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          //if (!mounted) return;
          //setState(() {});
        });
      }
    });
    if (treeView!.onExpansionChanged != null) {
      treeView!.onExpansionChanged!(widget.node.key, _isExpanded);
    }
  }

  void _handleHover(bool hover) {
    treeView ??= TreeView.of(context);
    setState(() {
      _isHover = hover;
    });
    treeView?.onNodeHover?.call(widget.node.key, hover);
  }

  void _handleTap(TapDownDetails details) {
    treeView ??= TreeView.of(context);
    //TreeNode.selectedRoot = widget.node.key;
    //print('_handleTap ${treeView!.controller.selectedKey}');

    if (StudioVariables.isShiftPressed &&
        treeView!.controller.selectedKey != null &&
        treeView!.controller.selectedKey!.isNotEmpty) {
      //print('shift pressed');

      // 현재 Select 된 Key 와 shift 로 눌린 key 의 type 이 다르면 무시된다.
      ContaineeEnum selectedKeyType = Node.genKeyType(treeView!.controller.selectedKey!);
      if (selectedKeyType != widget.node.keyType) {
        StudioVariables.isShiftPressed = false;
        //print('keyType is different');
        return;
      }

      bool isMultiSelectedChanged = false;
      setState(
        () {
          //_isMultiSelected = !_isMultiSelected;
          isMultiSelectedChanged = treeView!.setMultiSelected(widget.node);
        },
      );
      if (isMultiSelectedChanged) {
        // 다른 Node 를 모두 setState 해주어야 한다.
        treeView?.onNodeShiftTap!(widget.node.key, widget.index);
      }
      return;
    }
    if (StudioVariables.isCtrlPressed) {
      bool isMultiSelectedChanged = false;
      setState(
        () {
          //_isMultiSelected = !_isMultiSelected;
          isMultiSelectedChanged = treeView!.setMultiSelected(widget.node);
        },
      );
      if (isMultiSelectedChanged) {
        // 다른 Node 를 모두 setState 해주어야 한다.
        treeView?.onNodeShiftTap!(widget.node.key, widget.index);
      }
      return;
    }

    StudioVariables.isShiftPressed = false;
    treeView?.clearMultiSelected();
    treeView?.onNodeTap!(widget.node.key, widget.index);
  }

  void _handleDoubleTap() {
    treeView ??= TreeView.of(context);
    assert(treeView != null, 'TreeView must exist in context');
    if (treeView!.onNodeDoubleTap != null) {
      treeView!.onNodeDoubleTap!(widget.node.key);
    }
  }

  Widget _buildNodeExpander() {
    TreeViewTheme theme = treeView!.theme;
    if (theme.expanderTheme.type == ExpanderType.none) return Container();

    //print('_buildNodeExpander=========================${widget.node.expanded}');
    return widget.node.isParent
        ? GestureDetector(
            onTapDown: (d) => _handleExpand(d),
            child: _TreeNodeExpander(
              speed: _controller.duration!,
              //expanded: widget.node.expanded,
              expanded: _isExpanded,
              themeData: theme.expanderTheme,
              //node: widget.node,
            ),
          )
        : Container(width: theme.expanderTheme.size);
  }

  Widget _buildNodeIcon() {
    treeView ??= TreeView.of(context);
    TreeViewTheme theme = treeView!.theme;
    bool isSelected = _isSelected();
    return Container(
      alignment: Alignment.center,
      width: widget.node.hasIcon ? theme.iconTheme.size! + theme.iconPadding : 0,
      child: widget.node.hasIcon
          ? Icon(
              widget.node.icon,
              size: theme.iconTheme.size,
              color: isSelected
                  ? widget.node.selectedIconColor ?? theme.colorScheme.onPrimary
                  : widget.node.iconColor ?? theme.iconTheme.color,
            )
          : null,
    );
  }

  Widget _buildNodeLabel() {
    // skpark : TreeView 의 nodeBuilder 가 사용되므로 사용되지 않는 코드이다.
    treeView ??= TreeView.of(context);
    TreeViewTheme theme = treeView!.theme;
    bool isSelected = _isSelected();
    final icon = _buildNodeIcon();
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: theme.verticalSpacing ?? (theme.dense ? 10 : 15),
        horizontal: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          Expanded(
            child: Text(
              widget.node.label,
              softWrap: widget.node.isParent
                  ? theme.parentLabelOverflow == null
                  : theme.labelOverflow == null,
              overflow: widget.node.isParent ? theme.parentLabelOverflow : theme.labelOverflow,
              style: widget.node.isParent
                  ? theme.parentLabelStyle.copyWith(
                      fontWeight: theme.parentLabelStyle.fontWeight,
                      color:
                          isSelected ? theme.colorScheme.onPrimary : theme.parentLabelStyle.color,
                    )
                  : theme.labelStyle.copyWith(
                      fontWeight: theme.labelStyle.fontWeight,
                      color: isSelected ? theme.colorScheme.onPrimary : null,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelected() {
    treeView ??= TreeView.of(context);
    bool retval = treeView!.controller.selectedKey != null &&
        treeView!.controller.selectedKey == widget.node.key;
    if (retval && _getMultiSelectedLength() > 0) {
      //print('isSelected but ShiftPressed-----------------');
      return false;
    }
    //print('isSelected = $retval-----------------');
    return retval;
  }

  Widget _buildNodeWidget() {
    treeView ??= TreeView.of(context);
    TreeViewTheme theme = treeView!.theme;

    bool isSelected = _isSelected();

    final Widget buttons = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.button1(widget.node.data!, widget.index, widget.node.key),
        widget.button2(widget.node.data!, widget.node.key),
      ],
    );

    // if (isSelected) {
    //   print('_buildNodeWidget(treeView.controller.selectedKey=${treeView.controller.selectedKey})');
    //   print('_buildNodeWidget(widget.node.key=${widget.node.key})');
    // }

    bool canSelectParent = treeView!.allowParentSelect;
    final arrowContainer = _buildNodeExpander();
    final labelContainer = treeView!.nodeBuilder != null
        ? treeView!.nodeBuilder!(context, widget.node)
        : _buildNodeLabel();

    final eachRow = _isHover
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: _isHover ? 200 : 272, child: labelContainer),
              buttons,
            ],
          )
        : labelContainer;
    Widget tappable = treeView!.onNodeDoubleTap != null
        ? InkWell(
            onHover: _handleHover,
            onTapDown: _handleTap,
            onDoubleTap: _handleDoubleTap,
            onSecondaryTapDown: _onRightMouseButton,
            child: eachRow,
          )
        : InkWell(
            onHover: _handleHover,
            onTapDown: _handleTap,
            onSecondaryTapDown: _onRightMouseButton,
            child: eachRow,
          );
    if (widget.node.isParent) {
      if (treeView!.supportParentDoubleTap && canSelectParent) {
        tappable = InkWell(
          onHover: _handleHover,
          onTapDown: canSelectParent ? _handleTap : _handleExpand,
          onDoubleTap: () {
            _handleExpand(TapDownDetails());
            _handleDoubleTap();
          },
          onSecondaryTapDown: _onRightMouseButton,
          child: eachRow,
        );
      } else if (treeView!.supportParentDoubleTap) {
        tappable = InkWell(
          onHover: _handleHover,
          onTapDown: _handleExpand,
          onDoubleTap: _handleDoubleTap,
          onSecondaryTapDown: _onRightMouseButton,
          child: eachRow,
        );
      } else {
        tappable = InkWell(
          onHover: _handleHover,
          onTapDown: canSelectParent ? _handleTap : _handleExpand,
          onSecondaryTapDown: _onRightMouseButton,
          child: eachRow,
        );
      }
    }
    return RepaintBoundary(
      child: Container(
        //color: isSelected ? theme.colorScheme.primary : null,
        color: isSelected // || _isMultiSelected()
            ? CretaColor.primary[200]!
            : _isMultiSelected()
                ? CretaColor.secondary[200]!
                : null, //skpark
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: theme.expanderTheme.position == ExpanderPosition.end
              ? <Widget>[
                  const SizedBox(width: 20), //skpark
                  Expanded(
                    child: tappable,
                  ),
                  arrowContainer,
                  const SizedBox(width: 20), //skpark
                ]
              : <Widget>[
                  const SizedBox(width: 20), //skpark
                  arrowContainer,
                  Expanded(
                    child: tappable,
                  ),
                  const SizedBox(width: 20), //skpark
                ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    treeView = TreeView.of(context);
    assert(treeView != null, 'TreeView must exist in context');
    final bool closed = (!_isExpanded || !widget.node.expanded) && _controller.isDismissed;
    final nodeWidget = _buildNodeWidget();
    // bool isSelected = treeView!.controller.selectedKey != null &&
    //     treeView.controller.selectedKey == widget.node.key;

    // if (isSelected) {
    //   _TreeNodeState._selectedRoot = widget.node.root;
    // }
    // bool isSelectedRoot = TreeNode.selectedRoot != null &&
    //     (widget.node.key != TreeNode.selectedRoot! &&
    //         widget.node.key.contains(TreeNode.selectedRoot!));

    //print('TreeNode.build $isSelectedRoot');

    return Container(
      // 모든 노드를 포함하는 전체 영역 박스임.
      color: Colors.white,
      // color: isSelectedRoot ? CretaColor.primary[100] : Colors.white,
      child: widget.node.isParent
          ? AnimatedBuilder(
              animation: _controller.view,
              builder: (BuildContext context, Widget? child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    nodeWidget,
                    ClipRect(
                      child: Align(
                        heightFactor: _heightFactor.value,
                        child: child,
                      ),
                    ),
                  ],
                );
              },
              child: closed
                  ? null
                  : Container(
                      margin: EdgeInsets.only(
                          left:
                              treeView!.theme.horizontalSpacing ?? treeView!.theme.iconTheme.size!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _childrenNode(),
                      ),
                    ),
            )
          : Container(
              child: nodeWidget,
            ),
    );
  }

  List<Widget> _childrenNode() {
    int index = 0;
    return widget.node.children.map((Node node) {
      return TreeNode(
        index: index++,
        node: node,
        button1: widget.button1,
        button2: widget.button2,
      );
    }).toList();
  }

  void _onRightMouseButton(TapDownDetails details) {
    //teamId = '';
    //print('rightMouse button pressed');

    CretaRightMouseMenu.showMenu(
      title: 'TreeRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            subMenu: _subMenuItems(),
            caption: CretaStudioLang['putInDepot']!,
            onPressed: () {
              // Set<String> targetList = TreeView.ctrlNodeSet;
              // if (TreeView.shiftNodeSet.isNotEmpty) {
              //   targetList.addAll(TreeView.shiftNodeSet);
              // }
              // if (targetList.isEmpty) {
              //   CretaModel? model = widget.node.data as CretaModel?;
              //   _putInDepot(model, widget.node.key);
              // } else {
              //   for (var ele in targetList) {
              //     CretaModel? model = LeftMenuPage.findModel(ele);
              //     _putInDepot(model, ele);
              //   }
              // }
            }),
        CretaMenuItem(
            caption: CretaStudioLang['tooltipDelete']!,
            onPressed: () {
              Set<String> targetList = TreeView.ctrlNodeSet;
              if (TreeView.shiftNodeSet.isNotEmpty) {
                targetList.addAll(TreeView.shiftNodeSet);
              }
              if (targetList.isEmpty) {
                CretaModel? model = widget.node.data as CretaModel?;
                _deleteNode(model);
              } else {
                for (var ele in targetList) {
                  CretaModel? model = LeftMenuPage.findModel(ele);
                  _deleteNode(model);
                }
              }
            }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: 235,
      height: 64,
      //textStyle: CretaFont.bodySmall,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }

  List<CretaMenuItem> _subMenuItems() {
    List<CretaMenuItem> teamMenuList = TeamManager.getTeamList.map((e) {
      String teamName = e.name;
      String teamId = e.mid;
      return CretaMenuItem(
          isSub: true,
          caption: '$teamName${CretaStudioLang['putInTeamDepot']!}',
          onPressed: () {
            Set<String> targetList = TreeView.ctrlNodeSet;
            if (TreeView.shiftNodeSet.isNotEmpty) {
              targetList.addAll(TreeView.shiftNodeSet);
            }
            if (targetList.isEmpty) {
              CretaModel? model = widget.node.data as CretaModel?;
              _putInDepot(model, widget.node.key, teamId);
              showSnackBar(context, CretaStudioLang['depotComplete']!);
            } else {
              for (var ele in targetList) {
                CretaModel? model = LeftMenuPage.findModel(ele);
                _putInDepot(model, ele, teamId);
              }
              showSnackBar(context, CretaStudioLang['depotComplete']!);
            }
          });
    }).toList();

    return [
      CretaMenuItem(
          isSub: true,
          caption: CretaStudioLang['putInMyDepot']!,
          onPressed: () {
            Set<String> targetList = TreeView.ctrlNodeSet;
            if (TreeView.shiftNodeSet.isNotEmpty) {
              targetList.addAll(TreeView.shiftNodeSet);
            }
            if (targetList.isEmpty) {
              CretaModel? model = widget.node.data as CretaModel?;
              _putInDepot(model, widget.node.key, null);
            } else {
              for (var ele in targetList) {
                CretaModel? model = LeftMenuPage.findModel(ele);
                _putInDepot(model, ele, null);
              }
            }
          }),
      ...teamMenuList,
    ];
  }

  Future<void> _deleteNode(CretaModel? model) async {
    if (model == null) return;

    mychangeStack.startTrans();
    if (model is PageModel) {
      model.isRemoved.set(true);
      await BookMainPage.pageManagerHolder?.removeChild(model.mid);
      if (BookMainPage.pageManagerHolder!.isSelected(model.mid)) {
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Book, doNoti: true);
      }
      BookMainPage.pageManagerHolder!.notify();
    } else if (model is FrameModel) {
      model.isRemoved.set(true);
      FrameManager? frameManager =
          BookMainPage.pageManagerHolder?.findFrameManager(model.parentMid.value);
      await frameManager?.removeChild(model.mid);
      if (frameManager != null && frameManager.isSelected(model.mid)) {
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page, doNoti: true);
      }
      BookMainPage.pageManagerHolder!.notify();
    } else if (model is ContentsModel) {
      model.isRemoved.set(true);
      String pageMid = Node.extractMid(widget.node.key, 'page=');
      // key 에서 pageMid 를 추출해야 한다.
      FrameManager? frameManager = BookMainPage.pageManagerHolder?.findFrameManager(pageMid);
      if (frameManager != null) {
        ContentsManager? contentsManager =
            frameManager.findContentsManagerByMid(model.parentMid.value);
        await contentsManager?.removeChild(model.mid);
        if (contentsManager != null && contentsManager.isSelected(model.mid)) {
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
        }
        frameManager.notify();
      }
    } else if (model is LinkModel) {
      model.isRemoved.set(true);
    }

    MyChange<CretaModel> c = MyChange<CretaModel>(
      model,
      execute: () async {
        LeftMenuPage.initTreeNodes();
        LeftMenuPage.treeInvalidate();
      },
      redo: () async {
        LeftMenuPage.initTreeNodes();
        LeftMenuPage.treeInvalidate();
      },
      undo: (CretaModel oldModel) async {
        LeftMenuPage.initTreeNodes();
        LeftMenuPage.treeInvalidate();
      },
    );
    mychangeStack.add(c);
    mychangeStack.endTrans();
  }

  void _putInDepot(CretaModel? model, String key, String? teamId) {
    if (model == null) return;
    if (model is ContentsModel) {
      ContentsManager.insertDepot([model], false, teamId); // notify 를 안해도 된다. 보관함이 열려있지 않기 때문이다.
    }
    if (model is FrameModel) {
      List<Node<dynamic>>? children = LeftMenuPage.findChildren(key);
      if (children != null) {
        for (var node in children) {
          if (node.data is ContentsModel) {
            ContentsManager.insertDepot([node.data], false, teamId);
          }
        }
      }
    }
    if (model is PageModel) {
      List<Node<dynamic>>? children = LeftMenuPage.findChildren(key);
      if (children != null) {
        for (var frameNode in children) {
          List<Node<dynamic>>? grandChildren = LeftMenuPage.findChildren(frameNode.key);
          if (grandChildren != null) {
            for (var node in grandChildren) {
              if (node.data is ContentsModel) {
                ContentsManager.insertDepot([node.data], false, teamId);
              }
            }
          }
        }
      }
    }
  }
}

class _TreeNodeExpander extends StatefulWidget {
  final ExpanderThemeData themeData;
  final bool expanded;
  final Duration _expandSpeed;
  //final Node<dynamic> node;

  const _TreeNodeExpander({
    required Duration speed,
    required this.themeData,
    required this.expanded,
    //required this.node,
  }) : _expandSpeed = speed;

  @override
  _TreeNodeExpanderState createState() => _TreeNodeExpanderState();
}

class _TreeNodeExpanderState extends State<_TreeNodeExpander> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    bool isEnd = widget.themeData.position == ExpanderPosition.end;
    if (widget.themeData.type != ExpanderType.plusMinus) {
      controller = AnimationController(
        duration: widget.themeData.animated
            ? isEnd
                ? widget._expandSpeed * 0.625
                : widget._expandSpeed
            : const Duration(milliseconds: 0),
        vsync: this,
      );
      animation = Tween<double>(
        begin: 0,
        end: isEnd ? 180 : 90,
      ).animate(controller);
    } else {
      controller = AnimationController(duration: const Duration(milliseconds: 0), vsync: this);
      animation = Tween<double>(begin: 0, end: 0).animate(controller);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_TreeNodeExpander oldWidget) {
    //print('***************_TreeNodeExpander.didUpdateWidget ${widget.expanded},${oldWidget.expanded}');
    if (widget.themeData != oldWidget.themeData || widget.expanded != oldWidget.expanded) {
      bool isEnd = widget.themeData.position == ExpanderPosition.end;
      setState(() {
        if (widget.themeData.type != ExpanderType.plusMinus) {
          controller.duration = widget.themeData.animated
              ? isEnd
                  ? widget._expandSpeed * 0.625
                  : widget._expandSpeed
              : const Duration(milliseconds: 0);
          animation = Tween<double>(
            begin: 0,
            end: isEnd ? 180 : 90,
          ).animate(controller);
        } else {
          controller.duration = const Duration(milliseconds: 0);
          animation = Tween<double>(begin: 0, end: 0).animate(controller);
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Color? _onColor(Color? color) {
    if (color != null) {
      if (color.computeLuminance() > 0.6) {
        return Colors.black;
      } else {
        return Colors.white;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    IconData arrow;
    double iconSize = widget.themeData.size;
    double borderWidth = 0;
    BoxShape shapeBorder = BoxShape.rectangle;
    Color backColor = Colors.transparent;
    Color? iconColor = widget.themeData.color ?? Theme.of(context).iconTheme.color;
    switch (widget.themeData.modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        shapeBorder = BoxShape.circle;
        backColor = widget.themeData.color ?? Colors.black;
        iconColor = _onColor(backColor);
        break;
      case ExpanderModifier.circleOutlined:
        borderWidth = _kBorderWidth;
        shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        backColor = widget.themeData.color ?? Colors.black;
        iconColor = _onColor(backColor);
        break;
      case ExpanderModifier.squareOutlined:
        borderWidth = _kBorderWidth;
        break;
    }
    switch (widget.themeData.type) {
      case ExpanderType.chevron:
        arrow = Icons.expand_more;
        break;
      case ExpanderType.arrow:
        arrow = Icons.arrow_downward;
        iconSize = widget.themeData.size > 20 ? widget.themeData.size - 8 : widget.themeData.size;
        break;
      case ExpanderType.none:
      case ExpanderType.caret:
        arrow = Icons.arrow_drop_down;
        break;
      case ExpanderType.plusMinus:
        arrow = widget.expanded ? Icons.remove : Icons.add;
        break;
    }

    Icon icon = Icon(
      arrow,
      size: iconSize,
      color: iconColor,
    );

    if (widget.expanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    return Container(
      width: widget.themeData.size + 2,
      height: widget.themeData.size + 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: shapeBorder,
        border: borderWidth == 0
            ? null
            : Border.all(
                width: borderWidth,
                color: widget.themeData.color ?? Colors.black,
              ),
        color: backColor,
      ),
      child: AnimatedBuilder(
        animation: controller,
        child: icon,
        builder: (context, child) {
          return Transform.rotate(
            angle: animation.value * (-pi / 180),
            child: child,
          );
        },
      ),
    );
  }
}
