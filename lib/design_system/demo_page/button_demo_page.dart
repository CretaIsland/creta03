// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/buttons/creta_checkbox.dart';
import 'package:creta03/design_system/buttons/creta_slider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import '../buttons/creta_button.dart';
import '../buttons/creta_button_wrapper.dart';
import '../buttons/creta_radio_button.dart';
//import '../buttons/creta_radio_button2.dart';
//import '../buttons/creta_radio_button3.dart';
import '../buttons/creta_tab_button.dart';
import '../buttons/creta_thick_choice.dart';
import '../buttons/creta_toggle_button.dart';
import '../component/snippet.dart';
//import '../creta_color.dart';
//import '../creta_font.dart';

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
        title: Snippet.logo('Button Demo'),
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
                        BTN.fill_gray_t_es(text: '????????? ?????????', onPressed: () {}),
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
                          text: '????????????',
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
                        const Text('fill_gray_l_profile   '),
                        const SizedBox(height: 20),
                        BTN.fill_gray_l_profile(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '????????? ?????????',
                          subText: '????????? ??????',
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
                          text: '????????? ?????????',
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
                          text: "??? ???????????? ??????",
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
                          text: "??? ???????????? ??????",
                          icon: Icons.arrow_forward_outlined,
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
                        const Text('fill_blue_it_m_animation'),
                        const SizedBox(height: 20),
                        BTN.fill_blue_it_m_animation(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '????????????',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('fill_blue_it_l'),
                        const SizedBox(height: 20),
                        BTN.fill_blue_it_l(
                          icon: Icons.add_outlined,
                          text: '???????????????',
                          onPressed: () {},
                        ),
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
                        const Text('fill_blue_itt_l'),
                        const SizedBox(height: 20),
                        BTN.fill_blue_itt_l(
                          text: "???????????????",
                          subText: "???????????????",
                          icon: Icons.add_outlined,
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
                        const Text('fill_purple_it_m_animation'),
                        const SizedBox(height: 20),
                        BTN.fill_purple_it_m_animation(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '????????????',
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
                        const Text('fill_black_i_l'),
                        const SizedBox(height: 20),
                        BTN.fill_black_i_l(
                          icon: Icons.notifications_outlined,
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
                        const Text('fill_black_iti_l   '),
                        const SizedBox(height: 20),
                        BTN.fill_black_iti_l(
                          image: NetworkImage(
                              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                          text: '????????? ?????????',
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
                        const Text('expand_circle_up'),
                        const SizedBox(height: 20),
                        BTN.expand_circle_up(
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('expand_circle_down'),
                        const SizedBox(height: 20),
                        BTN.expand_circle_down(
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('line_i_m'),
                        const SizedBox(height: 20),
                        BTN.line_i_m(
                          icon: Icons.volume_off_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('line_gray_t_m'),
                    const SizedBox(height: 20),
                    BTN.line_gray_t_m(
                      text: '????????????',
                      onPressed: () {},
                    ),
                  ],
                ),

                Divider(),
                Column(
                  children: [
                    const Text('line_gray_ti_m'),
                    const SizedBox(height: 20),
                    BTN.line_gray_ti_m(
                      icon: Icons.close_outlined,
                      text: '????????????',
                      onPressed: () {},
                    ),
                  ],
                ),

                Divider(),

                Divider(
                  thickness: 5,
                  color: Colors.amber,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text('Thickness --> CretaThickChoice()'),
                        const SizedBox(height: 20),
                        CretaThickChoice(
                          valueList: [1, 2, 3, 4, 5],
                          defaultValue: 2,
                          onSelected: (value) {
                            logger.finest('selected CretaThickChoice $value');
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('fill_blue_i_menu'),
                        const SizedBox(height: 20),
                        BTN.fill_blue_i_menu(
                          icon: Icons.volume_up_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('line_blue_i_m'),
                        const SizedBox(height: 20),
                        BTN.line_blue_i_m(
                          icon: Icons.volume_off_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(),
                Column(
                  children: [
                    const Text('line_blue_t_m'),
                    const SizedBox(height: 20),
                    BTN.line_blue_t_m(
                      text: 'button',
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('line_blue_it_m_animation'),
                    const SizedBox(height: 20),
                    BTN.line_blue_it_m_animation(
                      image: NetworkImage(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      text: '????????????',
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('line_blue_iti_m'),
                    const SizedBox(height: 20),
                    BTN.line_blue_iti_m(
                      image: NetworkImage(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      text: 'button',
                      icon: Icons.add_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: Colors.amber,
                ),
                Column(
                  children: [
                    const Text('line_red_it_m_animation'),
                    const SizedBox(height: 20),
                    BTN.line_red_it_m_animation(
                      image: NetworkImage(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      text: '????????????',
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('line_purple_iti_m'),
                    const SizedBox(height: 20),
                    BTN.line_purple_iti_m(
                      image: NetworkImage(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      text: 'button',
                      icon: Icons.add_outlined,
                      onPressed: () {},
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
                        const Text('opacity_gray_i_s'),
                        const SizedBox(height: 20),
                        BTN.opacity_gray_i_s(
                          icon: Icons.arrow_forward_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('opacity_gray_i_l'),
                        const SizedBox(height: 20),
                        BTN.opacity_gray_i_l(
                          icon: Icons.arrow_forward_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('opacity_gray_i_el'),
                        const SizedBox(height: 20),
                        BTN.opacity_gray_i_el(
                          icon: Icons.play_arrow,
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
                        const Text('opacity_gray_it_s'),
                        const SizedBox(height: 20),
                        BTN.opacity_gray_it_s(
                          icon: Icons.arrow_forward_outlined,
                          text: 'Button',
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        const Text('opacity_gray_it_m'),
                        const SizedBox(height: 20),
                        BTN.opacity_gray_it_m(
                          text: 'Button',
                          icon: Icons.arrow_forward_outlined,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('opacity_gray_ti_m'),
                    const SizedBox(height: 20),
                    BTN.opacity_gray_ti_m(
                      text: 'Button',
                      icon: Icons.arrow_forward_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: Colors.amber,
                ),
                Column(
                  children: [
                    const Text('floating_l'),
                    const SizedBox(height: 20),
                    BTN.floating_l(
                      icon: Icons.add_outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('floating_it_l'),
                    const SizedBox(height: 20),
                    BTN.floating_it_l(
                      icon: Icons.add_outlined,
                      text: 'button',
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('floating_iti_l'),
                    const SizedBox(height: 20),
                    BTN.floating_iti_l(
                      icon1: Icons.remove_outlined,
                      icon2: Icons.add_outlined,
                      text: 'button',
                      onPressed1: () {},
                      onPressed2: () {},
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: Colors.amber,
                ),
                Column(
                  children: [
                    const Text('fill_color_t_m'),
                    const SizedBox(height: 20),
                    BTN.fill_color_t_m(
                      text: 'button',
                      onPressed: () {},
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('fill_color_it_m'),
                    const SizedBox(height: 20),
                    BTN.fill_color_it_m(
                      text: '?????? ??????',
                      onPressed: () {},
                      iconData: Icons.link_outlined,
                    ),
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    const Text('fill_color_ic_el'),
                    const SizedBox(height: 20),
                    BTN.fill_color_ic_el(
                      text: '????????????',
                      onPressed: () {},
                      iconData: Icons.menu_outlined,
                    ),
                  ],
                ),
                Divider(
                  thickness: 5,
                  color: Colors.red,
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
