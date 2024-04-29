// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creta_common/common/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/config.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:translator_plus/translator_plus.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/component/creta_property_card.dart';
import '../../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_constant.dart';
import '../../login/creta_account_manager.dart';
import 'imageAI/api_services.dart';
import 'imageAI/search_tip_position.dart';
import 'imageAI/style_selected.dart';
import 'imageAI/tip_toggle.dart';
import 'image_giphy/left_menu_giphy.dart';

class LeftMenuImage extends StatefulWidget {
  static final TextEditingController textController = TextEditingController();
  const LeftMenuImage({super.key});

  @override
  State<LeftMenuImage> createState() => _LeftMenuImageState();
}

enum AIState { ready, processing, succeed, fail }

class _LeftMenuImageState extends State<LeftMenuImage> {
  final double verticalPadding = 18;
  final double horizontalPadding = 19;

  String searchText = '';
  late String _selectedTab;
  late double bodyWidth;

  int numImg = 4;
  // final TextEditingController textController = TextEditingController();
  int selectedImage = -1;
  int selectedAIImage = -1;

  late String originalText;
  String promptText = '';
  String searchValue = '';

  bool _isStyleOpened = true;
  final bool _isTrailShowed = false;

  List<String> imgUrl = [];

  bool downloading = false;

  GoogleTranslator translator = GoogleTranslator();

  AIState _state = AIState.ready;

  final imageTitle = [
    CretaStudioLang['recentUsedImage']!,
    CretaStudioLang['recommendedImage']!,
    CretaStudioLang['myImage']!,
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

  Future<void> generateImage(String text) async {
    if (LeftMenuImage.textController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(CretaStudioLang['specifyGenScript']!)));
      return;
    }

    _state = AIState.processing;
    Api.generateImageAI(text, numImg).then((values) {
      setState(() {
        imgUrl = [...values];
        logger.fine("------Generated image is '$text' ---------");
        _state = imgUrl.isNotEmpty ? AIState.succeed : AIState.fail;
      });
    });
  }

  Future<void> downloadImage(String urlImage) async {
    // const fileName = "download.png";

    // final res = await http.get(Uri.parse(urlImage));

    // final fileBlob = Blob([res.bodyBytes]);
    // AnchorElement(href: Url.createObjectUrlFromBlob(fileBlob))
    //   ..download = fileName
    //   ..click();

    http
        .post(Uri.parse("${CretaAccountManager.getEnterprise!.mediaApiUrl}/downloadAiImg"),
            headers: {"Content-type": "application/json"},
            body: jsonEncode(
                {"userId": myConfig!.serverConfig!.storageConnInfo.bucketId, "imgUrl": urlImage}))
        .then((value) async {
      final res = jsonDecode(value.body);
      final imgRes = await http.get(Uri.parse(res["fileView"]));

      final fileBlob = Blob([imgRes.bodyBytes]);
      AnchorElement(href: Url.createObjectUrlFromBlob(fileBlob))
        ..download = "${res["fileName"].toString().split('/').last}.png"
        ..click();

      debugPrint(res.body);
    });
  }

  Future<void> storageImage(String urlImage) async {
    await http.post(
      Uri.parse("${CretaAccountManager.getEnterprise!.mediaApiUrl}/downloadAiImg"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(
          {"userId": myConfig!.serverConfig!.storageConnInfo.bucketId, "imgUrl": urlImage}),
    );
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
    logger.fine('_LeftMenuImageState.initState');
    _selectedTab = CretaStudioLang['imageMenuTabBar']!.values.first;
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
    originalText = '';
    super.initState();
  }

  @override
  void dispose() {
    TipToggleWidget.overlayEntry?.remove();
    super.dispose();
  }

  Widget _menuBar() {
    return Container(
      height: LayoutConst.innerMenuBarHeight, // heihgt: 36
      width: LayoutConst.rightMenuWidth, // width: 380
      color: CretaColor.text[100],
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: CustomRadioButton(
          radioButtonValue: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          width: 95,
          autoWidth: true,
          height: 28,
          buttonTextStyle: ButtonTextStyle(
            selectedColor: CretaColor.primary,
            unSelectedColor: CretaColor.text[700]!,
            textStyle: CretaFont.buttonMedium,
          ),
          selectedColor: Colors.white,
          unSelectedColor: CretaColor.text[100]!,
          defaultSelected: _selectedTab,
          buttonLables: CretaStudioLang['imageMenuTabBar']!.keys.toList(),
          buttonValues: [...CretaStudioLang['imageMenuTabBar']!.values.toList()],
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          elevation: 0,
          enableButtonWrap: false,
          enableShape: true,
          shapeRadius: 60,
        ),
      ),
    );
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
      hintText: CretaStudioLang['queryHintText']!,
      onSearch: (value) {
        searchText = value;
      },
    );
  }

  Widget _imageResult() {
    List<dynamic> menu = CretaStudioLang['imageMenuTabBar']!.values.toList();
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
                BTN.line_blue_t_m(text: CretaStudioLang['myUploadedImage']!, onPressed: () {}),
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
                ? Text(CretaStudioLang['aiImageGeneration']!, style: CretaFont.titleSmall)
                : Text(CretaStudioLang['aiGeneratedImage']!, style: CretaFont.titleSmall),
            const TipToggleWidget(),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CretaTextField.short(
                controller: LeftMenuImage.textController,
                textFieldKey: GlobalKey(),
                value: originalText,
                hintText: '',
                onEditComplete: (value) {
                  originalText = value;
                  logger.fine('onEditComplete value = $value');
                }),
          ),
          imageAIDisplay(),
        ],
      );
    }

    if (_selectedTab == menu[3]) {
      return const LeftMenuGiphy();
    }

    return const SizedBox.shrink();
  }

  Widget searchTip() {
    return const SearchTipPosition();
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
          logger.fine('------ Style open state: $_isStyleOpened---------');
        });
      },
      titleWidget: Text(CretaStudioLang['imageStyle']!, style: CretaFont.titleSmall),
      bodyWidget: _styleOptions(),
      trailWidget: Text(StyleSelectedWidget.selectedCard != -1
          ? CretaStudioLang['imageStyleList']![StyleSelectedWidget.selectedCard]
          : ''),
      showTrail: _state == AIState.ready ? _isTrailShowed : !_isTrailShowed,
      hasRemoveButton: StyleSelectedWidget.selectedCard >= 0 ? true : false,
      onDelete: () {
        setState(() {
          StyleSelectedWidget.selectedCard = -1;
        });
      },
    );
  }

  Widget _styleOptions() {
    return const StyleSelectedWidget();
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
                    LeftMenuImage.textController.text = promptText;
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
                              logger.fine('----------Select generated image $imageIndex----------');
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
              child: CretaSnippet.showWaitSign(),
            ),
          ),
        );
      case AIState.fail:
        return SizedBox(
            height: 350.0,
            child: Center(
              child: Text(CretaStudioLang['genAIerrorMsg']!, textAlign: TextAlign.center),
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
                },
              ),
              const SizedBox(width: 4.0),
              // add to my storage
              BTN.opacity_gray_i_s(
                  icon: Icons.inventory_2_outlined,
                  onPressed: () {
                    storageImage(imgUrl[imageIndex]);
                    debugPrint('Storage button pressed');
                  }),
            ],
          ),
        ),
    ]);
  }

  // with promptText translation
  void _onPressed() {
    String textToGen = LeftMenuImage.textController.text;
    originalText = textToGen;
    String selectedStyle = StyleSelectedWidget.selectedCard != -1
        ? CretaStudioLang['imageStyleList']![StyleSelectedWidget.selectedCard]
        : '';
    if (selectedStyle.isNotEmpty) textToGen += ' , $selectedStyle';
    translator.translate(textToGen, to: "en").then((value) {
      setState(() {
        _isStyleOpened = false;
        TipToggleWidget.isTipOpened = false;
        TipToggleWidget.overlayEntry?.remove();
        TipToggleWidget.overlayEntry = null;
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
              text: CretaStudioLang['genAIImage']!,
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
                text: CretaStudioLang['genImageAgain']!,
                onPressed: _onPressed,
              ),
              const SizedBox(width: 5.0),
              BTN.line_blue_t_m(
                text: CretaStudioLang['genFromBeginning']!,
                onPressed: () {
                  setState(() {
                    TipToggleWidget.isTipOpened = false;
                    _isStyleOpened = true;
                    _state = AIState.ready;
                    StyleSelectedWidget.selectedCard = -1;
                    originalText = '';
                  });
                },
              ),
            ],
          ),
        );
      case AIState.fail:
        return BTN.line_blue_t_m(
          text: CretaStudioLang['genFromBeginning']!,
          onPressed: () {
            setState(() {
              TipToggleWidget.isTipOpened = false;
              _isStyleOpened = true;
              _state = AIState.ready;
              StyleSelectedWidget.selectedCard = -1;
              originalText = '';
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
                // tooltip: CretaStudioLang['copy']!,
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
                    logger.fine('-------- Select image $totalIndex in $title--------');
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
            child: Text(CretaStudioLang['recentUploadedImage']!, style: CretaFont.titleSmall),
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
                        logger.fine('---------Select image $index---------');
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
