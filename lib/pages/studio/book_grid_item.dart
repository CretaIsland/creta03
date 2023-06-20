// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';

import '../../common/creta_utils.dart';
import '../../data_io/book_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_lang.dart';
import '../../model/book_model.dart';
import '../../model/connected_user_model.dart';
import '../../routes.dart';
import 'book_grid_page.dart';
import 'book_main_page.dart';
import 'sample_data.dart';
import 'studio_constant.dart';

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

  double aWidth = 0;
  double aHeight = 0;

  @override
  void initState() {
    super.initState();

    _popupMenuList = [
      CretaMenuItem(
        caption: CretaLang.play,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.edit,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.addToPlayList,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.share,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.download,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.copy,
        onPressed: () {},
      ),
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
      caption: CretaStudioLang.newBook,
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

  Widget _controllArea() {
    String url = '${AppRoutes.studioBookMainPage}?${widget.bookModel!.mid}';
    if (mouseOver) {
      return Link(
          uri: Uri.parse(url),
          builder: (context, function) {
            return InkWell(
              onTap: () async {
                //Get.offAllNamed("${AppRoutes.studioBookMainPage}?${CretaManager.bookPrefix}${widget.bookModel!.name.value}");
                BookMainPage.selectedMid = widget.bookModel!.mid;
                Routemaster.of(context)
                    .push('${AppRoutes.studioBookMainPage}?${BookMainPage.selectedMid}');
              },
              onDoubleTap: () {
                logger.finest('${widget.bookModel!.name.value} double clicked');

                AppRoutes.launchTab(url);
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
                height: aHeight - LayoutConst.bookDescriptionHeight,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: BTN.opacity_gray_i_s(
                            icon: Icons.delete_outline,
                            onPressed: () {
                              logger.finest('delete pressed');
                              // removeItem(widget.index).then((value) {
                              //   if (widget.bookManager.isShort(offset: 1)) {
                              //     widget.bookManager.reGet(AccountManager.currentLoginUser.email,
                              //         onModelFiltered: () {
                              //       widget.bookManager.notify();
                              //     });
                              //   }
                              //   return null;
                              // });

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CretaAlertDialog(
                                      height: 140,
                                      content: Text(
                                        CretaLang.deleteConfirm,
                                        style: CretaFont.titleMedium,
                                      ),
                                      onPressedOK: () async {
                                        logger.info('onPressedOK()');

                                        removeItem(widget.index).then((value) {
                                          if (widget.bookManager.isShort(offset: 1)) {
                                            widget.bookManager
                                                .reGet(AccountManager.currentLoginUser.email,
                                                    onModelFiltered: () {
                                              widget.bookManager.notify();
                                              return value;
                                            });
                                          }
                                          // ignore: use_build_context_synchronously

                                          return value;
                                        });
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  });
                            },
                            tooltip: CretaStudioLang.tooltipDelete,
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
                                  logger.finest('팝업메뉴 닫기');
                                  setState(() {
                                    dropDownButtonOpened = false;
                                  });
                                });
                                dropDownButtonOpened = !dropDownButtonOpened;
                              });
                            },
                            tooltip: CretaStudioLang.tooltipMenu,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.bookModel!.name.value,
                            overflow: TextOverflow.fade,
                            style: CretaFont.bodySmall.copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                          child: Text(
                            widget.bookModel!.description.value,
                            // [
                            //   ...widget.bookModel!.owners,
                            //   ...widget.bookModel!.writers,
                            //   ...widget.bookModel!.readers
                            // ].toString(),
                            overflow: TextOverflow.fade,
                            style: CretaFont.bodyESmall.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
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

    return SizedBox(
      width: aWidth,
      height: aHeight - LayoutConst.bookDescriptionHeight,
      child: CustomImage(
          key: UniqueKey(),
          hasMouseOverEffect: true,
          duration: duration,
          width: aWidth,
          height: aHeight,
          image: widget.bookModel!.thumbnailUrl.value),
    );
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
              CretaUtils.dateToDurationString(widget.bookModel!.updateTime),
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
    int len = SampleData.connectedUserList.length;
    int randomNumber = random.nextInt(1000);
    int modelIdx = randomNumber % len;
    ConnectedUserModel model = SampleData.connectedUserList[modelIdx];

    BookModel book = BookModel.withName(
      '${model.name}_$randomNumber',
      creator: AccountManager.currentLoginUser.email,
      creatorName: AccountManager.currentLoginUser.name,
      imageUrl: model.imageUrl,
      viewNo: randomNumber,
      likeNo: 1000 - randomNumber,
      bookTypeVal: BookType.fromInt(randomNumber % 4 + 1),
      ownerList: [
        SampleData.connectedUserList[modelIdx].email,
      ],
      readerList: [
        SampleData.connectedUserList[(modelIdx + 1) % len].email,
        SampleData.connectedUserList[(modelIdx + 2) % len].email,
        SampleData.connectedUserList[(modelIdx + 3) % len].email,
      ],
      writerList: [
        SampleData.connectedUserList[(modelIdx + 4) % len].email,
        SampleData.connectedUserList[(modelIdx + 5) % len].email,
        SampleData.connectedUserList[(modelIdx + 6) % len].email,
      ],
      desc: SampleData.sampleDesc[randomNumber % SampleData.sampleDesc.length],
    );

    book.hashTag.set('#$randomNumber tag...');

    await widget.bookManager.createToDB(book);
    widget.bookManager.insert(book);
  }

  Future<BookModel?> removeItem(int index) async {
    BookModel? removedItem = widget.bookManager.findByIndex(index) as BookModel?;
    if (removedItem != null) {
      await widget.bookManager.removeChild(removedItem.mid);
      await widget.bookManager.removeToDB(removedItem.mid);
      widget.bookManager.remove(removedItem);
    }
    return removedItem;
  }
}
