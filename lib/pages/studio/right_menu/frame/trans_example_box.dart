// import 'dart:math';

import 'package:creta03/design_system/component/example_box_mixin.dart';
import 'package:creta03/pages/studio/right_menu/frame/transition_types.dart';
import 'package:flutter/material.dart';
import '../../../../data_io/frame_manager.dart';
//import '../../../../design_system/dialog/creta_alert_dialog.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/frame_model.dart';

class TransExampleBox extends StatefulWidget {
  final FrameModel model;
  final NextContentTypes nextContentTypes;
  final String name;
  final FrameManager frameManager;
  final bool selectedType;
  final Function onTypeSelected;
  const TransExampleBox({
    super.key,
    required this.frameManager,
    required this.model,
    required this.nextContentTypes,
    required this.name,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  State<TransExampleBox> createState() => _TransExampleBoxState();
}

class _TransExampleBoxState extends State<TransExampleBox> with ExampleBoxStateMixin {
  // ContentsManager? _contentsManager;

  @override
  void initState() {
    super.initState();
    // _contentsManager = widget.frameManager.getContentsManager(widget.model.mid);
  }

  void onSelected() {
    // if (_contentsManager!.modelList.length < 3) {
    //   showAnnouceDialog(context);
    // } else {
    setState(() {
      widget.model.nextContentTypes.set(widget.nextContentTypes);
    });
    // }
    widget.onTypeSelected.call();
  }

  void onUnSelected() {
    setState(() {
      widget.model.nextContentTypes.set(NextContentTypes.none);
    });
    widget.onTypeSelected.call();
  }

  void rebuild() {
    setState(() {});
  }

  // void showAnnouceDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return CretaAlertDialog(
  //         //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //         content: const Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Text('캐러셀 디스플레이를 적용하려면 최소 3개의 이미지가 있어야 합니다.'),
  //         ),
  //         onPressedOK: () {
  //           Navigator.of(context).pop();
  //         },
  //         // actions: [
  //         //   Padding(
  //         //     padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
  //         //     child: ElevatedButton(
  //         //       onPressed: () {
  //         //         Navigator.of(context).pop();
  //         //       },
  //         //       style: ElevatedButton.styleFrom(
  //         //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
  //         //       child: const Text('확인'),
  //         //     ),
  //         //   )
  //         // ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return super.buildMixin(
      context,
      isSelected: widget.selectedType,
      setState: rebuild,
      onSelected: onSelected,
      onUnselected: onUnSelected,
      selectWidget: transitionTypesWidget,
    );
  }

  Widget transitionTypesWidget() {
    return TransitionTypes(
        frameManager: widget.frameManager,
        model: widget.model,
        nextContentTypes: widget.nextContentTypes,
        name: widget.name);
  }
}
