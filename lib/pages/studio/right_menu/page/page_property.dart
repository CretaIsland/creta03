// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/data_io/page_manager.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_animate/flutter_animate.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../design_system/buttons/creta_radio_button.dart';
import '../../../../design_system/buttons/creta_toggle_button.dart';
import '../../../../design_system/component/creta_proprty_slider.dart';
//import '../../../../design_system/component/example_box_mixin.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/containee_nofifier.dart';
import '../../left_menu/left_menu_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
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
  BookModel? _book;
  // ignore: unused_field
  PageModel? _model;
  // ignore: unused_field
  PageManager? _pageManager;
  static bool _isTransitionOpen = false;
  static bool _isTimeBaseOpen = false;

  PageEventController? _sendEvent;
  bool _tagEnabled = true;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _isTimeSettingEnabled = false;

  @override
  void initState() {
    logger.finer('_PagePropertyState.initState');
    super.initMixin();
    super.initState();

    final PageEventController sendEvent = Get.find(tag: 'page-property-to-main');
    _sendEvent = sendEvent;

    initializeDateFormatting('ko');
    PageModel? page = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    _isTimeSettingEnabled =
        page != null && page.startTime.value.isNotEmpty && page.endTime.value.isNotEmpty;

    if (page != null && page.startTime.value.isNotEmpty) {
      _startTime = stringToTimeOfDay(page.startTime.value);
    }
    if (page != null && page.endTime.value.isNotEmpty) {
      _endTime = stringToTimeOfDay(page.endTime.value);
    }
    if (page != null && page.startDate.value.isNotEmpty) {
      DateTime dateTime = DateTime.parse(page.startDate.value);
      _startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    }
    if (page != null && page.endDate.value.isNotEmpty) {
      DateTime dateTime = DateTime.parse(page.endDate.value);
      _endDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    }
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
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Book);
        LeftMenuPage.treeInvalidate();
        return RightMenu(
          key: ValueKey(BookMainPage.containeeNotifier!.selectedClass.toString()),
          onClose: () {
            BookMainPage.containeeNotifier!.set(ContaineeEnum.None);
            LeftMenuPage.treeInvalidate();
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
        _gradation(),
        propertyDivider(),
        // 당분간 _texture 는 사용하지 않을 예정.
        // _texture(),
        // propertyDivider(),
        _pageTransition(), // 페이지 전환 효과는 일단 막아둔다. 나중에 다시 작업할 예정
        propertyDivider(),
        effect(
          _model!.effect.value.name,
          padding: horizontalPadding,
          setState: () {
            setState(() {});
          },
          model: _model!,
          modelPrefix: 'page',
          onSelected: () {
            setState(() {});
            BookMainPage.bookManagerHolder!.notify();
          },
          onDelete: () {
            setState(() {
              _model!.effect.set(EffectType.none);
            });
            _sendEvent?.sendEvent(_model!);
            _pageManager?.notify();
          },
        ),
        propertyDivider(),
        _timeBasePage(),
        propertyDivider(),
        _event(),
        propertyDivider(),
        _hashTag(),
        SizedBox(
          height: 100,
        )
      ]);
      //);
    });
  }

  Widget _pageColor() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: colorPropertyCard(
        title: CretaStudioLang['pageBgColor']!,
        trailWidth: 154,
        color1: _model!.bgColor1.value,
        color2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        cardOpenPressed: () {
          setState(() {});
        },
        onOpacityDragComplete: (value) {
          //setState(() {
          _model!.opacity.set(value);
          logger.finest('opacity1=${_model!.opacity.value}');
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onOpacityDrag: (value) {
          _model!.opacity.set(value);
          logger.finest('opacity1=${_model!.opacity.value}');
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onColor1Changed: (val) {
          //setState(() {
          _model!.bgColor1.set(val);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onColorIndicatorClicked: () {
          PropertyMixin.isColorOpen = true;
          setState(() {});
        },
        onDelete: () {
          //setState(() {
          _model!.bgColor1.set(Colors.white);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
      ),
    );
  }

  Widget _gradation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: gradationCard(
        onPressed: () {
          setState(() {});
        },
        bgColor1: _model!.bgColor1.value,
        bgColor2: _model!.bgColor2.value,
        opacity: _model!.opacity.value,
        gradationType: _model!.gradationType.value,
        onGradationTapPressed: (GradationType type, Color color1, Color color2) {
          logger.finest('GradationIndicator clicked');
          //setState(() {
          if (_model!.gradationType.value == type) {
            _model!.gradationType.set(GradationType.none);
          } else {
            _model!.gradationType.set(type);
          }
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onColor2Changed: (Color val) {
          //setState(() {
          _model!.bgColor2.set(val);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onColorIndicatorClicked: () {
          setState(() {
            PropertyMixin.isGradationOpen = true;
          });
        },
        onDelete: () {
          //setState(() {
          _model!.gradationType.set(GradationType.none);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _texture() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: textureCard(
        textureType: _model!.textureType.value,
        onPressed: () {
          setState(() {});
        },
        onTextureTapPressed: (val) {
          //setState(() {
          _model!.textureType.set(val);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
        onDelete: () {
          //setState(() {
          _model!.textureType.set(TextureType.none);
          //});
          //BookMainPage.bookManagerHolder?.notify();
          _sendEvent?.sendEvent(_model!);
          _pageManager?.notify();
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _pageTransition() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isTransitionOpen,
        onPressed: () {
          setState(() {
            _isTransitionOpen = !_isTransitionOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['transitionPage']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: Text(
          PageTransitionType.getTitleFromInt(_model!.transitionEffect.value),
          textAlign: TextAlign.right,
          style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
        ),
        hasRemoveButton: _model!.transitionEffect.value > 0 || _model!.transitionEffect2.value > 0,
        onDelete: () {
          setState(() {
            _model!.transitionEffect.set(0);
            _model!.transitionEffect2.set(0);
          });
          BookMainPage.pageManagerHolder!.notify();
        },
        bodyWidget: _transitionBody(),
      ),
    );
  }

  Widget _transitionBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CretaRadioButton(
            onSelected: (title, value) {
              setState(() {
                _model!.transitionEffect.set(value);
              });
              BookMainPage.pageManagerHolder!.notify();
            },
            valueMap: CretaLang['pageTransitionType']!,
            defaultTitle: PageTransitionType.getTitleFromInt(_model!.transitionEffect.value),
            //spacebetween: 10,
            padding: EdgeInsets.zero,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(
          //       width: 160,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             CretaStudioLang['whenOpenPage']!,
          //             style: CretaFont.titleSmall,
          //           ),
          //           Divider(endIndent: 15),
          //           CretaRadioButton(
          //             onSelected: (title, value) {
          //               setState(() {
          //                 _model!.transitionEffect.set(value);
          //               });
          //               BookMainPage.pageManagerHolder!.notify();
          //             },
          //             valueMap: CretaStudioLang['pageTransitionType']!,
          //             defaultTitle:
          //                 PageTransitionType.getTitleFromInt(_model!.transitionEffect.value),
          //             //spacebetween: 10,
          //             padding: EdgeInsets.zero,
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(
          //       width: 160,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             CretaStudioLang['whenClosePage']!,
          //             style: CretaFont.titleSmall,
          //           ),
          //           Divider(endIndent: 15),
          //           CretaRadioButton(
          //             onSelected: (title, value) {
          //               setState(() {
          //                 _model!.transitionEffect2.set(value);
          //               });
          //               BookMainPage.pageManagerHolder!.notify();
          //             },
          //             valueMap: CretaStudioLang['pageTransitionType2']!,
          //             defaultTitle:
          //                 PageTransitionType.getTitleFromInt2(_model!.transitionEffect2.value),
          //             //spacebetween: 10,
          //             padding: EdgeInsets.zero,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          CretaPropertySlider(
            // page transition duration
            key: GlobalKey(),
            name: CretaStudioLang['transitionSpeed']!,
            min: 1,
            max: 5,
            value: CretaCommonUtils.validCheckDouble(_model!.duration.value.toDouble(), 1, 5),
            valueType: SliderValueType.normal,
            onChannged: (value) {
              // widget.model.opacity.set(value);
              // //widget.model.save();
              // logger.fine('opacity=${widget.model.opacity.value}');
              // _sendEvent!.sendEvent(widget.model);
            },
            onChanngeComplete: (value) {
              _model!.duration.set(value.round());
              _sendEvent!.sendEvent(_model!);
            },
          ),
        ],
      ),
    );
  }

  Widget _event() {
    return super.event(
      cretaModel: _model!,
      mixinModel: _model!,
      setState: () {
        setState(() {});
      },
      onDelete: () {
        setState(() {
          _model!.eventReceive.set('');
        });
      },
      //durationTypeWidget: _durationTypeWidget(),
      //durationWidget: _durationWidget(),
    );
  }

  Widget _hashTag() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: PropertyMixin.isHashTagOpen,
        onPressed: () {
          setState(() {
            PropertyMixin.isHashTagOpen = !PropertyMixin.isHashTagOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['hashTab']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: _model!.hashTag.value.length < 3
            ? SizedBox.shrink()
            : SizedBox(
                width: 160,
                child: Text(
                  _model!.hashTag.value,
                  style: CretaFont.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        hasRemoveButton: _model!.hashTag.value.isNotEmpty,
        onDelete: () {
          _model!.hashTag.set('');
          BookMainPage.bookManagerHolder!.notify();
        },
        bodyWidget: Column(children: _tagBody()),
      ),
    );
  }

  List<Widget> _tagBody() {
    String val = _model!.hashTag.value;
    int rest = StudioConst.maxTextLimit - 2 - val.length;
    if (rest <= 0) {
      logger.warning('len1 overflow $rest');
      _tagEnabled = false;
    }

    return hashTagWrapper.hashTag(
      hasTitle: false,
      top: 12,
      model: _model!,
      minTextFieldWidth: LayoutConst.rightMenuWidth - horizontalPadding * 2,
      onTagChanged: (value) {},
      onSubmitted: (value) {
        _tagEnabled = (value == null) ? false : true;
        BookMainPage.bookManagerHolder!.notify();
      },
      onDeleted: (value) {
        BookMainPage.bookManagerHolder!.notify();
      },
      limit: StudioConst.maxTextLimit - 2,
      enabled: _tagEnabled,
      rest: rest > 0 ? rest - 1 : 0,
    );
  }

  Widget _timeBasePage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: propertyCard(
        isOpen: _isTimeBaseOpen,
        onPressed: () {
          setState(() {
            _isTimeBaseOpen = !_isTimeBaseOpen;
          });
        },
        titleWidget: Text(CretaStudioLang['timeBasePage']!, style: CretaFont.titleSmall),
        //trailWidget: isColorOpen ? _gradationButton() : _colorIndicator(),
        trailWidget: _model!.startTime.value.isNotEmpty && _model!.endTime.value.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      _model!.startTime.value,
                      textAlign: TextAlign.right,
                      style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      _model!.endTime.value,
                      textAlign: TextAlign.right,
                      style: CretaFont.titleSmall.copyWith(overflow: TextOverflow.fade),
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        hasRemoveButton: _model!.startTime.value.isNotEmpty && _model!.endTime.value.isNotEmpty,
        onDelete: () {
          setState(() {
            _model!.startDate.set('');
            _model!.endDate.set('');
            _model!.startTime.set('');
            _model!.endTime.set('');
            _isTimeSettingEnabled = false;
          });
          BookMainPage.pageManagerHolder!.notify();
        },
        bodyWidget: _timeBasePageBody(),
      ),
    );
  }

  Widget _timeBasePageBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 30, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(CretaStudioLang['useTimeBasePage']!, style: titleStyle)),
              Expanded(
                child: CretaToggleButton(
                  width: 54 * 0.75,
                  height: 28 * 0.75,
                  defaultValue:
                      _model!.startTime.value.isNotEmpty && _model!.endTime.value.isNotEmpty,
                  onSelected: (bool value) {
                    setState(() {
                      _isTimeSettingEnabled = value;
                      if (value == true) {
                        _model!.startDate.set(formatDate(_startDate));
                        _model!.endDate.set(formatDate(_endDate));
                        _model!.startTime.set(formatTime(_startTime));
                        _model!.endTime.set(formatTime(_endTime));
                      } else {
                        _model!.startDate.set('');
                        _model!.endDate.set('');
                        _model!.startTime.set('');
                        _model!.endTime.set('');
                      }
                      BookMainPage.pageManagerHolder?.notify();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isTimeSettingEnabled,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(CretaStudioLang['startDate']!, style: titleStyle),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_startDate), style: dataStyle),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: _startDate.subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                          _model!.startDate.set(formatDate(_startDate));
                        });
                        BookMainPage.pageManagerHolder?.notify();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(CretaStudioLang['startTime']!, style: titleStyle),
                    subtitle: Text(_startTime.format(context), style: dataStyle),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      if (time != null) {
                        setState(() {
                          _startTime = time;
                          _model!.startTime.set(formatTime(_startTime));
                        });
                        BookMainPage.pageManagerHolder?.notify();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isTimeSettingEnabled,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(CretaStudioLang['endDate']!, style: titleStyle),
                    subtitle: Text(DateFormat('yyyy-MM-dd').format(_endDate), style: dataStyle),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _endDate.subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                          _model!.endDate.set(formatDate(_endDate));
                        });
                        BookMainPage.pageManagerHolder?.notify();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(CretaStudioLang['endTime']!, style: titleStyle),
                    subtitle: Text(_endTime.format(context), style: dataStyle),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _endTime,
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      if (time != null) {
                        setState(() {
                          _endTime = time;
                          _model!.endTime.set(formatTime(_endTime));
                        });
                        BookMainPage.pageManagerHolder?.notify();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // String formatDateTime(DateTime date, TimeOfDay time) {
  //   final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  //   return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  //   //return DateFormat.EEEE('ko').format(dateTime);
  // }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
    //return DateFormat.EEEE('ko').format(dateTime);
  }

  String formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
    //return DateFormat.EEEE('ko').format(dateTime);
  }

  TimeOfDay stringToTimeOfDay(String time) {
    // time에  날자 포맷으로 들어있을 수도 있다. 날짜 포맷이 있다면 없애야 한다.
    if (time.length > 11) {
      time = time.substring(11);
    }
    final timeParts = time.split(':');
    if (timeParts.length < 2) return TimeOfDay.now();
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Widget _durationTypeWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(CretaStudioLang['durationType']!, style: titleStyle),
  //         CretaWidgetDropDown(
  //           items: [
  //             ...CretaStudioLang['durationTypeList']!.keys.map((e) {
  //               return choiceStringElement(e, 156, 30);
  //             }).toList(),
  //           ],
  //           defaultValue: getDurationType(_model!.durationType.value),
  //           onSelected: (val) {
  //             _model!.durationType.set(DurationType.fromInt(val + 1));
  //             setState(() {});
  //           },
  //           width: boderStyleDropBoxWidth,
  //           height: 32,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _durationWidget() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 8, left: 30, right: 24),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(CretaStudioLang['durationSpecifiedTime']!, style: titleStyle),
  //         TimeInputWidget(
  //           textStyle: titleStyle,
  //           initValue: _model!.duration.value,
  //           onValueChnaged: (duration) {
  //             _model!.duration.set(duration.inSeconds);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

// class AniExampleBox extends StatefulWidget {
//   final PageModel model;
//   final String name;
//   final AnimationType aniType;
//   final bool selected;
//   final Function onSelected;
//   const AniExampleBox({
//     super.key,
//     required this.name,
//     required this.aniType,
//     required this.model,
//     required this.selected,
//     required this.onSelected,
//   });

//   @override
//   State<AniExampleBox> createState() => _AniExampleBoxState();
// }

// class _AniExampleBoxState extends State<AniExampleBox> with ExampleBoxStateMixin {
//   @override
//   void initState() {
//     //_isClicked = widget.selected;
//     super.initMixin(widget.selected);
//     super.initState();
//   }

//   void onSelected() {
//     setState(() {
//       if (widget.aniType.value == 0) {
//         widget.model.transitionEffect.set(0);
//       } else {
//         widget.model.transitionEffect.set(widget.aniType.value);
//       }
//     });
//     widget.onSelected.call();
//   }

//   void onUnselected() {
//     setState(() {
//       widget.model.transitionEffect.set(0);
//     });
//     widget.onSelected.call();
//   }

//   void onNormalSelected() {
//     setState(() {
//       widget.model.transitionEffect.set(0);
//       logger.finest('pageTrasitionValue = ${widget.model.transitionEffect.value}');
//     });
//     widget.onSelected.call();
//   }

//   void rebuild() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     //return _selectAnimation();
//     return super.buildMixin(context,
//         setState: rebuild,
//         onSelected: onSelected,
//         onUnselected: onUnselected,
//         selectWidget: selectWidget);
//   }

//   Widget selectWidget() {
//     switch (widget.aniType) {
//       case AnimationType.fadeIn:
//         return isAni() ? _aniBox().fadeIn() : normalBox(widget.name);
//       case AnimationType.flip:
//         return isAni() ? _aniBox().flip() : normalBox(widget.name);
//       case AnimationType.shake:
//         return isAni() ? _aniBox().shake() : normalBox(widget.name);
//       case AnimationType.blurXY:
//         return isAni() ? _aniBox().blurXY() : normalBox(widget.name);
//       case AnimationType.scaleXY:
//         return isAni() ? _aniBox().scaleXY() : normalBox(widget.name);
//       default:
//         return noAnimation(widget.name, onNormalSelected: onNormalSelected);
//     }
//   }

//   Animate _aniBox() {
//     return normalBox(widget.name).animate(
//         onPlay: (controller) => controller.loop(
//             period: Duration(
//               milliseconds: 1000,
//             ),
//             count: 3,
//             reverse: true));
//   }
// }
