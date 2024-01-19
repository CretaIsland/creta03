import 'package:creta03/pages/studio/left_menu/currency_exchange/currency_api.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/component/snippet.dart';
import '../../../../model/frame_model.dart';
import 'conversion_card.dart';
import 'model/rates_model.dart';

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
  late Future<RatesModel> ratesModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RatesModel>(
      future: ratesModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Snippet.showWaitSign(),
          );
        } else {
          return Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.xChangeEle.baseCurrency} / ${widget.xChangeEle.finalCurrency}'),
                conversionResult(snapshot.data!.rates),
              ],
            ),
          );
        }
      },
    );
  }

  Widget conversionResult(Map? rate) {
    if (rate == null) {
      return const Text('Error: Data is null',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center);
    }
    return Text(
      Utils.convert(rate, '1', widget.xChangeEle.baseCurrency, widget.xChangeEle.finalCurrency),
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );
  }
}

class XchangeEle {
  String baseCurrency;
  String finalCurrency;

  XchangeEle({
    required this.baseCurrency,
    required this.finalCurrency,
  });
}
