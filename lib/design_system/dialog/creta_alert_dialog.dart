import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';

class CretaAlertDialog extends StatelessWidget {
  


  final double? width;
  final double? height;
  final Icon? icon;
  final Widget? content;
  final String? cancelButtonText;
  final String? okButtonText;
  final Function? onPressedOK; 


  const CretaAlertDialog({
    super.key, 
    this.width = 387.0,
    this.height = 208.0,
    this.icon,
    this.content, 
    this.cancelButtonText,
    this.okButtonText,
    this.onPressedOK
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width!*.9, top: height!*.05),
              child: BTN.fill_gray_i_s(
                icon: Icons.close, 
                onPressed: () => Navigator.of(context).pop()
              )
            ),
            content == null ? const SizedBox() : content!,
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Container(
                width: width,
                height: 1.0,
                color: Colors.grey.shade200,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width! * .65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BTN.line_red_t_m(
                    text: cancelButtonText!, 
                    onPressed: () => Navigator.of(context).pop()
                  ),
                  const SizedBox(width: 8.0),
                  BTN.fill_red_t_m(
                    text: okButtonText!, 
                    width: 55,
                    onPressed: () => onPressedOK
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }






}