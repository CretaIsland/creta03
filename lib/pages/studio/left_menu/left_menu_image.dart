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

  List<String> imgUrl = [];
  AIState _state = AIState.ready;

  final imageTitle = [
    {
      "title": CretaStudioLang.recentUsedImage,
      "color": Colors.amber,
    },
    {
      "title": CretaStudioLang.recommendedImage,
      "color": Colors.lightBlue,
    },
    {
      "title": CretaStudioLang.myImage,
      "color": Colors.redAccent,
    },
  ];

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
              itemBuilder: (BuildContext context, int index) {
                return imageDisplay(
                  title: imageTitle[index]["title"] as String,
                  colorname: imageTitle[index]["color"] as Color,
                );
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
                value: '',
                hintText: '플레이스홀더',
                onEditComplete: (value) {
                  logger.info('onEditComplete value=$value');
                }),
          ),
          _imageDisplayAI(),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Container imageDisplay({String title = "Title", Color colorname = Colors.black}) {
    // ignore: sized_box_for_whitespace, avoid_unnecessary_containers
    return Container(
      child: Column(
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
          Container(height: 230, color: colorname),
        ],
      ),
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
          Container(height: 250, color: Colors.pink.shade200),
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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      color: Colors.pink.shade100,
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: _state != AIState.processing
                          ? BTN.line_blue_t_m(
                              text: CretaStudioLang.aiImageGeneration,
                              onPressed: () async {
                                if (_textController.text.isNotEmpty) {
                                  setState(() {
                                    _state = AIState.processing;
                                  });
                                  imgUrl =
                                      (await Api.generateImageAI(_textController.text, numImg));
                                  setState(() {
                                    _state = imgUrl.isNotEmpty ? AIState.succeed : AIState.fail;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please enter text description for image generation')));
                                }
                              },
                            )
                          : const SizedBox.shrink(),
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
              height: 400,
              child: GridView.builder(
                itemCount: imgUrl.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1 / 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return CustomImage(
                      key: GlobalKey(),
                      width: 160,
                      height: 160,
                      image: imgUrl[index],
                      hasAni: false);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BTN.line_blue_t_m(text: CretaStudioLang.generateImageAgain, onPressed: () {}),
                  const SizedBox(width: 5.0),
                  BTN.line_blue_t_m(text: CretaStudioLang.generateFromBeginning, onPressed: () {}),
                ],
              ),
            ),
          ],
        );
      case AIState.processing:
        return Container(
          color: Colors.white, // Placeholder color
          child: Center(
            child: Snippet.showWaitSign(),
          ),
        );
      case AIState.fail:
        return const Center(child: Text('ERROR'));
      default:
        return const SizedBox.shrink();
    }
  }
}
