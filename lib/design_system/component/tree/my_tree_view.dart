// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages

//import 'package:flutter_treeview/flutter_treeview.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../pages/studio/book_main_page.dart';
import '../../../pages/studio/containees/containee_nofifier.dart';
import '../../../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../../../pages/studio/containees/frame/sticker/mini_menu.dart';
import '../../../pages/studio/left_menu/left_menu_page.dart';
import '../../../pages/studio/studio_getx_controller.dart';
import '../../../pages/studio/studio_variables.dart';
import '../../buttons/creta_button.dart';
import '../../buttons/creta_button_wrapper.dart';
import '../../creta_font.dart';
import 'flutter_treeview.dart' as tree;
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

class MyTreeView extends StatefulWidget {
  //final List<tree.Node> nodes;
  final PageManager pageManager;
  final void Function(PageModel model) removePage;
  final void Function(FrameModel model) removeFrame;
  final void Function(ContentsModel model) removeContents;
  final void Function(CretaModel model, int index) showUnshow;

  MyTreeView({
    Key? key,
    //required this.nodes,
    required this.pageManager,
    required this.removePage,
    required this.removeFrame,
    required this.removeContents,
    required this.showUnshow,
  }) : super(key: key);

  @override
  MyTreeViewState createState() => MyTreeViewState();
}

class MyTreeViewState extends State<MyTreeView> {
  //List<tree.Node> _nodes = [];
  FrameEventController? _sendEvent;
  //bool _isHover = false;
  String _selectedNode = '';

  late tree.TreeViewController _treeViewController;
  bool docsOpen = true;
  bool deepExpanded = true;
  final Map<tree.ExpanderPosition, Widget> expansionPositionOptions = const {
    tree.ExpanderPosition.start: Text('Start'),
    tree.ExpanderPosition.end: Text('End'),
  };
  final Map<tree.ExpanderType, Widget> expansionTypeOptions = {
    tree.ExpanderType.none: Container(),
    tree.ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    tree.ExpanderType.arrow: Icon(Icons.arrow_downward),
    tree.ExpanderType.chevron: Icon(Icons.expand_more),
    tree.ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<tree.ExpanderModifier, Widget> expansionModifierOptions = {
    tree.ExpanderModifier.none: ModContainer(tree.ExpanderModifier.none),
    tree.ExpanderModifier.circleFilled: ModContainer(tree.ExpanderModifier.circleFilled),
    tree.ExpanderModifier.circleOutlined: ModContainer(tree.ExpanderModifier.circleOutlined),
    tree.ExpanderModifier.squareFilled: ModContainer(tree.ExpanderModifier.squareFilled),
    tree.ExpanderModifier.squareOutlined: ModContainer(tree.ExpanderModifier.squareOutlined),
  };
  final tree.ExpanderPosition _expanderPosition = tree.ExpanderPosition.start;
  final tree.ExpanderType _expanderType = tree.ExpanderType.caret;
  final tree.ExpanderModifier _expanderModifier = tree.ExpanderModifier.none;
  final bool _allowParentSelect = true;
  final bool _supportParentDoubleTap = true;

  //final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);
  //Future<String> _getSelectedNode() async {
  void setSelectedNode() {
    setState(() {
      //print('setSelectedNode');
      _selectedNode = _getSelectedNode();
    });
  }

  String _getSelectedNode() {
    if (BookMainPage.containeeNotifier!.isBook() || BookMainPage.containeeNotifier!.isNone()) {
      return '';
    }
    PageModel? pageModel = widget.pageManager.getSelected() as PageModel?;
    if (pageModel == null) {
      return '';
    }
    String pageKey = pageModel.mid;

    FrameManager? frameManager = widget.pageManager.getSelectedFrameManager();
    if (frameManager == null || BookMainPage.containeeNotifier!.isPage()) {
      return pageKey;
    }
    FrameModel? frameModel = frameManager.getSelected() as FrameModel?;
    if (frameModel == null) {
      return pageKey;
    }
    String frameKey = '$pageKey/${frameModel.mid}';

    ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
    if (contentsManager == null || BookMainPage.containeeNotifier!.isFrame()) {
      return frameKey;
    }
    ContentsModel? contentsModel = contentsManager.getCurrentModel();
    if (contentsModel == null) {
      return frameKey;
    }
    return '$frameKey/${contentsModel.mid}';
  }

  // void initNodes() {
  //   PageModel? selectedModel = widget.pageManager.getSelected() as PageModel?;
  //   if (selectedModel == null) {
  //     logger.warning('pageManagerHolder is not inited');
  //     // _nodes = [
  //     //   Node(
  //     //       label: 'samples',
  //     //       key: 'key',
  //     //       expanded: true,
  //     //       icon: Icons.folder_open, //Icons.folder,
  //     //       children: []),
  //     // ];
  //     return;
  //   }
  //   logger.info('pageManagerHolder is inited');
  //   _nodes.clear();
  //   _nodes = widget.pageManager.toNodes(selectedModel);
  // }

  // void invalidate1() {
  //   setState(() {});
  // }

  @override
  void dispose() {
    //_nodes.clear();
    super.dispose();
  }

  @override
  void initState() {
    //_selectedNode = widget.pageManager.getSelected()!.id.toString();
    //initNodes();

    final FrameEventController sendEvent = Get.find(tag: 'frame-property-to-main');
    _sendEvent = sendEvent;
    _selectedNode = _getSelectedNode();

    logger.info('myTreeView inited : _selectedNode=$_selectedNode');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_initNodes(widget.pageManager.getSelected() as PageModel?);
    tree.TreeViewTheme treeViewTheme = tree.TreeViewTheme(
      expanderTheme: tree.ExpanderThemeData(
        // 꼭지점 테마임.
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        color: Colors.grey.shade800,
        size: 24, // 20 --> 24
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
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );

    // return FutureBuilder(
    //     future: _getSelectedNode(),
    //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //       if (snapshot.hasData == false) {
    //         //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
    //         return Snippet.showWaitSign();
    //       }
    //       if (snapshot.hasError) {
    //         //error가 발생하게 될 경우 반환하게 되는 부분
    //         return Snippet.errMsgWidget(snapshot);
    //       }
    //       _selectedNode = snapshot.data!;

    //print('nodes length = ${LeftMenuPage.nodes.length}');

    //logger.info('_getSelectedNode=$_selectedNode', level: 5);
    _treeViewController = tree.TreeViewController(
      //children: widget.nodes,
      children: LeftMenuPage.nodes,
      selectedKey: _selectedNode,
    );

    return tree.TreeView(
      button1: _button1,
      button2: _button2,
      controller: _treeViewController,
      allowParentSelect: _allowParentSelect,
      supportParentDoubleTap: _supportParentDoubleTap,
      onExpansionChanged: (key, expanded) => _expandNode(key, expanded),
      //onNodeHover: (key, hover) {},
      onNodeShiftTap: (key, index) {},
      onNodeTap: (key, index) {
        StudioVariables.selectedKeyType = ContaineeEnum.None;
        //print('------------------Selected: $key');
        if (_selectedNode == key) {
          if (BookMainPage.containeeNotifier!.isBook()) {
            BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
          }
          return;
        }
        //setState(() {
        _selectedNode = key;
        _treeViewController = _treeViewController.copyWith(selectedKey: key);
        tree.Node? node = _treeViewController.getNode(key);
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
        // _selectPage
        widget.pageManager.setSelectedMid(pageMid);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);

        String frameMid = '';
        if (key.contains('frame=') == false) {
          return;
        }
        frameMid = key.substring(5 + 36 + 1, 5 + 36 + 1 + 6 + 36);
        FrameManager? frameManager = widget.pageManager.findFrameManager(pageMid);
        if (frameManager == null) {
          logger.severe('Invalid key $key');
          return;
        }
        //print('frameMid=$frameMid');
        FrameModel? frameModel = frameManager.getModel(frameMid) as FrameModel?;
        if (frameModel == null) {
          logger.severe('Invalid MID $frameMid');
          return;
        }
        ContentsManager? contentsManager = frameManager.getContentsManager(frameMid);
        if (contentsManager == null) {
          _selectFrame(frameModel, frameManager);
          return;
        }
        if (key.contains('contents=') == false) {
          _selectFrame(frameModel, frameManager);
          return;
        }
        String contentsMid =
            key.substring(5 + 36 + 1 + 6 + 36 + 1, 5 + 36 + 1 + 6 + 36 + 1 + 9 + 36);
        ContentsModel? contentsModel = contentsManager.getModel(contentsMid) as ContentsModel?;
        if (contentsModel == null) {
          logger.severe('Invalid MID $contentsMid');
          return;
        }
        //print('contentsMid=$contentsMid');
        _selectContents(
          frameModel,
          contentsModel,
          frameManager,
          contentsManager,
          index,
        );
        //});
      },
      onNodeDoubleTap: (key) {
        logger.info('onNodeDoubleTap');
      },
      nodeBuilder: (BuildContext context, tree.Node<dynamic> node) {
        // 한 Row에서 딱 Text Label 과 버튼 Area 아 있는 부분의 모양을 결정한다.
        CretaModel model = node.data!;
        bool isShow = true;
        if (model is FrameModel) {
          isShow = model.isShow.value;
        }
        if (model is ContentsModel) {
          isShow = model.isShow.value;
        }
        if (model is PageModel) {
          isShow = model.isShow.value;
        }
        double verticalPadding = model.type == ExModelType.page ? 9 : 6;
        bool isSelected = _isSelected(node);
        if (isSelected) {
          // 현재 선택된 노드의 Root Node 를 알고 있어야 한다.
          //print("selectedRoot fixed = ${node.root}");
          //tree.TreeNode.selectedRoot = node.root;
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Text(
            node.label,
            style: node.isParent
                ? isShow
                    ? CretaFont.bodySmall
                    : CretaFont.bodySmall.copyWith(color: CretaColor.text[300])
                : isShow
                    ? CretaFont.titleSmall
                    : CretaFont.titleSmall.copyWith(color: CretaColor.text[300]),
          ),
        );
      },
      theme: treeViewTheme,
    );
    //});
  }

  void _selectFrame(FrameModel frameModel, FrameManager frameManager) {
    // 프레임을 선택되게 하기 위해서 참 많은 이벤트를 날려야 한다.;
    //print('_selectFrame=${frameModel.mid}');
    MiniMenu.showFrame = true;
    //BookMainPage.miniMenuNotifier!.show();  // 안해도 된다.
    BookMainPage.containeeNotifier!.setFrameClick(true); // page 를 누른 것이 아닌것으로 하기 위해
    DraggableStickers.frameSelectNotifier?.set(frameModel.mid); // 실제 frame이 select 되도록 하기 위해
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true); // right menu tab
    frameManager.setSelectedMid(frameModel.mid,
        doNotify: false); // 현재 선택된 것이 무엇인지 확실시, 이벤트는 날리지 않는다. page_main 으로 이벤트가 가기 때문이다.
    _sendEvent!.sendEvent(frameModel); // frame_main 이 reBuild 되게 하기 위해
  }

  void _selectContents(FrameModel frameModel, ContentsModel contentsModel,
      FrameManager frameManager, ContentsManager contentsManager, int index) {
    // 프레임을 선택되게 하기 위해서 참 많은 이벤트를 날려야 한다.;
    //print('_selectContents=${contentsModel.mid}');
    MiniMenu.showFrame = false;
    //BookMainPage.miniMenuNotifier!.show();  // 안해도 된다.
    BookMainPage.containeeNotifier!.setFrameClick(true); // page 를 누른 것이 아닌것으로 하기 위해
    DraggableStickers.frameSelectNotifier?.set(frameModel.mid); // 실제 frame이 select 되도록 하기 위해
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: true); // right menu tab

    frameManager.setSelectedMid(frameModel.mid, doNotify: false);
    _sendEvent!.sendEvent(frameModel); // frame_main 이 reBuild 되게 하기 위해

    if (contentsModel.isShow.value == true) {
      ContentsModel? currentModel = contentsManager.playTimer?.getCurrentModel();
      if (currentModel != null && currentModel.mid != contentsModel.mid) {
        //print('currentModel = ${currentModel.name}, contents=${contentsModel.name}');
        contentsManager.playTimer?.releasePause();
        //print('----------------------------------------');
        contentsManager.goto(contentsModel.order.value).then((v) {
          contentsManager.setSelectedMid(contentsModel.mid, doNotify: true); // 현재 선택된 것이 무엇인지 확실시,
        });
      } else {
        contentsManager.setSelectedMid(contentsModel.mid, doNotify: true);
      }
      if (contentsModel.isMusic()) {
        contentsManager.selectMusic(contentsModel, index);
      }
    }
  }

  bool _isSelected(tree.Node<dynamic> node) {
    return _treeViewController.selectedKey != null && _treeViewController.selectedKey == node.key;
  }

  // Widget _buttons(CretaModel model) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       BTN.fill_blue_i_m(
  //         fgColor: CretaColor.text[700]!,
  //         buttonColor: CretaButtonColor.forTree,
  //         tooltip: CretaStudioLang.showUnshow,
  //         tooltipBg: CretaColor.text[200]!,
  //         icon: _isShow(model) ? Icons.visibility_outlined : Icons.visibility_off_outlined,
  //         onPressed: () {
  //           setState(() {
  //             _toggleShow(model);
  //           });
  //           widget.showUnshow(model);
  //         },
  //       ),
  //       BTN.fill_blue_i_m(
  //         fgColor: CretaColor.text[700]!,
  //         buttonColor: CretaButtonColor.forTree,
  //         tooltip: CretaStudioLang.tooltipDelete,
  //         tooltipBg: CretaColor.text[200]!,
  //         //iconImageFile: "assets/delete.svg",
  //         icon: Icons.delete,
  //         onPressed: () {
  //           // Delete Page
  //           logger.info('remove page');
  //           if (model.type == ExModelType.page) {
  //             widget.removePage(model as PageModel);
  //             return;
  //           }
  //           if (model.type == ExModelType.frame) {
  //             widget.removeFrame(model as FrameModel);
  //             return;
  //           }
  //           if (model.type == ExModelType.contents) {
  //             widget.removeContents(model as ContentsModel);
  //             return;
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _button1(CretaModel model, int index) {
    return BTN.fill_blue_i_m(
      fgColor: CretaColor.text[700]!,
      buttonColor: CretaButtonColor.forTree,
      tooltip: CretaStudioLang.showUnshow,
      tooltipBg: CretaColor.text[200]!,
      icon: _isShow(model) ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      onPressed: () {
        setState(() {
          _toggleShow(model, index);
        });
        widget.showUnshow(model, index);
      },
    );
  }

  Widget _button2(CretaModel model) {
    return BTN.fill_blue_i_m(
      fgColor: CretaColor.text[700]!,
      buttonColor: CretaButtonColor.forTree,
      tooltip: CretaStudioLang.tooltipDelete,
      tooltipBg: CretaColor.text[200]!,
      //iconImageFile: "assets/delete.svg",
      icon: Icons.delete,
      onPressed: () {
        // Delete Page
        logger.info('remove page');
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
          if (model.isMusic()) {
            ContentsManager? contentsManager = findContentsManager(model);
            contentsManager?.removeMusic(model);
          }
          return;
        }
      },
    );
  }

  bool _isShow(CretaModel model) {
    if (model.type == ExModelType.page) {
      PageModel page = model as PageModel;
      return page.isShow.value;
    }
    if (model.type == ExModelType.frame) {
      FrameModel frame = model as FrameModel;
      return frame.isShow.value;
    }
    if (model.type == ExModelType.contents) {
      ContentsModel contents = model as ContentsModel;
      return contents.isShow.value;
    }
    return true;
  }

  void _toggleShow(CretaModel model, int index) {
    if (model.type == ExModelType.page) {
      PageModel page = model as PageModel;
      page.isShow.set(!(page.isShow.value));
    }
    if (model.type == ExModelType.frame) {
      FrameModel frame = model as FrameModel;
      frame.isShow.set(!(frame.isShow.value));
    }
    if (model.type == ExModelType.contents) {
      ContentsModel contents = model as ContentsModel;
      contents.isShow.set(!(contents.isShow.value));
      if (contents.isMusic()) {
        ContentsManager? contentsManager = findContentsManager(model);
        if (contents.isShow.value == true) {
          contentsManager?.showMusic(model, index);
        } else {
          contentsManager?.unshowMusic(model);
        }
      }
    }
  }

  void _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    tree.Node? node = _treeViewController.getNode(key);
    if (node != null) {
      //skpark
      if (node.data != null) {
        CretaModel model = node.data;
        model.expanded = expanded;
      }

      List<tree.Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon: expanded ? Icons.folder_open : Icons.folder,
            ));
      } else {
        //print('_expandNode ($expanded)');
        updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
            ));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }

  ContentsManager? findContentsManager(CretaModel model) {
    PageModel? pageModel = widget.pageManager.getSelected() as PageModel?;
    if (pageModel == null) {
      return null;
    }
    FrameManager? frameManager = widget.pageManager.findFrameManager(pageModel.mid);
    if (frameManager == null) {
      logger.severe('Invalid key');
      return null;
    } // _selectPage
    return frameManager.getContentsManager(model.parentMid.value);
  }
}

class CretaColors {}

class ModContainer extends StatelessWidget {
  final tree.ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case tree.ExpanderModifier.none:
        break;
      case tree.ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case tree.ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case tree.ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case tree.ExpanderModifier.squareOutlined:
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
