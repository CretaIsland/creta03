// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:image_network/image_network.dart';

import '../../common/creta_constant.dart';
import '../../common/creta_utils.dart';
import '../../data_io/book_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import '../../model/connected_user_model.dart';
import 'sample_data.dart';
import 'studio_constant.dart';

class BookGridItem extends StatefulWidget {
  final int index;
  final BookModel? bookModel;
  final double width;
  final double height;

  const BookGridItem({
    required super.key,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          //boxShadow: StudioSnippet.basicShadow(offset: 2), // crop
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
      height: widget.height,
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
    return Column(
      children: [
        Stack(
          children: [
            _thumnailArea(),
            _controllArea(),
          ],
        ),
        _bottomArea(),
      ],
    );
  }

  Widget _controllArea() {
    if (mouseOver) {
      return Container(
        alignment: AlignmentDirectional.topEnd,
        width: widget.width,
        height: widget.height - LayoutConst.bookDescriptionHeight,
        color: CretaColor.text[200]!.withOpacity(0.3),
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
    return Container(
      width: widget.width,
      height: widget.height - LayoutConst.bookDescriptionHeight,
      color: Colors.white,
      child: CretaVariables.isCanvaskit
          ?
          // 콘텐츠 프리뷰 이미지
          ImageNetwork(
              width: widget.width,
              height: widget.height - LayoutConst.bookDescriptionHeight,
              image: widget.bookModel!.thumbnailUrl.value,
              imageCache: CachedNetworkImageProvider(widget.bookModel!.thumbnailUrl.value),
              duration: 1500,
              curve: Curves.easeIn,
              //onPointer: true,
              debugPrint: false,
              fullScreen: false,
              fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.cover,
              onLoading: const CircularProgressIndicator(
                color: CretaColor.primary,
              ),
              onError: const Icon(
                Icons.error,
                color: CretaColor.secondary,
              ),
            )
          : CachedNetworkImage(
              imageUrl: widget.bookModel!.thumbnailUrl.value,
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
    );
  }

  Widget _bottomArea() {
    return Container(
      height: LayoutConst.bookDescriptionHeight,
      color: (mouseOver) ? Colors.grey[100] : Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
        imageUrl: model.imageUrl);

    book.hashTag.set('#$randomNumber tag...');

    await bookManagerHolder!.createToDB(book);
    bookManagerHolder!.modelList.insert(0, book);
    bookManagerHolder!.notify();
  }

  void removeItem(int index) async {
    BookModel removedItem = bookManagerHolder!.modelList[index] as BookModel;
    await bookManagerHolder!.removeToDB(removedItem.mid);
    bookManagerHolder!.modelList.remove(removedItem);
    bookManagerHolder!.notify();
  }
}
