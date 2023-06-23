import 'dart:async';

import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rte/flutter_rte.dart';
import '../../../../model/app_enums.dart';
import '../../studio_variables.dart';
// import 'fullscreen.dart';

class QuillFloatingToolBarWidget extends StatefulWidget {
  final ContentsModel document;
  const QuillFloatingToolBarWidget({super.key, required this.document});
  @override
  State<QuillFloatingToolBarWidget> createState() => _QuillFloatingToolBarWidgetState();
}

class _QuillFloatingToolBarWidgetState extends State<QuillFloatingToolBarWidget>
    with TickerProviderStateMixin {
  HtmlEditorController? _currentController;

  late final AnimationController _controller =
      AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
    _currentController = HtmlEditorController(
      toolbarOptions: HtmlToolbarOptions(
        toolbarType: ToolbarType.nativeScrollable,
        backgroundColor: Colors.transparent,
        toolbarPosition: ToolbarPosition.custom,
      ),
      callbacks: Callbacks(
        onChangeContent: (text) {
          debugPrint('----editor is invoked $text---');
          widget.document.remoteUrl = text;

          debugPrint('saved: ${widget.document.remoteUrl}');
          widget.document.filter.set(widget.document.filter.value == ImageFilterType.bright
              ? ImageFilterType.cold
              : ImageFilterType.bright);
        },
        onFocus: () {
          debugPrint('----editor focused---');
          setState(() {
            resetTimeout();
          });
        },
        onBlur: () {
          debugPrint('----editor unfocused---');
          setTimeout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentController != null) {
      _controller.animateTo(1, duration: const Duration(milliseconds: 100));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _popupToolbox(),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.only(top: 24.0, left: 36.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: CretaColor.text[700]!, width: 0.2),
                        left: BorderSide(color: CretaColor.text[700]!, width: 0.2),
                        right: BorderSide(color: CretaColor.text[700]!, width: 0.2),
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 900,
                      minWidth: 550,
                      maxWidth: 750,
                    ),
                    child: HtmlEditor(
                      initialValue: widget.document.remoteUrl,
                      controller: _currentController,
                      isReadOnly: false,
                      // hint: widget.document.remoteUrl,
                    ),
                  ),
                ),
              ]),
        ));
  }

  Widget _popupToolbox() {
    return _currentController == null
        ? const SizedBox()
        : ScaleTransition(
            scale: _animation,
            child: FadeTransition(
              opacity: _animation,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  decoration: BoxDecoration(
                    color: CretaColor.primary[100],
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: StudioVariables.isPreview == false
                          ? ToolbarWidget(controller: _currentController!)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Timer? timer;

  void resetTimeout() {
    timer?.cancel();
    timer = null;
  }

  void setTimeout() {
    timer = Timer(const Duration(milliseconds: 100), () {
      if (_currentController != null) {
        _controller.reverse(from: 1).then((_) {
          if (mounted) {}
        });
      }
    });
  }
}
