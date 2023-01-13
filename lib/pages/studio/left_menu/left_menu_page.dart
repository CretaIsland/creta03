import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/creta_color.dart';

class LeftMenuPage extends StatefulWidget {
  const LeftMenuPage({super.key});

  @override
  State<LeftMenuPage> createState() => _LeftMenuPageState();
}

class _LeftMenuPageState extends State<LeftMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
      ],
    );
  }

  Widget _menuBar() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 36,
      color: CretaColor.text[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BTN.fill_gray_100_i_s(icon: Icons.add_outlined, onPressed: (() {})),
          BTN.fill_gray_100_i_s(icon: Icons.account_tree_outlined, onPressed: (() {})),
        ],
      ),
    );
  }
}
