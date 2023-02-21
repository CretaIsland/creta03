// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/data_io/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../property_mixin.dart';
import '../right_menu.dart';

class PageProperty extends StatefulWidget {
  const PageProperty({super.key});

  @override
  State<PageProperty> createState() => _PagePropertyState();
}

class _PagePropertyState extends State<PageProperty> with PropertyMixin {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;
  BookModel? _book;
  // ignore: unused_field
  PageModel? _model;
  // ignore: unused_field
  PageManager? _pageManager;
  bool _isTransitionOpen = false;

  @override
  void initState() {
    logger.finer('_PagePropertyState.initState');
    super.initMixin();
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _book = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
      if (_book == null) {
        return Center(
          child: Text("No CretaBook Selected", style: CretaFont.titleLarge),
        );
      }
      _pageManager = pageManager;
      pageManager.reOrdering();
      _model = pageManager.getSelected() as PageModel?;
      if (_model == null) {
        BookMainPage.selectedClass = RightMenuEnum.Book;
        return RightMenu(
          onClose: () {
            setState(() {
              if (BookMainPage.selectedClass == RightMenuEnum.Book) {
                BookMainPage.onceBookInfoOpened = true;
              }
              BookMainPage.selectedClass = RightMenuEnum.None;
            });
          },
        );
      }
      return //SizedBox(
          //padding: EdgeInsets.all(horizontalPadding),
          //width: LayoutConst.rightMenuWidth,
          //child:
          Column(children: [
        //propertyDivider(height: 4),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _pageColor(),
        ),
        propertyDivider(),
        _pageTransition(),
        propertyDivider(),
      ]);
      //);
    });
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang.pageBgColor,
        color1: _model!.bgColor1.value,
        color2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          setState(() {
            _model!.opacity.set(1 - (value / 100));
            logger.finest('opacity1=${_model!.opacity.value}');
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onGradationTapPressed: (type, color1, color2) {
          logger.finest('GradationIndicator clicked');
          setState(() {
            if (_model!.gradationType.value == type) {
              _model!.gradationType.set(GradationType.none);
            } else {
              _model!.gradationType.set(type);
            }
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onColor1Changed: (val) {
          setState(() {
            _model!.bgColor1.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        },
        onColor2Changed: (val) {
          setState(() {
            _model!.bgColor2.set(val);
          });
          BookMainPage.bookManagerHolder?.notify();
        },
      ),
    );
  }

  Widget _pageTransition() {
    logger.finest('pageTransition=${_model!.transitionEffect.value}');
    List<AnimationType> animations = AnimationType.toAniListFromInt(_model!.transitionEffect.value);
    String trails = '';
    for (var ele in animations) {
      logger.finest('anymationTy=[$ele]');
      if (trails.isNotEmpty) {
        trails += "+";
      }
      trails += CretaStudioLang.animationTypes[ele.index];
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isTransitionOpen,
        onPressed: () {
          setState(() {
            _isTransitionOpen = !_isTransitionOpen;
          });
        },
        titleWidget: Text(CretaStudioLang.transitionPage, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: SizedBox(
          width: 200,
          child: Text(
            trails,
            textAlign: TextAlign.right,
            style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
          ),
        ),
        bodyWidget: _transitionBody(),
      ),
    );
  }

  Widget _transitionBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (int i = 0; i < AnimationType.end.index; i++)
            ExampleBox(
                key: GlobalKey(),
                model: _model!,
                name: CretaStudioLang.animationTypes[i],
                aniType: AnimationType.values[i],
                selected: (i != 0 &&
                        (AnimationType.values[i].value & _model!.transitionEffect.value ==
                            AnimationType.values[i].value) ||
                    i == 0 && _model!.transitionEffect.value == 0),
                onSelected: () {
                  setState(() {});
                  BookMainPage.bookManagerHolder!.notify();
                }),
          // ExampleBox(model: _model!, name: CretaStudioLang.flip, aniType: AnimationType.flip),
          // ExampleBox(model: _model!, name: CretaStudioLang.shake, aniType: AnimationType.shake),
          // ExampleBox(model: _model!, name: CretaStudioLang.shimmer, aniType: AnimationType.shimmer),
        ],
      ),
    );
  }
}

class ExampleBox extends StatefulWidget {
  final PageModel model;
  final String name;
  final AnimationType aniType;
  final bool selected;
  final Function onSelected;
  const ExampleBox({
    super.key,
    required this.name,
    required this.aniType,
    required this.model,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<ExampleBox> createState() => _ExampleBoxState();
}

class _ExampleBoxState extends State<ExampleBox> {
  bool? _isHover;
  bool _isClicked = false;

  final double _height = 106;
  final double _width = 156;

  @override
  void initState() {
    _isClicked = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _selectAnimation();
  }

  bool isAni() {
    if (_isHover == null) return true;
    return _isHover!;
  }

  Widget _selectAnimation() {
    switch (widget.aniType) {
      case AnimationType.fadeIn:
        return isAni() ? _aniBox().fadeIn() : _normalBox();
      case AnimationType.flip:
        return isAni() ? _aniBox().flip() : _normalBox();
      case AnimationType.shake:
        return isAni() ? _aniBox().shake() : _normalBox();
      case AnimationType.shimmer:
        return isAni() ? _aniBox().shimmer() : _normalBox();
      default:
        return _noAnimation();
    }
  }

  Widget _normalBox() {
    return MouseRegion(
      onHover: (value) {
        if (_isHover == null || _isHover! == false) {
          setState(() {
            logger.finest('transition hovered');
            _isHover = true;
          });
        }
      },
      onExit: (value) {
        if (_isHover == null || _isHover! == true) {
          setState(() {
            logger.finest('transition exit');
            _isHover = false;
          });
        }
      },
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClicked = !_isClicked;
            if (_isClicked) {
              widget.model.transitionEffect
                  .set(widget.model.transitionEffect.value | widget.aniType.value);
            } else {
              int newVal = widget.model.transitionEffect.value - widget.aniType.value;
              if (newVal < 0) newVal = 0;
              widget.model.transitionEffect.set(newVal);
            }
            logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
          });
          widget.onSelected.call();
        },
        child: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: _isClicked ? CretaColor.primary : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Container(
            height: _height - 8,
            width: _width - 8,
            decoration: BoxDecoration(
              color: CretaColor.text[200]!,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Center(
              child: Text(widget.name, style: CretaFont.titleSmall),
            ),
          ),
        ),
      ),
    );
  }

  Animate _aniBox() {
    return _normalBox().animate(
        onPlay: (controller) => controller.loop(
            period: Duration(
              milliseconds: 1000,
            ),
            count: 3,
            reverse: true));
  }

  Widget _noAnimation() {
    return GestureDetector(
      onLongPressDown: (details) {
        setState(() {
          _isClicked = !_isClicked;
          widget.model.transitionEffect.set(0);
          logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
        });
        widget.onSelected.call();
      },
      child: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: _isClicked ? CretaColor.primary : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          height: _height - 8,
          width: _width - 8,
          decoration: BoxDecoration(
            color: CretaColor.text[200]!,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Center(
            child: Text(widget.name, style: CretaFont.titleSmall),
          ),
        ),
      ),
    );
  }
}
