import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_common_utils.dart';

class CretaScrolledText extends StatefulWidget {
  const CretaScrolledText({
    required this.child,
    required this.scrollDirection,
    required this.text,
    required this.style,
    required this.realSize,
    Key? key,
    this.stopSeconds = 1,
    this.delay = const Duration(seconds: 1),
    this.duration = const Duration(seconds: 50),
    this.gap = 25,
    this.reverseScroll = false,
    this.duplicateChild = 25,
    this.enableScrollInput = true,
    this.delayAfterScrollInput = const Duration(seconds: 1),
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final int stopSeconds;
  final Size realSize;

  /// Widget to display in loop
  ///
  /// required
  final Widget child;

  /// Duration to wait before starting animation
  ///
  /// Default set to Duration(seconds: 1).
  ///

  final Duration delay;

  /// Duration of animation
  ///
  /// Default set to Duration(seconds: 30).
  final Duration duration;

  /// Sized between end of child and beginning of next child instance
  ///
  /// Default set to 25.
  final double gap;

  /// The axis along which the scroll view scrolls.
  ///
  /// required
  final Axis scrollDirection;

  ///
  /// true : Right to Left
  ///
  // |___________________________<--Scrollbar-Starting-Right-->|
  ///
  /// fasle : Left to Right (Default)
  ///
  // |<--Scrollbar-Starting-Left-->____________________________|
  final bool reverseScroll;

  /// The number of times duplicates child. So when the user scrolls then, he can't find the end.
  ///
  /// Default set to 25.
  ///
  final int duplicateChild;

  ///User scroll input
  ///
  ///Default set to true
  final bool enableScrollInput;

  /// Duration to wait before starting animation, after user scroll Input.
  ///
  /// Default set to Duration(seconds: 1).
  ///
  final Duration delayAfterScrollInput;
  @override
  State<CretaScrolledText> createState() => _CretaScrolledTextState();
}

class _CretaScrolledTextState extends State<CretaScrolledText> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<Offset> offset;

  ValueNotifier<bool> shouldScroll = ValueNotifier<bool>(false);
  late final ScrollController scrollController;
  late double _itemHeight;

  //skpark add mounted
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(CretaScrolledText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.realSize != widget.realSize) {
      List<String> sentences = widget.text.split('\n');
      String first = sentences[0];
      _itemHeight =
          CretaCommonUtils.calculateTextSize(first, widget.style, widget.realSize.width).height;
    }
  }

  @override
  void initState() {
    List<String> sentences = widget.text.split('\n');
    String first = sentences[0];
    _itemHeight =
        CretaCommonUtils.calculateTextSize(first, widget.style, widget.realSize.width).height;

    scrollController = ScrollController();

    scrollController.addListener(() async {
      if (widget.enableScrollInput) {
        if (animationController.isAnimating) {
          animationController.stop();
        } else {
          await Future.delayed(widget.delayAfterScrollInput);
          animationHandler();
        }
      }
    });

    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    offset = Tween<Offset>(
      begin: Offset.zero,
      end: widget.scrollDirection == Axis.horizontal
          ? widget.reverseScroll
              ? const Offset(.5, 0)
              : const Offset(-.5, 0)
          : widget.reverseScroll
              ? const Offset(0, .5)
              : const Offset(0, -.5),
    ).animate(animationController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(widget.delay);
      animationHandler();
    });

    super.initState();
  }

  // animationHandler() async {
  //   if (mounted && scrollController.position.maxScrollExtent > 0) {
  //     //skpark add mounted
  //     shouldScroll.value = true;

  //     if (shouldScroll.value && mounted) {
  //       animationController.forward().then((_) async {
  //         animationController.reset();

  //         if (shouldScroll.value && mounted) {
  //           animationHandler();
  //         }
  //       });
  //     }
  //   }
  // }

  animationHandler() async {
    if (mounted && scrollController.position.maxScrollExtent > 0) {
      shouldScroll.value = true;

      if (shouldScroll.value && mounted) {
        // 스크롤을 한 항목의 높이만큼 이동
        var scrollPosition = scrollController.offset + _itemHeight; // itemHeight는 한 항목의 높이
        scrollController
            .animateTo(
          scrollPosition,
          duration: widget.duration,
          curve: Curves.linear,
        )
            .then((_) async {
          // 각 항목에서 2초 동안 대기
          await Future.delayed(Duration(seconds: widget.stopSeconds));

          if (shouldScroll.value && mounted) {
            animationHandler();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.enableScrollInput
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      controller: scrollController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverseScroll,
      child: SlideTransition(
        position: offset,
        child: ValueListenableBuilder<bool>(
          valueListenable: shouldScroll,
          builder: (BuildContext context, bool shouldScroll, _) {
            return widget.scrollDirection == Axis.horizontal
                ? Row(
                    children: List.generate(
                        widget.duplicateChild,
                        (index) => Padding(
                              padding: EdgeInsets.only(
                                  right: shouldScroll && !widget.reverseScroll ? widget.gap : 0,
                                  left: shouldScroll && widget.reverseScroll ? widget.gap : 0),
                              child: widget.child,
                            )))
                : Column(
                    children: List.generate(
                    widget.duplicateChild,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                          bottom: shouldScroll && !widget.reverseScroll ? widget.gap : 0,
                          top: shouldScroll && widget.reverseScroll ? widget.gap : 0),
                      child: widget.child,
                    ),
                  ));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
