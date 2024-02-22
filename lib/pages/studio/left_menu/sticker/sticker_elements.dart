import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../login/creta_account_manager.dart';

class StickerElements extends StatefulWidget {
  final double width;
  final double height;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final TextStyle? titleTextStyle;
  final BorderRadiusGeometry? radius;
  final void Function()? onPressed;

  const StickerElements({
    super.key,
    required this.width,
    required this.height,
    this.textStyle,
    this.border,
    this.titleTextStyle,
    this.radius,
    this.onPressed,
  });

  @override
  State<StickerElements> createState() => _StickerElementsState();
}

class _StickerElementsState extends State<StickerElements> {
  TextStyle? _textStyle;
  TextStyle? _titleTextStyle;
  bool _isHover = false;
  bool _isClicked = false;

  // Gif
  GiphyGif? currentGif;

  // Giphy Client
  late GiphyClient client = GiphyClient(apiKey: giphyApiKey, randomId: '');

  String randomId = '';
  String giphyApiKey = CretaAccountManager.getEnterprise!.giphyApiKey;

  @override
  void initState() {
    super.initState();
    _textStyle = widget.textStyle;
    _textStyle ??= CretaFont.bodyMedium;
    _titleTextStyle = widget.titleTextStyle;
    _titleTextStyle ??= CretaFont.bodySmall;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        client.getRandomId().then(
          (value) {
            setState(
              () {
                randomId = value;
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.onPressed == null ? _noActionCase() : _hasActionCase();
  }

  Widget _main() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(),
    );
  }

  Widget _hasActionCase() {
    return MouseRegion(
      onExit: (value) {
        setState(() {
          _isHover = false;
          _isClicked = false;
        });
      },
      onEnter: (value) {
        setState(() {
          _isHover = true;
        });
      },
      child: GestureDetector(
        onLongPressDown: (d) {
          setState(() {
            _isClicked = true;
          });
          // widget.onPressed?.call(widget.infoType);
        },
        child: Container(
          width: _isClicked ? widget.width + 2 : widget.width,
          height: _isClicked ? widget.height + 2 : widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHover ? CretaColor.primary : CretaColor.text[400]!,
              width: _isHover ? 2 : 1,
            ),
            borderRadius: widget.radius,
            color: Colors.transparent,
          ),
          child: Center(
            child: _main(),
          ),
        ),
      ),
    );
  }

  Widget _noActionCase() {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.radius,
        color: Colors.transparent,
      ),
      width: widget.width,
      height: widget.height,
      child: Center(child: _main()),
    );
  }
}
