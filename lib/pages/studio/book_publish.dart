// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:math';

import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop.dart';
import 'package:progress_bar_steppers/steppers.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_snippet.dart';

import '../../common/creta_utils.dart';
import '../../data_io/book_published_manager.dart';
import '../../data_io/channel_manager.dart';
import '../../data_io/host_manager.dart';
import '../../design_system/animation/staggerd_animation.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/hash_tag_wrapper.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_drop_down_button.dart';
import '../../design_system/text_field/creta_text_field.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import '../../routes.dart';
//import '../login_page.dart';
import '../login/creta_account_manager.dart';
import 'book_info_mixin.dart';
import 'book_main_page.dart';
import 'host_select_page.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';

class BookPublishDialog extends StatefulWidget {
  final BookModel? model;
  final int currentStep;
  String? title;
  final Function? onNext;
  final Function? onPrev;
  String? nextBtTitle;
  String? prevBtTitle;

  BookPublishDialog({
    super.key,
    required this.model,
    this.currentStep = 1,
    this.title,
    this.onNext,
    this.onPrev,
    this.nextBtTitle, // = CretaLang['next']!,
    this.prevBtTitle, // = CretaLang['prev']!,
  }) {
    nextBtTitle ??= CretaLang['next']!;
    prevBtTitle ??= CretaLang['prev']!;
    title ??= CretaStudioLang['publishSettings']!;
  }

  @override
  State<BookPublishDialog> createState() => _BookPublishDialogState();
}

class _BookPublishDialogState extends State<BookPublishDialog> with BookInfoMixin {
  //, SingleTickerProviderStateMixin {
  final TextEditingController scopeController = TextEditingController();
  int currentStep = 1;
  var totalSteps = 0;
  late List<StepperData> stepsData;
  late List<Widget> stepsWidget;

  final double width = 430;
  final double height = 610;

  late HostManager hostManagerHolder;
  String message = '';

  HashTagWrapper hashTagWrapper = HashTagWrapper();
  List<String> emailList = [];
  List<PermissionType> permitionList = [];
  List<UserPropertyModel> userModelList = [];

  List<String> channelEmailList = [];
  // List<UserPropertyModel> channelUserModelList = [];

  List<TeamModel> teamModelList = [];
  List<String> publishingChannelIdList = [CretaAccountManager.getUserProperty!.channelId];
  final String myChannelId = CretaAccountManager.getUserProperty!.channelId;

  Future<bool>? _onceDBGetComplete1;
  //bool _onceDBGetComplete2 = false;
  Future<bool>? _onceDBPublishComplete;

  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  String _modifier = '';
  String _publishResultStr = CretaStudioLang['publishFailed']!;

  List<String> _owners = [];
  List<String> _readers = [];
  List<String> _writers = [];

  BookPublishedManager bookPublishedManagerHolder = BookPublishedManager();
  BookModel? alreadyPublishedBook;

  final Set<String> _invitees = {};

  bool _tagEnabled = true;

  String _publishedBookMid = '';
  String _publishedBookName = '';

  //final bool _isInvite = false;

  // late AnimationController animationController;
  // late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    horizontalPadding = 16;
    hashTagWrapper.hashTagList = CretaCommonUtils.jsonStringToList(widget.model!.hashTag.value);
    logger.fine('hashTagList=${hashTagWrapper.hashTagList}');

    stepsData = List.generate(CretaStudioLang['publishSteps']!.length,
        (index) => StepperData(label: CretaStudioLang['publishSteps']![index]));
    // stepsData = [
    //   StepperData(label: CretaStudioLang['publishSteps']![0]),
    //   StepperData(label: CretaStudioLang['publishSteps']![1]),
    //   StepperData(label: CretaStudioLang['publishSteps']![2]),
    //   StepperData(label: CretaStudioLang['publishSteps']![3]),
    //   StepperData(label: CretaStudioLang['publishSteps']![4]),
    // ];
    totalSteps = stepsData.length;

    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;

    _onceDBGetComplete1 = _initData();
    currentStep = widget.currentStep;

    hostManagerHolder = HostManager();
    hostManagerHolder.configEvent(notifyModify: false);
    hostManagerHolder.clearAll();

    // LoginPage.channelManagerHolder!
    //     .getChannelFromList(widget.model!.channels)
    //     .then((value) {
    //       List<String> emailList = [];
    //       for(var model in value) {
    //         if (model.userId.isNotEmpty) {
    //           emailList.add(model.userId);
    //         }
    //       }
    //       //
    //       LoginPage.userPropertyManagerHolder!
    //           .getUserPropertyFromEmail(emailList)
    //           .then((value) {
    //         channelUserModelList = [...value];
    //         for (var ele in channelUserModelList) {
    //           logger.fine('=======>>>>>>>>>>>> user_property ${ele.nickname}, ${ele.email} founded');
    //         }
    //         _onceDBGetComplete2 = true;
    //         return value;
    //       });
    // });

    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 1000),
    // );
    // animation = CurvedAnimation(
    //   parent: animationController,
    //   curve: Curves.easeIn,
    // );
  }

  Future<bool> _initData() async {
    alreadyPublishedBook = await bookPublishedManagerHolder.findPublished(widget.model!.mid);

    if (alreadyPublishedBook != null) {
      logger.fine('published already exist');
      _owners = [...alreadyPublishedBook!.owners];
      _readers = [...alreadyPublishedBook!.readers];
      _writers = [...alreadyPublishedBook!.writers];
    } else {
      _owners = [...widget.model!.owners];
      _readers = [...widget.model!.readers];
      _writers = [...widget.model!.writers];
    }

    _resetList();

    userModelList =
        await CretaAccountManager.userPropertyManagerHolder.getUserPropertyFromEmail(emailList);

    logger.fine('_readers=$_readers');
    logger.fine('_writers=$_writers');
    logger.fine('emailList=$emailList');

    return true;
  }

  Map<String, PermissionType> getSharesAsMap() {
    Map<String, PermissionType> retval = {};
    for (var val in _owners) {
      retval[val] = PermissionType.owner;
    }
    for (var val in _writers) {
      retval[val] = PermissionType.writer;
    }
    for (var val in _readers) {
      retval[val] = PermissionType.reader;
    }
    return retval;
  }

  void _resetList() {
    emailList.clear();
    permitionList.clear();
    Map<String, PermissionType> shares = getSharesAsMap();
    // creator 를 항상 제일 앞에 놓는다.
    for (var ele in shares.entries) {
      if (ele.key == widget.model!.creator) {
        emailList.add(ele.key);
        permitionList.add(ele.value);
      }
    }
    shares.remove(widget.model!.creator);

    for (var ele in shares.entries) {
      if (ele.value == PermissionType.owner) {
        emailList.add(ele.key);
        permitionList.add(ele.value);
      }
    }
    // owner 를 먼저 email list 에 넣기 위애 이와 같이 for 문을 두번도는 것임.
    for (var ele in shares.entries) {
      if (ele.value != PermissionType.owner) {
        emailList.add(ele.key);
        permitionList.add(ele.value);
      }
    }
    logger.fine('emailList=$emailList');
  }

  // Future<bool> _waitDBJob() async {
  //   while (_onceDBGetComplete1 == false /*|| _onceDBGetComplete2 == false*/) {
  //     await Future.delayed(const Duration(microseconds: 500));
  //   }
  //   logger.fine('_onceDBGetComplete=$_onceDBGetComplete1 wait end');
  //   return _onceDBGetComplete1;
  // }

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
      // case 5:
      //   return step5();
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
          initialData: false,
          future: _onceDBGetComplete1,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData == false) {
              //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
              return SizedBox(width: width, height: height, child: CretaSnippet.showWaitSign());
            }
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              return Snippet.errMsgWidget(snapshot);
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return SizedBox(width: width, height: height, child: CretaSnippet.showWaitSign());
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
                              widget.title!,
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
                          bottom: 0,
                        ),
                        child: _stepsWidget(currentStep),
                      ),
                      const Divider(
                        height: 10,
                        indent: 0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (currentStep > 1 && currentStep < 4)
                              BTN.line_red_t_m(
                                //width: 24,
                                text: widget.prevBtTitle!,
                                onPressed: widget.onPrev ??
                                    () {
                                      setState(() {
                                        _prevStep();
                                      });
                                    },
                              ),
                            const SizedBox(width: 8),
                            if (currentStep < 4)
                              BTN.line_red_t_m(
                                //width: 55,
                                text: widget.nextBtTitle!,
                                onPressed: widget.onNext ??
                                    () {
                                      setState(() {
                                        _nextStep();
                                      });
                                    },
                              ),
                            if (currentStep == 4)
                              //SizedBox(
                              //width: 240,
                              //child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  BTN.fill_blue_t_m(
                                    width: 150,
                                    text: CretaLang['gotoCommunity']!,
                                    onPressed: () {
                                      AppRoutes.launchTab(AppRoutes.communityHome);
                                      setState(() {
                                        _nextStep();
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  BTN.fill_blue_t_m(
                                    width: 55,
                                    text: CretaLang['close']!,
                                    onPressed: () {
                                      setState(() {
                                        _nextStep();
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  BTN.fill_blue_t_m(
                                    width: 110,
                                    text: CretaStudioLang['broadcast'] ?? 'broadcast',
                                    onPressed: () async {
                                      //setState(() {
                                      await HostUtil.broadCast(context, hostManagerHolder,
                                          _publishedBookMid, _publishedBookName);
                                      Navigator.of(context).pop();
                                      //});
                                    },
                                  ),
                                ],
                              ),
                            //),
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._scope(),
            ..._defaultScope(),
            ..._publishTo(),
          ],
        ),
      ),
    );
  }

  Widget step3() {
    return SizedBox(
      height: 380,
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget step4() {
    return FutureBuilder(
        initialData: false,
        future: _onceDBPublishComplete,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return SizedBox(width: width, height: 365, child: CretaSnippet.showWaitSign());
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }
          if (snapshot.data == false) {
            return SizedBox(width: width, height: 365, child: CretaSnippet.showWaitSign());
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox(width: width, height: 365, child: CretaSnippet.showWaitSign());
          }
          return SizedBox(
            height: 365,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // CircularRevealAnimation(
                //   // @required
                //   animation: animation,
                //   // child's center if not specified
                //   centerAlignment: Alignment.center,
                //   // 0 if not specified
                //   minRadius: 12,
                //   // distance from center to further child's corner if not specified
                //   maxRadius: 200,
                //   // @required
                //   child: _drawThumbnail(),
                // ),
                StaggeredAnimation(
                  child: _drawThumbnail(),
                ),
                Center(
                    child: Text(
                  '$_modifier $_publishResultStr',
                  style: CretaFont.titleELarge,
                )),
                // .animate(delay: const Duration(microseconds: 1500))
                // .then()
                // .fade()
                // .slide()
                // .then()
                // .tint()
                // .then()
                // .shake()),
              ],
            ),
          );
        });
  }

  // Future<void> _broadCast() async {
  //   List<HostModel> selectedHosts = [];

  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CretaAlertDialog(
  //           width: 420,
  //           height: 600,
  //           title: CretaStudioLang['selectDevice'] ?? "Select the device you want to broadcast.",
  //           padding: const EdgeInsets.only(left: 20, right: 20),
  //           //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //           //child: Container(
  //           content: Container(
  //             width: 420,
  //             height: 560,
  //             margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
  //             child: HostSelectPage(
  //               hostManager: hostManagerHolder,
  //               selectedHosts: selectedHosts,
  //               onSelected: (hostId, name) {
  //                 logger.fine('onSelected $hostId, $name');
  //               },
  //               searchText: '',
  //             ),
  //           ),
  //           okButtonText: CretaLang['apply'] ?? 'Apply',

  //           okButtonWidth: 110,
  //           onPressedOK: () async {
  //             for (var host in selectedHosts) {
  //               host.requestedBook1Id = widget.model!.mid;
  //               host.requestedBook1 = widget.model!.name.value;
  //               host.requestedBook1Time = DateTime.now().toUtc();
  //               await hostManagerHolder.setToDB(host);
  //             }
  //             message = CretaStudioLang['broadcastComplete'] ?? 'Broadcast complete.';
  //             Navigator.of(context).pop();
  //           },
  //           onPressedCancel: () {
  //             message = '';
  //             Navigator.of(context).pop();
  //           },
  //         );
  //       });
  //   if (message.isNotEmpty) {
  //     await showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return CretaAlertDialog(
  //             width: 420,
  //             height: 300,
  //             title: CretaStudioLang['broadcastComplete'] ?? "The broadcast has been applied.",
  //             padding: const EdgeInsets.only(left: 20, right: 20),
  //             //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //             //child: Container(
  //             content: Center(
  //                 child: Text(
  //                     CretaLang['moveToDevice'] ??
  //                         'Would you like to go to the device management page ?',
  //                     style: CretaFont.bodyMedium)),
  //             okButtonText: 'Yes',
  //             okButtonWidth: 110,
  //             onPressedOK: () async {
  //               Navigator.of(context).pop();
  //               Routemaster.of(context).push(AppRoutes.deviceSharedPage);
  //             },
  //             onPressedCancel: () {
  //               Navigator.of(context).pop();
  //             },
  //           );
  //         });
  //   }
  // }

  Widget _drawThumbnail() {
    final Random random = Random();
    int randomNumber = random.nextInt(100);
    String image = widget.model!.thumbnailUrl.value.isEmpty
        ? 'https://picsum.photos/200/?random=$randomNumber'
        : widget.model!.thumbnailUrl.value;
    // String image = 'https://picsum.photos/200/?random=$randomNumber';
    // String image =
    //     'https://oaidalleapiprodscus.blob.core.windows.net/private/org-wu0lAWU8sN5CR4ZUjC13D0XH/user-U7GAXXruTXKgCHDICrqUDVT0/img-NiOCRrCd1oEPpOjIdOfa2v8r.png?st=2023-05-24T07%3A53%3A57Z&se=2023-05-24T09%3A53%3A57Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-05-24T00%3A07%3A46Z&ske=2023-05-25T00%3A07%3A46Z&sks=b&skv=2021-08-06&sig=ISd6MJBNwyCJoSuo25O1rKD1%2BCbdJafY5UISDnotaZg%3D';
    //return Image.network(image);
    return CustomImage(
        key: GlobalKey(),
        hasMouseOverEffect: false,
        boxFit: BoxFit.cover,
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
      _onceDBPublishComplete = _beforePublish();
    } else if (currentStep == 3) {
      _onceDBPublishComplete = _publish();
    }
  }

  // Future<bool> _waitPublish() async {
  //   while (_onceDBPublishComplete == false) {
  //     await Future.delayed(const Duration(microseconds: 500));
  //   }
  //   return true;
  // }
  Future<bool> _beforePublish() async {
    _publishedBookMid = '';
    _publishedBookName = '';
    return false;
  }

  Future<bool> _publish() async {
    logger.fine('_readers=$_readers');
    logger.fine('_writers=$_writers');

    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    widget.model!.channels = publishingChannelIdList;
    return bookPublishedManagerHolder.publish(
      src: widget.model!,
      alreadyPublishedOne: alreadyPublishedBook,
      readers: _readers,
      writers: _writers,
      pageManager: BookMainPage.pageManagerHolder!,
      onComplete: (isNew, published) {
        ChannelManager channelManagerHolder = ChannelManager();
        channelManagerHolder.updateToDB(
          CretaAccountManager.getUserProperty!.channelId,
          {"lastPublishTime": HycopUtils.dateTimeToDB(DateTime.now())},
        );
        _modifier = isNew ? CretaStudioLang['newely']! : CretaStudioLang['update']!;
        _publishResultStr = CretaStudioLang['publishComplete']!;

        _publishedBookMid = published.mid;
        _publishedBookName = published.name.value;

        for (var email in _invitees) {
          CretaUtils.inviteBook(
            context,
            email,
            _publishedBookMid,
            _publishedBookName,
            AccountManager.currentLoginUser.name,
          );
        }
        //_onceDBPublishComplete = true;
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
    String val = widget.model!.hashTag.value;
    int rest = StudioConst.maxTextLimit - 2 - val.length;
    if (rest <= 0) {
      logger.warning('len1 overflow $rest');
      _tagEnabled = false;
    }

    return hashTagWrapper.hashTag(
      top: 0,
      model: widget.model!,
      minTextFieldWidth: width - horizontalPadding * 2,
      onTagChanged: (value) {
        setState(() {
          _tagEnabled = (value == null) ? false : true;
        });
      },
      onSubmitted: (value) {
        setState(() {
          _tagEnabled = (value == null) ? false : true;
        });
      },
      onDeleted: (value) {
        setState(() {});
      },
      limit: StudioConst.maxTextLimit - 2,
      enabled: _tagEnabled,
      rest: rest > 0 ? rest - 1 : 0,
    );
  }

//
// step 2
//

  List<Widget> _scope() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaLang['inPublic']!, style: CretaFont.titleSmall),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CretaTextField(
              height: 32,
              width: 238,
              textFieldKey: GlobalKey(),
              value: '',
              hintText: '',
              controller: scopeController,
              onEditComplete: (val) {
                // _addUser(scopeController.text).then((value) {
                //   if (value) {
                //     setState(() {});
                //   }
                //   return value;
                // });
              }),
          BTN.line_blue_t_m(
              text: CretaLang['invite']!,
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

  // Widget _inviteDialog() {
  //   return Center(
  //     child: Container(
  //       width: width - 20,
  //       height: height - 300, // Add custom padding
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(width: 1, color: CretaColor.text[200]!),
  //       ),
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             width: width - 40,
  //             height: height - 500,
  //             child: Center(
  //               child: Text(
  //                 CretaStudioLang['isSendEmail']!,
  //                 style: CretaFont.bodyMedium,
  //               ),
  //             ),
  //           ),
  //           const Divider(indent: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                   backgroundColor: CretaColor.primary.withOpacity(0.15),
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5)), // Rounded corners
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Dismiss dialog
  //                 },
  //                 child: Text(CretaLang['cancel']!, style: CretaFont.buttonMedium),
  //               ),
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                   backgroundColor: CretaColor.primary.withOpacity(0.15),
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5)), // Rounded corners
  //                 ),
  //                 onPressed: () async {
  //                   await _invite(
  //                     scopeController.text,
  //                     widget.model!.mid,
  //                     widget.model!.name.value,
  //                     AccountManager.currentLoginUser.name,
  //                   );
  //                   Navigator.of(context).pop(); // Dismiss dialog
  //                 },
  //                 child: Text(CretaLang['confirm']!, style: CretaFont.buttonMedium),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<bool> _addUser(String email) async {
    // email 이거나, 팀명이다.
    bool isEmail = CretaCommonUtils.isValidEmail(email);
    if (isEmail) {
      // 헤당 유저가 회원인지 찾는다.
      UserPropertyModel? user =
          await CretaAccountManager.userPropertyManagerHolder.emailToModel(email);
      if (user != null) {
        setState(() {
          _addReaders(email);
          userModelList.add(user);
          _resetList();
        });
        return true;
      }
      // 여기서, 초대를 해야 한다.  단,  실제 메일을 보내는 것은 발행이 끝나고, 해야 한다.
      _invitees.add(scopeController.text);
      // bool succeed = await _invite(
      //   scopeController.text,
      //   widget.model!.mid,
      //   widget.model!.name.value,
      //   AccountManager.currentLoginUser.name,
      // );
      //if (succeed) {
      UserPropertyModel newBee = UserPropertyModel('');
      newBee.email = scopeController.text;
      newBee.nickname = scopeController.text;
      setState(() {
        _addReaders(email);
        userModelList.add(newBee);
        _resetList();
      });
      return true;
      //}
      //return false;
    }
    // 팀명인지 확인한다. 현재 enterpriseId 가 없으므로 ${UserPropertyModel.defaultEnterprise} 으로 검색한다
    TeamModel? team =
        await CretaAccountManager.findTeamModelByName(email, UserPropertyModel.defaultEnterprise);
    if (team != null) {
      setState(() {
        _addReaders(team.mid);
        userModelList.add(CretaAccountManager.userPropertyManagerHolder.makeDummyModel(team));
        _resetList();
      });
      return true;
    }
    // 해당하는 Team 명이 없다. 이메일등을 넣도록 경고한다.
    showSnackBar(context, CretaStudioLang['wrongEmail']!, duration: const Duration(seconds: 3));
    return false;
  }

  List<Widget> _defaultScope() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BTN.line_blue_wmi_m(
                leftWidget: CretaAccountManager.userPropertyManagerHolder
                    .imageCircle('', CretaLang['entire']!, radius: 24, color: CretaColor.primary),
                icon: Icons.add_outlined,
                text: CretaLang['entire']!,
                onPressed: () {
                  UserPropertyModel? user = _findModel(UserPropertyModel.defaultEmail);
                  if (user == null) {
                    //아직 전체가 없을 때만 넣는다.
                    setState(() {
                      _addReaders(UserPropertyModel.defaultEmail);
                      userModelList
                          .add(CretaAccountManager.userPropertyManagerHolder.makeDummyModel(null));
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
    return TeamManager.getTeamList.map((e) {
      return BTN.line_blue_wmi_m(
          leftWidget: CretaAccountManager.userPropertyManagerHolder
              .imageCircle(e.profileImgUrl, e.name, radius: 24),
          icon: Icons.add_outlined,
          text: '${e.name} ${CretaLang['team']!}',
          width: 180,
          textWidth: 90,
          onPressed: () {
            UserPropertyModel? user = _findModel(e.mid);
            if (user == null) {
              setState(() {
                _addReaders(e.mid);
                userModelList.add(CretaAccountManager.userPropertyManagerHolder.makeDummyModel(e));
                _resetList();
              });
            }
          });
    }).toList();
  }

  bool _addReaders(String id) {
    if (_owners.contains(id) == false) {
      _readers.add(id);
    }
    _owners.remove(id);
    _writers.remove(id);
    //widget.model!.save();
    return true;
  }

  bool _addWriters(String id) {
    if (_writers.contains(id) == false) {
      _writers.add(id);
    }
    _owners.remove(id);
    _readers.remove(id);
    //widget.model!.save();
    return true;
  }

  // bool _addOwners(String id) {
  //   if (_owners.contains(id) == false) {
  //     _owners.add(id);
  //   }
  //   _writers.remove(id);
  //   _readers.remove(id);
  //   widget.model!.save();
  //   return true;
  // }

  List<Widget> _publishTo() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(CretaStudioLang['publishTo']!, style: CretaFont.titleSmall),
      ),
      Container(
        width: 393,
        height: 175,
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
                  padding: const EdgeInsets.only(left: 0, bottom: 6, right: 4.0),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CretaAccountManager.userPropertyManagerHolder.profileImageBox(
                          model: userModel,
                          radius: 28,
                          color: email == UserPropertyModel.defaultEmail
                              ? CretaColor.primary
                              : Colors.primaries[index % Colors.primaries.length]),
                      //const Icon(Icons.account_circle_outlined),
                      SizedBox(
                        //color: Colors.amber,
                        width: isNotCreator ? 120 : 120 + 96 + 24,
                        child: Tooltip(
                          message: userModel != null
                              ? userModel.phoneNumber == 'team'
                                  ? userModel.nickname
                                  : userModel.email
                              : '',
                          child: Text(
                            _nameWrap(
                                userModel,
                                ((userModel != null && userModel.phoneNumber == 'team')
                                    ? userModel.nickname
                                    : email),
                                isNotCreator,
                                false),
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
                          width: 104,
                          alignment: Alignment.centerLeft,
                          child: CretaDropDownButton(
                              selectedColor: CretaColor.text[700]!,
                              textStyle: CretaFont.bodyESmall,
                              width: 106,
                              height: 28,
                              itemHeight: 28,
                              dropDownMenuItemList: StudioSnippet.getPublishPermitionListItem(
                                  defaultValue: permitionList[index],
                                  onChanged: (val) {
                                    if (val == PermissionType.writer) {
                                      _addWriters(email);
                                    } else if (val == PermissionType.reader) {
                                      _addReaders(email);
                                    }
                                    setState(() {
                                      //widget.model!.save();
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
                                  _owners.remove(email);
                                } else if (permitionList[index] == PermissionType.writer) {
                                  // deleteFrom writers
                                  _writers.remove(email);
                                } else if (permitionList[index] == PermissionType.reader) {
                                  // deleteFrom readers
                                  _readers.remove(email);
                                }
                                for (var ele in userModelList) {
                                  if (ele.email == email) {
                                    userModelList.remove(ele);
                                    break;
                                  }
                                }
                                _invitees.remove(email);

                                setState(() {
                                  //widget.model!.save();
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
      logger.fine('===============>>>_nameWrap(${model.nickname}, email, isNotCreator)');
      name = model.nickname;
    }
    if (isNotCreator) {
      return name;
    }
    return '$name(${isChannel ? CretaLang['myChannel']! : CretaLang['creator']!})';
  }

  UserPropertyModel? _findModel(String email) {
    for (var model in userModelList) {
      if (model.email == email) {
        return model;
      }
    }
    return null;
  }

  // UserPropertyModel? _findChannelModel(String email) {
  //   for (var model in channelUserModelList) {
  //     if (model.email == email) {
  //       return model;
  //     }
  //   }
  //   return null;
  // }

  //
  // step3
  //

  List<Widget> _channelScope() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(CretaStudioLang['channelList']!, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BTN.line_blue_wmi_m(
                leftWidget: CretaAccountManager.userPropertyManagerHolder
                    .imageCircle('', CretaLang['entire']!, radius: 24, color: CretaColor.primary),
                icon: Icons.add_outlined,
                text: CretaLang['myChannel']!,
                onPressed: () {
                  // UserPropertyModel? user = _findChannelModel('${UserPropertyModel.defaultEmail}');
                  // if (user == null) {
                  //   //아직 전체가 없을 때만 넣는다.
                  //   setState(() {
                  //     widget.model!.channels.add('${UserPropertyModel.defaultEmail}');
                  //     widget.model!.save();
                  //     channelUserModelList
                  //         .add(LoginPage.userPropertyManagerHolder!.makeDummyModel(null));
                  //   });
                  // }
                  if (!publishingChannelIdList.contains(myChannelId)) {
                    setState(() {
                      publishingChannelIdList.add(myChannelId);
                      //widget.model!.save();
                      // channelUserModelList
                      //     .add(LoginPage.userPropertyManagerHolder!.makeDummyModel(null));
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
    return TeamManager.getTeamList.map((e) {
      return BTN.line_blue_wmi_m(
          leftWidget: CretaAccountManager.userPropertyManagerHolder
              .imageCircle(e.profileImgUrl, e.name, radius: 24),
          icon: Icons.add_outlined,
          text: '${e.name} ${CretaLang['team']!}',
          width: 180,
          textWidth: 90,
          onPressed: () {
            if (!publishingChannelIdList.contains(e.channelId)) {
              setState(() {
                //widget.model!.channels.add(e.channelId);
                //widget.model!.save();
                //channelUserModelList.add(LoginPage.userPropertyManagerHolder!.makeDummyModel(e));
                publishingChannelIdList.add(e.channelId);
              });
            }
          });
    }).toList();
  }

  TeamModel? _findTeamModel(String channelId) {
    for (var teamModel in TeamManager.getTeamList) {
      if (teamModel.channelId == channelId) {
        return teamModel;
      }
    }
    return null;
  }

  List<Widget> _channelTo() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(CretaStudioLang['publishingChannelList']!, style: CretaFont.titleSmall),
      ),
      Container(
        width: 393,
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
              itemCount: publishingChannelIdList.length,
              itemBuilder: (BuildContext context, int index) {
                String channelId = publishingChannelIdList[index];
                TeamModel? teamModel = _findTeamModel(channelId);
                //bool isNotCreator = (userModel.email != widget.model!.creator);
                UserPropertyModel userModel = CretaAccountManager.getUserProperty!;
                // ignore: unused_local_variable
                bool isNotCreator = (teamModel != null);
                return Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 6, right: 12.0),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LoginPage.userPropertyManagerHolder!.profileImageBox(
                      //     model: userModel,
                      //     radius: 28,
                      //     color: userModel.email == '${UserPropertyModel.defaultEmail}' ? CretaColor.primary : null),
                      CretaAccountManager.userPropertyManagerHolder.imageCircle(
                        teamModel?.profileImgUrl ??
                            CretaAccountManager.getUserProperty!.profileImgUrl,
                        teamModel?.name ?? CretaAccountManager.getUserProperty!.nickname,
                        radius: 28,
                      ),
                      //const Icon(Icons.account_circle_outlined),
                      SizedBox(
                        //color: Colors.amber,
                        width: 120 + 96, //isNotCreator ? 120 + 96 : 120 + 96 + 24,
                        child: Tooltip(
                          message: (teamModel == null)
                              ? userModel.email
                              : '${teamModel.name} ${CretaLang['team']!}',
                          child: Text(
                            (teamModel == null)
                                ? CretaLang['myChannel']!
                                : '${teamModel.name} ${CretaStudioLang["channel"]!}',
                            style: (index > 0) // isNotCreator
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

                      /*isNotCreator
                          ?*/
                      BTN.fill_gray_i_s(
                        icon: Icons.close,
                        onPressed: () {
                          // widget.model!.channels.remove(userModel.channelId);
                          // for (var ele in channelUserModelList) {
                          //   if (ele.email == userModel.email) {
                          //     channelUserModelList.remove(ele);
                          //     break;
                          //   }
                          // }
                          if (publishingChannelIdList.length > 1) {
                            setState(() {
                              //widget.model!.save();
                              publishingChannelIdList.remove(channelId);
                            });
                          }
                        },
                        buttonSize: 24,
                      ) /*: const SizedBox.shrink()*/,
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
          Text(CretaStudioLang['allowReply']!, style: titleStyle),
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

  // Future<bool> _invite(String email, String bookMid, String bookName, String userName) async {
  //   String was = 'https://devcreta.com';
  //   String url = '$was:444/sendEmail';
  //   String msg =
  //       '$userName${CretaStudioLang['pressLinkToJoinCreta1']!}$was${AppRoutes.communityBook}?$bookMid'; //내용

  //   Map<String, dynamic> body = {
  //     "to": ['"$email"'], // 수신인
  //     "cc": [], // 참조
  //     "bcc": [], // 숨은참조
  //     "subject": '"$userName${CretaStudioLang['cretaInviteYou']!}"', //제목
  //     "message": '"$msg"', //내용
  //   };

  //   Response? res = await CretaUtils.post(url, body, onError: (code) {
  //     showSnackBar(context, '${CretaStudioLang['inviteEmailFailed']!}($code)');
  //   }, onException: (e) {
  //     showSnackBar(context, '${CretaStudioLang['inviteEmailFailed']!}($e)');
  //   });

  //   if (res != null) {
  //     showSnackBar(context, CretaStudioLang['inviteEmailSucceed']!);
  //     return true;
  //   }
  //   return false;
  // }
}
