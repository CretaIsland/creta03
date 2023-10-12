// import 'dart:math';

import 'package:creta03/design_system/component/example_box_mixin.dart';
import 'package:creta03/pages/studio/right_menu/frame/transition_types.dart';
import 'package:flutter/material.dart';

// import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
// import '../../../../design_system/creta_font.dart';
import '../../../../model/app_enums.dart';
// import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';

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
  void onSelected() {
    setState(() {
      widget.model.nextContentTypes.set(widget.nextContentTypes);
    });
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
