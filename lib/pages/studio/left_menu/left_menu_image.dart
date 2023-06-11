// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/component/creta_property_card.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/component/snippet.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';
import 'image/api_services.dart';

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

  String searchValue = '';

  bool _isStyleOpened = true;
  final bool _isTrailShowed = false;
  bool _isHovered = false;
  bool _isHoveredStyle = false;
  bool _isHoveredTip = false;
  List<String> imgUrl = [];
  AIState _state = AIState.ready;

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

  late String originalText;
  String promptText = '';

  Future<void> generateImage(String text) async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter text description for image generation')));
      return;
    }
    //setState(() {
    _state = AIState.processing;
    Api.generateImageAI(text, numImg).then((values) {
      setState(() {
        imgUrl = [...values];
        logger.info('------Generated image is $text ---------');
        _state = imgUrl.isNotEmpty ? AIState.succeed : AIState.fail;
      });
    });
  }

  void downloadImage(String urlImages) {
    AnchorElement anchorElement = AnchorElement(href: urlImages);
    anchorElement.download = "OpenAI_Image";
    anchorElement.click();
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
    super.dispose();
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                MouseRegion(
                  onEnter: (event) {
                    setState(() {
                      _isHoveredTip = true;
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      _isHoveredTip = false;
                    });
                  },
                  child: BTN.fill_gray_i_s(
                    icon: Icons.lightbulb_outline_sharp,
                    iconColor: CretaColor.primary[400],
                    bgColor: CretaColor.primary[100],
                    tooltip: CretaStudioLang.genAIimageTooltip,
                    tooltipFg: CretaColor.text[200],
                    tooltipBg: Colors.transparent,
                    onPressed: () {},
                  ),
                ),
                if (_isHoveredTip)
                  Positioned(
                    right: -425.0,
                    child: searchTip(),
                  ),
              ],
            ),
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
    return Container(
      height: 436.0,
      width: LayoutConst.rightMenuWidth - (verticalPadding - 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.pink[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(12.0),
            width: LayoutConst.rightMenuWidth - 2 * (verticalPadding),
            height: 52.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: CretaColor.text[100],
            ),
            child: Center(
              child: Text(
                CretaStudioLang.tipMessage,
                style: CretaFont.bodySmall,
              ),
            ),
          ),
          Stack(children: [
            SizedBox(
              height: LayoutConst.rightMenuWidth - 2 * (verticalPadding),
              width: LayoutConst.rightMenuWidth - 2 * (verticalPadding),
              child: Image.asset('assets/ai_tip_image.png'),
            ),
            Positioned(
                left: 16.0,
                top: 16.0,
                child: Align(
                  child: Container(
                    // width: 120.0,
                    width: 140.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      color: Colors.transparent.withOpacity(0.2),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        CretaStudioLang.tipSearchExample,
                        style: TextStyle(
                          fontSize: 9.0,
                          fontWeight: CretaFont.semiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          ]),
        ],
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
      trailWidget:
          Text(selectedCard != -1 ? CretaStudioLang.imageStyleList[selectedCard]["styleKR"]! : ''),
      showTrail: _state == AIState.ready ? _isTrailShowed : !_isTrailShowed,
      hasRemoveButton: selectedCard >= 0 && _isHoveredStyle ? true : false,
      onDelete: () {
        // setState(() {
        //   selectedCard = -1;
        // });
      },
    );
  }

  Widget _styleOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      height: 300.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Vertical axis
            mainAxisSpacing: 15.0,
            childAspectRatio: 1 / 1),
        itemCount: CretaStudioLang.imageStyleList.length,
        itemBuilder: (context, int styleIndex) {
          return Column(
            children: [
              MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _isHoveredStyle = true;
                    selectedCard = styleIndex;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _isHoveredStyle = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: BoxDecoration(
                      // color: CretaColor.text[200],
                      border: _isHoveredStyle && selectedCard == styleIndex
                          ? Border.all(color: CretaColor.primary, width: 2.0)
                          : null),
                  height: 68.0,
                  width: 68.0,
                  child: Image.asset(imageSample[styleIndex]),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2.0),
                alignment: Alignment.center,
                child: Text(
                  CretaStudioLang.imageStyleList[styleIndex]["styleKR"]!,
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
            Container(
              padding: const EdgeInsets.only(top: 12.0),
              height: 350.0,
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
                  return MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        _isHovered = true;
                        selectedAIImage = imageIndex;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        _isHovered = false;
                        selectedAIImage = -1;
                      });
                    },
                    child: Stack(children: [
                      CustomImage(
                          key: GlobalKey(),
                          width: 160,
                          height: 160,
                          image: imgUrl[imageIndex],
                          hasMouseOverEffect: isImageSelected,
                          hasAni: false),
                      if (_isHovered && selectedAIImage == imageIndex)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent.withOpacity(0.4),
                          ),
                        ),
                      if (selectedAIImage == imageIndex)
                        Positioned(
                          right: 8.0,
                          bottom: 8.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BTN.opacity_gray_i_s(
                                icon: Icons.file_download_outlined,
                                onPressed: () {
                                  downloadImage(imgUrl[imageIndex]);
                                },
                              ),
                              const SizedBox(width: 4.0),
                              BTN.opacity_gray_i_s(
                                icon: Icons.inventory_2_outlined,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                    ]),
                  );
                },
              ),
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
              child: Text('서버가 사용 중입니다. 잠시 후 다시 시도하세요!'),
            ));
      default:
        return const SizedBox.shrink();
    }
  }

  void _onPressed() {
    setState(() {
      _isStyleOpened = false;
      String selectedStyle =
          selectedCard != -1 ? CretaStudioLang.imageStyleList[selectedCard]["styleENG"]! : '';
      originalText = _textController.text;
      promptText = selectedStyle.isNotEmpty ? '$originalText, $selectedStyle' : originalText;
      generateImage(promptText);
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
          text: CretaStudioLang.genImageAgain,
          onPressed: _onPressed,
        );
    }
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
