import 'package:flutter/material.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/creta_icon_toggle_button.dart';
import '../../lang/creta_studio_lang.dart';
import 'book_main_page.dart';
import 'studio_main_menu.dart';
import 'studio_variables.dart';

class BookTopMenu extends StatefulWidget {
  final double padding;
  final Function onManualScale;
  final Function onAutoScale;
  final Function onUndo;
  final Function onRedo;
  final Function onFrameCreate;
  final Function onTextCreate;
  //final Function onLinkCreate;
  //final Function onMenu;

  const BookTopMenu({
    super.key,
    required this.padding,
    required this.onManualScale,
    required this.onAutoScale,
    required this.onUndo,
    required this.onRedo,
    required this.onFrameCreate,
    required this.onTextCreate,
    //required this.onLinkCreate,
    //required this.onMenu,
  });

  @override
  State<BookTopMenu> createState() => BookTopMenuState();

  static GlobalObjectKey<BookTopMenuState> topMenuKey = const GlobalObjectKey('book_top_menu');
  static void invalidate() {
    topMenuKey.currentState?.invalidate();
  }
}

class BookTopMenuState extends State<BookTopMenu> {
  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.padding * 1.75,
        ),
        const StudioMainMenu(
            //onPressed: widget.onMenu,
            ),
        SizedBox(width: widget.padding),
        Visibility(
          // Scale, Undo
          visible: StudioVariables.workHeight > 1 ? true : false,
          child: Row(
            children: [
              if (StudioVariables.displayWidth > 300)
                BTN.floating_l(
                  icon: Icons.undo_outlined,
                  onPressed: widget.onUndo,
                  hasShadow: false,
                  tooltip: CretaStudioLang['tooltipUndo']!,
                ),
              if (StudioVariables.displayWidth > 300) SizedBox(width: widget.padding / 2),
              if (StudioVariables.displayWidth > 300)
                BTN.floating_l(
                  icon: Icons.redo_outlined,
                  onPressed: widget.onRedo,
                  hasShadow: false,
                  tooltip: CretaStudioLang['tooltipRedo']!,
                ),
              if (StudioVariables.displayWidth > 550) SizedBox(width: widget.padding),
              if (StudioVariables.displayWidth > 550)
                BTN.floating_l(
                  icon: Icons.title_outlined,
                  onPressed: widget.onTextCreate,
                  hasShadow: false,
                  tooltip: CretaStudioLang['tooltipText']!,
                ),
              if (StudioVariables.displayWidth > 550) SizedBox(width: widget.padding / 2),
              if (StudioVariables.displayWidth > 550)
                BTN.floating_l(
                  icon: Icons.space_dashboard_outlined,
                  onPressed: widget.onFrameCreate,
                  hasShadow: false,
                  tooltip: CretaStudioLang['tooltipFrame']!,
                ),
              if (StudioVariables.displayWidth > 1000) SizedBox(width: widget.padding),
              if (StudioVariables.displayWidth > 1000)
                CretaScaleButton(
                  width: 180,
                  onManualScale: widget.onManualScale,
                  onAutoScale: widget.onAutoScale,
                  hasShadow: false,
                  tooltip: CretaStudioLang['tooltipScale']!,
                  extended: CretaIconToggleButton(
                    key: const ValueKey('HandToolToggleButton'),
                    buttonStyle: ToggleButtonStyle.fill_gray_i_m,
                    toggleValue: StudioVariables.isHandToolMode,
                    icon1: Icons.transit_enterexit_outlined,
                    icon2: Icons.pan_tool_outlined,
                    tooltip: StudioVariables.isHandToolMode
                        ? CretaStudioLang['tooltipEdit']!
                        : CretaStudioLang['tooltipNoneEdit']!,
                    onPressed: () {
                      StudioVariables.isHandToolMode = !StudioVariables.isHandToolMode;
                      BookMainPage.bookManagerHolder!.notify();
                    },
                  ),
                ),
              if (StudioVariables.displayWidth > 1080) SizedBox(width: widget.padding),
              if (StudioVariables.displayWidth > 1080)
                CretaIconToggleButton(
                  key: ValueKey('MuteToggleButton ${StudioVariables.isMute}'),
                  toggleValue: StudioVariables.isMute,
                  icon1: Icons.volume_off_outlined,
                  icon2: Icons.volume_up_outlined,
                  tooltip: CretaStudioLang['tooltipVolume']!,
                  buttonSize: 20,
                  onPressed: () {
                    StudioVariables.globalToggleMute();
                  },
                ),
              if (StudioVariables.displayWidth > 1190) SizedBox(width: widget.padding / 2),
              if (StudioVariables.displayWidth > 1190)
                CretaIconToggleButton(
                  key: ValueKey('AutoPlayToggleButton ${StudioVariables.isAutoPlay}'),
                  toggleValue: StudioVariables.isAutoPlay,
                  icon1: Icons.pause_outlined,
                  icon2: Icons.play_arrow,
                  tooltip: CretaStudioLang['tooltipPause']!,
                  buttonSize: StudioVariables.isAutoPlay ? 20 : 30,
                  onPressed: () {
                    //StudioVariables.globalToggleAutoPlay(_linkSendEvent, _autoPlaySendEvent);
                    StudioVariables.globalToggleAutoPlay();
                  },
                ),
              //SizedBox(width: widget.padding),
//VerticalDivider(),
              // SizedBox(width: widget.padding / 2),
              // if (StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false)
              //   BTN.floating_lc(
              //     icon: Icon(Icons.radio_button_checked_outlined,
              //         size: 20, color: CretaColor.primary),
              //     onPressed: () {
              //       setState(() {
              //         StudioVariables.isLinkMode = true;
              //         _globalToggleAutoPlay(forceValue: false);
              //       });
              //     },
              //     hasShadow: false,
              //     tooltip: CretaStudioLang['tooltipLink']!,
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}
