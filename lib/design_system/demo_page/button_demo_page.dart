// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/buttons/creta_checkbox.dart';
import 'package:creta03/design_system/buttons/creta_slider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../buttons/creta_button.dart';
import '../buttons/creta_button_wrapper.dart';
import '../buttons/creta_radio_button.dart';
//import '../buttons/creta_radio_button2.dart';
//import '../buttons/creta_radio_button3.dart';
import '../buttons/creta_tab_button.dart';
import '../buttons/creta_thick_choice.dart';
import '../buttons/creta_toggle_button.dart';
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
                // Btn_fill_Blue_I_menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('btn_fill_gray_i_xs   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_i_xs(
                          icon: Icons.play_arrow,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('btn_fill_gray_i_s   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_i_s(
                          icon: Icons.play_arrow,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        const Text('btn_fill_gray_100_i_s   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_100_i_s(
                          icon: Icons.play_arrow,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        const Text('btn_fill_gray_200_i_s   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_200_i_s(
                          icon: Icons.play_arrow,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        const Text('btn_fill_gray_i_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_i_m(
                          icon: Icons.volume_up_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        const Text('btn_fill_gray_i_l   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_i_l(
                          icon: Icons.volume_up_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('btn_fill_gray_t_es   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_t_es(text: '사용자 닉네임', onPressed: () {}),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('btn_fill_gray_t_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_t_m(text: 'Button', onPressed: () {}),
                      ],
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_gray_ti_s   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_ti_s(
                          icon: Icons.arrow_forward_outlined,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_gray_ti_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_ti_m(
                          icon: Icons.arrow_forward_outlined,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_gray_ti_l  '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_ti_l(
                          icon: Icons.arrow_drop_down,
                          text: '용도선택',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_gray_it_s   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_it_s(
                          icon: Icons.arrow_forward_outlined,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_gray_it_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_it_m(
                          icon: Icons.volume_down,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_gray_it_l   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_it_l(
                          icon: Icons.volume_down,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_gray_t_profile   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_t_profile(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '사용자 닉네임',
                          subText: '요금제 정보',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_gray_iti_l   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_iti_l(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '사용자 닉네임',
                          icon: Icons.arrow_drop_down_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: Colors.amber,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_blue_i_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_blue_i_m(
                          icon: Icons.volume_up_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('fill_blue_i_l   '),
                        const SizedBox(height: 20),
                        BTN.fill_blue_i_l(
                          icon: Icons.volume_up_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_blue_t_m   '),
                        const SizedBox(height: 20),
                        BTN.fill_blue_t_m(
                          text: 'button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('fill_blue_t_el   '),
                        const SizedBox(height: 20),
                        BTN.fill_blue_t_el(
                          text: "내 크레타북 관리",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('fill_blue_ti_el   '),
                        const SizedBox(height: 20),
                        BTN.fill_blue_ti_el(
                          text: "내 크레타북 관리",
                          icon: Icons.arrow_forward_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Divider(
                  thickness: 5,
                  color: Colors.red,
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 30),
                  const Text('btn_fill_blue_i_menu   '),
                  const SizedBox(width: 30),
                  BTN.fill_blue_i_menu(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {},
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_gray_IT_S   '),
                    const SizedBox(width: 30),
                    BTN.fill_gray_it_s(
                      icon: Icons.arrow_forward_outlined,
                      text: 'Button',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Btn_fill_gray_T_M
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_fill_gray_T_M   '),
                    const SizedBox(width: 30),
                    BTN.fill_gray_t_m(text: 'Button', onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 30),
                // Btn_fill_opacity_gray_IT_S
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Btn_opacity_fill_gray_IT_S   '),
                    const SizedBox(width: 30),
                    BTN.fill_opacity_gray_it_s(
                      icon: Icons.arrow_forward_outlined,
                      text: 'Button',
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
                    const SizedBox(width: 30),
                    CretaButton(
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
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 72,
                      height: 36,
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
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 125,
                      height: 36,
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
                    const SizedBox(width: 30),
                    CretaButton(
                      width: 191,
                      height: 36,
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
                    const SizedBox(width: 20),
                    CretaButton(
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
                SizedBox(height: 30),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Slider'),
                    SizedBox(width: 30),
                    Text('CretaSlider().'),
                    SizedBox(width: 30),
                    SizedBox(
                      height: 20,
                      width: 164,
                      child: CretaSlider(
                        max: 100,
                        min: 0,
                        value: 50,
                        onDragComplete: (value) {
                          logger.finest('selected slider value=$value');
                        },
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 30),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Thickness'),
                    SizedBox(width: 30),
                    Text('CretaThickChoice()'),
                    SizedBox(width: 30),
                    CretaThickChoice(
                      valueList: [1, 2, 3, 4, 5],
                      defaultValue: 2,
                      onSelected: (value) {
                        logger.finest('selected CretaThickChoice $value');
                      },
                    ),
                    SizedBox(width: 30),
                  ],
                )),
                SizedBox(height: 30),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Toggle'),
                    SizedBox(width: 30),
                    Text('CretaToggleButton()'),
                    SizedBox(width: 30),
                    CretaToggleButton(
                      defaultValue: true,
                      onSelected: (value) {
                        logger.finest('toggled CretaToggleButton $value');
                      },
                    ),
                    SizedBox(width: 30),
                  ],
                )),
                SizedBox(height: 30),
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
