//구글맵 임시로 사용안함.
/*
import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_color.dart';
import 'google_map.dart';

class CretaMapWidget extends StatefulWidget {
  const CretaMapWidget({super.key});

  @override
  State<CretaMapWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CretaMapWidget> {
  bool _isHover = false;
  bool disableCameraMove = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GoogleMapClass(),
        Container(
          height: 60,
          width: double.infinity,
          color: _isHover == false ? Colors.transparent : CretaColor.text[900]!.withOpacity(0.25),
          child: MouseRegion(
            onHover: (event) {
              setState(() {
                _isHover = true;
              });
            },
            onExit: (event) {
              setState(() {
                _isHover = false;
              });
            },
            child: _isHover == false
                ? const SizedBox.shrink()
                : Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
          ),
        ),
      ],
    );
  }
}
*/
