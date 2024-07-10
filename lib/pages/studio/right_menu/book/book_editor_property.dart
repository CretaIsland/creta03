// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_snippet.dart';

import '../../../../common/creta_utils.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../design_system/menu/creta_drop_down_button.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
//import '../../../login_page.dart';
import '../../../login/creta_account_manager.dart';
import '../../studio_snippet.dart';
import '../property_mixin.dart';

// 권한 프로퍼티 부분임.  클래스 이름을 잘못지은거임.
class BookEditorProperty extends StatefulWidget {
  final BookModel model;
  final Function() parentNotify;
  final bool isDialog;
  const BookEditorProperty(
      {super.key, required this.model, required this.parentNotify, this.isDialog = false});

  @override
  State<BookEditorProperty> createState() => _BookEditorPropertyState();
}

class _BookEditorPropertyState extends State<BookEditorProperty> with PropertyMixin {
  final ScrollController _scrollController1 = ScrollController();
  final TextEditingController scopeController = TextEditingController();
  Map<String, UserPropertyModel> userModelMap = {};
  List<String> emailList = [];
  List<PermissionType> permitionList = [];
  bool _onceDBGetComplete1 = false;
  @override
  void initState() {
    logger.finer('_BookEditorPropertyState.initState');
    super.initState();

    _resetList();

    CretaAccountManager.userPropertyManagerHolder.getUserPropertyFromEmail(emailList).then((value) {
      for (var ele in value) {
        userModelMap[ele.email] = ele;
      }
      for (var ele in userModelMap.values) {
        logger.fine('=======>>>>>>>>>>>> user_property ${ele.nickname}, ${ele.email} founded');
      }
      _onceDBGetComplete1 = true;
      return value;
    });
  }

  Future<bool> _waitDBJob() async {
    while (_onceDBGetComplete1 == false) {
      await Future.delayed(const Duration(microseconds: 500));
    }
    logger.fine('_onceDBGetComplete=$_onceDBGetComplete1 wait end');
    return _onceDBGetComplete1;
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _waitDBJob(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return CretaSnippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._scope(),
                ..._defaultScope(),
                ..._invitedPeople(),
                ..._invitedPeople(isTeam: true),
                // if (widget.isDialog)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 20),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         // BTN.line_blue_t_m(
                //         //   width: 24,
                //         //   text: CretaLang['cancel']!,
                //         //   onPressed: () {
                //         //     Navigator.of(context).pop();
                //         //   },
                //         // ),
                //         // const SizedBox(width: 8),
                //         BTN.fill_blue_t_m(
                //           width: 55,
                //           text: CretaLang['confirm']!,
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //         ),
                //         const SizedBox(width: 8),
                //       ],
                //     ),
                //   )
              ],
            ),
          );
        });
  }

  List<Widget> _scope() {
    return [
      // if (widget.isDialog)
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text(
      //           CretaLang['invite']!,
      //           style: CretaFont.titleMedium,
      //         ),
      //         if (widget.isDialog)
      //           BTN.fill_gray_i_m(
      //               icon: Icons.close_outlined,
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               }),
      //       ],
      //     ),
      //   ),
      // if (widget.isDialog)
      //   const Divider(
      //     height: 22,
      //     indent: 0,
      //   ),
      if (widget.isDialog == false)
        Padding(
          padding: EdgeInsets.only(bottom: 12, top: widget.isDialog ? 12 : 0),
          child: Text(CretaLang['invite']!, style: CretaFont.titleSmall),
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
                  CretaUtils.inviteBook(
                    context,
                    scopeController.text,
                    widget.model.mid,
                    widget.model.name.value,
                    AccountManager.currentLoginUser.name,
                  );
                  return value;
                });
              })
        ],
      )
    ];
  }

  void _resetList() {
    // Map<String, PermissionType> shares = widget.model.getSharesAsMap();

    emailList.clear();
    permitionList.clear();
    Map<String, PermissionType> shares = widget.model.getSharesAsMap();
    // creator 를 항상 제일 앞에 놓는다.
    for (var ele in shares.entries) {
      if (ele.key == widget.model.creator) {
        emailList.add(ele.key);
        permitionList.add(ele.value);
      }
    }
    shares.remove(widget.model.creator);

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

    // emailList = shares.keys.toList();
    // permitionList = shares.values.toList();
  }

  UserPropertyModel? _findModel(String email) {
    for (var model in userModelMap.values) {
      if (model.email == email) {
        return model;
      }
    }
    return null;
  }

  bool _addReaders(String id) {
    if (widget.model.owners.contains(id) == false) {
      widget.model.readers.add(id);
    }
    widget.model.owners.remove(id);
    widget.model.writers.remove(id);
    widget.model.save();
    return true;
  }

  bool _addWriters(String id) {
    if (widget.model.writers.contains(id) == false) {
      widget.model.writers.add(id);
    }
    widget.model.owners.remove(id);
    widget.model.readers.remove(id);
    widget.model.save();
    return true;
  }

  bool _addOwners(String id) {
    if (widget.model.owners.contains(id) == false) {
      widget.model.owners.add(id);
    }
    widget.model.writers.remove(id);
    widget.model.readers.remove(id);
    widget.model.save();
    return true;
  }

  Future<bool> _addUser(String email) async {
    // email 이거나, 팀명이다.
    bool isEmail = CretaCommonUtils.isValidEmail(email);
    if (isEmail) {
      // 헤당 유저가 회원인지 찾는다.
      UserPropertyModel? user =
          await CretaAccountManager.userPropertyManagerHolder.emailToModel(email);
      if (user != null) {
        setState(() {
          _addWriters(email);
          userModelMap[user.email] = user;
          _resetList();
        });
        return true;
      }

      UserPropertyModel newBee = UserPropertyModel('');
      newBee.email = scopeController.text;
      newBee.nickname = scopeController.text;
      setState(() {
        _addReaders(email);
        userModelMap[newBee.email] = newBee;
        _resetList();
      });
      // 여기서, 초대를 해야 한다.
      // ignore: use_build_context_synchronously
      //showSnackBar(context, CretaStudioLang['noExitEmail']!, duration: const Duration(seconds: 3));
      return true;
    }
    // 팀명인지 확인한다. 현재 enterpriseId 가 없으므로 ${UserPropertyModel.defaultEnterprse} 으로 검색한다
    TeamModel? team =
        await CretaAccountManager.findTeamModelByName(email, UserPropertyModel.defaultEnterprise);
    if (team != null) {
      setState(() {
        _addWriters(team.mid);
        UserPropertyModel user = CretaAccountManager.userPropertyManagerHolder.makeDummyModel(team);
        userModelMap[user.email] = user;
        _resetList();
      });
      return true;
    }
    // 해당하는 Team 명이 없다. 이메일등을 넣도록 경고한다.
    // ignore: use_build_context_synchronously
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
            ..._myMembers(),
            ..._myTeams(),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myMembers() {
    Set<UserPropertyModel>? myMembers = CretaAccountManager.getMyTeamMembers();
    if (myMembers == null) {
      return [];
    }
    return myMembers.map((e) {
      // 자기 자신은 제외함.
      if (e.email == CretaAccountManager.currentLoginUser.email) {
        return SizedBox.shrink();
      }
      return BTN.line_blue_wmi_m(
          leftWidget: CretaAccountManager.userPropertyManagerHolder
              .imageCircle(e.profileImgUrl, e.nickname, radius: 24),
          icon: Icons.add_outlined,
          text: e.nickname,
          width: 140,
          textWidth: 60,
          onPressed: () {
            setState(() {
              _addWriters(e.email);
              userModelMap[e.email] = e;
              _resetList();
            });
          });
    }).toList();
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
            setState(() {
              _addWriters(e.mid);
              UserPropertyModel user =
                  CretaAccountManager.userPropertyManagerHolder.makeDummyModel(e);
              userModelMap[user.email] = user;
              _resetList();
            });
          });
    }).toList();
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

  List<Widget> _invitedPeople({bool isTeam = false}) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Text(isTeam ? CretaStudioLang['invitedTeam']! : CretaStudioLang['invitedPeople']!,
            style: CretaFont.titleSmall),
      ),
      Container(
        width: 333,
        height: isTeam ? 160 : 175,
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
                bool isNotCreator = (email != widget.model.creator);
                if (CretaCommonUtils.isValidEmail(email) == isTeam) {
                  return SizedBox.shrink();
                }
                UserPropertyModel? userModel = _findModel(email);
                return Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 6, right: 12.0),
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CretaAccountManager.userPropertyManagerHolder.profileImageBox(
                        model: userModel,
                        radius: 28,
                        color: email == UserPropertyModel.defaultEmail
                            ? CretaColor.primary
                            : Colors.primaries[index % Colors.primaries.length],
                      ),
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
                                      _addOwners(email);
                                    } else if (val == PermissionType.writer) {
                                      _addWriters(email);
                                    } else if (val == PermissionType.reader) {
                                      _addReaders(email);
                                    }
                                    setState(() {
                                      //widget.model.save();
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
                                  widget.model.owners.remove(email);
                                } else if (permitionList[index] == PermissionType.writer) {
                                  // deleteFrom writers
                                  widget.model.writers.remove(email);
                                } else if (permitionList[index] == PermissionType.reader) {
                                  // deleteFrom readers
                                  widget.model.readers.remove(email);
                                }
                                for (var ele in userModelMap.keys) {
                                  if (ele == email) {
                                    userModelMap.remove(ele);
                                    break;
                                  }
                                }

                                setState(() {
                                  widget.model.save();
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
}
