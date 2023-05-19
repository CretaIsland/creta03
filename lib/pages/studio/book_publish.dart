import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:progress_bar_steppers/steppers.dart';

import '../../common/creta_utils.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/text_field/creta_text_field.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import 'book_info_mixin.dart';
import 'book_main_page.dart';

class BookPublishDialog extends StatefulWidget {
  final BookModel? model;
  const BookPublishDialog({super.key, required this.model});

  @override
  State<BookPublishDialog> createState() => _BookPublishDialogState();
}

class _BookPublishDialogState extends State<BookPublishDialog> with BookInfoMixin {
  final TextEditingController scopeController = TextEditingController();
  var currentStep = 1;
  var totalSteps = 0;
  late List<StepperData> stepsData;
  late List<Widget> stepsWidget;

  final double width = 364;
  final double height = 583;

  @override
  void initState() {
    super.initState();
    horizontalPadding = 16;
    hashTagList = CretaUtils.jsonStringToList(widget.model!.hashTag.value);
    logger.info('hashTagList=$hashTagList');
    stepsData = [
      StepperData(label: CretaStudioLang.publishSteps[0]),
      StepperData(label: CretaStudioLang.publishSteps[1]),
      StepperData(label: CretaStudioLang.publishSteps[2]),
      StepperData(label: CretaStudioLang.publishSteps[3]),
    ];
    totalSteps = stepsData.length;
    stepsWidget = [
      step1(),
      step2(),
      step3(),
      step4(),
      const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep > totalSteps) {
      Navigator.of(context).pop();
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CretaStudioLang.publishSettings,
                        style: CretaFont.titleMedium,
                      ),
                      BTN.fill_gray_i_m(
                          icon: Icons.close_outlined,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
                const Divider(
                  height: 22,
                  indent: 0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Steppers(
                    direction: StepperDirection.horizontal,
                    labels: stepsData,
                    currentStep: currentStep,
                    stepBarStyle: StepperStyle(
                      // activeColor: StepperColors.red500,
                      maxLineLabel: 2,
                      // inactiveColor: StepperColors.grey400
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: 8,
                  ),
                  child: stepsWidget[currentStep - 1],
                ),
                const Divider(
                  height: 22,
                  indent: 0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BTN.fill_blue_t_m(
                        text: CretaLang.next,
                        onPressed: () {
                          setState(() {
                            _nextStep();
                          });
                        },
                      ),
                      // ElevatedButton(
                      //   child: const Text('Fix Error'),
                      //   onPressed: () {
                      //     setState(() {
                      //       _fixError();
                      //     });
                      //   },
                      //),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget step1() {
    return SizedBox(
      height: 365,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._bookTitle(),
            const SizedBox(height: 16),
            ..._description(),
            const SizedBox(height: 16),
            ..._tag(),
          ],
        ),
      ),
    );
  }

  Widget step2() {
    return Container(
      color: Colors.blue,
      height: 365,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._scope(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget step3() {
    return Container(
      color: Colors.purple,
      height: 365,
    );
  }

  Widget step4() {
    return Container(
      color: Colors.orange,
      height: 365,
    );
  }

  void _nextStep() {
    if (currentStep > totalSteps) {
      Navigator.of(context).pop();
      return;
    }
    _doWork();
    // check if current step has no error, then move to the next step
    if (stepsData[currentStep - 1].state != StepperState.error) {
      currentStep++;
    }
  }

  void _doWork() {
    if (currentStep == 3) {
      // fake error happens at step 3 when do work
      //stepsData[2].state = StepperState.error;
    }
  }

  // ignore: unused_element
  void _fixError() {
    // fix error at the step 3 to continue to step 4
    if (stepsData[2].state == StepperState.error) {
      stepsData[2].state = StepperState.normal;
      currentStep++;
    }
  }

//
// step 1
//
  List<Widget> _bookTitle() {
    return bookTitle(
        model: widget.model,
        alwaysEdit: true,
        onEditComplete: (value) {
          setState(() {});
          BookMainPage.bookManagerHolder?.notify();
        });
  }

  List<Widget> _description() {
    return description(
        model: widget.model,
        onEditComplete: (value) {
          setState(() {});
        });
  }

  List<Widget> _tag() {
    return hashTag(
      top: 0,
      model: widget.model!,
      minTextFieldWidth: width - horizontalPadding * 2,
      onTagChanged: (value) {
        setState(() {});
      },
      onSubmitted: (value) {
        setState(() {});
      },
      onDeleted: (value) {
        setState(() {});
      },
    );
  }

//
// step 2
//

  List<Widget> _scope() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaLang.inPublic, style: CretaFont.titleSmall),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CretaTextField(
              height: 32,
              width: 244,
              textFieldKey: GlobalKey(),
              value: '',
              hintText: '',
              controller: scopeController,
              onEditComplete: (val) {
                setState(() {});
              }),
          BTN.line_blue_t_m(
              text: CretaLang.invite,
              onPressed: () {
                // 여기서, team 명과 userId 를 검증하여, 임시로 readers 에 넣는다.
              })
        ],
      )
    ];
  }
}
