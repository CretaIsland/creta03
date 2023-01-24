// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../common/creta_utils.dart';
import '../../data_io/book_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import '../../model/connected_user_model.dart';
import 'sample_data.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';

class BookGridItem extends StatefulWidget {
  final int index;
  final BookModel? bookModel;
  final double width;
  final double height;
  final BookManager bookManager;

  const BookGridItem({
    required super.key,
    required this.bookManager,
    required this.index,
    this.bookModel,
    required this.width,
    required this.height,
  });

  @override
  BookGridItemState createState() => BookGridItemState();
}

class BookGridItemState extends State<BookGridItem> {
  bool mouseOver = false;
  int counter = 0;
  final Random random = Random();

  double aWidth = 0;
  double aHeight = 0;

  @override
  void initState() {
    super.initState();
    aWidth = widget.width;
    aHeight = widget.height;
  }

  @override
  Widget build(BuildContext context) {
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
          boxShadow: mouseOver ? StudioSnippet.basicShadow(offset: 4) : null,
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias, // crop method
        child: widget.bookModel == null ? _drawInsertButton() : _drawBook(),
      ),
    );
  }

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
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                _thumnailArea(),
                _controllArea(),
              ],
            ),
            _bottomArea(),
          ],
        ),
      ),
    );
  }

  Widget _controllArea() {
    if (mouseOver) {
      return Container(
        alignment: AlignmentDirectional.topEnd,
        width: aWidth,
        height: aHeight - LayoutConst.bookDescriptionHeight,
        color: CretaColor.text[200]!.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8),
          child: BTN.floating_l(
            icon: Icons.delete_outline,
            onPressed: () {
              logger.finest('delete pressed');
              removeItem(widget.index);
            },
            hasShadow: false,
            tooltip: CretaStudioLang.tooltipDelete,
          ),
        ),
      );
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
                    child: Text(
                      widget.bookModel!.name.value,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: CretaFont.bodyMedium,
                    )),
              ),
              Expanded(
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
              ),
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
    int randomNumber = random.nextInt(1000);
    ConnectedUserModel model =
        SampleData.connectedUserList[randomNumber % SampleData.connectedUserList.length];

    BookModel book = BookModel.withName('${model.name}_$randomNumber',
        creator: AccountManager.currentLoginUser.email,
        creatorName: AccountManager.currentLoginUser.name,
        imageUrl: model.imageUrl,
        viewNo: randomNumber,
        likeNo: 1000 - randomNumber,
        bookTypeVal: BookType.fromInt(randomNumber % 4 + 1));

    book.hashTag.set('#$randomNumber tag...');

    await widget.bookManager.createToDB(book);
    widget.bookManager.insert(book);
  }

  void removeItem(int index) async {
    BookModel? removedItem = widget.bookManager.findByIndex(index) as BookModel?;
    if (removedItem != null) {
      await widget.bookManager.removeToDB(removedItem.mid);
      widget.bookManager.remove(removedItem);
    }
  }
}
