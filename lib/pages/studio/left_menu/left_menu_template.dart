// ignore: avoid_web_libraries_in_flutter, depend_on_referenced_packages
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:hycop/hycop/account/account_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../data_io/template_manager.dart';
import '../../../design_system/buttons/creta_toggle_button.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../lang/creta_studio_lang.dart';
import '../book_main_page.dart';
import '../studio_constant.dart';
import 'template/template_list.dart';

class LeftMenuTemplate extends StatefulWidget {
  static final TextEditingController textController = TextEditingController();
  const LeftMenuTemplate({super.key});

  @override
  State<LeftMenuTemplate> createState() => _LeftMenuTemplateState();
}

class _LeftMenuTemplateState extends State<LeftMenuTemplate> {
  final double verticalPadding = 18;
  final double horizontalPadding = 19;

  late double bodyWidth;

  String searchText = '';
  bool refreshToggle = false;

  late String _selectedTab = '';
  Map<String, String> templateMenuTabBar = {};

  bool showAll = false;
  late Size? bookSize;

  @override
  void initState() {
    logger.fine('_LeftMenuTemplateState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;

    templateMenuTabBar[CretaStudioLang['myTemplate']!] = AccountManager.currentLoginUser.email;
    templateMenuTabBar[CretaStudioLang['sharedTemplate']!] = 'SHARED_TEMPLATE';
    _selectedTab = templateMenuTabBar.values.first;

    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book != null) {
      bookSize = Size(book.width.value, book.height.value);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
        _templateView(),
      ],
    );
  }

  // ignore: unused_element
  // Widget _menuBar() {
  //   return Container(
  //     height: LayoutConst.leftMenuBarHeight,
  //     color: CretaColor.text[100]!,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           child: BTN.fill_gray_100_i_m_text(
  //               // tooltip: CretaStudioLang['newTemplate']!,
  //               // tooltipBg: CretaColor.text[700]!,
  //               text: CretaStudioLang['newTemplate']!,
  //               icon: Icons.add_outlined,
  //               onPressed: (() {
  //                 PageModel? pageModel =
  //                     BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
  //                 if (pageModel == null) {
  //                   return;
  //                 }
  //                 String userEmail = AccountManager.currentLoginUser.email;
  //                 TemplateModel templateModel = TemplateModel('');
  //                 templateModel.copyFrom(pageModel);
  //                 templateModel.parentMid.set(userEmail);

  //                 //print('pageModel ${pageModel.thumbnailUrl.value}');
  //                 //print('template ${templateModel.thumbnailUrl.value}, $userEmail saved');
  //                 BookMainPage.templateManagerHolder!.createToDB(templateModel);
  //                 FrameManager? frameManager =
  //                     BookMainPage.pageManagerHolder!.findCurrentFrameManager();
  //                 if (frameManager == null) {
  //                   return;
  //                 }
  //                 frameManager.copyFrames(templateModel.mid, userEmail, samePage: false);
  //               })),
  //         ),
  //         //BTN.fill_gray_100_i_s(icon: Icons.delete_outlined, onPressed: (() {})),
  //       ],
  //     ),
  //   );
  // }

  Widget _menuBar() {
    return Container(
        height: LayoutConst.innerMenuBarHeight, // heihgt: 36
        width: LayoutConst.rightMenuWidth, // width: 380
        color: CretaColor.text[100],
        alignment: Alignment.centerLeft,
        child: CustomRadioButton(
          wrapAlignment: WrapAlignment.spaceEvenly,
          radioButtonValue: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          spacing: 100,
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
          buttonLables: templateMenuTabBar.keys.toList(),
          buttonValues: templateMenuTabBar.values.toList(),
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          elevation: 0,
          enableButtonWrap: true,
          enableShape: true,
          shapeRadius: 60,
        ));
  }

  Widget _templateView() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TemplateManager>.value(
          value: BookMainPage.templateManagerHolder!,
        ),
      ],
      child: Consumer<TemplateManager>(builder: (context, manager, child) {
        // print(
        //     'Consumer<TemplateManager>-----$refreshToggle------------------------------------------------------------------');
        return Container(
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
          child: Column(
            children: [
              _textQuery(),
              _sizeChioce(),
              TemplateList(
                key: GlobalKey(),
                selectedTab: _selectedTab,
                queryText: searchText,
                width: bodyWidth,
                refreshToggle: !refreshToggle,
                showAll: showAll,
                bookSize: bookSize,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _textQuery() {
    return CretaSearchBar(
      width: bodyWidth,
      hintText: CretaStudioLang['queryHintText']!,
      onSearch: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }

  Widget _sizeChioce() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang["AllSizeView"] ?? "모든 사이즈 보기",
              style: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!)),
          CretaToggleButton(
            width: 50,
            height: 24,
            defaultValue: showAll,
            onSelected: (v) {
              setState(() {
                showAll = v;
              });
            },
            isActive: true,
          ),
        ],
      ),
    );
  }
}
