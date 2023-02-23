import 'package:flutter/widgets.dart';

import '../../../../model/frame_model.dart';
import '../../studio_snippet.dart';

mixin FrameMixin {
  BoxDecoration frameDecoration(FrameModel model) {
    return BoxDecoration(
      color: model.opacity.value == 1
          ? model.bgColor1.value
          : model.bgColor1.value.withOpacity(model.opacity.value),
      borderRadius: BorderRadius.all(Radius.circular(model.angle.value)),
      gradient: StudioSnippet.gradient(
        model.gradationType.value,
        model.bgColor1.value,
        model.bgColor2.value,
      ),
    );
  }
}
