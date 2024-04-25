// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../data_io/book_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../routes.dart';
import 'book_grid_page.dart';
import 'studio_constant.dart';
import 'studio_variables.dart';

class BookGridItem extends StatefulWidget {
  final int index;
  final BookModel? bookModel;
  final double width;
  final double height;
  final BookManager bookManager;
  final GlobalKey<BookGridItemState> itemKey;
  final SelectedPage selectedPage;

  const BookGridItem({
    required this.itemKey,
    required this.bookManager,
    required this.index,
    this.bookModel,
    required this.width,
    required this.height,
    required this.selectedPage,
  }) : super(key: itemKey);

  @override
  BookGridItemState createState() => BookGridItemState();
}

class BookGridItemState extends State<BookGridItem> {
  late List<CretaMenuItem> _popupMenuList;
  bool mouseOver = false;
  int counter = 0;
  final Random random = Random();
  bool dropDownButtonOpened = false;
  int defaultThumbnailNumber = 100;
  double aWidth = 0;
  double aHeight = 0;

  @override
  void initState() {
    super.initState();

    defaultThumbnailNumber = random.nextInt(1000);

    _popupMenuList = [
      CretaMenuItem(
        caption: CretaLang['play']!,
        onPressed: () {
          openBook(AppRoutes.studioBookPreviewPage);
        },
      ),
      if (widget.bookModel != null && widget.bookModel!.hasWritePermition() == true)
        CretaMenuItem(
          caption: CretaLang['edit']!,
          onPressed: () {
            openBook(AppRoutes.studioBookMainPage);
          },
        ),
      // CretaMenuItem(
      //   caption: CretaLang['addToPlayList']!,
      //   onPressed: () {},
      // ),
      // CretaMenuItem(
      //   caption: CretaLang['share']!,
      //   onPressed: () {},
      // ),
      // CretaMenuItem(
      //   caption: CretaLang['download']!,
      //   onPressed: () {},
      // ),
      // CretaMenuItem(
      //   caption: CretaLang['copy']!,
      //   onPressed: () {},
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    aWidth = widget.width;
    aHeight = widget.height;
    //double margin = mouseOver ? 0 : LayoutConst.bookThumbSpacing / 2;
    //double margin = 0;

    // if (mouseOver) {
    //   aWidth = widget.width + 10;
    //   aHeight = widget.height + 10;
    // } else {
    //   aWidth = widget.width;
    //   aHeight = widget.height;
    // }

    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
          //logger.finest('mouse over');
        });
      },
      onHover: (event) {
        //logger.finest('onHover');
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          width: aWidth,
          height: aHeight,
          decoration: BoxDecoration(
            //boxShadow: mouseOver ? StudioSnippet.basicShadow(offset: 4) : null,
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.antiAlias, // crop method
          child: (widget.bookModel == null && widget.index < 0) ? _drawInsertButton() : _drawBook()
          // : widget.bookManager.getLength() <= widget.index && widget.bookManager.isNotEnd()
          //     ? _drawCount()
          //     : _drawBook(),
          ),
    );
  }

  // Widget _drawCount() {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     color: CretaColor.text[100]!.withOpacity(0.2),
  //     child: Center(
  //       child: Text(
  //         '${widget.bookManager.getLength()} \nCreta Book founded \n Press this button to more ...',
  //         style: CretaFont.bodyLarge,
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

  Widget _drawInsertButton() {
    return CretaElevatedButton(
      isVertical: true,
      height: aHeight,
      bgHoverColor: CretaColor.text[100]!,
      bgHoverSelectedColor: CretaColor.text[100]!,
      bgSelectedColor: CretaColor.text[100]!,
      bgColor: CretaColor.text[100]!,
      fgColor: CretaColor.primary[300]!,
      fgSelectedColor: CretaColor.primary,
      caption: CretaStudioLang['newBook']!,
      captionStyle: CretaFont.bodyMedium,
      radius: 20.0,
      onPressed: insertItem,
      icon: const Icon(
        Icons.add_outlined,
        size: 96,
        color: CretaColor.primary,
      ),
    );
  }

  Widget _drawBook() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          //boxShadow: StudioSnippet.basicShadow(offset: 2), // crop
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRect(
              child: Stack(
                children: [
                  _thumnailArea(),
                  _controllArea(),
                ],
              ),
            ),
            _bottomArea(),
          ],
        ),
      ),
    );
  }

  void openBook(String route) {
    //Get.offAllNamed("${AppRoutes.studioBookMainPage}?${CretaManager.bookPrefix}${widget.bookModel!.name.value}");
    if (route == AppRoutes.studioBookMainPage) {
      if (widget.bookModel!.hasWritePermition() == false) {
        route = AppRoutes.studioBookPreviewPage;
      }
    }
    StudioVariables.selectedBookMid = widget.bookModel!.mid;
    Routemaster.of(context).push('$route?${StudioVariables.selectedBookMid}');
    //studioBookPreviewPage
  }

  void playBook() {
    //Get.offAllNamed("${AppRoutes.studioBookMainPage}?${CretaManager.bookPrefix}${widget.bookModel!.name.value}");
    StudioVariables.selectedBookMid = widget.bookModel!.mid;
    Routemaster.of(context)
        .push('${AppRoutes.studioBookPreviewPage}?${StudioVariables.selectedBookMid}');
    //
  }

  Widget _controllArea() {
    bool readOnly = false;
    if (widget.bookModel != null && widget.bookModel!.hasWritePermition() == false) {
      readOnly = true;
    }

    String url = '${AppRoutes.studioBookMainPage}?${widget.bookModel!.mid}';
    double controllAreaHeight = aHeight - LayoutConst.bookDescriptionHeight;

    //print('bookItemHeight = $aHeight');
    //print('controllAreaHeight = $controllAreaHeight');

    if (mouseOver) {
      return Link(
          uri: Uri.parse(url),
          builder: (context, function) {
            return InkWell(
              onTap: () async {
                openBook(AppRoutes.studioBookMainPage);
              },
              onDoubleTap: () {
                if (readOnly == false) {
                  logger.finest('${widget.bookModel!.name.value} double clicked');
                  AppRoutes.launchTab(url);
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                alignment: AlignmentDirectional.topEnd,
                decoration: mouseOver
                    ? Snippet.gradationShadowDeco()
                    : BoxDecoration(
                        color: Colors.transparent,
                      ),
                //width: aWidth,
                height: controllAreaHeight, //aHeight - LayoutConst.bookDescriptionHeight,
                //color: CretaColor.text[200]!.withOpacity(0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            widget.bookModel!.likeCount.toString(),
                            overflow: TextOverflow.fade,
                            style: CretaFont.buttonSmall.copyWith(color: Colors.white),
                          ),
                        ),
                        Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                          size: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            widget.bookModel!.viewCount.toString(),
                            overflow: TextOverflow.fade,
                            style: CretaFont.buttonSmall.copyWith(color: Colors.white),
                          ),
                        ),
                        if (readOnly == false)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: BTN.opacity_gray_i_s(
                              icon: Icons.delete_outline,
                              onPressed: () {
                                logger.finest('delete pressed');
                                CretaPopup.yesNoDialog(
                                  context: context,
                                  title: CretaLang['deleteConfirmTitle']!,
                                  icon: Icons.file_download_outlined,
                                  question: CretaLang['deleteConfirm']!,
                                  noBtText: CretaStudioLang['noBtDnText']!,
                                  yesBtText: CretaStudioLang['yesBtDnText']!,
                                  yesIsDefault: true,
                                  onNo: () {
                                    //Navigator.of(context).pop();
                                  },
                                  onYes: () {
                                    logger.fine('onPressedOK(${widget.bookModel!.name.value})');

                                    _removeItem(widget.bookModel).then((value) {
                                      if (value == null) return null;
                                      if (widget.bookManager.isShort(offset: 1)) {
                                        widget.bookManager
                                            .reGet(AccountManager.currentLoginUser.email,
                                                onModelFiltered: () {
                                          widget.bookManager.notify();
                                          logger.fine('removeItem complete');
                                          return value;
                                        });
                                      }
                                      // ignore: use_build_context_synchronously

                                      return value;
                                    });
                                    // ignore: use_build_context_synchronously
                                    //Navigator.of(context).pop();
                                  },
                                );
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return CretaAlertDialog(
                                //         height: 200,
                                //         title: CretaLang['deleteConfirmTitle']!,
                                //         content: Text(
                                //           CretaLang['deleteConfirm']!,
                                //           style: CretaFont.titleMedium,
                                //         ),
                                //         onPressedOK: () async {
                                //           logger
                                //               .fine('onPressedOK(${widget.bookModel!.name.value})');

                                //           _removeItem(widget.bookModel).then((value) {
                                //             if (value == null) return null;
                                //             if (widget.bookManager.isShort(offset: 1)) {
                                //               widget.bookManager
                                //                   .reGet(AccountManager.currentLoginUser.email,
                                //                       onModelFiltered: () {
                                //                 widget.bookManager.notify();
                                //                 logger.fine('removeItem complete');
                                //                 return value;
                                //               });
                                //             }
                                //             // ignore: use_build_context_synchronously

                                //             return value;
                                //           });
                                //           // ignore: use_build_context_synchronously
                                //           Navigator.of(context).pop();
                                //         },
                                //       );
                                //     });
                              },
                              tooltip: CretaStudioLang['tooltipDelete']!,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: BTN.opacity_gray_i_s(
                            icon: Icons.menu_outlined,
                            onPressed: () {
                              logger.finest('menu pressed');
                              setState(() {
                                CretaPopupMenu.showMenu(
                                    context: context,
                                    globalKey: widget.itemKey,
                                    popupMenu: _popupMenuList,
                                    initFunc: () {
                                      dropDownButtonOpened = true;
                                    }).then((value) {
                                  logger.finest('Close menu');
                                  setState(() {
                                    dropDownButtonOpened = false;
                                  });
                                });
                                dropDownButtonOpened = !dropDownButtonOpened;
                              });
                            },
                            tooltip: CretaStudioLang['tooltipMenu']!,
                          ),
                        ),
                      ],
                    ),
                    if (aHeight > 186)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                        child: Container(
                          color: Colors.transparent,
                          height: 16,
                          child: Text(
                            widget.bookModel!.description.value,
                            overflow: TextOverflow.ellipsis,
                            style: CretaFont.bodyESmall.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
    }
    return Container();
  }

  Widget _thumnailArea() {
    int randomNumber = random.nextInt(1000);
    int duration = widget.index == 0 ? 500 : 500 + randomNumber;
    String url = widget.bookModel!.thumbnailUrl.value;
    if (url.isEmpty) {
      url = 'https://picsum.photos/200/?random=$defaultThumbnailNumber';
    }
    logger.fine('_thumnailArea ${widget.bookModel!.name.value} = <$url>');
    try {
      return SizedBox(
          width: aWidth,
          height: aHeight - LayoutConst.bookDescriptionHeight,
          child: CustomImage(
              key: UniqueKey(),
              hasMouseOverEffect: true,
              duration: duration,
              width: aWidth,
              height: aHeight,
              image: url));
    } catch (err) {
      logger.warning('CustomeImage failed $err');
      return SizedBox.shrink();
    }
  }

  Widget _bottomArea() {
    return Container(
      //width: aWidth,
      height: LayoutConst.bookDescriptionHeight,
      color: (mouseOver) ? Colors.grey[100] : Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                    color: (mouseOver) ? Colors.grey[100] : Colors.white,
                    child: Snippet.TooltipWrapper(
                      tooltip: widget.bookModel!.name.value,
                      fgColor: Colors.black,
                      bgColor: CretaColor.text[200]!,
                      child: Text(
                        widget.bookModel!.name.value,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: CretaFont.bodyMedium,
                      ),
                    )),
              ),
              widget.selectedPage != SelectedPage.myPage
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        color: (mouseOver) ? Colors.grey[100] : Colors.white,
                        child: Text(
                          widget.bookModel!.creatorName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: CretaFont.buttonMedium,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Container(
            color: (mouseOver) ? Colors.grey[100] : Colors.white,
            child: Text(
              CretaCommonUtils.dateToDurationString(widget.bookModel!.updateTime),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: CretaFont.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  void insertItem() async {
    // int randomNumber = random.nextInt(1000);
    // int modelIdx = randomNumber % 10;
    // BookModel book = BookModel.withName(
    //   '${CretaStudioLang['newBook']!}_$randomNumber',
    //   creator: AccountManager.currentLoginUser.email,
    //   creatorName: AccountManager.currentLoginUser.name,
    //   imageUrl: 'https://picsum.photos/200/?random=$modelIdx',
    //   viewCount: randomNumber,
    //   likeCount: 1000 - randomNumber,
    //   bookTypeVal: BookType.fromInt(randomNumber % 4 + 1),
    //   ownerList: const [],
    //   readerList: const [],
    //   writerList: const [],
    //   desc: SampleData.sampleDesc[randomNumber % SampleData.sampleDesc.length],
    // );

    // book.hashTag.set('#${randomNumber}tag');

    // await widget.bookManager.createToDB(book);
    // widget.bookManager.insert(book);

    BookModel book = widget.bookManager.createSample();
    await widget.bookManager.createNewBook(book);
    StudioVariables.selectedBookMid = book.mid;
    // ignore: use_build_context_synchronously
    Routemaster.of(context)
        .push('${AppRoutes.studioBookMainPage}?${StudioVariables.selectedBookMid}');
  }

  Future<BookModel?> _removeItem(BookModel? removedItem) async {
    if (removedItem != null) {
      await widget.bookManager.removeChildren(removedItem);
      removedItem.isRemoved.set(true, save: false, noUndo: true);
      await widget.bookManager.setToDB(removedItem);
      widget.bookManager.remove(removedItem);
    }
    return removedItem;
  }
}
