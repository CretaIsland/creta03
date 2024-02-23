import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta03/pages/studio/left_menu/currency_exchange/currency_api.dart';
import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'conversion_card.dart';
import 'model/rates_model.dart';

class LeftMenuCurrency extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuCurrency({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuCurrency> createState() => _LeftMenuCurrencyState();
}

class _LeftMenuCurrencyState extends State<LeftMenuCurrency> {
  late Future<RatesModel> ratesModel;
  late Future<Map> currenciesModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
    currenciesModel = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        SizedBox(
          height: StudioVariables.workHeight - 332.0,
          child: FutureBuilder<RatesModel>(
            future: ratesModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CretaSnippet.showWaitSign(),
                );
              } else {
                return FutureBuilder<Map>(
                  future: currenciesModel,
                  builder: (context, index) {
                    if (index.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CretaSnippet.showWaitSign(),
                      );
                    } else if (index.hasError) {
                      return Center(child: Text('Error: ${index.error}'));
                    } else {
                      return ConversionCard(
                        rates: snapshot.data!.rates,
                        currencies: index.data!,
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
