import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:internet_file/internet_file.dart';
// import 'package:pdfx/pdfx.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../pages/studio/book_main_page.dart';

class PinchPage extends StatefulWidget {
  final String url;
  const PinchPage({Key? key, required this.url}) : super(key: key);

  @override
  State<PinchPage> createState() => _PinchPageState();
}

enum DocShown { sample, tutorial, hello, password }

class _PinchPageState extends State<PinchPage> {
  //static const int _initialPage = 1;
  //double _baseScale = 0;
  //final DocShown _showing = DocShown.sample;
  //late PdfControllerPinch _pdfControllerPinch;
  late PdfViewerController _pdfViewerController;
  double _zoomCount = 1;
  bool _isHover = false;

  @override
  void initState() {
    // _pdfControllerPinch = PdfControllerPinch(
    //   // document: PdfDocument.openAsset('assets/hello.pdf'),
    //   document: PdfDocument.openData(
    //     InternetFile.get(widget.url),
    //     // InternetFile.get(
    //     //   'https://api.codetabs.com/v1/proxy/?quest=http://www.africau.edu/images/default/sample.pdf',
    //     // ),
    //   ),
    //   initialPage: _initialPage,
    // );
    super.initState();
    _pdfViewerController = PdfViewerController();
    afterBuild();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //_baseScale = _pdfControllerPinch.value.getMaxScaleOnAxis();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey,
  //     appBar: AppBar(
  //       title: const Text('Pdfx example'),
  //       actions: <Widget>[
  //         IconButton(
  //           icon: const Icon(Icons.navigate_before),
  //           onPressed: () {
  //             _pdfControllerPinch.previousPage(
  //               curve: Curves.ease,
  //               duration: const Duration(milliseconds: 100),
  //             );
  //           },
  //         ),
  //         PdfPageNumber(
  //           controller: _pdfControllerPinch,
  //           builder: (_, loadingState, page, pagesCount) => Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               '$page/${pagesCount ?? 0}',
  //               style: const TextStyle(fontSize: 22),
  //             ),
  //           ),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.navigate_next),
  //           onPressed: () {
  //             _pdfControllerPinch.nextPage(
  //               curve: Curves.ease,
  //               duration: const Duration(milliseconds: 100),
  //             );
  //           },
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.zoom_out_outlined),
  //           onPressed: () {
  //             setState(() {
  //               final x = Offset(widget.size.width / 2, widget.size.height / 2);
  //               final offset1 = _pdfControllerPinch.toScene(x);
  //               _pdfControllerPinch.value.scale(1.1);
  //               final offset2 = _pdfControllerPinch.toScene(x);
  //               final dx = offset1.dx - offset2.dx;
  //               final dy = offset1.dy - offset2.dy;
  //               _pdfControllerPinch.value.translate(-dx, -dy);

  //               // if (_zoomCount > 0) {
  //               //   _pdfControllerPinch.scaleXY(0.89);
  //               //   _zoomCount--;
  //               // }
  //             });
  //           },
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.zoom_in_outlined),
  //           onPressed: () {
  //             setState(() {
  //               if (_zoomCount < 10) {
  //                 // 여기 참조해서 다시 고쳐보자..
  //                 //https://stackoverflow.com/questions/74478910/zooming-in-at-the-center-of-interactiveviewer-using-matrix4-transformation
  //                 _pdfControllerPinch.scaleXY(1.1);
  //                 _zoomCount++;
  //               }
  //             });
  //             // switch (_showing) {
  //             //   case DocShown.sample:
  //             //   case DocShown.tutorial:
  //             //     _pdfControllerPinch
  //             //         .loadDocument(PdfDocument.openAsset('assets/flutter_tutorial.pdf'));
  //             //     _showing = DocShown.hello;
  //             //     break;
  //             //   case DocShown.hello:
  //             //     _pdfControllerPinch.loadDocument(PdfDocument.openAsset('assets/hello.pdf'));
  //             //     _showing = UniversalPlatform.isWeb ? DocShown.password : DocShown.tutorial;
  //             //     break;

  //             //   case DocShown.password:
  //             //     _pdfControllerPinch.loadDocument(PdfDocument.openAsset(
  //             //       'assets/password.pdf',
  //             //       password: 'MyPassword',
  //             //     ));
  //             //     _showing = DocShown.tutorial;
  //             //     break;
  //             // }
  //           },
  //         )
  //       ],
  //     ),
  //     body: PdfViewPinch(
  //       builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
  //         options: const DefaultBuilderOptions(),
  //         documentLoaderBuilder: (_) => Center(child: CretaSnippet.showWaitSign()),
  //         //pageLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
  //         pageLoaderBuilder: (_) => Center(child: CretaSnippet.showWaitSign()),
  //         errorBuilder: (_, error) => Center(child: Text(error.toString())),
  //       ),
  //       controller: _pdfControllerPinch,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SfPdfViewer.network(
            widget.url,
            controller: _pdfViewerController,
            enableDoubleTapZooming: false,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            canShowPaginationDialog: false,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            //password: 'syncfusion',
            canShowPasswordDialog: false,
            interactionMode: PdfInteractionMode.pan,
            scrollDirection: PdfScrollDirection.vertical,
          ),
          // PdfViewPinch(
          //   key: GlobalObjectKey('pdf${widget.url}'),
          //   builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          //     options: DefaultBuilderOptions(
          //       transitionBuilder: (child, animation) {
          //         return child;
          //       },
          //     ),
          //     documentLoaderBuilder: (_) => Center(child: CretaSnippet.showWaitSign()),
          //     pageLoaderBuilder: (_) => Center(child: CretaSnippet.showWaitSign()),
          //     errorBuilder: (_, error) => Center(child: Text(error.toString())),
          //   ),
          //   controller: _pdfControllerPinch,
          // ),
          Container(
            height: 60,
            width: double.infinity,
            color: _isHover == false ? Colors.transparent : CretaColor.text[900]!.withOpacity(0.25),
            child: MouseRegion(
              onHover: (event) {
                setState(() {
                  _isHover = true;
                });
              },
              onExit: (event) {
                setState(() {
                  _isHover = false;
                });
              },
              child: _isHover == false
                  ? const SizedBox.shrink()
                  : Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: BTN.opacity_gray_i_s(
                                  iconSize: 16,
                                  icon: Icons.navigate_before,
                                  onPressed: () {
                                    BookMainPage.containeeNotifier!.setFrameClick(true);
                                    _pdfViewerController.previousPage();
                                    // _pdfControllerPinch.previousPage(
                                    //   curve: Curves.ease,
                                    //   duration: const Duration(milliseconds: 100),
                                    // );
                                  },
                                  //hasShadow: false,
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: PdfPageNumber(
                              //     controller: _pdfControllerPinch,
                              //     builder: (_, loadingState, page, pagesCount) => Container(
                              //       alignment: Alignment.center,
                              //       child: Text(
                              //         '$page/${pagesCount ?? 0}',
                              //         style: CretaFont.bodySmall,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: BTN.opacity_gray_i_s(
                                  iconSize: 16,
                                  icon: Icons.navigate_next,
                                  onPressed: () {
                                    BookMainPage.containeeNotifier!.setFrameClick(true);
                                    _pdfViewerController.nextPage();
                                    // _pdfControllerPinch.nextPage(
                                    //   curve: Curves.ease,
                                    //   duration: const Duration(milliseconds: 100),
                                    // );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: BTN.opacity_gray_i_s(
                                  icon: Icons.zoom_in_outlined,
                                  iconSize: 16,
                                  onPressed: () {
                                    BookMainPage.containeeNotifier!.setFrameClick(true);
                                    if (_zoomCount < 3.0) {
                                      _zoomCount += 0.2;
                                      _pdfViewerController.zoomLevel = _zoomCount;
                                    }
                                    //setState(() {
                                    //https://stackoverflow.com/questions/74478910/zooming-in-at-the-center-of-interactiveviewer-using-matrix4-transformation
                                    //final currentScale = _pdfControllerPinch.value.getMaxScaleOnAxis();
                                    //final x = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                                    //final offset1 = _pdfControllerPinch.toScene(x);
                                    //_pdfControllerPinch.value.scale(1.1);
                                    //_pdfControllerPinch.notify();
                                    //final offset2 = _pdfControllerPinch.toScene(x);
                                    //final dx = offset1.dx - offset2.dx;
                                    //final dy = offset1.dy - offset2.dy;
                                    //_pdfControllerPinch.value.translate(-dx, -dy);
                                    //});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: BTN.opacity_gray_i_s(
                                  icon: Icons.zoom_out_outlined,
                                  iconSize: 16,
                                  onPressed: () {
                                    BookMainPage.containeeNotifier!.setFrameClick(true);
                                    if (_zoomCount > 1.0) {
                                      _zoomCount -= 0.2;
                                      _pdfViewerController.zoomLevel = _zoomCount;
                                    }
                                    //setState(() {
                                    //final currentScale = _pdfControllerPinch.value.getMaxScaleOnAxis();
                                    //https://stackoverflow.com/questions/74478910/zooming-in-at-the-center-of-interactiveviewer-using-matrix4-transformation
                                    //final x = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                                    //final offset1 = _pdfControllerPinch.toScene(x);
                                    //_pdfControllerPinch.value.scale(1 / 1.1);
                                    //_pdfControllerPinch.notify();
                                    //final offset2 = _pdfControllerPinch.toScene(x);
                                    //final dx = offset1.dx - offset2.dx;
                                    //final dy = offset1.dy - offset2.dy;
                                    //_pdfControllerPinch.value.translate(-dx, -dy);
                                    //});
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              //   child: BTN.opacity_gray_i_s(
                              //     icon: Icons.expand_outlined,
                              //     iconSize: 16,
                              //     onPressed: () {
                              //       BookMainPage.containeeNotifier!.setFrameClick(true);
                              //       setState(() {
                              //         //https://stackoverflow.com/questions/74478910/zooming-in-at-the-center-of-interactiveviewer-using-matrix4-transformation
                              //         //final x = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                              //         //final offset1 = _pdfControllerPinch.toScene(x);
                              //         _pdfControllerPinch.value.setZero();
                              //         _pdfControllerPinch.value.scale(_baseScale);
                              //         //final offset2 = _pdfControllerPinch.toScene(x);
                              //         //final dx = offset1.dx - offset2.dx;
                              //         //final dy = offset1.dy - offset2.dy;
                              //         //_pdfControllerPinch.value.translate(-dx, -dy);
                              //       });
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
