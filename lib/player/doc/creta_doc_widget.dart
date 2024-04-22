// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

//import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../data_io/frame_manager.dart';
import '../../data_io/key_handler.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
//import '../../pages/studio/left_menu/word_pad/quill_appflowy.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_doc_mixin.dart';
import 'creta_doc_player.dart';
import 'editor_dialog.dart';

class CretaDocWidget extends CretaAbsPlayerWidget {
  final FrameManager frameManager;
  const CretaDocWidget({super.key, required super.player, required this.frameManager});

  @override
  CretaDocPlayerWidgetState createState() => CretaDocPlayerWidgetState();

  static void showHtmlEditor(
    BuildContext context,
    ContentsModel model,
    Size realSize,
    FrameModel frameModel,
    FrameManager frameManager,
    String initialText,
    Offset dialogOffset,
    Size dialogSize, {
    required dynamic Function(String) onPressedOK,
  }) {
    //GlobalKey? frameKey = frameManager.frameKeyMap[frameModel.mid];
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: EditorDialog(
              initialText: initialText,
              dialogOffset: dialogOffset,
              //key: GlobalObjectKey('SimpleEditor-CretaAlertDialog'),
              width: dialogSize.width,
              height: dialogSize.height * 1.5,
              frameSize: realSize,
              //frameKey: frameKey,
              backgroundColor: frameModel.bgColor1.value.withOpacity(frameModel.opacity.value),
              onChanged: (value) {
                //print('onChanged $value');
              },
              onPressedOK: onPressedOK,
              onPressedCancel: () {
                //widget.model.remoteUrl = _oldJsonString;
                //setState(() {});
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }
}

class CretaDocPlayerWidgetState extends CretaState<CretaDocWidget> with CretaDocMixin {
  ContentsEventController? _receiveEvent;
  late HtmlEditorController controller;
  Size _dialogSize = const Size(800, 600);
  Offset _dialogOffset = Offset.zero;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    //widget.player.afterBuild();
    final ContentsEventController receiveEvent = Get.find(tag: 'text-property-to-textplayer');
    _receiveEvent = receiveEvent;
    controller = HtmlEditorController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final CretaDocPlayer player = widget.player as CretaDocPlayer;
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data! is ContentsModel) {
            ContentsModel model = snapshot.data! as ContentsModel;
            player.acc.updateModel(model);
            logger.fine('model updated ${model.name}, ${model.font.value}');
            //print('++++++++++++++++++++++++++++++++++++++++++${model.height.value}');
          }
          logger.fine('Text StreamBuilder<AbsExModel>');

          return playDoc(context, player, player.model!, player.acc.getRealSize(),
              widget.player.acc.frameModel, widget.frameManager);
        });
  }

  Widget playDoc(
    BuildContext context,
    CretaDocPlayer? player,
    ContentsModel model,
    Size realSize,
    FrameModel frameModel,
    FrameManager frameManager, {
    bool isPagePreview = false,
  }) {
    if (StudioVariables.isAutoPlay) {
      player?.play();
    } else {
      player?.pause();
    }

    String uri = model.getURI();
    String errMsg = '${model.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");
    player?.buttonIdle();

    // ignore: unused_local_variable
    //GlobalKey? frameKey = frameManager.frameKeyMap[frameModel.mid];

    //print('++++++++++++++++++++++playDoc+++++++++++$uri');

    Size screenSize = MediaQuery.of(context).size;
    _dialogSize = screenSize / 2;
    _dialogOffset = Offset(
      (screenSize.width - _dialogSize.width) / 2,
      (screenSize.height - _dialogSize.height) / 2,
    ); //rootBundle.loadString('assets/example.json');

    //String lineSpacing = uri.replaceAll('<p>', '<p><p style="line-height: 0;">');

    return Stack(
      children: [
        Container(
          color: frameModel.bgColor1.value.withOpacity(frameModel.opacity.value),
          width: realSize.width,
          height: realSize.height,
          child: Html(data: uri),
        ),
        if (isPagePreview == false) _editButton(model, realSize, frameModel, frameManager, uri),
      ],
    );
  }

  Widget _editButton(
    ContentsModel model,
    Size realSize,
    FrameModel frameModel,
    FrameManager frameManager,
    String initialText,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 4,
          ),
          child: BTN.fill_blue_i_menu(
            tooltip: CretaLang['edit']!,
            width: 20,
            height: 20,
            buttonColor: CretaButtonColor.gray2,
            icon: Icons.edit_outlined,
            onPressed: () {
              CretaDocWidget.showHtmlEditor(
                context,
                model,
                realSize,
                frameModel,
                frameManager,
                initialText,
                _dialogOffset,
                _dialogSize,
                onPressedOK: (value) {
                  setState(() {
                    model.remoteUrl = value;
                    //print('onPressedOK: ${model.remoteUrl}');
                    model.save();
                  });
                  Navigator.of(context).pop();
                },
              );
            },
            //text: 'move mode',
            //width: 80,
          ),
        ),
      ),
    );
  }
}
