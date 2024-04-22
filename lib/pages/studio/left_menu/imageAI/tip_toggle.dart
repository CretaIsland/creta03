import 'package:creta03/pages/studio/left_menu/imageAI/search_tip_position.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../lang/creta_studio_lang.dart';

class TipToggleWidget extends StatefulWidget {
  static bool isTipOpened = false;
  static OverlayEntry? overlayEntry;

  const TipToggleWidget({super.key});

  @override
  State<TipToggleWidget> createState() => _TipToggleWidgetState();
}

class _TipToggleWidgetState extends State<TipToggleWidget> {
  void showOverlay() {
    setState(() {
      TipToggleWidget.isTipOpened = true;
      TipToggleWidget.overlayEntry ??=
          OverlayEntry(builder: (BuildContext context) => const SearchTipPosition());
      Overlay.of(context).insert(TipToggleWidget.overlayEntry!);
    });
  }

  void hideOverlay() {
    setState(() {
      TipToggleWidget.isTipOpened = false;
      TipToggleWidget.overlayEntry?.remove();
      TipToggleWidget.overlayEntry = null;
    });
  }

  void _toggleSearchTip() {
    if (TipToggleWidget.isTipOpened) {
      hideOverlay();
    } else {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BTN.fill_gray_i_s(
        icon: Icons.lightbulb_outline_sharp,
        iconColor: CretaColor.primary[400],
        bgColor: CretaColor.primary[100],
        tooltip: CretaStudioLang['genAIimageTooltip']!,
        tooltipFg: CretaColor.text[200],
        tooltipBg: Colors.transparent,
        onPressed: () {
          _toggleSearchTip();
        });
  }
}
