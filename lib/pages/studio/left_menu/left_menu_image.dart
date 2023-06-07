import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
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

  String searchValue = '';

  bool _isHovered = false;

  List<String> imgUrl = [];
  AIState _state = AIState.ready;

  final imageTitle = [
    CretaStudioLang.recentUsedImage,
    CretaStudioLang.recommendedImage,
    CretaStudioLang.myImage,
  ];

  String originalText = '';
  String promptText = '';

  final imageStyleList = [
    {
      "styleENG": "photo",
      "styleKR": "사진",
    },
    {
      "styleENG": "illustration",
      "styleKR": "일러스트",
    },
    {
      "styleENG": "digital art",
      "styleKR": "디지털 아트",
    },
    {
      "styleENG": "pop Art",
      "styleKR": "팝아트",
    },
    {
      "styleENG": "watercolor",
      "styleKR": "수채화",
    },
    {
      "styleENG": "oil painting",
      "styleKR": "유화",
    },
    {
      "styleENG": "printmaking",
      "styleKR": "판화",
    },
    {
      "styleENG": "drawing",
      "styleKR": "드로잉",
    },
    {
      "styleENG": "oriental painting",
      "styleKR": "동양화",
    },
    {
      "styleENG": "outline drawing",
      "styleKR": "소묘",
    },
    {
      "styleENG": "crayon",
      "styleKR": "크레피스",
    },
    {
      "styleENG": "sketch",
      "styleKR": "스케치",
    },
  ];

  Future<void> generateImage(String text) async {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _state = AIState.processing;
      });
      imgUrl = (await Api.generateImageAI(text, numImg));
      setState(() {
        logger.info('------Generated image is $text ---------');
        _state = imgUrl.isNotEmpty ? AIState.succeed : AIState.fail;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter text description for image generation')));
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
    // selectedCard = -1; // Set an int with value -1 since no card has been selected
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
      // height: StudioVariables.workHeight,
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
            height: StudioVariables.workHeight - 250,
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
      // String selectedStyle = selectedCard != -1 ? imageStyleList[selectedCard]["styleENG"]! : '';

      // String promptText = _state == AIState.succeed && selectedStyle.isNotEmpty
      //     ? '$originalText, $selectedStyle'
      //     : originalText;
      // String newText = selectedStyle.isNotEmpty ? '$originalText, $selectedStyle' : originalText;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _state != AIState.ready
              ? Text(CretaStudioLang.aiImageGeneration, style: CretaFont.titleSmall)
              : Text(CretaStudioLang.aiGeneratedImage, style: CretaFont.titleSmall),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CretaTextField.short(
                controller: _textController,
                textFieldKey: GlobalKey(),
                value: promptText,
                hintText: '플레이스홀더',
                onEditComplete: (value) {
                  //originalText = _textController.text;
                  originalText = value;
                  logger.info('onEditComplete value = $value');
                }),
          ),
          //_imageDisplayAI(newText),
          _imageDisplayAI(),
        ],
      );
    }
    return const SizedBox.shrink();
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
              return MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _isHovered = true;
                    selectedCard = totalIndex;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _isHovered = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      logger.info('-------- Select image $totalIndex in $title--------');
                      // selectedCard = totalIndex;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: CretaColor.text[200],
                      border: (_isHovered && selectedCard == totalIndex)
                          ? Border.all(color: CretaColor.primary, width: 2.0)
                          : null,
                    ),
                    height: 95.0,
                    width: 160.0,
                    child: Center(
                      child: Text('Image $totalIndex'),
                    ),
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
                  return MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        _isHovered = true;
                        selectedCard = index;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        _isHovered = false;
                      });
                    },
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          logger.info('---------Select image $index---------');
                          selectedCard = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                            color: CretaColor.text[200],
                            border: (_isHovered && selectedCard == index)
                                ? Border.all(color: CretaColor.primary, width: 2.0)
                                : null),
                        height: 95,
                        width: 160,
                        child: Center(child: Text('Image $index')),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _imageDisplayAI() {
    return SizedBox(
      height: StudioVariables.workHeight,
      child: Column(
        children: [
          _state == AIState.ready
              ? Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(CretaStudioLang.imageStyle, style: CretaFont.titleSmall)),
                    Column(
                      children: [
                        SizedBox(
                          height: 280.0,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // Vertical axis
                                mainAxisSpacing: 15.0,
                                childAspectRatio: 1 / 1),
                            itemCount: imageStyleList.length,
                            itemBuilder: (context, int index) {
                              // Select/ Deselect car //
                              // bool isSelected = selectedCard == index;
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        logger.info(
                                            '------Select card #$index, ${imageStyleList[index]["styleENG"]}------');
                                        selectedCard = index; // Outline selected card
                                        // Select/ Deselect car effect//
                                        // if (isSelected) {
                                        //   selectedCard = -1;
                                        //   logger.info('------Card #$index is deseletced------');
                                        // } else {
                                        //   selectedCard = index;
                                        //   logger.info('------Card #$index is seletced------');
                                        // }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      decoration: BoxDecoration(
                                          color: CretaColor.text[200],
                                          border: selectedCard == index
                                              ? Border.all(color: CretaColor.primary, width: 2.0)
                                              : null),
                                      height: 68.0,
                                      width: 68.0,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      imageStyleList[index]["styleKR"]!,
                                      style: CretaFont.buttonSmall,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: verticalPadding + 2.0),
                          child: _state != AIState.processing
                              ? BTN.line_blue_t_m(
                                  text: CretaStudioLang.aiImageGeneration,
                                  onPressed: () {
                                    String selectedStyle = selectedCard != -1
                                        ? imageStyleList[selectedCard]["styleENG"]!
                                        : '';
                                    originalText = _textController.text;
                                    // String promptText = _state == AIState.succeed && selectedStyle.isNotEmpty
                                    //     ? '$originalText, $selectedStyle'
                                    //     : originalText;
                                    promptText = selectedStyle.isNotEmpty
                                        ? '$originalText, $selectedStyle'
                                        : originalText;
                                    generateImage(promptText);
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                )
              : _aiResult()
        ],
      ),
    );
  }

  Widget _aiResult() {
    switch (_state) {
      case AIState.succeed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 350.0,
              child: GridView.builder(
                itemCount: imgUrl.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1 / 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _isHovered = true;
                        selectedCard = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _isHovered = false;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          logger.info('------Select $index image');
                          selectedCard = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: (_isHovered && selectedCard == index)
                                ? Border.all(color: CretaColor.primary)
                                : null),
                        child: CustomImage(
                            key: GlobalKey(),
                            width: 160,
                            height: 160,
                            image: imgUrl[index],
                            hasAni: false),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BTN.line_blue_t_m(
                    text: CretaStudioLang.generateImageAgain,
                    onPressed: () {
                      generateImage(promptText);
                      _textController.text;
                    },
                  ),
                  const SizedBox(width: 5.0),
                  BTN.line_blue_t_m(
                    text: CretaStudioLang.generateFromBeginning,
                    onPressed: () {
                      setState(() {
                        _state = AIState.ready;
                        _textController.text = '';
                        selectedCard = -1;
                      });
                    },
                  ),
                ],
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
              child: Text('서버가 사용 중입니다./n 잠시 후 다시 시도하세요!'),
            ));
      default:
        return const SizedBox.shrink();
    }
  }
}
