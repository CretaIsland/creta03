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

  bool _isStyleOpen = true;
  final bool _isTrailShowed = false;
  // bool _isHovered = false;

  List<String> imgUrl = [];
  AIState _state = AIState.ready;

  final imageTitle = [
    CretaStudioLang.recentUsedImage,
    CretaStudioLang.recommendedImage,
    CretaStudioLang.myImage,
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
          _state == AIState.ready
              ? Text(CretaStudioLang.aiImageGeneration, style: CretaFont.titleSmall)
              : Text(CretaStudioLang.aiGeneratedImage, style: CretaFont.titleSmall),
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
          // _styleWidget(),
          // if (_state != AIState.ready) _aiResult(),
          // _generatedButton(),
        ],
      );
    }
    return const SizedBox.shrink();
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
      //isOpen: _state == AIState.ready ? _isStyleOpen : !_isStyleOpen,
      isOpen: _isStyleOpen,
      onPressed: () {
        setState(() {
          _isStyleOpen = !_isStyleOpen;
          logger.info('------ Style open state: $_isStyleOpen---------');
        });
      },
      titleWidget: Text(CretaStudioLang.imageStyle, style: CretaFont.titleSmall),
      bodyWidget: _styleOptions(),
      trailWidget:
          Text(selectedCard != -1 ? CretaStudioLang.imageStyleList[selectedCard]["styleKR"]! : ''),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      height: 300.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Vertical axis
            mainAxisSpacing: 15.0,
            childAspectRatio: 1 / 1),
        itemCount: CretaStudioLang.imageStyleList.length,
        itemBuilder: (context, int styleIndex) {
          bool isSelected = selectedCard == styleIndex;
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    // logger.info(
                    //     '------Select card #$styleIndex, ${CretaStudioLang.imageStyleList[styleIndex]["styleENG"]}------');
                    // selectedCard = styleIndex;
                    //--------------Select/ Deselect car effect
                    if (isSelected) {
                      selectedCard = -1;
                      logger.info(
                          '------Deselect sard #$styleIndex, ${CretaStudioLang.imageStyleList[styleIndex]["styleENG"]}------');
                    } else {
                      selectedCard = styleIndex;
                      logger.info(
                          '------Select card #$styleIndex, ${CretaStudioLang.imageStyleList[styleIndex]["styleENG"]}------');
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: BoxDecoration(
                      color: CretaColor.text[200],
                      border: selectedCard == styleIndex
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
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        logger.info('-------- Select image $imageIndex--------');
                        selectedAIImage = imageIndex;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: (selectedAIImage == imageIndex)
                              ? Border.all(color: CretaColor.primary, width: 2.0)
                              : null),
                      child: CustomImage(
                          key: GlobalKey(),
                          width: 160,
                          height: 160,
                          image: imgUrl[imageIndex],
                          hasAni: false),
                    ),
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
              child: Text('서버가 사용 중입니다./n 잠시 후 다시 시도하세요!'),
            ));
      default:
        return const SizedBox.shrink();
    }
  }

  void _onPressed() {
    setState(() {
      _isStyleOpen = false;
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
              text: CretaStudioLang.aiImageGeneration,
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
                text: CretaStudioLang.generateImageAgain,
                onPressed: _onPressed,
              ),
              const SizedBox(width: 5.0),
              BTN.line_blue_t_m(
                text: CretaStudioLang.generateFromBeginning,
                onPressed: () {
                  setState(() {
                    _state = AIState.ready;
                    originalText = '';
                    selectedCard = -1;
                  });
                },
              ),
            ],
          ),
        );
      case AIState.fail:
        return BTN.line_blue_t_m(
          text: CretaStudioLang.generateImageAgain,
          onPressed: () {
            setState(() {
              generateImage(promptText);
            });
          },
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
