// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:translator/translator.dart';
import 'package:universal_html/html.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/component/creta_property_card.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/component/snippet.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';
import 'imageAI/api_services.dart';

class LeftMenuImage extends StatefulWidget {
  const LeftMenuImage({super.key});

  @override
  State<LeftMenuImage> createState() => _LeftMenuImageState();
}

enum AIState { ready, processing, succeed, fail }

class _LeftMenuImageState extends State<LeftMenuImage> {
  final double verticalPadding = 18;
  final double horizontalPadding = 24;

  String searchText = '';
  late String _selectedTab;
  late double bodyWidth;

  int numImg = 4;
  final TextEditingController _textController = TextEditingController();

  int selectedCard = -1;
  int selectedImage = -1;
  int selectedAIImage = -1;

  late String originalText;
  String promptText = '';
  String searchValue = '';

  OverlayEntry? _overlayEntry;

  bool _isStyleOpened = true;
  final bool _isTrailShowed = false;
  bool _isTipOpened = false;
  List<String> imgUrl = [];

  bool downloading = false;

  GoogleTranslator translator = GoogleTranslator();

  AIState _state = AIState.ready;

  // PageController
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 1.0);

  int _activePage = 0;

  final imageTitle = [
    CretaStudioLang.recentUsedImage,
    CretaStudioLang.recommendedImage,
    CretaStudioLang.myImage,
  ];

  final imageSample = [
    'assets/creta-photo.png',
    'assets/creta-illustration.png',
    'assets/creta-digital-art.png',
    'assets/creta-popart.png',
    'assets/creta-watercolor.png',
    'assets/creta-oilpainting.png',
    'assets/creta-printmaking.png',
    'assets/creta-drawing.png',
    'assets/creta-orientalpainting.png',
    'assets/creta-outlinedrawing.png',
    'assets/creta-crayon.png',
    'assets/creta-sketch.png',
  ];

  final tipImage1 = [
    "assets/tipImage-1-1.png",
    "assets/tipImage-1-2.png",
    "assets/tipImage-1-3.png",
    "assets/tipImage-1-4.png",
  ];

  final tipImage2 = [
    "assets/tipImage-2-1.png",
    "assets/tipImage-2-2.png",
    "assets/tipImage-2-3.png",
    "assets/tipImage-2-4.png",
  ];

  Future<void> generateImage(String text) async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이미지 생성을 위한 텍스트 설명을 입력하세요.')));
      return;
    }

    _state = AIState.processing;
    Api.generateImageAI(text, numImg).then((values) {
      setState(() {
        imgUrl = [...values];
        logger.info("------Generated image is '$text' ---------");
        _state = imgUrl.isNotEmpty ? AIState.succeed : AIState.fail;
      });
    });
  }

  // Future<void> downloadImage(String imageUrl) async {
  //   try {
  //     final http.Response res = await http.get(
  //       Uri.http(imageUrl, ''),
  //     );

  //     // get the bytes from the body
  //     final data = res.bodyBytes;
  //     // encode to base64
  //     final base64data = base64Encode(data);

  //     // create and AnchorElement with the html package
  //     final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

  //     // set the name of the file we want the image to get
  //     // downloaded to
  //     a.download = 'download.jpg';

  //     // and we click the AnchorElement which downloads the image
  //     a.click();
  //     // finally we remove the AnchorElement
  //     a.remove();
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  // void downloadImage(String urlImages) {
  //   http.get(Uri.https(urlImages)).then((value) {
  //     final data = value.bodyBytes;
  //     final base64data = base64Encode(data);
  //     final anchorElement = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
  //     anchorElement.download = 'download.jpg';
  //     anchorElement.click();
  //     anchorElement.remove();
  //   });
  // }

  void downloadImage(String urlImages) {
    final anchorElement = AnchorElement(href: urlImages);
    anchorElement.download = 'download.jpg';
    anchorElement.click();
  }

  // Future<void> downloadImage(String urlImage) async {
  //   const fileName = "download.png";

  //   final res = await http.get(Uri.parse(urlImage));

  //   final fileBlob = Blob([res.bodyBytes]);
  //   AnchorElement(href: Url.createObjectUrlFromBlob(fileBlob))
  //     ..download = fileName
  //     ..click();
  // }

  void _changePage(int page) {
    if (page >= 0 && page < CretaStudioLang.tipMessage.length) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        _activePage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
        _imageView(),
      ],
    );
  }

  @override
  void initState() {
    logger.info('_LeftMenuImageState.initState');
    _selectedTab = CretaStudioLang.imageMenuTabBar.values.first;
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    originalText = '';
    super.initState();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay() {
    setState(() {
      _isTipOpened = true;
      _overlayEntry ??= OverlayEntry(builder: (BuildContext context) => searchTip());
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void hideOverlay() {
    setState(() {
      _isTipOpened = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _toggleSearchTip() {
    if (_isTipOpened) {
      hideOverlay();
    } else {
      showOverlay();
    }
  }

  Widget _menuBar() {
    return Container(
        height: LayoutConst.innerMenuBarHeight, // heihgt: 36
        width: LayoutConst.rightMenuWidth, // width: 380
        color: CretaColor.text[100],
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 100.0),
          child: CustomRadioButton(
            radioButtonValue: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            width: 95,
            autoWidth: true,
            height: 24,
            buttonTextStyle: ButtonTextStyle(
              selectedColor: CretaColor.primary,
              unSelectedColor: CretaColor.text[700]!,
              textStyle: CretaFont.buttonMedium,
            ),
            selectedColor: Colors.white,
            unSelectedColor: CretaColor.text[100]!,
            defaultSelected: _selectedTab,
            buttonLables: CretaStudioLang.imageMenuTabBar.keys.toList(),
            buttonValues: CretaStudioLang.imageMenuTabBar.values.toList(),
            selectedBorderColor: Colors.transparent,
            unSelectedBorderColor: Colors.transparent,
            elevation: 0,
            enableButtonWrap: true,
            enableShape: true,
            shapeRadius: 60,
          ),
        ));
  }

  Widget _imageView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: _imageResult(),
    );
  }

  Widget _textQuery() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang.queryHintText,
      onSearch: (value) {
        searchText = value;
      },
    );
  }

  Widget _imageResult() {
    List<String> menu = CretaStudioLang.imageMenuTabBar.values.toList();
    // 이미지
    if (_selectedTab == menu[0]) {
      return Column(
        children: [
          _textQuery(),
          Container(
            height: StudioVariables.workHeight - 250.0,
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: imageTitle.length,
              itemBuilder: (BuildContext context, int listIndex) {
                return imageDisplay(imageTitle[listIndex], listIndex);
              },
            ),
          ),
        ],
      );
    }

    // 가져오기
    if (_selectedTab == menu[1]) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _textQuery(),
          Container(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BTN.line_blue_t_m(text: CretaStudioLang.myUploadedImage, onPressed: () {}),
                _imageDisplayUploaded(),
              ],
            ),
          ),
        ],
      );
    }

    //AI 생성
    if (_selectedTab == menu[2]) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _state == AIState.ready
                ? Text(CretaStudioLang.aiImageGeneration, style: CretaFont.titleSmall)
                : Text(CretaStudioLang.aiGeneratedImage, style: CretaFont.titleSmall),
            BTN.fill_gray_i_s(
                icon: Icons.lightbulb_outline_sharp,
                iconColor: CretaColor.primary[400],
                bgColor: CretaColor.primary[100],
                tooltip: CretaStudioLang.genAIimageTooltip,
                tooltipFg: CretaColor.text[200],
                tooltipBg: Colors.transparent,
                onPressed: () {
                  _toggleSearchTip();
                }),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CretaTextField.short(
                controller: _textController,
                textFieldKey: GlobalKey(),
                value: originalText,
                hintText: '플레이스홀더',
                onEditComplete: (value) {
                  originalText = value;
                  logger.info('onEditComplete value = $value');
                }),
          ),
          imageAIDisplay(),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget searchTip() {
    return Positioned(
      left: 485.0,
      top: 243.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          child: Container(
            key: UniqueKey(),
            height: 455.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            width: LayoutConst.rightMenuWidth,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemCount: CretaStudioLang.tipMessage.length,
              itemBuilder: (BuildContext context, pageIndex) {
                return Stack(clipBehavior: Clip.none, children: [
                  tipContent(pageIndex),
                  Positioned(
                    top: 230.0,
                    left: _activePage > 0 ? 8.0 : 333.0,
                    child: BTN.floating_l(
                      icon: _activePage == 0 ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                      onPressed: () {
                        // logger.info('----------swipe page------------');
                        if (_activePage == 0) {
                          _changePage(_activePage + 1);
                        } else if (_activePage > 0) {
                          _changePage(_activePage - 1);
                        }
                      },
                    ),
                  )
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget imageAIDisplay() {
    return SizedBox(
      height: StudioVariables.workHeight - 250.0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _styleWidget(),
            if (_state != AIState.ready) _aiResult(),
            _generatedButton(),
          ],
        ),
      ),
    );
  }

  Widget _styleWidget() {
    return CretaPropertyUtility.propertyCard(
      //isOpen: _state == AIState.ready ? _isStyleOpened : !_isStyleOpened,
      isOpen: _isStyleOpened,
      onPressed: () {
        setState(() {
          _isStyleOpened = !_isStyleOpened;
          logger.info('------ Style open state: $_isStyleOpened---------');
        });
      },
      titleWidget: Text(CretaStudioLang.imageStyle, style: CretaFont.titleSmall),
      bodyWidget: _styleOptions(),
      trailWidget: Text(selectedCard != -1 ? CretaStudioLang.imageStyleList[selectedCard] : ''),
      showTrail: _state == AIState.ready ? _isTrailShowed : !_isTrailShowed,
      hasRemoveButton: selectedCard >= 0 ? true : false,
      onDelete: () {
        setState(() {
          selectedCard = -1;
        });
      },
    );
  }

  Widget _styleOptions() {
    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      height: 308.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Vertical axis
            mainAxisSpacing: 15.0,
            childAspectRatio: 1 / 1),
        itemCount: CretaStudioLang.imageStyleList.length,
        itemBuilder: (context, int styleIndex) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCard = styleIndex;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: BoxDecoration(
                      // color: CretaColor.text[200],
                      border: selectedCard == styleIndex
                          ? Border.all(color: CretaColor.primary, width: 2.0)
                          : null),
                  height: 68.0,
                  width: 68.0,
                  child: Image.asset(imageSample[styleIndex], fit: BoxFit.fill),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2.0),
                alignment: Alignment.center,
                child: Text(
                  CretaStudioLang.imageStyleList[styleIndex],
                  style: CretaFont.buttonSmall,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _aiResult() {
    switch (_state) {
      case AIState.succeed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _textController.text = promptText;
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: verticalPadding, bottom: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    width: LayoutConst.rightMenuWidth - 2 * (horizontalPadding),
                    height: 44.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: CretaColor.text[100],
                    ),
                    child: Center(
                      child: Text(
                        promptText,
                        style: CretaFont.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  height: 352.0,
                  child: GridView.builder(
                    itemCount: imgUrl.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1,
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int imageIndex) {
                      bool isImageSelected = selectedAIImage == imageIndex;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isImageSelected) {
                              logger
                                  .info('----------Deselect generated image $imageIndex----------');
                              selectedAIImage = -1;
                            } else {
                              logger.info('----------Select generated image $imageIndex----------');
                              selectedAIImage = imageIndex;
                            }
                          });
                        },
                        child: generatedImage(imageIndex, isImageSelected),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      case AIState.processing:
        return Container(
          color: Colors.white, // Placeholder color
          child: SizedBox(
            height: 350.0,
            child: Center(
              child: Snippet.showWaitSign(),
            ),
          ),
        );
      case AIState.fail:
        return const SizedBox(
            height: 350.0,
            child: Center(
              child: Text(CretaStudioLang.genAIerrorMsg, textAlign: TextAlign.center),
            ));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget generatedImage(int imageIndex, bool isImageSelected) {
    return Stack(children: [
      CustomImage(
        key: GlobalKey(),
        width: 160,
        height: 160,
        image: imgUrl[imageIndex],
        hasAni: false,
      ),
      if (isImageSelected)
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.4),
          ),
        ),
      if (isImageSelected)
        Positioned(
          right: 8.0,
          bottom: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // download to local folder
              BTN.opacity_gray_i_s(
                icon: Icons.file_download_outlined,
                onPressed: () {
                  downloadImage(imgUrl[imageIndex]);
                  debugPrint('Download button pressed');
                  // FileSaver.instance.saveFile(
                  //   name: 'donwload.png',
                  //   mimeType: MimeType.png,
                  //   link: imgUrl[imageIndex],
                  // );
                },
              ),
              const SizedBox(width: 4.0),
              // add to my storage
              BTN.opacity_gray_i_s(
                icon: Icons.inventory_2_outlined,
                onPressed: () {},
              ),
            ],
          ),
        ),
    ]);
  }

  // with promptText translation
  void _onPressed() {
    String textToGen = _textController.text;
    originalText = textToGen;
    String selectedStyle = selectedCard != -1 ? CretaStudioLang.imageStyleList[selectedCard] : '';
    if (selectedStyle.isNotEmpty) textToGen += ' , $selectedStyle';
    translator.translate(textToGen, to: "en").then((value) {
      setState(() {
        _isStyleOpened = false;
        hideOverlay();
        promptText = value.toString();
        generateImage(promptText);
      });
    });
  }

  Widget _generatedButton() {
    switch (_state) {
      case AIState.ready:
        return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: verticalPadding + 2.0),
            child: BTN.line_blue_t_m(
              text: CretaStudioLang.genAIImage,
              onPressed: _onPressed,
            ));
      case AIState.processing:
        return const SizedBox.shrink();
      case AIState.succeed:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BTN.line_blue_t_m(
                text: CretaStudioLang.genImageAgain,
                onPressed: _onPressed,
              ),
              const SizedBox(width: 5.0),
              BTN.line_blue_t_m(
                text: CretaStudioLang.genFromBeginning,
                onPressed: () {
                  setState(() {
                    _isStyleOpened = true;
                    _isTipOpened = false;
                    _state = AIState.ready;
                    selectedCard = -1;
                    originalText = '';
                  });
                },
              ),
            ],
          ),
        );
      case AIState.fail:
        return BTN.line_blue_t_m(
          text: CretaStudioLang.genFromBeginning,
          onPressed: () {
            setState(() {
              _isStyleOpened = true;
              _isTipOpened = false;
              _state = AIState.ready;
              selectedCard = -1;
              originalText = '';
            });
          },
        );
    }
  }

  Widget tipContent(int pageIndex) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: verticalPadding),
        width: LayoutConst.rightMenuWidth - 2 * (horizontalPadding),
        height: 52.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: CretaColor.text[100],
        ),
        child:
            Center(child: Text(CretaStudioLang.tipMessage[pageIndex], style: CretaFont.bodyESmall)),
      ),
      // image and text examples
      SizedBox(
        height: LayoutConst.rightMenuWidth - 2 * (verticalPadding),
        width: LayoutConst.rightMenuWidth - 2 * (horizontalPadding),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Vertical axis
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 1 / 1),
          itemCount: tipImage1.length,
          itemBuilder: (context, int tipIndex) {
            return InkWell(
              onTap: () {
                logger.info(
                    "-----Example search text '${CretaStudioLang.detailTipMessage1[tipIndex]}' -------");
                _textController.text = _activePage == 0
                    ? CretaStudioLang.detailTipMessage1[tipIndex]
                    : CretaStudioLang.detailTipMessage2[tipIndex];
              },
              child: tipExample(tipIndex),
            );
          },
        ),
      ),
      // page indicator
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (pageIndex) {
          return Container(
            alignment: Alignment.center,
            height: 4.0,
            width: 12.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _activePage == pageIndex ? CretaColor.primary[400] : CretaColor.text[200],
            ),
          );
        }),
      )),
    ]);
  }

  Widget tipExample(int tipIndex) {
    return Stack(clipBehavior: Clip.none, children: [
      // image examples
      SizedBox(
        height: 156.0,
        width: 156.0,
        child: _activePage == 0
            ? Image.asset(tipImage1[tipIndex], fit: BoxFit.fill)
            : Image.asset(tipImage2[tipIndex], fit: BoxFit.fill),
      ),
      // text examples
      Positioned(
        top: 8.0,
        left: 8.0,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 140.0,
            height: 36.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: Colors.transparent.withOpacity(0.5),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  _activePage == 0
                      ? CretaStudioLang.detailTipMessage1[tipIndex]
                      : CretaStudioLang.detailTipMessage2[tipIndex],
                  style: const TextStyle(
                    fontSize: 8.0,
                    fontWeight: CretaFont.semiBold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget imageDisplay(String title, int listViewIndex) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: CretaFont.titleSmall),
              BTN.fill_gray_i_m(
                // tooltip: CretaStudioLang.copy,
                // tooltipBg: CretaColor.text[700],
                icon: Icons.arrow_forward_ios,
                onPressed: () {},
              )
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 1.7 / 1),
            itemCount: 4,
            itemBuilder: (BuildContext context, int gridIndex) {
              int totalIndex = (listViewIndex * 4) + gridIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    logger.info('-------- Select image $totalIndex in $title--------');
                    selectedImage = totalIndex;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CretaColor.text[200],
                    border: (selectedImage == totalIndex)
                        ? Border.all(color: CretaColor.primary, width: 2.0)
                        : null,
                  ),
                  height: 95.0,
                  width: 160.0,
                  child: Center(
                    child: Text('Image $totalIndex'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _imageDisplayUploaded() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(CretaStudioLang.recentUploadedImage, style: CretaFont.titleSmall),
          ),
          SizedBox(
              height: 450,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 1.7 / 1,
                ),
                itemCount: 8,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        logger.info('---------Select image $index---------');
                        selectedImage = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      decoration: BoxDecoration(
                          color: CretaColor.text[200],
                          border: (selectedImage == index)
                              ? Border.all(color: CretaColor.primary, width: 2.0)
                              : null),
                      height: 95,
                      width: 160,
                      child: Center(child: Text('Image $index')),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
