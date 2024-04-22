import 'dart:math';
import 'package:creta03/pages/studio/containees/frame/frame_play_mixin.dart';
import 'package:creta03/pages/studio/left_menu/currency_exchange/dropdown_row.dart';
import 'package:creta03/pages/studio/left_menu/currency_exchange/rate_result.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:intl/intl.dart';

import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';

class ConversionCard extends StatefulWidget {
  final Map? rates;
  final Map? currencies;

  const ConversionCard({
    super.key,
    this.rates,
    this.currencies,
  });

  @override
  State<ConversionCard> createState() => _ConversionCardState();
}

class _ConversionCardState extends State<ConversionCard> with FramePlayMixin {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();
  String dropDownValue1 = "USD";
  String dropDownValue2 = "KRW";
  String conversion = '';

  List<String> defaultBasedCurrency = CretaStudioLang['firstCurrency']!;
  List<String> defaultFinalCurrency = CretaStudioLang['secondCurrency']!;

  Map<String, String> conversionResults = {};
  bool isLoading = false;
  int selectedCard = -1;
  late List<bool> isSelected;

  double x = 150.0;
  double y = 150.0;
  int frameCount = 0;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(defaultBasedCurrency.length, (index) => false);
    defaultConvertAndDisplay();
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void defaultConvertAndDisplay() {
    Map<String, String> updatedConversionResults = {};

    for (int i = 0; i < defaultBasedCurrency.length; i++) {
      String basedCurrency = defaultBasedCurrency[i];
      String finalCurrency = defaultFinalCurrency[i];

      if (widget.rates![basedCurrency] != null) {
        String rawConversion = Utils.convert(widget.rates!, '1', basedCurrency, finalCurrency);
        double conversionValue = double.tryParse(rawConversion) ?? 0.00;
        NumberFormat numberFormat = NumberFormat("#,##0.0000", "en_US");
        String formatConversion = numberFormat.format(conversionValue);

        updatedConversionResults[basedCurrency] = formatConversion;
      } else {
        updatedConversionResults[basedCurrency] = '';
      }
    }
    setState(() {
      conversionResults = updatedConversionResults;
    });
    stopLoading();
  }

  void swapCurrencies() {
    setState(() {
      String temp = dropDownValue1;
      dropDownValue1 = dropDownValue2;
      dropDownValue2 = temp;
    });
  }

  void toggleSelectedState(int index) {
    setState(() {
      if (selectedCard == index) {
        isSelected[index] = !isSelected[index];
        selectedCard = -1;
        dropDownValue1 = "USD";
        dropDownValue2 = "KRW";
      } else {
        isSelected[index] = true;
        if (selectedCard != -1) {
          isSelected[selectedCard] = false;
        }
        selectedCard = index;
        dropDownValue1 = defaultBasedCurrency[index];
        dropDownValue2 = defaultFinalCurrency[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              currencyBased(),
              swapIcon(),
              currencyFinal(),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              itemCount: defaultBasedCurrency.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                String baseCurrency = defaultBasedCurrency[index];
                String finalCurrency = defaultFinalCurrency[index];
                XchangeEle xChangeEle = XchangeEle(
                  baseCurrency: baseCurrency,
                  finalCurrency: finalCurrency,
                );
                return GestureDetector(
                  onLongPressDown: (d) {
                    toggleSelectedState(index);
                  },
                  onDoubleTap: () {
                    _createXchangeFrame(FrameType.currencyXchange, index);
                    BookMainPage.pageManagerHolder!.notify();
                  },
                  child: Container(
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected[index] ? CretaColor.primary : CretaColor.text[200]!,
                        width: isSelected[index] ? 4 : 1,
                      ),
                    ),
                    child: RateResult(xChangeEle: xChangeEle),
                  ),
                );
              },
            ),
          ),
          const Center(child: Text('Currency Rates by Open Exchange Rates')),
        ],
      ),
    );
  }

  Future<void> _createXchangeFrame(FrameType frameType, int index) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = pageModel.width.value * 0.2;
    double height = pageModel.height.value * 0.2;

    x += 20.0 * frameCount;
    y += 20.0 * frameCount;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    int defaultSubType = index;

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: defaultSubType,
    );

    frameCount++;
    mychangeStack.endTrans();
  }

  Widget currencyBased() {
    return DropDownRow(
      label: dropDownValue1,
      value: dropDownValue1,
      currencies: widget.currencies!,
      onChanged: (String? newValue) {
        setState(() {
          if (selectedCard != -1) {
            defaultBasedCurrency[selectedCard] = newValue!;
            defaultConvertAndDisplay();
          }
        });
      },
    );
  }

  Widget currencyFinal() {
    return DropDownRow(
      label: dropDownValue2,
      value: dropDownValue2,
      currencies: widget.currencies!,
      onChanged: (String? newValue) {
        setState(() {
          if (selectedCard != -1) {
            defaultFinalCurrency[selectedCard] = newValue!;
            defaultConvertAndDisplay();
          }
        });
      },
    );
  }

  Widget swapIcon({double rotationAngle = pi / 2}) {
    return IconButton(
      icon: Transform.rotate(
        angle: rotationAngle,
        child: const Icon(Icons.swap_vert),
      ),
      onPressed: () {
        swapCurrencies();
        defaultConvertAndDisplay();
      },
    );
  }
}

class Utils {
  static String convert(
    Map exchangeRates,
    String amount,
    String currencyBase,
    String currencyFinal,
  ) {
    double usdAmount = double.parse(amount) / exchangeRates[currencyBase];
    String output = (usdAmount * exchangeRates[currencyFinal]).toStringAsFixed(4);
    return output;
  }
}
