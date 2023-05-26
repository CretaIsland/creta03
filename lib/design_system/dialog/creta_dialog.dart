import 'package:creta03/design_system/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';

class CretaDialog extends StatelessWidget {
  

  final double width;
  final double height;
  final String title;
  final CrossAxisAlignment crossAxisAlign;
  final Widget content;


  const CretaDialog({
    super.key, 
    this.width = 406.0,
    this.height = 289.0,
    this.title = '',
    this.crossAxisAlign = CrossAxisAlignment.start,
    required this.content, 
  });


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: crossAxisAlign,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: CretaFont.titleMedium,
                  ),
                  BTN.fill_gray_i_s(
                    icon: Icons.close, 
                    onPressed: () => Navigator.of(context).pop()
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: width,
                height: 1.0,
                color: Colors.grey.shade200,
              ),
            ),
            content
          ],
        ),
      ),
    );
  }






}