import 'package:creta03/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:progress_bar_steppers/steppers.dart';

import '../../common/creta_utils.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/text_field/creta_text_field.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/app_enums.dart';
import '../../model/book_model.dart';
import '../login_page.dart';
import 'book_info_mixin.dart';
import 'book_main_page.dart';
import 'studio_snippet.dart';

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

  List<String> emailList = [];
  List<PermissionType> permitionList = [];
  List<UserPropertyModel> userModelList = [];

  bool _onceDBGetComplete = false;

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

    Map<String, PermissionType> shares = widget.model!.getSharesAsMap();
    emailList = shares.keys.toList();
    permitionList = shares.values.toList();

    LoginPage.userPropertyManagerHolder!.getUserPropertyFromEmail(emailList).then((value) {
      userModelList = [...value];
      for (var ele in userModelList) {
        logger.info('user_property ${ele.nickname}, ${ele.email} founded');
      }
      _onceDBGetComplete = true;
      return value;
    });

    stepsWidget = [
      step1(),
      step2(),
      step3(),
      step4(),
      const SizedBox.shrink(),
    ];
  }

  Future<bool> _waitDBJob() async {
    while (_onceDBGetComplete == false) {
      await Future.delayed(const Duration(microseconds: 500));
    }
    logger.info('_onceDBGetComplete=$_onceDBGetComplete wait end');
    return _onceDBGetComplete;
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep > totalSteps) {
      Navigator.of(context).pop();
    }
    return FutureBuilder(
        future: _waitDBJob(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
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
                            if (currentStep > 1)
                              BTN.line_blue_t_m(
                                width: 24,
                                text: CretaLang.prev,
                                onPressed: () {
                                  setState(() {
                                    _prevStep();
                                  });
                                },
                              ),
                            const SizedBox(width: 8),
                            BTN.fill_blue_t_m(
                              width: 55,
                              text: CretaLang.next,
                              onPressed: () {
                                setState(() {
                                  _nextStep();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
    return SizedBox(
      height: 365,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._scope(),
          ..._defaultScope(),
          ..._publishTo(),
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

  void _prevStep() {
    if (currentStep > 1) {
      currentStep--;
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

  List<Widget> _defaultScope() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Wrap(
          spacing: 8.0,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BTN.line_blue_iti_m(
                icon1: Icons.groups_outlined,
                icon2: Icons.add_outlined,
                text: CretaLang.entire,
                onPressed: () {
                  setState(() {
                    widget.model!.readers.add('public');
                  });
                }),
            ..._myTeams(),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myTeams() {
    return LoginPage.teamManagerHolder!.teamModelList.map((e) {
      return BTN.line_blue_iti_m(
          icon1: Icons.people_outlined,
          icon2: Icons.add_outlined,
          text: '${e.name} ${CretaLang.team}',
          onPressed: () {
            // 여기서, team 명과 userId 를 검증하여, 임시로 readers 에 넣는다.
          });
    }).toList();
  }

  List<Widget> _publishTo() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(CretaStudioLang.publishTo, style: CretaFont.titleSmall),
      ),
      Container(
        width: 333,
        height: 207,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: CretaColor.text[200]!,
            width: 2,
          ),
        ),
        child: ListView.builder(
          itemCount: emailList.length,
          itemBuilder: (BuildContext context, int index) {
            String email = emailList[index];
            bool isNotCreator = (email != widget.model!.creator);
            UserPropertyModel? userModel = _findModel(email);
            return Container(
              padding: const EdgeInsets.only(bottom: 2),
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: LoginPage.userPropertyManagerHolder!
                        .profileImageBox(model: userModel, radius: 24),
                  ),
                  //const Icon(Icons.account_circle_outlined),
                  SizedBox(
                    //color: Colors.amber,
                    width: isNotCreator ? 148 : 148 + 96 + 24,
                    child: Text(
                      _nameWrap(userModel, email, isNotCreator),
                      style: isNotCreator
                          ? CretaFont.bodySmall
                          : CretaFont.bodySmall.copyWith(
                              color: CretaColor.primary,
                            ),
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (isNotCreator)
                    Container(
                      width: 96,
                      alignment: Alignment.centerLeft,
                      child: CretaDropDownButton(
                          selectedColor: CretaColor.text[700]!,
                          textStyle: CretaFont.bodyESmall,
                          width: 87,
                          height: 28,
                          itemHeight: 28,
                          dropDownMenuItemList: StudioSnippet.getPermitionListItem(
                              defaultValue: permitionList[index],
                              onChanged: (val) {
                                //widget.model.copyRight.set(val);
                              })),
                    ),
                  isNotCreator
                      ? BTN.fill_gray_i_s(
                          icon: Icons.close,
                          onPressed: () {},
                          buttonSize: 24,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    ];
  }

  String _nameWrap(UserPropertyModel? model, String email, bool isNotCreator) {
    String name = email;
    if (model != null) {
      name = model.nickname;
    }
    if (isNotCreator) {
      return name;
    }
    return '$name(${CretaLang.creator})';
  }

  UserPropertyModel? _findModel(String email) {
    for (var model in userModelList) {
      if (model.email == email) {
        return model;
      }
    }
    return null;
  }
}
