// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/buttons/creta_checkbox.dart';
import 'package:creta03/design_system/buttons/creta_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../buttons/creta_button.dart';
import '../buttons/creta_radio_button.dart';
//import '../buttons/creta_radio_button2.dart';
//import '../buttons/creta_radio_button3.dart';
import '../buttons/creta_tab_button.dart';
import '../component/snippet.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class ButtonDemoPage extends StatefulWidget {
  ButtonDemoPage({super.key});

  @override
  State<ButtonDemoPage> createState() => _ButtonDemoPageState();
}

class _ButtonDemoPageState extends State<ButtonDemoPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
        title: 'Button Demo pagge',
        context: context,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CretaTextButton.text(text: "CretaTextButton", onPressed: () {}),
                    const SizedBox(width: 30),
                    CretaTextButton.icon(
                        iconData: Icons.volume_up_outlined,
                        width: 36,
                        height: 36,
                        onPressed: () {}),
                    const SizedBox(width: 30),
                    CretaTextButton.iconText(
                        iconData: Icons.volume_up_outlined,
                        text: "CretaTextButton",
                        onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_Blue_I_menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_Blue_I_menu   '),
                    CretaButton(
                      width: 24,
                      height: 24,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.childSelected,
                      buttonColor: CretaButtonColor.sky,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 16,
                          color: CretaColor.primary[400]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 24,
                      height: 24,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.childSelected,
                      buttonColor: CretaButtonColor.sky,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 16,
                          color: CretaColor.primary[400]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 24,
                      height: 24,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.childSelected,
                      buttonColor: CretaButtonColor.sky,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 16,
                          color: CretaColor.primary[400]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_gray_I_M
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_Gray_I_M   '),
                    CretaButton(
                      width: 32,
                      height: 32,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      child: //CircleAvatar(
                          //backgroundColor: Colors.transparent,
                          //child:
                          Icon(
                        Icons.volume_up_outlined,
                        size: 16,
                        color: CretaColor.text[700]!,
                      ),
                      //),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 32,
                      height: 32,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      //child: CircleAvatar(
                      //backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.volume_up_outlined,
                        size: 16,
                        color: CretaColor.text[700]!,
                      ),
                      //),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 32,
                      height: 32,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      //child: CircleAvatar(
                      //backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.volume_up_outlined,
                        size: 16,
                        color: CretaColor.text[700]!,
                      ),
                      //),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_gray_I_L
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_Gray_I_L   '),
                    CretaButton(
                      width: 36,
                      height: 36,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 20,
                          color: CretaColor.text[700]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 36,
                      height: 36,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 20,
                          color: CretaColor.text[700]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 86,
                      height: 36,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.child,
                      buttonColor: CretaButtonColor.white,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 20,
                          color: CretaColor.text[700]!,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_gray_IT_S
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_gray_IT_S   '),
                    CretaButton(
                      width: 86,
                      height: 29,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconText,
                      buttonColor: CretaButtonColor.white,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 12,
                        color: CretaColor.text[700]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('Button',
                              style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 86,
                      height: 29,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconText,
                      buttonColor: CretaButtonColor.white,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 12,
                        color: CretaColor.text[700]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('Button',
                              style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 86,
                      height: 29,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconText,
                      buttonColor: CretaButtonColor.white,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 12,
                        color: CretaColor.text[700]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('Button',
                              style: CretaFont.buttonSmall.copyWith(color: CretaColor.text[700]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_Blue_I_L
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_Blue_I_L   '),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconOnly,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_blue_T_M
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_blue_T_M   '),
                    CretaButton(
                      width: 72,
                      height: 36,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 72,
                      height: 36,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 72,
                      height: 36,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_blue_IT_L
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_blue_IT_L   '),
                    CretaButton(
                      width: 125,
                      height: 36,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconText,
                      icon: Icon(
                        Icons.add_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 125,
                      height: 36,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconText,
                      icon: Icon(
                        Icons.add_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 125,
                      height: 36,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconText,
                      icon: Icon(
                        Icons.add_outlined,
                        size: 20,
                        color: CretaColor.text[100]!,
                      ),
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Center(
                          child: Text('button',
                              style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Btn_fill_blue_ITT_L
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_blue_ITT_L   '),
                    CretaButton(
                      width: 191,
                      height: 36,
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.child,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_outlined,
                            size: 20,
                            color: CretaColor.text[100]!,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style:
                                      CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style: CretaFont.buttonSmall
                                      .copyWith(color: CretaColor.primary[200]!)),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 191,
                      height: 36,
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.child,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_outlined,
                            size: 20,
                            color: CretaColor.text[100]!,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style:
                                      CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style: CretaFont.buttonSmall
                                      .copyWith(color: CretaColor.primary[200]!)),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 191,
                      height: 36,
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.child,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_outlined,
                            size: 20,
                            color: CretaColor.text[100]!,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style:
                                      CretaFont.buttonLarge.copyWith(color: CretaColor.text[100]!)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Center(
                              child: Text('새크레타북',
                                  style: CretaFont.buttonSmall
                                      .copyWith(color: CretaColor.primary[200]!)),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_blue_T_EL
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_blue_T_EL   '),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
                        child: Center(
                          child: Text('스튜디오 바로가기',
                              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
                        child: Center(
                          child: Text('스튜디오 바로가기',
                              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.textOnly,
                      text: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
                        child: Center(
                          child: Text('스튜디오 바로가기',
                              style: CretaFont.titleLarge.copyWith(color: CretaColor.text[100]!)),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CretaTabButton(
                  onEditComplete: (value) {},
                ),
                SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Radio'),
                      SizedBox(width: 30),
                      Text('CretaRadioButton().'),
                      SizedBox(width: 30),
                      SizedBox(
                        width: 300,
                        child: CretaRadioButton(
                          valueMap: {
                            'Jisoo': 1,
                            'Lisa': 2,
                            'Jennie': 3,
                            'Rose': 4,
                          },
                          defaultTitle: 'Jennie',
                          onSelected: (title, value) {
                            logger.finest('selected $title=$value');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Checkbox'),
                      SizedBox(width: 30),
                      Text('CretaCheckbox().'),
                      SizedBox(width: 30),
                      SizedBox(
                        width: 300,
                        child: CretaCheckbox(
                          valueMap: {
                            'Jisoo': false,
                            'Lisa': false,
                            'Jennie': false,
                            'Rose': true,
                          },
                          onSelected: (title, value, nvMap) {
                            logger.finest('selected $title=$value');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        // child: Theme(
        //   data: Theme.of(context).copyWith(
        //       scrollbarTheme:
        //           ScrollbarThemeData(thumbColor: MaterialStateProperty.all(CretaColor.primary))),
        //   child: Scrollbar(
        //     thumbVisibility: true,
        //     controller: controller,
        //     thickness: 10,
        //     child: ListView(
        //       controller: controller,
        //       //mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         CretaTextButton("CretaTextButton", onPressed: () {}),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
