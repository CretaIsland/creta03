// ignore: avoid_web_libraries_in_flutter, depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../../data_io/template_manager.dart';
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
  final double horizontalPadding = 24;

  late double bodyWidth;

  String searchText = '';
  bool refreshToggle = false;

  @override
  void initState() {
    logger.fine('_LeftMenuTemplateState.initState');
    bodyWidth = LayoutConst.leftMenuWidth - horizontalPadding * 2;
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
        //_menuBar(),
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
  //               // tooltip: CretaStudioLang.newTemplate,
  //               // tooltipBg: CretaColor.text[700]!,
  //               text: CretaStudioLang.newTemplate,
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
              TemplateList(
                key: GlobalKey(),
                queryText: searchText,
                width: bodyWidth,
                refreshToggle: !refreshToggle,
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
      hintText: CretaStudioLang.queryHintText,
      onSearch: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }
}
