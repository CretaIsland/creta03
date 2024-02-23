import 'dart:async';

import 'package:creta03/pages/studio/left_menu/currency_exchange/currency_api.dart';
import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_studio_model/model/frame_model.dart';
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
  late Map? currentRate;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startTimer();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
  }

  void _startTimer() {
    const Duration updateInterval = Duration(hours: 1);

    Timer.periodic(updateInterval, (Timer timer) {
      // Fetch new data every hour
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RatesModel>(
      future: ratesModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CretaSnippet.showWaitSign(),
          );
        } else {
          currentRate = snapshot.data?.rates;
          return Container(
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.xChangeEle.baseCurrency} / ${widget.xChangeEle.finalCurrency}'),
                conversionResult(currentRate),
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
