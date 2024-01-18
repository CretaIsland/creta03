// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:provider/provider.dart';

import 'package:hycop/common/util/logger.dart';
import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/depot_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../design_system/buttons/creta_button.dart';
import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import '../../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../design_system/creta_font.dart';
import '../../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../../lang/creta_studio_lang.dart';
import '../../../../../model/app_enums.dart';
import '../../../../../model/book_model.dart';
import '../../../../../model/contents_model.dart';
import '../../../../../model/creta_model.dart';
import '../../../../../model/depot_model.dart';
import '../../../../../model/frame_model.dart';
import '../../../../../model/page_model.dart';
import '../../../../login/creta_account_manager.dart';
import '../../../book_main_page.dart';
import '../../../left_menu/depot/depot_display.dart';
import '../../../left_menu/left_menu_page.dart';
import '../../../studio_constant.dart';
import '../../../studio_getx_controller.dart';
import '../../../studio_variables.dart';
import '../../containee_nofifier.dart';
import 'draggable_resizable.dart';
import 'instant_editor.dart';
import 'mini_menu.dart';
import 'page_bottom_layer.dart';
import 'stickerview.dart';

class FrameSelectNotifier extends ChangeNotifier {
  String? _selectedAssetId;
  String? get selectedAssetId => _selectedAssetId;

  void set(String val, {bool doNotify = true}) {
    _selectedAssetId = val;
    if (doNotify) {
      notifyListeners();
    }
  }

  void notify() => notifyListeners();
}

class DraggableStickers extends StatefulWidget {
  //static String? selectedAssetId;
  static bool isFrontBackHover = false;
  static FrameSelectNotifier? frameSelectNotifier;

  //List of stickers (elements)
  final BookModel book;
  final PageModel page;
  final double pageWidth;
  final double pageHeight;
  final FrameManager? frameManager;
  final List<Sticker> stickerList;
  final void Function(DragUpdate, String) onUpdate;
  final void Function(String) onFrameDelete;
  //final void Function(String, double) onFrameRotate;
  //final void Function(String) onFrameLink;
  final void Function(String, String) onFrameBack;
  final void Function(String, String) onFrameFront;
  final void Function(String) onFrameCopy;
  final void Function(String) onFrameMain;
  final void Function(String) onFrameShowUnshow;
  final void Function(String)? onTap;
  final void Function() onResizeButtonTap;
  final void Function(String) onComplete;
  final void Function(String) onScaleStart;
  final void Function(List<ContentsModel>) onDropPage;
  final void Function(bool) onFrontBackHover;
  //final void Function(String, ContentsModel) onDropFrame;

  const DraggableStickers({
    super.key,
    required this.book,
    required this.page,
    required this.pageWidth,
    required this.pageHeight,
    required this.frameManager,
    required this.stickerList,
    required this.onUpdate,
    required this.onFrameDelete,
    //required this.onFrameRotate,
    //required this.onFrameLink,
    required this.onFrameBack,
    required this.onFrameFront,
    required this.onFrameCopy,
    required this.onFrameMain,
    required this.onFrameShowUnshow,
    required this.onTap,
    required this.onComplete,
    required this.onScaleStart,
    required this.onResizeButtonTap,
    required this.onDropPage,
    required this.onFrontBackHover,
    //required this.onDropFrame,
  });
  @override
  State<DraggableStickers> createState() => _DraggableStickersState();
}

class _DraggableStickersState extends State<DraggableStickers> {
  // initial scale of sticker
  //final _initialStickerScale = 5.0;
  FrameEventController? _sendEvent;
  List<Sticker> stickers = [];
  late GlobalObjectKey<PageBottomLayerState> pageBottomLayerKey;

  //bool _isEditorAlreadyExist = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    //print('initState--------------------------');
    // setState(() {
    //   stickers = widget.stickerList ?? [];
    // });
    DraggableStickers.frameSelectNotifier ??= FrameSelectNotifier();
    final FrameEventController sendEvent = Get.find(tag: 'frame-property-to-main');
    _sendEvent = sendEvent;
    super.initState();

    pageBottomLayerKey =
        GlobalObjectKey<PageBottomLayerState>('PageBottomLayerKey${widget.page.mid}');
  }

  @override
  Widget build(BuildContext context) {
    stickers = widget.stickerList;

    //print('_DraggableStickersState build-----------------------------------');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameSelectNotifier>.value(
          value: DraggableStickers.frameSelectNotifier!,
        ),
      ],
      child: Stack(
        children: [
          // Positioned(
          //   left: BookMainPage.pageOffset.dx,
          //   top: BookMainPage.pageOffset.dy,
          //   child: SizedBox(
          //     //color: Colors.transparent,
          //     width: widget.pageWidth,
          //     height: widget.pageHeight, // - LayoutConst.miniMenuArea,
          //   ),
          // ),
          PageBottomLayer(
            key: pageBottomLayerKey,
            pageWidth: widget.pageWidth,
            pageHeight: widget.pageHeight,
            pageModel: widget.page,
          ),
          _pageDropZone(widget.book.mid),
          if (StudioVariables.isPreview == false && StudioVariables.applyScale >= 0.245)
            _pageController(),
          for (final sticker in stickers) _drawEachStiker(sticker),
          if (StudioVariables.isPreview == false) _drawMiniMenu(),
        ],
      ),
    );
  }

  // 페이지 footer , header 부분
  // _pageController 는 안쓰는 걸로 !!!
  // ignore: unused_element
  Widget _pageController() {
    int pageIndex = BookMainPage.pageManagerHolder!.getPageIndex(widget.page.mid);
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.pageWidth,
        height: widget.pageHeight + 2 * 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 16,
              left: 2,
              child: SizedBox(
                width: 360 * StudioVariables.applyScale,
                child: Text(
                    //'P ${(pageIndex + 1).toString().padLeft(2, '0')} | ${widget.page.name.value}',
                    'Page ${(pageIndex + 1).toString().padLeft(2, '0')}',
                    overflow: TextOverflow.ellipsis,
                    style: CretaFont.titleSmall),
              ),
            ),
            Positioned(
              top: 0,
              child: BTN.fill_gray_i_s(
                iconSize: 16,
                bgColor: LayoutConst.studioBGColor,
                onPressed: () {
                  BookMainPage.pageManagerHolder?.gotoPrev();
                },
                icon: Icons.keyboard_arrow_up_outlined,
              ),
            ),
            // RepaintBoundary(
            //   child: IgnorePointer(
            //     child: Container(
            //       //color: Colors.red.withOpacity(0.1),
            //       color: Colors.transparent,
            //       width: widget.pageWidth,
            //       height: widget.pageHeight,
            //     ),
            //   ),
            // ),
            Positioned(
              top: widget.pageHeight + 36,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: BTN.fill_gray_i_s(
                  iconSize: 16,
                  bgColor: LayoutConst.studioBGColor,
                  onPressed: () {
                    BookMainPage.pageManagerHolder?.gotoNext();
                  },
                  icon: Icons.keyboard_arrow_down_outlined,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _pageButtons() {
    return SizedBox(
      width: max<double>(360 * StudioVariables.applyScale, 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BTN.fill_gray_i_s(
              iconSize: 16,
              bgColor: LayoutConst.studioBGColor,
              tooltip: CretaStudioLang.copy,
              tooltipBg: CretaColor.text[700]!,
              icon: Icons.content_copy_outlined,
              onPressed: () {
                BookMainPage.pageManagerHolder?.copyPage(widget.page);
                setState(() {});
              }),
          BTN.fill_gray_image_m(
            iconSize: 16,
            buttonColor: CretaButtonColor.transparent,
            tooltip: CretaStudioLang.tooltipDelete,
            tooltipBg: CretaColor.text[700]!,
            iconImageFile: "assets/delete.svg",
            onPressed: () {
              // Delete Page
              logger.fine('remove page');
              BookMainPage.pageManagerHolder?.removePage(widget.page);
            },
          ),
        ],
      ),
    );
  }

  Widget _drawEachStiker(Sticker sticker) {
    //if (sticker.isEditMode && _isEditorAlreadyExist == false) {
    bool isVerticalResiable = true;
    bool isHorizontalResiable = true;
    FrameModel? frameModel = widget.frameManager!.getModel(sticker.id) as FrameModel?;
    if (frameModel != null && frameModel.isTextType()) {
      //print('3 : ${frameModel.name.value}');
      ContentsModel? contentsModel = widget.frameManager!.getFirstContents(frameModel.mid);
      if (contentsModel != null) {
        if (contentsModel.isAutoFrameHeight()) {
          isVerticalResiable = false;
        } else if (contentsModel.isAutoFrameSize()) {
          isHorizontalResiable = false;
        }
        if (contentsModel.isText()) {
          if (frameModel.isEditMode) {
            // GlobalObjectKey<InstantEditorState> editorKey = GlobalObjectKey<InstantEditorState>(
            //     'InstantEditor${sticker.pageMid}/${frameModel.mid}');
            // sticker.instantEditorKey = editorKey;
            //print('editor selected');
            return Stack(
              children: [
                IgnorePointer(
                    child: _dragableResizable(
                        sticker, frameModel, isVerticalResiable, isHorizontalResiable)),
                InstantEditor(
                    key: widget.frameManager!
                        .registerInstantEditorrKey(sticker.pageMid, frameModel.mid),
                    frameModel: frameModel,
                    frameManager: widget.frameManager,
                    onTap: widget.onTap,
                    onEditComplete: () {
                      setState(
                        () {
                          //_isEditorAlreadyExist = false;
                          frameModel.setIsEditMode(false);
                        },
                      );
                      //widget.frameManager?.notify();
                      //sticker.frameSize = newSize;
                      widget.frameManager?.refreshFrame(frameModel.mid, deep: true);
                      LeftMenuPage.initTreeNodes();
                      LeftMenuPage.treeInvalidate();
                    },
                    onChanged: (newSize) {
                      // AutoSizeText 로 인한 size변경을 전파하기 위해
                      sticker.frameSize = newSize;
                      widget.frameManager?.refreshFrame(frameModel.mid, deep: true);
                    }),
              ],
            );
            // } else if (contentsModel.isNoAutoSize()) {
            //   return Stack(
            //     children: [
            //       _dragableResizable(sticker, frameModel, isResiable),
            //       InstantEditor(
            //         readOnly: true,
            //         enabled: false,
            //         key: GlobalObjectKey('InstantEditor${frameModel.mid}'),
            //         frameModel: frameModel,
            //         frameManager: widget.frameManager,
            //         onTap: (v) {},
            //         onEditComplete: () {},
            //       ),
            //     ],
            //   );
          }
        }
      }
    }
    //print('editor not selected');

    return _dragableResizable(sticker, frameModel!, isVerticalResiable, isHorizontalResiable);
  }

  Widget _dragableResizable(
      Sticker sticker, FrameModel frameModel, bool isVerticalResiable, bool isHorizontalResiable) {
    double posX = frameModel.getRealPosX();
    double posY = frameModel.getRealPosY();

    // GlobalObjectKey<DraggableResizableState> draggableResizableKey =
    //     GlobalObjectKey<DraggableResizableState>(
    //         'DraggableResizable${sticker.pageMid}/${frameModel.mid}');

    // sticker.dragableResiableKey = draggableResizableKey;

    //
    return DraggableResizable(
      key: widget.frameManager!.registerDragableResiableKey(sticker.pageMid, frameModel.mid),
      isVerticalResiable: isVerticalResiable,
      isHorizontalResiable: isHorizontalResiable,
      sticker: sticker,
      // mid: sticker.id,
      // pageMid: sticker.pageMid,
      // angle: sticker.angle,
      // borderWidth: sticker.borderWidth,
      // isMain: sticker.isMain,
      // frameSize: sticker.isText == true
      //     ? Size(64 * _initialStickerScale / 3, 64 * _initialStickerScale / 3)
      //     : sticker.frameSize,
      //position: sticker.position + BookMainPage.pageOffset,
      realPosition: Offset(posX, posY),
      frameModel: frameModel,
      pageWidth: widget.pageWidth,
      pageHeight: widget.pageHeight, // - LayoutConst.miniMenuArea,
      // Size of the sticker

      //canTransform: DraggableStickers.selectedAssetId == sticker.id ? true : false,
      onResizeButtonTap: widget.onResizeButtonTap,
      //  true
      /*sticker.id == state.selectedAssetId*/
      onUpdate: (update, mid) {
        logger.finest(
            "oldposition=${sticker.position.toString()}, new=${update.position.toString()}");

        sticker.angle = update.angle;
        sticker.frameSize = update.size;
        sticker.position = update.position;
        widget.onUpdate.call(update, mid);
        logger.finest("saved");
      },
      // draggable_point 로 이사갔음.
      // onTap: () {
      //   logger.fine('onTap : from Gest2');
      //   BookMainPage.containeeNotifier!.setFrameClick(true);
      // },
      onComplete: () {
        logger.fine('onComplete : from DraggableResizable...');
        //setState(() {
        widget.onComplete.call(sticker.id);
        //});
      },
      onScaleStart: () {
        //print('DraggableResizable onScaleStart --------------------------');

        widget.onScaleStart.call(sticker.id);

        FrameModel? frameModel = widget.frameManager!.getModel(sticker.id) as FrameModel?;
        if (frameModel != null && frameModel.isTextType()) {
          //print('4 : ${frameModel.name.value}');
          ContentsModel? contentsModel = widget.frameManager!.getFirstContents(frameModel.mid);
          if (contentsModel != null && contentsModel.isText() && contentsModel.isAutoFontSize()) {
            // 마우스를 끌기 시작하여, fontSize 가 변하기 시작한다는 사실을 알림.
            logger.info('DraggableResizable fontSizeNotifier');
            CretaAutoSizeText.fontSizeNotifier?.start(doNotify: true); // rightMenu 에 전달
          }
        }
      },

      // To update the layer (manage position of widget in stack)
      onLayerTapped: () {
        var listLength = stickers.length;
        var ind = stickers.indexOf(sticker);
        stickers.remove(sticker);
        if (ind == listLength - 1) {
          stickers.insert(0, sticker);
        } else {
          stickers.insert(listLength - 1, sticker);
        }
        DraggableStickers.frameSelectNotifier?.set(sticker.id, doNotify: false);
        logger.finest('onLayerTapped');
        setState(() {});
      },

      // To edit (Not implemented yet)
      onEdit: () {},

      // To Delete the sticker
      onFrameDelete: () async {
        {
          stickers.remove(sticker);
          widget.onFrameDelete.call(sticker.id);
          setState(() {});
        }
      },
      child: (StudioVariables.isHandToolMode == false) //&& StudioVariables.isNotLinkState
          ? InkWell(
              splashColor: Colors.transparent,
              // onDoubleTap: () {
              //   ContentsManager? contentsManager =
              //       widget.frameManager!.getContentsManager(frameModel.mid);
              //   if (contentsManager == null) {
              //     return;
              //   }
              //   ContentsModel? selected = contentsManager.getSelected() as ContentsModel?;

              //   if (selected == null) {
              //     // 클릭되어 있지 않으면 싱글클릭과 동일하게 동작한다.
              //     BookMainPage.containeeNotifier!.setFrameClick(true);
              //     DraggableStickers.frameSelectNotifier?.set(sticker.id);
              //     widget.onTap?.call(sticker.id);
              //     selected = contentsManager.getSelected() as ContentsModel?;
              //     if (selected == null) {
              //       return;
              //     }
              //   }

              //   // double click action !!!
              //   _gotoEditMode(contentsManager, selected, frameModel, sticker);
              // },
              onSecondaryTapDown: (details) {
                // 오른쪽 마우스 버튼 --> 메뉴
                if (DraggableStickers.frameSelectNotifier != null) {
                  if (DraggableStickers.frameSelectNotifier!.selectedAssetId != sticker.id) return;
                }
                _showRightMouseMenu(details, frameModel, sticker);
              },
              onTap: () {
                //print('DraggableSticker');
                if (DraggableStickers.frameSelectNotifier != null &&
                    DraggableStickers.frameSelectNotifier!.selectedAssetId == sticker.id) {
                  if (frameModel.isTextType()) {
                    ContentsManager? contentsManager =
                        widget.frameManager!.getContentsManager(frameModel.mid);
                    if (contentsManager != null) {
                      ContentsModel? selected = contentsManager.getSelected() as ContentsModel?;
                      if (selected != null && (selected.isText() || selected.isDocument())) {
                        // Frame이 이미 선택되어 있고, 텍스트일때는 또 click 이 일어나면 더블클릭으로 간주된다.
                        //print('text edit');
                        if (frameModel.isEditMode == false) {
                          _gotoEditMode(contentsManager, selected, frameModel, sticker);
                        }
                        //return;
                      }
                    }
                  }
                }
                // single click action !!!
                // To update the selected widget
                DraggableStickers.frameSelectNotifier?.set(sticker.id);
                widget.onTap?.call(sticker.id);
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                //child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
                child: sticker,
              ),
              //),
            )
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              //child: sticker.isText == true ? FittedBox(child: sticker) : sticker,
              child: sticker,
            ),
      //),
    );
  }

  void _gotoEditMode(
    ContentsManager contentsManager,
    ContentsModel selected,
    FrameModel frameModel,
    Sticker sticker,
  ) {
    if (frameModel.isTextType()) {
      //print('Frame double is tapped ${selected.contentsType}');
      //print('selected  =${selected.parentMid.value}');
      //print('sticker.id=${sticker.id}');
      if (selected.isText() && selected.parentMid.value == sticker.id) {
        // Text Editor
        setState(
          () {
            frameModel.setIsEditMode(true);
            // 편집모드에서도, 선택했던 프레임이 다시 선택되어 있어야 한다.
            BookMainPage.containeeNotifier!.setFrameClick(true);
            DraggableStickers.frameSelectNotifier?.set(sticker.id);
            widget.onTap?.call(sticker.id);
          },
        );
      } else if (selected.isDocument()) {
        // // HTML Editor
        // Size realSize = Size(frameModel.width.value * StudioVariables.applyScale,
        //     frameModel.height.value * StudioVariables.applyScale);

        // // ignore: use_build_context_synchronously
        // Size screenSize = MediaQuery.of(context).size;
        // Size dialogSize = screenSize / 2;
        // Offset dialogOffset = Offset(
        //   (screenSize.width - dialogSize.width) / 2,
        //   (screenSize.height - dialogSize.height) / 2,
        // ); //rootBundle.loadString('assets/example.json');

        // CretaDocWidget.showHtmlEditor(
        //   context,
        //   selected,
        //   realSize,
        //   frameModel,
        //   widget.frameManager!,
        //   selected.getURI(),
        //   dialogOffset,
        //   dialogSize,
        //   onPressedOK: (value) {
        //     setState(() {
        //       selected.remoteUrl = value;
        //       contentsManager.setToDB(selected).then((value) {
        //         _sendEvent?.sendEvent(frameModel);
        //         return null;
        //       });
        //     });
        //     Navigator.of(context).pop();
        //   },
        // );
      }
    }
  }

  void _showRightMouseMenu(TapDownDetails details, FrameModel frameModel, Sticker sticker) {
    logger.fine('right mouse button clicked ${details.globalPosition}');
    logger.fine('right mouse button clicked ${details.localPosition}');

    bool isFullScreen = frameModel.isFullScreenTest(widget.book);

    double menuWidth = 291;

    ContentsModel? contentsModel = widget.frameManager!.getFirstContents(frameModel.mid);
    ContentsManager? contentsManager = widget.frameManager!.getContentsManager(frameModel.mid);

    CretaRightMouseMenu.showMenu(
      title: 'frameRightMouseMenu',
      context: context,
      popupMenu: [
        if (frameModel.frameType == FrameType.none && StudioVariables.isPreview == false)
          CretaMenuItem(
              subMenu: _subMenuItems(frameModel, true),
              caption: CretaStudioLang.putInDepotContents,
              onPressed: () {
                // ContentsManager? contentsManager =
                //     widget.frameManager!.getContentsManager(frameModel.mid);
                // if (contentsManager != null) {
                //   ContentsModel? selected = contentsManager.getSelected() as ContentsModel?;
                //   if (selected != null) {
                //     contentsManager.putInDepot(selected);
                //   }
                // }
              }),
        if (frameModel.frameType == FrameType.none && StudioVariables.isPreview == false)
          CretaMenuItem(
              subMenu: _subMenuItems(frameModel, false),
              caption: CretaStudioLang.putInDepotFrame,
              onPressed: () {
                // ContentsManager? contentsManager =
                //     widget.frameManager!.getContentsManager(frameModel.mid);
                // contentsManager?.putInDepot(null);
              }),
        CretaMenuItem(
            caption: isFullScreen ? CretaStudioLang.realSize : CretaStudioLang.maxSize,
            onPressed: () {
              logger.fine('${CretaStudioLang.maxSize} menu clicked');
              setState(() {
                frameModel.toggleFullscreen(isFullScreen, widget.book);
                _sendEvent!.sendEvent(frameModel);
                _notifyToThumbnail();
              });
            }),
        if (frameModel.isBackgroundMusic() == false)
          CretaMenuItem(
              caption: frameModel.isShow.value ? CretaStudioLang.unshow : CretaStudioLang.show,
              onPressed: () {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                mychangeStack.startTrans();
                frameModel.isShow.set(!frameModel.isShow.value);
                frameModel.changeOrderByIsShow(widget.frameManager!);
                mychangeStack.endTrans();
                widget.onFrameShowUnshow.call(frameModel.mid);
                if (frameModel.isOverlay.value == true) {
                  BookMainPage.pageManagerHolder!.notify();
                }
              }),
        if (StudioVariables.isPreview == false)
          CretaMenuItem(caption: '', onPressed: () {}), //divider
        if (StudioVariables.isPreview == false)
          CretaMenuItem(
              caption: CretaStudioLang.copy,
              onPressed: () {
                StudioVariables.clipFrame(frameModel, widget.frameManager!);
                //widget.onFrameShowUnshow.call(frameModel.mid);
              }),
        if (StudioVariables.isPreview == false)
          CretaMenuItem(
              caption: CretaStudioLang.crop,
              onPressed: () {
                frameModel.isRemoved.set(true);
                StudioVariables.cropFrame(frameModel, widget.frameManager!);
                widget.onFrameShowUnshow.call(frameModel.mid);
              }),
        if (StudioVariables.isPreview == false &&
            frameModel.isTextType() &&
            contentsModel != null &&
            contentsModel.isText())
          CretaMenuItem(
              caption: CretaStudioLang.copyStyle,
              onPressed: () {
                ContentsModel.setStyleInClipBoard(contentsModel, context);
              }),
        if (StudioVariables.isPreview == false &&
            frameModel.isTextType() &&
            contentsModel != null &&
            contentsModel.isText() &&
            ContentsModel.sytleInClipBoard != null)
          CretaMenuItem(
              caption: CretaStudioLang.pasteStyle,
              onPressed: () {
                mychangeStack.startTrans();
                ContentsModel.pasteStyle(contentsModel);
                mychangeStack.endTrans();
                contentsManager?.notify();
                if (contentsModel.isAutoFrameOrSide()) {
                  _sendEvent!.sendEvent(contentsManager!.frameModel);
                  _notifyToThumbnail();
                  //widget.frameManager?.notify();
                }
              }),
        if (StudioVariables.isPreview == false)
          CretaMenuItem(caption: '', onPressed: () {}), //divider
        if (StudioVariables.isPreview == false && frameModel.isMusicType() == true) // 뮤직의 경우
          CretaMenuItem(
              caption: frameModel.isBackgroundMusic()
                  ? CretaStudioLang.foregroundMusic
                  : CretaStudioLang.backgroundMusic,
              onPressed: () {
                logger.fine('${CretaStudioLang.backgroundMusic} menu clicked');
                setState(() {
                  frameModel.toggeleBackgoundMusic(
                      !frameModel.isBackgroundMusic(), widget.frameManager!, widget.book);
                  //_sendEvent!.sendEvent(frameModel);
                  BookMainPage.pageManagerHolder!.notify();
                });
              }),
        if (StudioVariables.isPreview == false && frameModel.isMusicType() == false)
          CretaMenuItem(
              caption: frameModel.isOverlay.value
                  ? CretaStudioLang.noOverlayFrame
                  : CretaStudioLang.overlayFrame,
              onPressed: () {
                logger.fine('${CretaStudioLang.overlayFrame} menu clicked');
                setState(() {
                  frameModel.toggeleOverlay(!frameModel.isOverlay.value, widget.frameManager!);
                  //_sendEvent!.sendEvent(frameModel);
                  //BookMainPage.pageManagerHolder!.notify();
                });
              }),
        if (StudioVariables.isPreview == false &&
            frameModel.isOverlay.value == true &&
            frameModel.parentMid.value != sticker.pageMid)
          CretaMenuItem(
              caption: frameModel.isThisPageExclude(sticker.pageMid)
                  ? CretaStudioLang.noOverlayExclude
                  : CretaStudioLang.overlayExclude,
              onPressed: () {
                bool value = !frameModel.isThisPageExclude(sticker.pageMid);
                setState(() {
                  if (value == true) {
                    frameModel.addOverlayExclude(sticker.pageMid);
                  } else {
                    frameModel.removeOverlayExclude(sticker.pageMid);
                  }
                  _sendEvent!.sendEvent(frameModel);
                  BookMainPage.pageManagerHolder?.invalidatThumbnail(sticker.pageMid);
                  //_notifyToThumbnail();
                  //BookMainPage.pageManagerHolder!.notify();
                });
              }),
        // CretaMenuItem(
        //     disabled: StudioVariables.clipBoard == null ? true : false,
        //     caption: CretaStudioLang.paste,
        //     onPressed: () {
        //
        //     }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: menuWidth,
      //height: menuHeight,
      //textStyle: CretaFont.bodySmall,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }

  List<CretaMenuItem> _subMenuItems(FrameModel frameModel, bool isContents) {
    List<CretaMenuItem> teamMenuList = CretaAccountManager.getTeamList.map((e) {
      String teamName = e.name;
      String teamId = e.mid;
      return CretaMenuItem(
          isSub: true,
          caption: '$teamName${CretaStudioLang.putInTeamDepot}',
          onPressed: () {
            _putInDepot(frameModel, isContents, teamId);
            showSnackBar(context, CretaStudioLang.depotComplete);
          });
    }).toList();

    return [
      CretaMenuItem(
          isSub: true,
          caption: CretaStudioLang.putInMyDepot,
          onPressed: () {
            _putInDepot(frameModel, isContents, null);
            showSnackBar(context, CretaStudioLang.depotComplete);
          }),
      ...teamMenuList,
    ];
  }

  // ignore: unused_element
  // void _showTeamListMenu(double dx, double dy, FrameModel frameModel, bool isContents) {
  //   List<CretaMenuItem> teamMenuList = CretaAccountManager.getTeamList.map((e) {
  //     String teamName = e.name;
  //     return CretaMenuItem(
  //         caption: '$teamName${CretaStudioLang.putInTeamDepot}',
  //         onPressed: () {
  //           _putInDepot(frameModel, isContents);
  //         });
  //   }).toList();

  //   print('_showTeamListMenu');

  //   CretaRightMouseMenu.showMenu(
  //     title: 'frameRightMouseMenu2',
  //     context: context,
  //     popupMenu: [
  //       CretaMenuItem(
  //           caption: CretaStudioLang.putInMyDepot,
  //           onPressed: () {
  //             _putInDepot(frameModel, isContents);
  //           }),
  //       ...teamMenuList,
  //     ],
  //     itemHeight: 24,
  //     x: dx,
  //     y: dy,
  //     width: 283,
  //     height: 100,
  //     //textStyle: CretaFont.bodySmall,
  //     iconSize: 12,
  //     alwaysShowBorder: true,
  //     borderRadius: 8,
  //   );
  // }

  void _putInDepot(FrameModel frameModel, bool isContents, String? teamId) {
    if (isContents) {
      ContentsManager? contentsManager = widget.frameManager!.getContentsManager(frameModel.mid);
      if (contentsManager != null) {
        ContentsModel? selected = contentsManager.getSelected() as ContentsModel?;
        if (selected != null) {
          contentsManager.putInDepot(selected, teamId);
        }
      }
    } else {
      // frame Case
      ContentsManager? contentsManager = widget.frameManager!.getContentsManager(frameModel.mid);
      contentsManager?.putInDepot(null, teamId);
    }
  }

  Sticker? _getSelectedSticker() {
    if (DraggableStickers.frameSelectNotifier == null ||
        DraggableStickers.frameSelectNotifier!.selectedAssetId == null) {
      return null;
    }
    for (Sticker sticker in widget.stickerList) {
      if (sticker.id == DraggableStickers.frameSelectNotifier!.selectedAssetId!) {
        return sticker;
      }
    }
    return null;
  }

  // ignore: unused_element
  Widget _drawMiniMenu() {
    //return Consumer<ContaineeNotifier>(builder: (context, notifier, child) {
    return Consumer<MiniMenuNotifier>(builder: (context, notifier, child) {
      logger.fine(
          'Consumer<MiniMenuNotifier> _drawMiniMenu(${BookMainPage.miniMenuNotifier!.isShow})------------------------------------------');

      Sticker? selectedSticker = _getSelectedSticker();
      if (selectedSticker == null) {
        return const SizedBox.shrink();
      }

      FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
      if (frameManager == null) {
        logger.warning('Selected frameManager is null');
        return const SizedBox.shrink();
      }

      FrameModel? frameModel = frameManager.getModel(selectedSticker.id) as FrameModel?;
      if (frameModel == null) {
        logger.warning('Selected frameModel is null');
        return const SizedBox.shrink();
      }

      ContentsManager? contentsManager = frameManager.getContentsManager(frameModel.mid);
      if (contentsManager == null) {
        logger.warning('Selected ConterntsManager is null');
        return const SizedBox.shrink();
      }
      // if (_isContents) {
      //   if (contentsManager.isEmpty()) {
      //     return const SizedBox.shrink();
      //   }
      //   if (contentsManager.getSelected() == null) {
      //     return const SizedBox.shrink();
      //   }
      //   if (BookMainPage.miniMenuContentsNotifier!.isShow == false) {
      //     return const SizedBox.shrink();
      //   }
      // }
      //print('MiniMenu---------------');
      return

          //  BookMainPage.miniMenuNotifier!.isShow == false
          //     ? const SizedBox.shrink()
          //     :
          MiniMenu(
        key: GlobalObjectKey('MiniMenu${selectedSticker.pageMid}/${selectedSticker.id}'),
        contentsManager: contentsManager,
        frameManager: frameManager,
        sticker: selectedSticker,
        pageHeight: widget.pageHeight,
        frameModel: frameModel,
        onFrameDelete: () {
          logger.fine('onFrameDelete');
          stickers.remove(selectedSticker);
          widget.onFrameDelete.call(selectedSticker.id);
          //setState(() {});
        },
        onFrameBack: () {
          logger.fine('onFrameBack');
          var ind = stickers.indexOf(selectedSticker);
          int newIndex = _getPrevIndex(ind, selectedSticker.isOverlay);
          if (newIndex >= 0) {
            // 제일 뒤에 있는것은 제외한다.
            // 뒤로 빼는 것이므로, 현재 보다 한숫자 작은 인덱스로 보내야 한다.
            stickers.remove(selectedSticker);
            stickers.insert(newIndex, selectedSticker);
            Sticker target = stickers[ind];
            widget.onFrameBack.call(selectedSticker.id, target.id);
            setState(() {});
          }
        },
        onFrontBackHover: widget.onFrontBackHover,
        onFrameFront: () {
          logger.fine('onFrameFront');
          var ind = stickers.indexOf(selectedSticker);
          int newIndex = _getNextIndex(ind, selectedSticker.isOverlay);
          if (newIndex > 0) {
            // 제일 앞에 있는것은 제외한다.
            // 앞으로 빼는 것이므로, 현재 보다 한숫자 큰 인덱스로 보내야 한다.
            stickers.remove(selectedSticker);
            stickers.insert(newIndex, selectedSticker);
            Sticker target = stickers[ind];
            widget.onFrameFront.call(selectedSticker.id, target.id);
            setState(() {});
          }
        },
        onFrameMain: () {
          logger.fine('onFrameMain');
          selectedSticker.isMain = true;
          widget.onFrameMain.call(selectedSticker.id);
          //setState(() {});
        },
        onFrameShowUnshow: () {
          logger.fine('onFrameShowUnshow');
          //selectedSticker.isMain = true;
          widget.onFrameShowUnshow.call(selectedSticker.id);
          //setState(() {});
        },
        onFrameCopy: () {
          logger.fine('onFrameCopy');
          widget.onFrameCopy.call(selectedSticker.id);
          //setState(() {});
        },
        // onFrameRotate: () {
        //   double reverse = 180 / pi;
        //   double before = (selectedSticker.angle * reverse).roundToDouble();
        //   logger.fine('onFrameRotate  before $before');
        //   int turns = (before / 15).round() + 1;
        //   double after = ((turns * 15.0) % 360).roundToDouble();
        //   selectedSticker.angle = after / reverse;
        //   logger.fine('onFrameRotate  after $after');
        //   widget.onFrameRotate.call(selectedSticker.id, after);
        //   setState(() {});
        // },
        // onFrameLink: () {
        //   logger.fine('onFrameLink');
        //   widget.onFrameLink.call(selectedSticker.id);
        //   //setState(() {});
        // },

        onContentsFlip: () {
          logger.fine('onContentsFlip');
        },
        onContentsRotate: () {
          logger.fine('onContentsRotate');
        },
        onContentsCrop: () {
          logger.fine('onContentsCrop');
        },
        onContentsFullscreen: () {
          logger.fine('onContentsFullscreen');
        },
        onContentsDelete: () {
          logger.fine('onContentsDelete');
          contentsManager.removeSelected(context);
          //setState(() {});
        },
        onContentsEdit: () {
          logger.fine('onContentsEdit');
        },
      );
    });
  }

  int _getNextIndex(int currentIndex, bool isOverlay) {
    var listLength = stickers.length;
    if (currentIndex >= listLength - 1) return -1;
    for (int i = currentIndex + 1; i < listLength; i++) {
      if (stickers[i].isOverlay == isOverlay) {
        return i;
      }
    }
    return -1;
  }

  int _getPrevIndex(int currentIndex, bool isOverlay) {
    if (currentIndex < 1) return -1;
    for (int i = currentIndex - 1; i >= 0; i--) {
      if (stickers[i].isOverlay == isOverlay) {
        return i;
      }
    }
    return -1;
  }

  // Widget _drawMiniMenuContents() {
  //   return Consumer<MiniMenuContentsNotifier>(builder: (context, notifier, child) {
  //     logger.fine('_drawMiniMenu()');

  //     if (BookMainPage.miniMenuContentsNotifier!.isShow == false) {
  //       return const SizedBox.shrink();
  //     }

  //     FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  //     if (frameManager == null) {
  //       return const SizedBox.shrink();
  //     }
  //     ContentsManager? contentsManager = frameManager.getContentsManager(widget.frameModel!.mid);
  //     if (contentsManager == null) {
  //       return const SizedBox.shrink();
  //     }
  //     if (contentsManager.isEmpty()) {
  //       return const SizedBox.shrink();
  //     }
  //     if (contentsManager.getSelected() == null) {
  //       return const SizedBox.shrink();
  //     }
  //     return MiniMenuContents(
  //       key: const ValueKey('MiniMenuContents'),
  //       contentsManager: contentsManager,
  //       parentPosition: selectedSticker!.position,
  //       parentSize: selectedSticker!.size,
  //       parentBorderWidth: selectedSticker!.borderWidth,
  //       pageHeight: widget.pageHeight,
  //       onContentsFlip: () {
  //         logger.fine('onContentsFlip');
  //       },
  //       onContentsRotate: () {
  //         logger.fine('onContentsRotate');
  //       },
  //       onContentsCrop: () {
  //         logger.fine('onContentsCrop');
  //       },
  //       onContentsFullscreen: () {
  //         logger.fine('onContentsFullscreen');
  //       },
  //       onContentsDelete: () {
  //         logger.fine('onContentsDelete');
  //         contentsManager.removeSelected(context);
  //         //setState(() {});
  //       },
  //       onContentsEdit: () {
  //         logger.fine('onContentsEdit');
  //       },
  //     );
  //   });
  // }

  Widget _pageDropZone(String bookMid) {
    return DragTarget<CretaModel>(
      // 보관함에서 끌어다 넣기
      builder: (context, candidateData, rejectedData) {
        return DropZoneWidget(
          bookMid: bookMid,
          parentId: '',
          onDroppedFile: (modelList) {
            //logger.fine('page dropZone contents added ${model.mid}');
            //model.isDynamicSize.set(true, save: false, noUndo: true);
            widget.onDropPage(modelList); // 동영상에 맞게 frame size 를 조절하라는 뜻
          },
        );
      },
      onMove: (data) {
        //print('onMove');
        if (widget.page.dragOnMove == false) {
          widget.page.dragOnMove = true;
          pageBottomLayerKey.currentState?.invalidate();
        }
      },
      onLeave: (data) {
        //print('onLeave');
        if (widget.page.dragOnMove == true) {
          widget.page.dragOnMove = false;
          pageBottomLayerKey.currentState?.invalidate();
        }
      },
      onAccept: (data) async {
        //print('drop depotModel =${data.contentsMid}');
        // DepotManager? depotManager = DepotDisplay.getMyTeamManager(null);
        // if (depotManager != null) {
        //   ContentsModel? newModel = await depotManager.copyContents(data);
        //   if (newModel != null) {
        //     widget.onDropPage([newModel]);
        //   }
        // }
        // widget.page.dragOnMove = false;
        // pageBottomLayerKey.currentState?.invalidate();
        if (data is DepotModel) {
          //print('drop depotModel =${data.contentsMid}');
          DepotManager? depotManager = DepotDisplay.getMyTeamManager(null);
          if (depotManager != null) {
            ContentsModel? newModel = await depotManager.copyContents(data);
            if (newModel != null) {
              widget.onDropPage([newModel]);
            }
          }
          widget.page.dragOnMove = false;
          pageBottomLayerKey.currentState?.invalidate();
        } else if (data is ContentsModel) {
          //print('drop gifModel =${data}');
          widget.onDropPage([data]);
        }
      },
      onWillAccept: (data) {
        return true;
      },
    );
  }

  void _notifyToThumbnail() {
    BookMainPage.pageManagerHolder?.invalidatThumbnail(widget.page.mid);
  }

  // Widget _frameDropZone(Sticker sticker, {required Widget child}) {
  //   return DropZoneWidget(
  //     parentId: '',
  //     onDroppedFile: (model) {
  //       logger.fine('frame dropzone contents added ${model.mid}');
  //       //model.isDynamicSize.set(true, save: false, noUndo: true);
  //       widget.onDropFrame(sticker.id, model); // 동영상에 맞게 frame size 를 조절하라는 뜻
  //     },
  //     child: child,
  //   );
  // }
}
