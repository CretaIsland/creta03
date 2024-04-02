// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../component/snippet.dart';
import 'package:creta_common/common/creta_font.dart';

class FontDemoPage extends StatefulWidget {
  FontDemoPage({super.key});

  @override
  State<FontDemoPage> createState() => _FontDemoPageState();
}

class _FontDemoPageState extends State<FontDemoPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      //title: Snippet.logo('Font Demo'),
              onFoldButtonPressed: () {
          setState(() {});
        },

      context: context,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Button_Small 11\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.buttonSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Button_Medium 13\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.buttonMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Button_Large 15\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                textAlign: TextAlign.center,
                style: CretaFont.buttonLarge,
              ),
              Text(
                'Body_Extra_Small 12\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.bodyESmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Body_Small 14\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.bodySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Body_Medium 16\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Body_Large 20\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                textAlign: TextAlign.center,
                style: CretaFont.bodyLarge,
              ),
              Text(
                'Title_Small 14\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.titleSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Title_Medium 20\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.titleMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Title_Large 22\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                textAlign: TextAlign.center,
                style: CretaFont.titleLarge,
              ),
              Text(
                'Headline_Small 26\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Headline_Medium 30\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Headline_Large 40\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                textAlign: TextAlign.center,
                style: CretaFont.headlineLarge,
              ),
              Text(
                'Display_Small 40\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.displaySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                'Display_Medium 50\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                style: CretaFont.displayMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Display_Large 60\n크레타에서 다양한 콘텐츠를 만들고 공유해보세요!',
                textAlign: TextAlign.center,
                style: CretaFont.displayLarge,
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
