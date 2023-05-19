import 'package:flutter/material.dart';
import 'package:progress_bar_steppers/steppers.dart';

import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/creta_font.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';

class BookPublishDialog extends StatefulWidget {
  const BookPublishDialog({super.key});

  @override
  State<BookPublishDialog> createState() => _BookPublishDialogState();
}

class _BookPublishDialogState extends State<BookPublishDialog> {
  var currentStep = 1;
  var totalSteps = 0;
  late List<StepperData> stepsData;
  late List<Widget> stepsWidget;

  @override
  void initState() {
    super.initState();
    stepsData = [
      StepperData(label: CretaStudioLang.publishSteps[0]),
      StepperData(label: CretaStudioLang.publishSteps[1]),
      StepperData(label: CretaStudioLang.publishSteps[2]),
      StepperData(label: CretaStudioLang.publishSteps[3]),
    ];
    stepsWidget = [
      step1(),
      step2(),
      step3(),
      step4(),
      const SizedBox.shrink(),
    ];
    totalSteps = stepsData.length;
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
          width: 364,
          height: 583,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  height: 24,
                  indent: 0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: stepsWidget[currentStep - 1],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    return Container(
      color: Colors.amber,
      height: 365,
    );
  }

  Widget step2() {
    return Container(
      color: Colors.blue,
      height: 365,
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
}
