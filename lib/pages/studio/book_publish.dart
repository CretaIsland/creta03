import 'dart:math';

import 'package:creta03/design_system/animation/staggerd_animation.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:progress_bar_steppers/steppers.dart';

import '../../common/creta_utils.dart';
import '../../data_io/book_published_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/text_field/creta_text_field.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/app_enums.dart';
import '../../model/book_model.dart';
import '../../model/team_model.dart';
import '../../routes.dart';
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

  List<String> channelEmailList = [];
  List<UserPropertyModel> channelUserModelList = [];

  bool _onceDBGetComplete1 = false;
  bool _onceDBGetComplete2 = false;
  bool _onceDBPublishComplete = false;

  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  String _modifier = '';
  String _publishResultStr = CretaStudioLang.publishFailed;

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

    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;

    _resetList();

    LoginPage.userPropertyManagerHolder!.getUserPropertyFromEmail(emailList).then((value) {
      userModelList = [...value];
      for (var ele in userModelList) {
        logger.info('=======>>>>>>>>>>>> user_property ${ele.nickname}, ${ele.email} founded');
      }
      _onceDBGetComplete1 = true;
      return value;
    });
    LoginPage.userPropertyManagerHolder!
        .getUserPropertyFromEmail(widget.model!.channels)
        .then((value) {
      channelUserModelList = [...value];
      for (var ele in channelUserModelList) {
        logger.info('=======>>>>>>>>>>>> user_property ${ele.nickname}, ${ele.email} founded');
      }
      _onceDBGetComplete2 = true;
      return value;
    });
  }

  void _resetList() {
    Map<String, PermissionType> shares = widget.model!.getSharesAsMap();
    emailList = shares.keys.toList();
    permitionList = shares.values.toList();
  }

  Future<bool> _waitDBJob() async {
    while (_onceDBGetComplete1 == false || _onceDBGetComplete2 == false) {
      await Future.delayed(const Duration(microseconds: 500));
    }
    logger.info('_onceDBGetComplete=$_onceDBGetComplete1 wait end');
    return _onceDBGetComplete1;
  }

  Widget _stepsWidget(int steps) {
    switch (steps) {
      case 1:
        return step1();
      case 2:
        return step2();
      case 3:
        return step3();
      case 4:
        return step4();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep > totalSteps) {
      Navigator.of(context).pop();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: FutureBuilder(
          future: _waitDBJob(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData == false) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
              return SizedBox(width: width, height: height, child: Snippet.showWaitSign());
            }
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              return Snippet.errMsgWidget(snapshot);
            }
            return SafeArea(
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
                        child: _stepsWidget(currentStep),
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
                            if (currentStep > 1 && currentStep < 4)
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
                            if (currentStep < 4)
                              BTN.fill_blue_t_m(
                                width: 55,
                                text: CretaLang.next,
                                onPressed: () {
                                  setState(() {
                                    _nextStep();
                                  });
                                },
                              ),
                            if (currentStep == 4)
                              SizedBox(
                                width: 240,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    BTN.fill_blue_t_m(
                                      width: 150,
                                      text: CretaLang.gotoCommunity,
                                      onPressed: () {
                                        AppRoutes.launchTab(AppRoutes.communityHome);
                                        setState(() {
                                          _nextStep();
                                        });
                                      },
                                    ),
                                    BTN.fill_blue_t_m(
                                      width: 55,
                                      text: CretaLang.close,
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
                    ],
                  ),
                ),
              ),
            );
          }),
    );
    //});
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
    return SizedBox(
      height: 365,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._channelScope(),
          ..._channelTo(),
          copyRight(widget.model!),
          _optionBody(),
        ],
      ),
    );
  }

  Widget step4() {
    return FutureBuilder(
        future: _waitPublish(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return SizedBox(width: width, height: 365, child: Snippet.showWaitSign());
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }
          if (snapshot.data == false) {
            return const SizedBox.shrink();
          }
          return SizedBox(
            height: 365,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StaggeredAnimation(
                  child: _drawThumbnail(),
                ),
                Center(
                    child: Text(
                  '$_modifier $_publishResultStr',
                  style: CretaFont.titleELarge,
                )
                        .animate(delay: const Duration(microseconds: 1500))
                        .then()
                        .fade()
                        .slide()
                        .then()
                        .tint()
                        .then()
                        .shake()),
              ],
            ),
          );
        });
  }

  Widget _drawThumbnail() {
    final Random random = Random();
    int randomNumber = random.nextInt(100);
    String image = widget.model!.thumbnailUrl.value.isEmpty
        ? 'https://picsum.photos/200/?random=$randomNumber'
        : widget.model!.thumbnailUrl.value;
    // String image =
    //     'https://oaidalleapiprodscus.blob.core.windows.net/private/org-wu0lAWU8sN5CR4ZUjC13D0XH/user-U7GAXXruTXKgCHDICrqUDVT0/img-NiOCRrCd1oEPpOjIdOfa2v8r.png?st=2023-05-24T07%3A53%3A57Z&se=2023-05-24T09%3A53%3A57Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-05-24T00%3A07%3A46Z&ske=2023-05-25T00%3A07%3A46Z&sks=b&skv=2021-08-06&sig=ISd6MJBNwyCJoSuo25O1rKD1%2BCbdJafY5UISDnotaZg%3D';

    return CustomImage(
        key: GlobalKey(),
        hasMouseOverEffect: false,
        hasAni: false,
        width: width,
        height: height,
        image: image);
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
    if (currentStep < 3) {
      _onceDBPublishComplete = false;
    } else if (currentStep == 3) {
      _publish();
    }
  }

  Future<bool> _waitPublish() async {
    while (_onceDBPublishComplete == false) {
      await Future.delayed(const Duration(microseconds: 500));
    }
    return true;
  }

  Future<bool> _publish() async {
    BookPublishedManager bookPublishedManagerHolder = BookPublishedManager();
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    return bookPublishedManagerHolder.publish(
      src: widget.model!,
      pageManager: BookMainPage.pageManagerHolder!,
      onComplete: (isNew) {
        _modifier = isNew ? CretaStudioLang.newely : CretaStudioLang.update;
        _publishResultStr = CretaStudioLang.publishComplete;
        _onceDBPublishComplete = true;
      },
    );
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
                _addUser(scopeController.text).then((value) {
                  if (value) {
                    setState(() {});
                  }
                  return value;
                });
              }),
          BTN.line_blue_t_m(
              text: CretaLang.invite,
              onPressed: () {
                _addUser(scopeController.text).then((value) {
                  if (value) {
                    setState(() {});
                  }
                  return value;
                });
              })
        ],
      )
    ];
  }

  Future<bool> _addUser(String email) async {
    // email 이거나, 팀명이다.
    bool isEmail = CretaUtils.isValidEmail(email);
    if (isEmail) {
      // 헤당 유저가 회원인지 찾는다.
      UserPropertyModel? user = await LoginPage.userPropertyManagerHolder!.emailToModel(email);
      if (user != null) {
        setState(() {
          widget.model!.readers.add(email);
          widget.model!.save();
          userModelList.add(user);
          _resetList();
        });
        return true;
      }
      // 여기서, 초대를 해야 한다.
      // ignore: use_build_context_synchronously
      showSnackBar(context, CretaStudioLang.noExitEmail, duration: const Duration(seconds: 3));
      return false;
    }
    // 팀명인지 확인한다. 현재 enterpriseId 가 없으므로 creta 으로 검색한다
    TeamModel? team = await LoginPage.teamManagerHolder!.findTeamModelByName(email, 'creta');
    if (team != null) {
      setState(() {
        widget.model!.readers.add(team.mid);
        widget.model!.save();
        userModelList.add(LoginPage.userPropertyManagerHolder!.makeDummyModel(team));
        _resetList();
      });
      return true;
    }
    // 해당하는 Team 명이 없다. 이메일등을 넣도록 경고한다.
    // ignore: use_build_context_synchronously
    showSnackBar(context, CretaStudioLang.wrongEmail, duration: const Duration(seconds: 3));
    return false;
  }

  List<Widget> _defaultScope() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Wrap(
          spacing: 8.0,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BTN.line_blue_wmi_m(
                leftWidget: LoginPage.userPropertyManagerHolder!
                    .imageCircle('', CretaLang.entire, radius: 24, color: CretaColor.primary),
                icon: Icons.add_outlined,
                text: CretaLang.entire,
                onPressed: () {
                  UserPropertyModel? user = _findModel('public');
                  if (user == null) {
                    //아직 전체가 없을 때만 넣는다.
                    setState(() {
                      widget.model!.readers.add('public');
                      widget.model!.save();
                      userModelList.add(LoginPage.userPropertyManagerHolder!.makeDummyModel(null));
                      _resetList();
                    });
                  }
                }),
            ..._myTeams(),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myTeams() {
    return LoginPage.teamManagerHolder!.teamModelList.map((e) {
      return BTN.line_blue_wmi_m(
          leftWidget:
              LoginPage.userPropertyManagerHolder!.imageCircle(e.profileImg, e.name, radius: 24),
          icon: Icons.add_outlined,
          text: '${e.name} ${CretaLang.team}',
          width: 180,
          textWidth: 90,
          onPressed: () {
            setState(() {
              widget.model!.readers.add(e.mid);
              widget.model!.save();
              userModelList.add(LoginPage.userPropertyManagerHolder!.makeDummyModel(e));
              _resetList();
            });
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
        //padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: CretaColor.text[200]!,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 1.0, top: 16, bottom: 16),
          child: Scrollbar(
            //thumbVisibility: true,
            controller: _scrollController1,
            child: ListView.builder(
              controller: _scrollController1,
              scrollDirection: Axis.vertical,
              itemCount: emailList.length,
              itemBuilder: (BuildContext context, int index) {
                String email = emailList[index];
                bool isNotCreator = (email != widget.model!.creator);
                UserPropertyModel? userModel = _findModel(email);
                return Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 6, right: 12.0),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoginPage.userPropertyManagerHolder!.profileImageBox(
                          model: userModel,
                          radius: 28,
                          color: email == 'public' ? CretaColor.primary : null),
                      //const Icon(Icons.account_circle_outlined),
                      SizedBox(
                        //color: Colors.amber,
                        width: isNotCreator ? 120 : 120 + 96 + 24,
                        child: Tooltip(
                          message: userModel != null ? userModel.email : '',
                          child: Text(
                            _nameWrap(userModel, email, isNotCreator, false),
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
                                    if (val == PermissionType.owner) {
                                      widget.model!.owners.add(email);
                                      widget.model!.writers.remove(email);
                                      widget.model!.readers.remove(email);
                                    } else if (val == PermissionType.writer) {
                                      widget.model!.owners.remove(email);
                                      widget.model!.writers.add(email);
                                      widget.model!.readers.remove(email);
                                    } else if (val == PermissionType.reader) {
                                      widget.model!.owners.remove(email);
                                      widget.model!.writers.remove(email);
                                      widget.model!.readers.add(email);
                                    }
                                    setState(() {
                                      widget.model!.save();
                                      _resetList();
                                    });
                                  })),
                        ),
                      isNotCreator
                          ? BTN.fill_gray_i_s(
                              icon: Icons.close,
                              onPressed: () {
                                if (permitionList[index] == PermissionType.owner) {
                                  // deleteFrom owners
                                  widget.model!.owners.remove(email);
                                } else if (permitionList[index] == PermissionType.writer) {
                                  // deleteFrom writers
                                  widget.model!.writers.remove(email);
                                } else if (permitionList[index] == PermissionType.reader) {
                                  // deleteFrom readers
                                  widget.model!.readers.remove(email);
                                }
                                for (var ele in userModelList) {
                                  if (ele.email == email) {
                                    userModelList.remove(ele);
                                    break;
                                  }
                                }

                                setState(() {
                                  widget.model!.save();
                                  _resetList();
                                });
                              },
                              buttonSize: 24,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ];
  }

  String _nameWrap(UserPropertyModel? model, String email, bool isNotCreator, bool isChannel) {
    String name = email;
    if (model != null) {
      logger.info('===============>>>_nameWrap(${model.nickname}, email, isNotCreator)');
      name = model.nickname;
    }
    if (isNotCreator) {
      return name;
    }
    return '$name(${isChannel ? CretaLang.myChannel : CretaLang.creator})';
  }

  UserPropertyModel? _findModel(String email) {
    for (var model in userModelList) {
      if (model.email == email) {
        return model;
      }
    }
    return null;
  }

  UserPropertyModel? _findChannelModel(String email) {
    for (var model in channelUserModelList) {
      if (model.email == email) {
        return model;
      }
    }
    return null;
  }

  //
  // step3
  //

  List<Widget> _channelScope() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(CretaStudioLang.publish, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Wrap(
          spacing: 8.0,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BTN.line_blue_wmi_m(
                leftWidget: LoginPage.userPropertyManagerHolder!
                    .imageCircle('', CretaLang.entire, radius: 24, color: CretaColor.primary),
                icon: Icons.add_outlined,
                text: CretaLang.entire,
                onPressed: () {
                  UserPropertyModel? user = _findChannelModel('public');
                  if (user == null) {
                    //아직 전체가 없을 때만 넣는다.
                    setState(() {
                      widget.model!.channels.add('public');
                      widget.model!.save();
                      channelUserModelList
                          .add(LoginPage.userPropertyManagerHolder!.makeDummyModel(null));
                    });
                  }
                }),
            ..._myChannelTeams(),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myChannelTeams() {
    return LoginPage.teamManagerHolder!.teamModelList.map((e) {
      return BTN.line_blue_wmi_m(
          leftWidget:
              LoginPage.userPropertyManagerHolder!.imageCircle(e.profileImg, e.name, radius: 24),
          icon: Icons.add_outlined,
          text: '${e.name} ${CretaLang.team}',
          width: 180,
          textWidth: 90,
          onPressed: () {
            setState(() {
              widget.model!.channels.add(e.mid);
              widget.model!.save();
              channelUserModelList.add(LoginPage.userPropertyManagerHolder!.makeDummyModel(e));
            });
          });
    }).toList();
  }

  List<Widget> _channelTo() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(CretaStudioLang.publishTo, style: CretaFont.titleSmall),
      ),
      Container(
        width: 333,
        height: 124,
        //padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: CretaColor.text[200]!,
            width: 2,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 1.0, top: 16, bottom: 16),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController2,
            child: ListView.builder(
              controller: _scrollController2,
              scrollDirection: Axis.vertical,
              itemCount: channelUserModelList.length,
              itemBuilder: (BuildContext context, int index) {
                UserPropertyModel userModel = channelUserModelList[index];
                bool isNotCreator = (userModel.email != widget.model!.creator);
                return Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 6, right: 12.0),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LoginPage.userPropertyManagerHolder!.profileImageBox(
                          model: userModel,
                          radius: 28,
                          color: userModel.email == 'public' ? CretaColor.primary : null),
                      //const Icon(Icons.account_circle_outlined),
                      SizedBox(
                        //color: Colors.amber,
                        width: isNotCreator ? 120 + 96 : 120 + 96 + 24,
                        child: Tooltip(
                          message: userModel.email,
                          child: Text(
                            _nameWrap(userModel, userModel.email, isNotCreator, true),
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
                      ),

                      isNotCreator
                          ? BTN.fill_gray_i_s(
                              icon: Icons.close,
                              onPressed: () {
                                widget.model!.channels.remove(userModel.email);
                                for (var ele in channelUserModelList) {
                                  if (ele.email == userModel.email) {
                                    channelUserModelList.remove(ele);
                                    break;
                                  }
                                }
                                setState(() {
                                  widget.model!.save();
                                });
                              },
                              buttonSize: 24,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ];
  }

  Widget _optionBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(CretaStudioLang.allowReply, style: titleStyle),
          CretaToggleButton(
            defaultValue: widget.model!.isAllowReply.value,
            onSelected: (value) {
              widget.model!.isAllowReply.set(value);
            },
          ),
        ],
      ),
    );
  }
}
