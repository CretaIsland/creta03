import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../../common/creta_constant.dart';
import '../../model/book_model.dart';
import 'studio_constant.dart';

class BookGridItem extends StatefulWidget {
  final BookModel bookModel;
  final double width;
  final double height;

  const BookGridItem({
    required super.key,
    required this.bookModel,
    required this.width,
    required this.height,
  });

  @override
  BookGridItemState createState() => BookGridItemState();
}

class BookGridItemState extends State<BookGridItem> {
  bool mouseOver = false;

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
          // crop
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias, // crop method
        child: Column(
          children: [
            Container(
              width: widget.width,
              height: widget.height - LayoutConst.bookDescriptionHeight,
              color: Colors.white,
              child: Stack(
                children: [
                  CretaVariables.isCanvaskit
                      ?
                      // 콘텐츠 프리뷰 이미지
                      ImageNetwork(
                          width: widget.width,
                          height: widget.height - LayoutConst.bookDescriptionHeight,
                          image: widget.bookModel.thumbnailUrl.value,
                          imageCache:
                              CachedNetworkImageProvider(widget.bookModel.thumbnailUrl.value),
                          duration: 1500,
                          curve: Curves.easeIn,
                          //onPointer: true,
                          debugPrint: false,
                          fullScreen: false,
                          fitAndroidIos: BoxFit.cover,
                          fitWeb: BoxFitWeb.cover,
                          onLoading: const CircularProgressIndicator(
                            color: Colors.indigoAccent,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.orange,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.bookModel.thumbnailUrl.value,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              height: LayoutConst.bookDescriptionHeight,
              color: (mouseOver) ? Colors.grey[100] : Colors.white,
              child: Stack(
                children: [
                  Positioned(
                      left: widget.width - 37,
                      top: 17,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: (mouseOver) ? Colors.grey[100] : Colors.white,
                        child: Icon(
                          Icons.favorite_outline,
                          size: 20.0,
                          color: Colors.grey[700],
                        ),
                      )),
                  Positioned(
                    left: 15,
                    top: 7,
                    child: Container(
                        width: widget.width - 45 - 15,
                        color: (mouseOver) ? Colors.grey[100] : Colors.white,
                        child: Text(
                          widget.bookModel.name.value,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontFamily: 'Pretendard',
                          ),
                        )),
                  ),
                  Positioned(
                    left: 16,
                    top: 29,
                    child: Container(
                      width: widget.width - 45 - 15,
                      color: (mouseOver) ? Colors.grey[100] : Colors.white,
                      child: Text(
                        widget.bookModel.creator,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
