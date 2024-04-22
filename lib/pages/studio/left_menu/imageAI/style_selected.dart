import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';

class StyleSelectedWidget extends StatefulWidget {
  static int selectedCard = -1;
  const StyleSelectedWidget({super.key});

  @override
  State<StyleSelectedWidget> createState() => _StyleSelectedWidgetState();
}

class _StyleSelectedWidgetState extends State<StyleSelectedWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12.0),
      height: 308.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Vertical axis
            mainAxisSpacing: 15.0,
            childAspectRatio: 1 / 1),
        itemCount: CretaStudioLang['imageStyleList']!.length,
        itemBuilder: (context, int styleIndex) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    StyleSelectedWidget.selectedCard = styleIndex;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  decoration: BoxDecoration(
                      // color: CretaColor.text[200],
                      border: StyleSelectedWidget.selectedCard == styleIndex
                          ? Border.all(color: CretaColor.primary, width: 2.0)
                          : null),
                  height: 68.0,
                  width: 68.0,
                  child: Image.asset(imageSample[styleIndex], fit: BoxFit.fill),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2.0),
                alignment: Alignment.center,
                child: Text(
                  CretaStudioLang['imageStyleList']![styleIndex],
                  style: CretaFont.buttonSmall,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
