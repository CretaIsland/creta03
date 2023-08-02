// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import 'flutter_treeview.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../data_io/contents_manager.dart';
import '../../../data_io/frame_manager.dart';
import '../../../data_io/page_manager.dart';
import '../../../model/contents_model.dart';
import '../../../model/creta_model.dart';
import '../../../model/frame_model.dart';
import '../../../model/page_model.dart';
import '../../creta_color.dart';
import '../snippet.dart';

class MyTreeView extends StatefulWidget {
  final List<Node> nodes;
  final PageManager pageManager;
  final void Function(PageModel model) removePage;
  final void Function(FrameModel model) removeFrame;
  final void Function(ContentsModel model) removeContents;

  MyTreeView({
    Key? key,
    required this.nodes,
    required this.pageManager,
    required this.removePage,
    required this.removeFrame,
    required this.removeContents,
  }) : super(key: key);

  @override
  MyTreeViewState createState() => MyTreeViewState();
}

class MyTreeViewState extends State<MyTreeView> {
  String _selectedNode = '';
  late TreeViewController _treeViewController;
  bool docsOpen = true;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = {
    ExpanderType.none: Container(),
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined: ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined: ModContainer(ExpanderModifier.squareOutlined),
  };
  final ExpanderPosition _expanderPosition = ExpanderPosition.start;
  final ExpanderType _expanderType = ExpanderType.caret;
  final ExpanderModifier _expanderModifier = ExpanderModifier.none;
  final bool _allowParentSelect = true;
  final bool _supportParentDoubleTap = true;

  //final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  Future<String> _getSelectedNode() async {
    PageModel? pageModel = widget.pageManager.getSelected() as PageModel?;
    if (pageModel == null) {
      return '';
    }
    String pageKey = pageModel.mid;

    FrameManager? frameManager = widget.pageManager.getSelectedFrameManager();
    if (frameManager == null) {
      return pageKey;
    }
    FrameModel? frameModel = frameManager.getSelected() as FrameModel?;
    if (frameModel == null) {
      return pageKey;
    }
    String frameKey = '$pageKey/${frameModel.mid}';

    ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
    if (contentsManager == null) {
      return frameKey;
    }
    ContentsModel? contentsModel = contentsManager.getCurrentModel();
    if (contentsModel == null) {
      return frameKey;
    }
    return '$frameKey/${contentsModel.mid}';
  }

  @override
  void initState() {
    //_selectedNode = widget.pageManager.getSelected()!.id.toString();
    logger.info('myTreeView inited : _selectedNode=$_selectedNode');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TreeViewTheme treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        // color: Colors.grey.shade800,
        size: 20,
        color: CretaColor.primary[200],
        //color: MyColors.primaryColor,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
        //color: MyColors.primaryColor,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );

    return FutureBuilder(
        future: _getSelectedNode(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return Snippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }
          _selectedNode = snapshot.data!;
          //logger.info('_getSelectedNode=$_selectedNode', level: 5);
          _treeViewController = TreeViewController(
            children: widget.nodes,
            selectedKey: _selectedNode,
          );

          return TreeView(
            controller: _treeViewController,
            allowParentSelect: _allowParentSelect,
            supportParentDoubleTap: _supportParentDoubleTap,
            onExpansionChanged: (key, expanded) => _expandNode(key, expanded),
            onNodeTap: (key) {
              debugPrint('Selected: $key');
              if (_selectedNode == key) {
                return;
              }
              setState(() {
                _selectedNode = key;
                _treeViewController = _treeViewController.copyWith(selectedKey: key);
                Node? node = _treeViewController.getNode(key);
                if (node == null) {
                  logger.severe('Invalid key $key');
                  return;
                }
                if (key.contains('page=') == false) {
                  logger.severe('Invalid key $key');
                  return;
                }

                logger.info('key=$key');
                String pageMid = key.substring(0, 5 + 36);
                widget.pageManager.setSelectedMid(pageMid);

                String frameMid = '';
                if (key.contains('frame=') == false) {
                  return;
                }
                frameMid = key.substring(5 + 36 + 1, 5 + 36 + 1 + 6 + 36);
                logger.info('frameMid=$frameMid');
                FrameManager? frameManager = widget.pageManager.findFrameManager(pageMid);
                if (frameManager == null) {
                  logger.severe('Invalid key $key');
                  return;
                }
                frameManager.setSelectedMid(frameMid);
                if (key.contains('contents=') == false) {
                  return;
                }

                String contentsMid =
                    key.substring(5 + 36 + 1 + 6 + 36 + 1, 5 + 36 + 1 + 6 + 36 + 1 + 9 + 36);
                ContentsManager? contentsManager = frameManager.getContentsManager(frameMid);
                if (contentsManager == null) {
                  logger.severe('Invalid key $key');
                  return;
                }
                contentsManager.setSelectedMid(contentsMid);
              });
            },
            onNodeDoubleTap: (key) {
              logger.info('onNodeDoubleTap');
            },
            nodeBuilder: (context, node) {
              CretaModel model = node.data!;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 200,
                      padding: EdgeInsets.only(
                          top: 3 + (model.type == ExModelType.page ? 6 : 0), bottom: 3),
                      child: Text(node.label)),
                  // 삭제 버튼
                  IconButton(
                    constraints: BoxConstraints.tight(Size(16, 16)),
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      //setState(() {
                      if (model.type == ExModelType.page) {
                        widget.removePage(model as PageModel);
                        return;
                      }
                      if (model.type == ExModelType.frame) {
                        widget.removeFrame(model as FrameModel);
                        return;
                      }
                      if (model.type == ExModelType.contents) {
                        widget.removeContents(model as ContentsModel);
                        return;
                      }
                      //});
                    },
                    icon: Icon(Icons.delete_outline),
                    color: CretaColor.text[300]!,
                  ),
                ],
              );
            },
            theme: treeViewTheme,
          );
        });
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node? node = _treeViewController.getNode(key);
    if (node != null) {
      //skpark
      if (node.data != null) {
        CretaModel model = node.data;
        model.expanded = expanded;
      }

      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon: expanded ? Icons.folder_open : Icons.folder,
            ));
      } else {
        updated = _treeViewController.updateNode(key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}
