import 'package:flutter/material.dart';

import '../buttons/creta_button.dart';
import '../buttons/creta_button_wrapper.dart';

class CretaFontDecoBar extends StatefulWidget {
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strike;
  final void Function(bool) toggleBold;
  final void Function(bool) toggleItalic;
  final void Function(bool) toggleUnderline;
  final void Function(bool) toggleStrikethrough;

  const CretaFontDecoBar({
    super.key,
    required this.bold,
    required this.italic,
    required this.underline,
    required this.strike,
    required this.toggleBold,
    required this.toggleItalic,
    required this.toggleUnderline,
    required this.toggleStrikethrough,
  });

  @override
  State<CretaFontDecoBar> createState() => _CretaFontDecoBarState();
}

class _CretaFontDecoBarState extends State<CretaFontDecoBar> {
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderlined = false;
  bool _isStrikethrough = false;

  @override
  void initState() {
    super.initState();
    _isBold = widget.bold;
    _isItalic = widget.italic;
    _isUnderlined = widget.underline;
    _isStrikethrough = widget.strike;
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
    widget.toggleBold(_isBold);
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
    widget.toggleItalic(_isItalic);
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderlined = !_isUnderlined;
    });
    widget.toggleUnderline(_isUnderlined);
  }

  void _toggleStrikethrough() {
    setState(() {
      _isStrikethrough = !_isStrikethrough;
    });
    widget.toggleStrikethrough(_isStrikethrough);
  }

  @override
  Widget build(BuildContext context) {
    // final textStyle = TextStyle(
    //   fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
    //   fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
    //   decoration: (_isUnderlined && _isStrikethrough)
    //       ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
    //       : _isUnderlined
    //           ? TextDecoration.underline
    //           : _isStrikethrough
    //               ? TextDecoration.lineThrough
    //               : TextDecoration.none,
    // );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BTN.fill_gray_i_m(
          icon: Icons.format_bold,
          onPressed: _toggleBold,
          buttonColor: _isBold ? CretaButtonColor.primary : CretaButtonColor.white,
        ),
        BTN.fill_gray_i_m(
          icon: Icons.format_italic,
          onPressed: _toggleItalic,
          buttonColor: _isItalic ? CretaButtonColor.primary : CretaButtonColor.white,
        ),
        BTN.fill_gray_i_m(
          icon: Icons.format_underlined,
          onPressed: _toggleUnderline,
          buttonColor: _isUnderlined ? CretaButtonColor.primary : CretaButtonColor.white,
        ),
        BTN.fill_gray_i_m(
          icon: Icons.format_strikethrough,
          onPressed: _toggleStrikethrough,
          buttonColor: _isStrikethrough ? CretaButtonColor.primary : CretaButtonColor.white,
        ),
      ],
    );
  }
}
