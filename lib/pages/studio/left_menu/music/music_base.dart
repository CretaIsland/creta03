import 'package:flutter/material.dart';

class MusicBase extends StatefulWidget {
  // final Text musicPlaylist;
  // final Widget musicWidget;
  // final double width;
  // final double height;
  final void Function()? onPressed;
  const MusicBase({
    super.key,
    // required this.musicPlaylist,
    // required this.musicWidget,
    // required this.width,
    // required this.height,
    required this.onPressed,
  });

  @override
  State<MusicBase> createState() => _MusicBaseState();
}

class _MusicBaseState extends State<MusicBase> {
  final double musicBgWidth = 56.0;
  final double musicBgHeight = 64.0;
  bool _isHover = false;
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: musicBgWidth,
                height: musicBgHeight,
                child: Image.asset('michael_buble.jpg'),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          const Text('Michael Buble'),
        ],
      ),
      _playListSelected(),
    ]);
  }

  Widget _playListSelected() {
    return MouseRegion(
      onExit: (event) {
        setState(() {
          _isHover = false;
          _isClicked = false;
        });
      },
      onEnter: (event) {
        setState(() {
          _isHover = true;
        });
      },
      child: InkWell(
        onLongPress: () {
          setState(() {
            _isClicked = true;
          });
          widget.onPressed?.call();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: _isClicked ? 352.0 : 344.0,
            height: _isClicked ? musicBgHeight + 16.0 : musicBgHeight + 12.0,
            color: _isHover ? Colors.transparent.withOpacity(0.075) : null,
          ),
        ),
      ),
    );
  }
}
