import 'dart:math';

import 'package:creta03/design_system/component/custom_image.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:quoter/quoter.dart';

import '../../../../model/frame_model.dart';

class QuotePage extends StatefulWidget {
  final double? width;
  final double? height;
  final FrameModel? frameModel;
  const QuotePage({
    Key? key,
    this.quoter = const Quoter(),
    this.width,
    this.height,
    this.frameModel,
  }) : super(key: key);

  final Quoter quoter;

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  Quote? _quote;
  Random random = Random();
  late String url;

  @override
  void initState() {
    super.initState();
    int randomNumber = random.nextInt(100);
    url = 'https://picsum.photos/200/?random=$randomNumber';
    _generateRandomQuote();
  }

  void _generateRandomQuote() {
    setState(() {
      _quote = widget.quoter.getRandomQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StudioVariables.workHeight - 480,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImage(
            width: widget.width!,
            height: widget.height!,
            image: url,
            boxFit: BoxFit.fill,
          ),
          Container(
            color: Colors.black38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _quote?.quotation ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Ic",
                    color: Colors.white,
                    fontSize: 32.0,
                  ),
                ),
                const SizedBox(height: 48.0),
                Text(
                  _quote?.quotee ?? "Unknown author",
                  style: const TextStyle(
                    fontFamily: "Ic",
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
