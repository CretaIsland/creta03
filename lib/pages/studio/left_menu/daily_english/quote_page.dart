import 'dart:math';

import 'package:creta03/design_system/component/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:quoter/quoter.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:creta_studio_model/model/frame_model.dart';

class QuotePage extends StatefulWidget {
  final double? width;
  final double? height;
  final FrameModel? frameModel;
  final Quoter quoter;

  const QuotePage({
    Key? key,
    this.quoter = const Quoter(),
    this.width,
    this.height,
    this.frameModel,
  }) : super(key: key);

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  Quote? _quote;
  Random random = Random();
  late String url;
  String korVer = "";

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
      _translateToKor(_quote!.quotation);
    });
  }

  Future<void> _translateToKor(String quote) async {
    try {
      final Translation translation = await GoogleTranslator().translate(
        quote.toString(),
        from: 'en',
        to: 'ko',
      );

      setState(() {
        korVer = translation.text;
      });
    } catch (e) {
      logger.severe('Exception: $e');
      throw Exception('Translation request failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImage(
            width: widget.width!,
            height: widget.height!,
            image: url,
            boxFit: BoxFit.cover,
          ),
          Container(
            color: Colors.black38,
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
            width: widget.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  _quote?.quotation ?? "",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                    fontFamily: "Ic",
                    color: Colors.white,
                    fontSize: 32.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  _quote?.quotee ?? "Unknown author",
                  style: const TextStyle(
                    fontFamily: "Ic",
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                const Spacer(),
                Text(
                  korVer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Ic",
                    color: Colors.white,
                    fontSize: 18.0,
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
