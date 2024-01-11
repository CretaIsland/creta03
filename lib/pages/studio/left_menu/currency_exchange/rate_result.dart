import 'package:flutter/material.dart';

import '../../../../model/frame_model.dart';

class RateResult extends StatefulWidget {
  final double? width;
  final double? height;
  final FrameModel? frameModel;
  final XchangeEle xChangeEle;

  const RateResult({
    Key? key,
    this.width,
    this.height,
    this.frameModel,
    required this.xChangeEle,
  }) : super(key: key);

  @override
  State<RateResult> createState() => _RateResultState();
}

class _RateResultState extends State<RateResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.xChangeEle.baseCurrency} / ${widget.xChangeEle.finalCurrency}'),
          conversionResult(),
        ],
      ),
    );
  }

  Widget conversionResult() {
    return Text(
      widget.xChangeEle.conversion,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}

class XchangeEle {
  String baseCurrency;
  String finalCurrency;
  String conversion;

  XchangeEle({
    required this.baseCurrency,
    required this.finalCurrency,
    required this.conversion,
  });
}
