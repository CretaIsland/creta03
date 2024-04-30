import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../studio_constant.dart';
import '../left_menu_image.dart';

class SearchTipPosition extends StatefulWidget {
  const SearchTipPosition({super.key});

  @override
  State<SearchTipPosition> createState() => _SearchTipPositionState();
}

class _SearchTipPositionState extends State<SearchTipPosition> {
  final double verticalPadding = 18;
  final double horizontalPadding = 19;

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

  // PageController
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 1.0);

  int _activePage = 0;
  void _changePage(int page) {
    if (page >= 0 && page < CretaStudioLang['tipMessage']!.length) {
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
              itemCount: CretaStudioLang['tipMessage']!.length,
              itemBuilder: (BuildContext context, pageIndex) {
                return Stack(clipBehavior: Clip.none, children: [
                  tipContent(pageIndex),
                  Positioned(
                    top: 230.0,
                    left: _activePage > 0 ? 8.0 : 333.0,
                    child: BTN.floating_l(
                      icon: _activePage == 0 ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
                      onPressed: () {
                        // logger.fine('----------swipe page------------');
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
        child: Center(
            child: Text(CretaStudioLang['tipMessage']![pageIndex], style: CretaFont.bodyESmall)),
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
                logger.fine(
                    "-----Example search text '${CretaStudioLang['detailTipMessage1']![tipIndex]}' -------");
                LeftMenuImage.textController.text = _activePage == 0
                    ? CretaStudioLang['detailTipMessage1']![tipIndex]
                    : CretaStudioLang['detailTipMessage2']![tipIndex];
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
                      ? CretaStudioLang['detailTipMessage1']![tipIndex]
                      : CretaStudioLang['detailTipMessage2']![tipIndex],
                  style: TextStyle(
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
}
