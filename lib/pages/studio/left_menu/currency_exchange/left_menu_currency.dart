import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: 150,
          height: 150,
          color: Colors.blue[200],
        ),
      ],
    );
  }
}
