import 'dart:async';
import 'package:creta_common/common/creta_snippet.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:creta03/data_io/book_published_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/login/login_dialog.dart';
import 'package:creta03/routes.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';
import 'package:video_player/video_player.dart';

import '../design_system/component/snippet.dart';
import '../design_system/menu/creta_widget_drop_down.dart';
import '../lang/creta_commu_lang.dart';
import '../lang/creta_mypage_lang.dart';
import 'mypage/popup/chage_pwd_popup.dart';
import 'studio/studio_variables.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // screen vertical scroll controller
  final ScrollController _verticalScroller = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // screen width
  double? _screenWidth;

  // published book manager
  late BookPublishedManager bookPublishedManagerHolder;

  // appbar effect
  BoxShadow? appBarShadow;

  // dropdown menu item
  List<Text> languageItemList = [];
  //late List<DropdownMenuItem> languageItems;
  List<DropdownMenuItem> purposeItems = [];
  List<DropdownMenuItem> sortItems = [];
  // selected value of dropdown menu
  //late String selectedLanguage;
  BookType selectedPurpose = BookType.presentation;
  BookSort selectedSort = BookSort.updateTime;

  List<String> topBannerImgPaths = [];
  List<String> bottomBannerImgPaths = [];

  // search result creta book
  List<BookModel> searchCretaBooks = [];
  Key _searchResultPageKey = UniqueKey();

  // video player controller
  late VideoPlayerController presentationAnimationController;
  late VideoPlayerController communityAnimationController;
  late VideoPlayerController signageAnimationController;
  late VideoPlayerController quickStartAnimationController;

  final ValueNotifier<String> _animationLogoImgPath =
      ValueNotifier<String>("assets/landing_page/image/creta_animation_logo.png");

  double _imageLeffOffset = 0;
  LanguageType oldLanguage = LanguageType.none;

  // initalize video controller
  Future<void> initalizeVideoController() async {
    await presentationAnimationController.initialize();
    await communityAnimationController.initialize();
    await signageAnimationController.initialize();
    await quickStartAnimationController.initialize();
  }

  BuildContext getBuildContext() {
    return context;
  }

  @override
  void initState() {
    super.initState();
    StudioVariables.selectedBookMid = ''; //skpark add
    bookPublishedManagerHolder = BookPublishedManager();

    // TextStyle languageMenuStyle = CretaFont.buttonLarge
    //     .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: CretaColor.primary);

    // languageItems = [
    //   DropdownMenuItem(value: "ko", child: Text("한국어", style: languageMenuStyle)),
    //   // DropdownMenuItem(value: "en", child: Text("EN", style: languageMenuStyle)),
    //   // DropdownMenuItem(value: "ja", child: Text("日本語", style: languageMenuStyle))
    // ];

    isLangInit = initLang();

    topBannerImgPaths = [
      // "assets/landing_page/image/banner/banner_top1.png",
      "assets/landing_page/image/banner/banner_top2.png",
      "assets/landing_page/image/banner/banner_top3.png",
      "assets/landing_page/image/banner/banner_top4.png",
      "assets/landing_page/image/banner/banner_top5.png",
      "assets/landing_page/image/banner/banner_top6.png",
      "assets/landing_page/image/banner/banner_top7.png",
      "assets/landing_page/image/banner/banner_top8.png",
      "assets/landing_page/image/banner/banner_top9.png",
      "assets/landing_page/image/banner/banner_top10.png",
      "assets/landing_page/image/banner/banner_top11.png",
    ];
    bottomBannerImgPaths = [
      "assets/landing_page/image/banner/banner_bottom1.png",
      "assets/landing_page/image/banner/banner_bottom2.png",
      "assets/landing_page/image/banner/banner_bottom3.png",
      "assets/landing_page/image/banner/banner_bottom4.png",
      "assets/landing_page/image/banner/banner_bottom5.png",
      "assets/landing_page/image/banner/banner_bottom7.png",
      "assets/landing_page/image/banner/banner_bottom6.png",
      "assets/landing_page/image/banner/banner_bottom8.png",
      "assets/landing_page/image/banner/banner_bottom9.png",
      "assets/landing_page/image/banner/banner_bottom10.png",
      "assets/landing_page/image/banner/banner_bottom11.png",
      "assets/landing_page/image/banner/banner_bottom12.png",
    ];

    presentationAnimationController =
        VideoPlayerController.asset("assets/landing_page/video/presentation_animation.mp4");
    communityAnimationController =
        VideoPlayerController.asset("assets/landing_page/video/community_animation.mp4");
    signageAnimationController =
        VideoPlayerController.asset("assets/landing_page/video/signage_animation.mp4");
    quickStartAnimationController =
        VideoPlayerController.asset("assets/landing_page/video/quick_start_animation.mp4");

    afterBuild();
  }

  static Future<bool>? isLangInit;

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initMenu();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;

    return true;
  }

  void _initMenu() {
    TextStyle searchFilterStyle = CretaFont.buttonLarge.copyWith(fontSize: 20);

    languageItemList.clear();
    for (var element in CretaMyPageLang['languageList']!) {
      languageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }

    purposeItems = [
      DropdownMenuItem(
          value: BookType.presentation,
          child: Text(CretaCommuLang['presentation']!, // "프레젠테이션",
              style: searchFilterStyle)),
      DropdownMenuItem(
          value: BookType.signage,
          child: Text(CretaCommuLang['signage']!, //"디지털사이니지"
              style: searchFilterStyle)),
    ];
    sortItems = [
      DropdownMenuItem(
          value: BookSort.updateTime,
          child: Text(CretaCommuLang['dateOrder']!, // "최신순",
              style: searchFilterStyle)),
      DropdownMenuItem(
          value: BookSort.likeCount,
          child: Text(CretaCommuLang['likeOrder']!, //"좋아요순",
              style: searchFilterStyle))
    ];

    //selectedLanguage = languageItems.first.value;
    selectedPurpose = purposeItems.first.value;
    selectedSort = sortItems.first.value;

    _imageLeffOffset = _calcImageLeftOffset();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initalizeVideoController().then((value) => setState(() {
            presentationAnimationController.setVolume(0);
            communityAnimationController.setVolume(0);
            signageAnimationController.setVolume(0);
            quickStartAnimationController.setVolume(0);

            presentationAnimationController.play();
            communityAnimationController.play();
            signageAnimationController.play();
            quickStartAnimationController.play();

            presentationAnimationController.setLooping(true);
            communityAnimationController.setLooping(true);
            signageAnimationController.setLooping(true);
            quickStartAnimationController.setLooping(true);
          }));

      searchCretaBook().then((value) => setState(() {}));
      _verticalScroller.addListener(() {
        if (_verticalScroller.offset > 10) {
          setState(() {
            appBarShadow = BoxShadow(
                color: const Color(0xff1A1A1A).withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 2));
          });
        }
      });

      Timer.periodic(const Duration(seconds: 3), (timer) {
        _animationLogoImgPath.value =
            (_animationLogoImgPath.value == "assets/landing_page/image/creta_animation_logo.png")
                ? "assets/landing_page/image/creta_animation_logo2.png"
                : "assets/landing_page/image/creta_animation_logo.png";
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();

    _verticalScroller.dispose();
    _horizontalController.dispose();
    presentationAnimationController.dispose();
    communityAnimationController.dispose();
    signageAnimationController.dispose();
    quickStartAnimationController.dispose();
    bookPublishedManagerHolder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = _screenWidth == null
        ? (275 + 10) * 5 + (60 + 40) * 2
        : _screenWidth! < MediaQuery.sizeOf(context).width
            ? MediaQuery.sizeOf(context).width
            : _screenWidth;

    //_screenWidth = _screenWidth == null ? 1600 : MediaQuery.sizeOf(context).width;

    return FutureBuilder<bool>(
        future: isLangInit,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            logger.severe("data fetch error(WaitDatum)");
            return const Center(child: Text('data fetch error(WaitDatum)'));
          }
          if (snapshot.hasData == false) {
            //print('xxxxxxxxxxxxxxxxxxxxx');
            logger.finest("wait data ...(WaitData)");
            return Center(
              child: CretaSnippet.showWaitSign(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            logger.finest("founded ${snapshot.data!}");

            return Scaffold(
              backgroundColor: Colors.white,
              body: MediaQuery.sizeOf(context).height < 140
                  ? const SizedBox.shrink()
                  : LayoutBuilder(builder: (context, constraints) {
                      //print('------------layoutBuilder ${MediaQuery.sizeOf(context).width}');
                      return Scrollbar(
                        thumbVisibility: true,
                        controller: _horizontalController,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _horizontalController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                appBar(),
                                SizedBox(
                                  width: _screenWidth,
                                  height: MediaQuery.sizeOf(context).height - 117,
                                  child: SingleChildScrollView(
                                    controller: _verticalScroller,
                                    child: Column(
                                      children: [
                                        mainBanner(),
                                        const SizedBox(height: 14),
                                        exploreSection(),
                                        const SizedBox(height: 238),
                                        experienceSection(),
                                        const SizedBox(height: 183),
                                        promotionSection(),
                                        const SizedBox(height: 195),
                                        guideSection(),
                                        const SizedBox(height: 217),
                                        solutionSection(),
                                        const SizedBox(height: 258),
                                        quickStartSection(),
                                        const SizedBox(height: 200),
                                        footer()
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                      );
                    }),
            );
          }
          return const SizedBox.shrink();
        });
  }

  // ************************************ get ************************************
  Future<void> searchCretaBook() async {
    searchCretaBooks.clear();

    bookPublishedManagerHolder.addCretaFilters(
        bookType: selectedPurpose,
        bookSort: selectedSort,
        permissionType: PermissionType.reader,
        searchKeyword: '',
        userId: 'cretacreates');

    await bookPublishedManagerHolder.queryByAddedContitions();
    List<AbsExModel> queryResults = bookPublishedManagerHolder.modelList;
    for (var result in queryResults) {
      searchCretaBooks.add(result as BookModel);
    }

    setState(() {
      _searchResultPageKey = UniqueKey();
    });
  }

  // ************************************ common widget ************************************
  Widget customButton(
      {required double width,
      required double height,
      required Widget child,
      required void Function() onTap,
      Color backgroundColor = Colors.white,
      Border? border,
      BorderRadius? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            color: backgroundColor,
            boxShadow: boxShadow),
        child: Center(
          child: child,
        ),
      ),
    );
  }

  Widget dropdownMenu(
      {required double width,
      required double height,
      required List<DropdownMenuItem> items,
      required dynamic defaultValue,
      required void Function(dynamic) onSelected,
      Icon icon = const Icon(Icons.expand_more, color: CretaColor.primary),
      double iconSize = 10}) {
    dynamic selectedValue = defaultValue;
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: selectedValue,
              items: items,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  onSelected(value);
                });
              },
              icon: icon,
              iconSize: iconSize,
              isExpanded: true,
              elevation: 0,
              focusColor: Colors.white,
              dropdownColor: Colors.white)),
    );
  }

  // ************************************ app bar ************************************
  Widget appBar() {
    TextStyle appBarBTNStyle = CretaFont.buttonLarge
        .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: CretaColor.primary);

    int langIndex = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language.index;

    return Container(
      width: MediaQuery.sizeOf(context).width, // _screenWidth,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: appBarShadow != null ? [appBarShadow!] : null),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, left: 140, right: 140, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(
              image: AssetImage("assets/creta_logo_blue.png"),
              width: 136,
              height: 40,
            ),
            SizedBox(
              width: 337,
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountManager.currentLoginUser.isLoginedUser
                      ? customButton(
                          width: 52,
                          height: 19,
                          child: Text("Logout", style: appBarBTNStyle),
                          onTap: () {
                            setState(() {
                              CretaAccountManager.logout();
                            });
                          })
                      : customButton(
                          width: 48,
                          height: 19,
                          child: Text("Login", style: appBarBTNStyle),
                          onTap: () => LoginDialog.popupDialog(
                            context: context,
                            getBuildContext: getBuildContext,
                            onAfterLogin: () {
                              //setState(() {});
                              if (AccountManager.currentLoginUser.hasGenPassword) {
                                showDialog(
                                    context: context,
                                    builder: (context) => ChangePwdPopUp.changePwdPopUp(context,
                                        title: CretaMyPageLang['shouldChangePassword'] ??
                                            '반드시 비밀번호를 변경한 후 사용해주세요.'));
                              }
                            },
                          ),
                        ),
                  customButton(
                      width: 140,
                      height: 48,
                      child: Text("Sign up", style: appBarBTNStyle),
                      onTap: () => LoginDialog.popupDialog(
                          context: context,
                          getBuildContext: getBuildContext,
                          loginPageState: LoginPageState.singup),
                      border: Border.all(color: CretaColor.primary),
                      borderRadius: BorderRadius.circular(6.6)),
                  CretaWidgetDropDown(
                      width: 102,
                      items: languageItemList,
                      defaultValue: langIndex > 0 ? langIndex - 1 : 0,
                      onSelected: (value) {
                        Snippet.onLangSelected(
                          value: value + 1,
                          userPropertyManager: CretaAccountManager.userPropertyManagerHolder,
                          invalidate: () {
                            setState(() {
                              _initMenu();
                            });
                            //CretaAccountManager.userPropertyManagerHolder.notify();
                          },
                        );
                        // userPropertyManager.userPropertyModel!.language =
                        //     LanguageType.fromInt(value + 1);
                        // setState(() {
                        //   AbsCretaLang.changeLang(
                        //       userPropertyManager.userPropertyModel!.language);
                        // });
                      }),
                  // dropdownMenu(
                  //     width: 64,
                  //     height: 19,
                  //     items: languageItems,
                  //     defaultValue: selectedLanguage,
                  //     onSelected: (value) => selectedLanguage = value)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ************************************ main banner ************************************
  Widget mainBanner() {
    return SizedBox(
      width: _screenWidth,
      height: 895,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              rollingBannerImg(topBannerImgPaths),
              const SizedBox(height: 26),
              rollingBannerImg(bottomBannerImgPaths, scrollDirection: "right")
            ],
          ),
          Center(
              child: Container(
            width: 1800,
            height: 480,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xffF4F8FF).withOpacity(0.6)),
          )),
          Positioned(
              top: 50,
              child: Center(
                  child: ValueListenableBuilder(
                valueListenable: _animationLogoImgPath,
                builder: (context, animationImgPath, child) {
                  return Image(image: AssetImage(animationImgPath));
                },
              ))),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Text(
                CretaCommuLang['intro']!,
                //"크레타는 사용자가 상상하는대로 다양하게 사용할 수 있습니다. \n사이니지, 프레젠테이션, 전자칠판, 화상회의까지 \n각 용도별로 직접 체험해보세요.",
                style: CretaFont.titleLarge.copyWith(color: CretaColor.text.shade400),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget rollingBannerImg(List<String> bannerImgPaths, {String scrollDirection = "left"}) {
    return Transform.rotate(
      angle: -0.1,
      child: SizedBox(
        width: _screenWidth,
        height: 320,
        child: CarouselSlider(
          items: bannerImgPaths
              .map((imgPath) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: AssetImage(imgPath),
                      height: 320,
                      fit: BoxFit.fitHeight,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              reverse: scrollDirection == "right",
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              initialPage: 1,
              viewportFraction: 0.25,
              scrollDirection: Axis.horizontal,
              autoPlayCurve: Curves.easeInOut),
        ),
      ),
    );
  }

  // ************************************ explore section ************************************
  Widget exploreSection() {
    final PageController resultPageController = PageController();
    int currentPage = 0;

    return SizedBox(
      width: _screenWidth,
      height: 407,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 841,
            height: 124,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xff0D41A5).withOpacity(0.06),
                      blurRadius: 80,
                      spreadRadius: 2,
                      offset: const Offset(0, 2))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),
                    dropdownMenu(
                        width: 160,
                        height: 24,
                        items: purposeItems,
                        defaultValue: selectedPurpose,
                        onSelected: (value) => selectedPurpose = value,
                        iconSize: 20),
                    const SizedBox(height: 20),
                    Text(CretaCommuLang['useGuide']!, //"크레타북을 어떻게 사용하는지",
                        style: CretaFont.bodyESmall.copyWith(fontWeight: FontWeight.w300))
                  ],
                ),
                //const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),
                    dropdownMenu(
                        width: 100,
                        height: 24,
                        items: sortItems,
                        defaultValue: selectedSort,
                        onSelected: (value) => selectedSort = value,
                        iconSize: 20),
                    const SizedBox(height: 20),
                    Text(CretaCommuLang['inventWhen']!, //"크레타북을 발행한 게 언제인지",
                        style: CretaFont.bodyESmall.copyWith(fontWeight: FontWeight.w300))
                  ],
                ),
                //const SizedBox(width: 220),
                customButton(
                    width: 186,
                    height: 68,
                    child: Text(CretaCommuLang['search']!, //"탐색하기",
                        style: CretaFont.buttonMedium.copyWith(color: Colors.white, fontSize: 24)),
                    backgroundColor: CretaColor.primary,
                    borderRadius: BorderRadius.circular(13.3),
                    onTap: () {
                      searchCretaBook();
                    })
              ],
            ),
          ),
          const SizedBox(height: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              searchCretaBooks.isNotEmpty
                  ? customButton(
                      width: 60,
                      height: 60,
                      child:
                          const Icon(Icons.arrow_back_ios_new, color: CretaColor.primary, size: 20),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff1A1A1A).withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 2))
                      ],
                      onTap: () {
                        if (currentPage > 0) {
                          resultPageController.animateToPage(currentPage - 1,
                              duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                          currentPage -= 1;
                        }
                      })
                  : const SizedBox.shrink(),
              const SizedBox(width: 40),
              SizedBox(
                width: (275 + 10) * 5,
                height: 231,
                child: Center(
                  child: PageView.builder(
                    key: _searchResultPageKey,
                    controller: resultPageController,
                    itemCount: (searchCretaBooks.length / 5).ceil(),
                    itemBuilder: (context, index) {
                      int endIndex = (index * 5) + 5 <= searchCretaBooks.length
                          ? (index * 5) + 5
                          : searchCretaBooks.length;
                      List<Widget> searchResults = [];
                      for (var cretaBook in searchCretaBooks.sublist(index * 5, endIndex)) {
                        searchResults.add(InkWell(
                          onTap: () => Routemaster.of(context)
                              .push("${AppRoutes.communityBook}?${cretaBook.mid}"),
                          child: Container(
                              width: 275,
                              height: 231,
                              decoration: BoxDecoration(
                                  color: Colors.yellow, borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  cretaBook.thumbnailUrl.value,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/creta_logo_blue.png",
                                        fit: BoxFit.cover);
                                  },
                                ),
                              )),
                        ));
                        searchResults.add(const SizedBox(width: 10));
                      }
                      searchResults.removeLast();

                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: searchResults);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 40),
              searchCretaBooks.length > 5
                  ? customButton(
                      width: 60,
                      height: 60,
                      child:
                          const Icon(Icons.arrow_forward_ios, color: CretaColor.primary, size: 20),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff1A1A1A).withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 2))
                      ],
                      onTap: () {
                        if (currentPage < (searchCretaBooks.length / 5).ceil()) {
                          resultPageController.animateToPage(currentPage + 1,
                              duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                          currentPage += 1;
                        }
                      })
                  : const SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  double _calcImageLeftOffset() {
    LanguageType language =
        CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    switch (language) {
      case LanguageType.english:
        return 145.0;
      case LanguageType.japanese:
        return 120.0;
      default:
        return 0;
    }
  }

  String _getTextEffect1BGFile() {
    LanguageType language =
        CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    switch (language) {
      case LanguageType.english:
        return "assets/landing_page/image/text_effect_1_big.png";
      case LanguageType.japanese:
        return "assets/landing_page/image/text_effect_1_big.png";
      default:
        return "assets/landing_page/image/text_effect_1.png";
    }
  }

  String _getTextEffect2BGFile() {
    LanguageType language =
        CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    switch (language) {
      case LanguageType.english:
        return "assets/landing_page/image/text_effect_2_eng.png";
      default:
        return "assets/landing_page/image/text_effect_2.png";
    }
  }

  // ************************************ experience section ************************************
  Widget experienceSection() {
    TextStyle titleFontStyle = CretaFont.titleLarge
        .copyWith(fontWeight: FontWeight.w700, fontSize: 40, color: CretaColor.text.shade700);

    return SizedBox(
      width: 1665,
      height: 900, //1062
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 45, bottom: 10, left: _imageLeffOffset),
                child: Image(image: AssetImage(_getTextEffect1BGFile()), width: 623, height: 63),
              ),
              //Text(CretaCommuLang['exp1']!, style: titleFontStyle, textAlign: TextAlign.center),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: CretaCommuLang['exp1']!, //"커뮤니티에 공개된 \n",
                    style: titleFontStyle,
                    children: [
                      TextSpan(
                          text: CretaCommuLang['exp2']!, // "다양한 용도의 ",
                          style: titleFontStyle),
                      TextSpan(
                          text: CretaCommuLang['exp3']!, // "크레타북",
                          style: titleFontStyle.copyWith(color: Colors.white)),
                      TextSpan(
                          text: CretaCommuLang['exp4']!, //" 을 체험해보세요",
                          style: titleFontStyle)
                    ]),
              ),
            ],
          ),

          SizedBox(
            width: 1665,
            height: 488,
            child: Stack(
              children: [
                Positioned(
                  top: 110,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 560.75,
                        height: 325,
                        child: presentationAnimationController.value.isInitialized
                            ? VideoPlayer(presentationAnimationController)
                            : null,
                      ),
                      const SizedBox(width: 180),
                      SizedBox(
                        width: 342,
                        height: 204,
                        child: communityAnimationController.value.isInitialized
                            ? VideoPlayer(communityAnimationController)
                            : null,
                      ),
                      const SizedBox(width: 41),
                      SizedBox(
                        width: 541,
                        height: 376,
                        child: signageAnimationController.value.isInitialized
                            ? VideoPlayer(signageAnimationController)
                            : null,
                      )
                    ],
                  ),
                ),
                experienceQuickBTN(
                    CretaCommuLang['presentation']!, //"프레젠테이션",
                    "Create and present",
                    const Offset(18, 14), () {
                  CretaAccountManager.experienceWithoutLogin = true;
                  Routemaster.of(context).push(AppRoutes.studioBookMainPage);
                }),
                experienceQuickBTN(
                    width: 220,
                    CretaCommuLang['community']!,
                    //"커뮤니티",
                    "Share and communicate",
                    const Offset(562, 320), () {
                  CretaAccountManager.experienceWithoutLogin = true;
                  Routemaster.of(context).push(AppRoutes.communityHome);
                }),
                experienceQuickBTN(
                    CretaCommuLang['signage']!,
                    //"디지털사이니지",
                    "Create and broadcast",
                    const Offset(1460, 0),
                    () {})
              ],
            ),
          ),
          // const SizedBox(height: 84),
          // Container(
          //   width: 1600,
          //   height: 400,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade100,
          //     borderRadius: BorderRadius.circular(60)
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const SizedBox(width: 80),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text("체험하기", style: CretaFont.titleELarge.copyWith(fontSize: 56, fontWeight: FontWeight.w700)),
          //           const SizedBox(height: 32),
          //           Text("크레타는 사용자가 상상하는대로 다양하게 사용할 수 있습니다. \n사이니지, 프레젠테이션, 전자칠판, 화상회의까지 \n각 용도별로 직접 체험해보세요.", style: CretaFont.bodyLarge.copyWith(color: CretaColor.text.shade400)),
          //         ],
          //       ),
          //       const SizedBox(width: 122),
          //       experienceBTN("사이니지", ""),
          //       const SizedBox(width: 28),
          //       experienceBTN("프레젠테이션", "")
          //     ],
          //   )
          // )
        ],
      ),
    );
  }

  Widget experienceQuickBTN(
      String solutionName, String solutionDescription, Offset offset, void Function() onTap,
      {double width = 200, double height = 80}) {
    return Positioned(
        top: offset.dy,
        left: offset.dx,
        child: customButton(
            width: width,
            height: height,
            child: Row(
              children: [
                const SizedBox(width: 23),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18), color: CretaColor.secondary),
                  child: const Center(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 12),
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(solutionName, style: CretaFont.titleMedium),
                      Text(solutionDescription,
                          style: CretaFont.bodyESmall.copyWith(color: CretaColor.text.shade400))
                    ],
                  ),
                )
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(-8, 8))
            ],
            onTap: onTap));
  }

  Widget experienceBTN(String solutionName, String description) {
    return Container(
      width: 400,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: const Color(0xff1A1A1A).withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 44, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(solutionName,
                    style: CretaFont.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        color: CretaColor.text.shade700)),
                customButton(
                    width: 72,
                    height: 72,
                    borderRadius: BorderRadius.circular(36),
                    backgroundColor: CretaColor.secondary,
                    child: const Center(
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    onTap: () {})
              ],
            ),
            const SizedBox(height: 48),
            Text(description, style: CretaFont.bodyLarge.copyWith(color: CretaColor.text.shade400))
          ],
        ),
      ),
    );
  }

  // ************************************ promotion section ************************************
  Widget promotionSection() {
    return SizedBox(
      width: 1256 + 52,
      height: 1161,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              promotionComponent(
                  width: 572,
                  height: 413,
                  promotionText:
                      CretaCommuLang['prot1']!, // "디자이너가 아니어도 누구나 \n쉽고 간단하게 디자인 할 수 있어!",
                  promotionImgPath: "assets/landing_page/image/promotion_1.png",
                  promotionImgOffset: const Offset(0, 163),
                  promotionImgSize: const Size(555, 250),
                  containerPadding: const EdgeInsets.only(left: 72)),
              const SizedBox(height: 38),
              promotionComponent(
                  width: 500,
                  height: 434,
                  promotionText: CretaCommuLang['prot2']!, // "팀원들과 효율적으로 협업하고 \n작업물은 체계적으로 관리하지!",
                  promotionImgPath: "assets/landing_page/image/promotion_3.png",
                  promotionImgOffset: const Offset(27, 164),
                  promotionImgSize: const Size(376, 270),
                  backgroundColor: Colors.grey.shade100,
                  fontColor: CretaColor.text.shade700),
              const SizedBox(height: 64),
              Text(CretaCommuLang['prot3']!, //"크레타에 대해 더 궁금하시다면 \n지금 바로 로그인 없이 체험해보세요!",
                  style: CretaFont.titleELarge.copyWith(fontSize: 28, height: 1.5),
                  textAlign: TextAlign.right),
              const SizedBox(height: 28),
              customButton(
                  width: 227,
                  height: 80,
                  backgroundColor: CretaColor.primary,
                  borderRadius: BorderRadius.circular(13.3),
                  child: Center(
                    child: Text(CretaCommuLang['experience']!, //  "체험하기",
                        style: CretaFont.buttonLarge.copyWith(color: Colors.white, fontSize: 24)),
                  ),
                  onTap: () {
                    CretaAccountManager.experienceWithoutLogin = true;
                    Routemaster.of(getBuildContext()).push(AppRoutes.communityHome);
                  })
            ],
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 74, left: 28),
                    child: Image(
                      image: AssetImage(_getTextEffect2BGFile()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 72, left: 42),
                    child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: CretaCommuLang['creativ1']!, // "놀라울정도로 크리에이티브한 ",
                            style: CretaFont.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 40,
                                color: CretaColor.text.shade700,
                                height: 1.6),
                            children: [
                              TextSpan(
                                  text: CretaCommuLang['creta']!, // "크레타",
                                  style: CretaFont.titleLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40,
                                      color: Colors.white,
                                      height: 1.6)),
                              TextSpan(
                                  text: CretaCommuLang['creativ2']!, // " 로",
                                  style: CretaFont.titleLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40,
                                      color: CretaColor.text.shade700,
                                      height: 1.6)),
                              TextSpan(
                                  text: CretaCommuLang['creativ3']!, //"\n당신의 상상력을 펼쳐보세요!",
                                  style: CretaFont.titleLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40,
                                      color: CretaColor.text.shade700))
                            ])),
                  ),
                ],
              ),
              const SizedBox(height: 76),
              promotionComponent(
                  width: 593.67,
                  height: 418,
                  promotionText: CretaCommuLang['commu1']!, //"디자인한 콘텐츠는 간편하게 \n공유하고 소통할 수 있지!",
                  promotionImgPath: "assets/landing_page/image/promotion_2.png",
                  promotionImgOffset: const Offset(75, 176),
                  promotionImgSize: const Size(518.67, 242),
                  backgroundColor: CretaColor.primary),
              const SizedBox(height: 30),
              promotionComponent(
                  width: 500,
                  height: 411.06,
                  promotionText: CretaCommuLang['commu2']!, //"다양한 디바이스에 바로 \n디자인한 콘텐츠를 송출시킬 수 있어!",
                  promotionImgPath: "assets/landing_page/image/promotion_4.png",
                  promotionImgOffset: const Offset(50, 164),
                  promotionImgSize: const Size(409.43, 247.06),
                  backgroundColor: CretaColor.primary.shade200,
                  fontColor: CretaColor.text.shade700),
            ],
          )
        ],
      ),
    );
  }

  Widget promotionComponent({
    required double width,
    required double height,
    required String promotionText,
    required String promotionImgPath,
    required Offset promotionImgOffset,
    required Size promotionImgSize,
    EdgeInsets containerPadding = EdgeInsets.zero,
    Color fontColor = Colors.white,
    Color backgroundColor = CretaColor.secondary,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Padding(
            padding: containerPadding,
            child: Container(
              width: 500,
              height: 400,
              decoration:
                  BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.only(top: 42, left: 48),
                child: Text(promotionText,
                    style: CretaFont.displaySmall
                        .copyWith(fontSize: 28, color: fontColor, height: 1.5)),
              ),
            ),
          ),
          Positioned(
              top: promotionImgOffset.dy,
              left: promotionImgOffset.dx,
              child: Image(
                image: AssetImage(promotionImgPath),
                width: promotionImgSize.width,
                height: promotionImgSize.height,
              ))
        ],
      ),
    );
  }

  // ************************************ creta guide section ************************************
  Widget guideSection() {
    return SizedBox(
      width: 1360 + 66 + 8,
      height: 792,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Positioned(
                top: 32,
                left: 74,
                child: Text(CretaCommuLang['useCreta']!, //"크레타를 이렇게 사용해보세요!",
                    style: CretaFont.titleELarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: CretaColor.text.shade700,
                        fontSize: 40)),
              ),
              const Image(image: AssetImage("assets/landing_page/image/text_effect_3.png")),
            ],
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                guideComponent(
                    "assets/landing_page/image/guide_1.png",
                    CretaCommuLang['commuSearch']!, //"커뮤니티 탐색",
                    CretaCommuLang['idea']!, // "다양한 크레타북을 시청하고 \n새로운 아이디어를 얻으세요.",
                    35),
                const SizedBox(height: 42),
                const Image(
                  image: AssetImage("assets/landing_page/image/arrow_1.png"),
                )
              ]),
              guideComponent(
                  "assets/landing_page/image/guide_2.png",
                  CretaCommuLang['edit']!, //"스튜디오 편집",
                  CretaCommuLang['easy']!, // "크레타 스튜디오에서 쉽고 간단하게 \n발표자료를 제작해보세요.",
                  88),
              Column(children: [
                guideComponent(
                    "assets/landing_page/image/guide_3.png",
                    CretaCommuLang['share1']!, //"발표자료 공유",
                    CretaCommuLang['share2']!, //"제작한 발표자료를 커뮤니티에 \n공유해보세요.",
                    0),
                const SizedBox(
                  width: 367,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 59),
                        child: Image(
                          image: AssetImage("assets/landing_page/image/arrow_2.png"),
                        ),
                      ),
                      Image(
                        image: AssetImage("assets/landing_page/image/arrow_3.png"),
                      )
                    ],
                  ),
                )
              ]),
              guideComponent(
                  "assets/landing_page/image/guide_4.png",
                  CretaCommuLang['presen1']!, // "성공적인 발표",
                  CretaCommuLang['presen2']!, //"판서 기능과 회의 기능을 활용하여 \n발표자료를 발표합니다.",
                  148),
            ],
          )
        ],
      ),
    );
  }

  Widget guideComponent(String guideImgPath, String title, String description, double topPadding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPadding),
        Image(image: AssetImage(guideImgPath)),
        const SizedBox(height: 14),
        Text(title,
            style: CretaFont.titleLarge.copyWith(fontSize: 28, color: CretaColor.text.shade700)),
        const SizedBox(height: 20),
        Text(description,
            style: CretaFont.bodyLarge
                .copyWith(fontWeight: FontWeight.w300, color: CretaColor.text.shade700)),
      ],
    );
  }

  // ************************************ creta guide section ************************************
  Widget solutionSection() {
    return SizedBox(
      width: 1360,
      height: 600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          solutionComponent(
              CretaCommuLang['studio']!, //"스튜디오",
              [
                {
                  "title": CretaCommuLang['studio1']!, //"다양한 위젯",
                  "description": CretaCommuLang[
                      'studio2']!, //"크레타가 제공하는 날씨, 뮤직, 시계, 카메라 등 \n다양한 위젯으로 다채롭게 꾸며보세요."
                },
                {
                  "title": CretaCommuLang['studio3']!, //"여러명이 동시에",
                  "description":
                      CretaCommuLang['studio4']!, //"여러 명의 사용자가 하나의 크레타북을 \n동시에 편집할 수 있습니다."
                },
                {
                  "title": CretaCommuLang['studio5']!, //"디바이스 통합 플랫폼",
                  "description":
                      CretaCommuLang['studio6']!, //"스튜디오에서 디자인한 콘텐츠를 \n바로 등록한 기기에 전송할 수 있습니다."
                }
              ]),
          solutionComponent(
              CretaCommuLang['community']!, //"커뮤니티",
              [
                {
                  "title": CretaCommuLang['community1']!, //"커뮤니티 탐색",
                  "description": CretaCommuLang['community2']!, //"다양한 크레타북을 시청하고 \n새로운 아이디어를 얻으세요."
                },
                {
                  "title": CretaCommuLang['community3']!, //"채널로 공유",
                  "description":
                      CretaCommuLang['community4']!, //"자신의 채널에 제작한 크레타북을 공유하고 \n전세계 사용자와 소통해보세요."
                },
                {
                  "title": CretaCommuLang['community5']!, // "크리에이터 구독",
                  "description": CretaCommuLang[
                      'community6']!, // "좋아하는 크리에이터를 구독하고 \n마음에 드는 크레타북은 저장하고 볼 수 있습니다."
                }
              ],
              backgroundColor: Colors.grey.shade100,
              fontColor: CretaColor.text.shade700)
        ],
      ),
    );
  }

  Widget soultionDescriptionComponent(String title, String description, Color fontColor) {
    return Container(
      width: 596,
      height: 136,
      decoration: BoxDecoration(
          color: fontColor == Colors.white
              ? const Color(0xffFFFFFF).withOpacity(0.1)
              : const Color(0xff4D4D4D).withOpacity(0.05),
          borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: CretaFont.titleMedium.copyWith(fontSize: 28, color: fontColor)),
            const SizedBox(height: 12),
            Text(description,
                style: CretaFont.bodyLarge.copyWith(fontWeight: FontWeight.w300, color: fontColor))
          ],
        ),
      ),
    );
  }

  Widget solutionComponent(String soultionName, List<Map<String, String>> solutionFunc,
      {Color fontColor = Colors.white, Color backgroundColor = CretaColor.primary}) {
    return Container(
      width: 660,
      height: 600,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 44, left: 60, bottom: 24, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(soultionName,
                    style: CretaFont.titleELarge
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 40, color: fontColor)),
                fontColor == Colors.white
                    ? BTN.line_blue_t_el(
                        text: CretaCommuLang['exp']!, //"체험해보기",
                        width: 135,
                        onPressed: () {
                          CretaAccountManager.experienceWithoutLogin = true;
                          Routemaster.of(context).push(AppRoutes.studioBookMainPage);
                        })
                    : BTN.fill_blue_t_el(
                        text: CretaCommuLang['search1']!, // "탐색해보기",
                        width: 135,
                        onPressed: () {
                          CretaAccountManager.experienceWithoutLogin = true;
                          Routemaster.of(context).push(AppRoutes.communityHome);
                        })
              ],
            ),
          ),
          soultionDescriptionComponent(
              solutionFunc[0]["title"]!, solutionFunc[0]["description"]!, fontColor),
          const SizedBox(height: 16),
          soultionDescriptionComponent(
              solutionFunc[1]["title"]!, solutionFunc[1]["description"]!, fontColor),
          const SizedBox(height: 16),
          soultionDescriptionComponent(
              solutionFunc[2]["title"]!, solutionFunc[2]["description"]!, fontColor),
        ],
      ),
    );
  }

  // ************************************ quick start section ************************************
  Widget quickStartSection() {
    return SizedBox(
        width: 1421,
        height: 436,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 27.0),
                    child: Text("Let's Creta!",
                        style: CretaFont.titleELarge
                            .copyWith(fontSize: 64, fontWeight: FontWeight.w700)),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 10, left: 128.0),
                      child: Image(
                          image: AssetImage("assets/landing_page/image/text_effect_4.png"),
                          width: 256,
                          height: 109))
                ],
              ),
              const SizedBox(height: 14),
              Text(CretaCommuLang['free1']!, //"크레타에서 당신의 상상력을 펼쳐보세요. \n지금 무료로 시작해보세요!",
                  style: CretaFont.bodyLarge.copyWith(fontWeight: FontWeight.w300)),
              const SizedBox(height: 40),
              customButton(
                  width: 227,
                  height: 80,
                  backgroundColor: CretaColor.primary,
                  borderRadius: BorderRadius.circular(13),
                  child: Center(
                      child: Text(CretaCommuLang['free2']!, //"무료로 시작하기",
                          style:
                              CretaFont.buttonLarge.copyWith(fontSize: 24, color: Colors.white))),
                  onTap: () {
                    CretaAccountManager.experienceWithoutLogin = true;
                    Routemaster.of(context).push(AppRoutes.communityHome);
                  })
            ],
          ),
          SizedBox(
            width: 971,
            height: 436,
            child: quickStartAnimationController.value.isInitialized
                ? VideoPlayer(quickStartAnimationController)
                : Container(),
          )
        ]));
  }

  // ************************************ footer ************************************
  Widget footer() {
    TextStyle footerBTNStyle = CretaFont.buttonLarge
        .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white);
    return Container(
        width: _screenWidth,
        height: 290,
        color: Colors.black,
        child: Center(
          child: SizedBox(
              width: 1360,
              height: 127,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Image(
                              image: AssetImage("assets/creta_logo_blue.png"),
                              width: 136,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Snippet.versionInfo(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 219,
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AccountManager.currentLoginUser.isLoginedUser
                                ? customButton(
                                    width: 52,
                                    height: 19,
                                    child: Text("Logout", style: footerBTNStyle),
                                    backgroundColor: Colors.black,
                                    onTap: () {
                                      setState(() {
                                        CretaAccountManager.logout();
                                      });
                                    })
                                : customButton(
                                    width: 52,
                                    height: 19,
                                    child: Text("Login", style: footerBTNStyle),
                                    backgroundColor: Colors.black,
                                    onTap: () => LoginDialog.popupDialog(
                                        context: context, getBuildContext: getBuildContext)),
                            customButton(
                                width: 140,
                                height: 48,
                                child: Text("Sign up", style: footerBTNStyle),
                                backgroundColor: Colors.black,
                                onTap: () => LoginDialog.popupDialog(
                                    context: context,
                                    getBuildContext: getBuildContext,
                                    loginPageState: LoginPageState.singup),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(6.6)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 24),
                    child: Container(width: 1360, height: 1, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 251,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 20),
                              customButton(
                                  width: 66,
                                  height: 19,
                                  child: Text(CretaCommuLang['termsOfUse']!, //"이용약관",
                                      style: CretaFont.bodyMedium.copyWith(color: Colors.white)),
                                  backgroundColor: Colors.black,
                                  onTap: () {
                                    Routemaster.of(context).push(AppRoutes.serviceTerms);
                                  }),
                              customButton(
                                  width: 115,
                                  height: 19,
                                  child: Text(CretaCommuLang['privacyPolicy']!, // "개인정보처리방침",
                                      style: CretaFont.bodyMedium.copyWith(color: Colors.white)),
                                  backgroundColor: Colors.black,
                                  onTap: () {
                                    Routemaster.of(context).push(AppRoutes.privacyPolicy);
                                  })
                            ],
                          )),
                      Text("© 2024 SQISOFT All Rights Reserved",
                          style: CretaFont.bodyESmall.copyWith(color: Colors.white.withOpacity(.2)))
                    ],
                  )
                ],
              )),
        ));
  }
}
