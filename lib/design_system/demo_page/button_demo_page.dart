// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

import 'package:creta03/design_system/buttons/creta_text_button.dart';
import 'package:flutter/material.dart';
import '../buttons/creta_button.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CretaButton(
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.volume_up_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.notifications_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.simple,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.add_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CretaButton(
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.volume_up_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.notifications_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.clickAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.add_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CretaButton(
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.volume_up_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.notifications_outlined,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 30),
                    CretaButton(
                      buttonStyle: CretaButtonStyle.hoverAnimate,
                      buttonType: CretaButtonType.iconOnly,
                      iconData: Icons.add_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(width: 30),
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
                    const SizedBox(width: 30),
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
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(width: 30),
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
                    const SizedBox(width: 30),
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
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(width: 30),
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
                    const SizedBox(width: 30),
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
