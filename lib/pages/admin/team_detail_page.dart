//import 'package:creta_common/common/creta_common_utils.dart';

import 'dart:typed_data';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/creta_utils.dart';
import '../../data_io/enterprise_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../lang/creta_device_lang.dart';
import '../login/creta_account_manager.dart';
import '../mypage/mypage_common_widget.dart';
//import 'book_select_filter.dart';

class TeamDetailPage extends StatefulWidget {
  final TeamModel teamModel;
  final GlobalKey<FormState> formKey;
  final double width;

  const TeamDetailPage({
    super.key,
    required this.teamModel,
    required this.formKey,
    required this.width,
  });

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  TextEditingController managerTextController = TextEditingController();
  TextEditingController memberTextController = TextEditingController();

  String _messageManager = '';
  String _messageMember = '';

  XFile? _selectedProfileImg;
  Uint8List? _selectedProfileImgBytes;
  XFile? _selectedBannerImg;
  Uint8List? _selectedBannerImgBytes;

  final double textWidth = 210;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    managerTextController.dispose();
    memberTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    // double width = screenSize.width * 0.5;
    // double height = screenSize.height * 0.5;

    return
        // Container(
        //   width: width,
        //   height: height,
        //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        //   color: Colors.white,
        //   child:
        Form(
      key: widget.formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: widget.width * 0.45,
            child: ListView(
              children: <Widget>[
                _nvRow('Team ID', widget.teamModel.name),
                _nvRow('Enterprise', widget.teamModel.enterprise),
                _nvRow('Owner', widget.teamModel.owner),
                ..._managers(),
                ..._members(),

                // TextFormField(
                //   initialValue: widget.teamModel.owner,
                //   decoration: InputDecoration(labelText: 'owner', labelStyle: titleStyle),
                //   onSaved: (value) => widget.teamModel.owner = value ?? '',
                // ),

                // Add more widgets for the second column here
              ],
            ),
          ),
          SizedBox(
            width: widget.width * 0.45,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Team Logo image', style: titleStyle),
                ),
                MyPageCommonWidget.profileImgComponent(
                  width: 200,
                  height: 200,
                  profileImgUrl: widget.teamModel.profileImgUrl,
                  profileImgBytes: _selectedProfileImgBytes,
                  userName: widget.teamModel.name,
                  replaceColor: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                  editBtn: Center(
                    child: BTN.opacity_gray_i_l(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white).icon!,
                        onPressed: () async {
                          try {
                            _selectedProfileImg =
                                await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (_selectedProfileImg != null) {
                              _selectedProfileImg!.readAsBytes().then((value) {
                                setState(() {
                                  _selectedProfileImgBytes = value;
                                });
                                HycopFactory.storage!
                                    .uploadFile(_selectedProfileImg!.name,
                                        _selectedProfileImg!.mimeType!, _selectedProfileImgBytes!)
                                    .then((value) {
                                  if (value != null) {
                                    widget.teamModel.profileImgUrl = value.url;
                                  }
                                });
                              });
                            }
                          } catch (error) {
                            logger.severe("error at team image >> $error");
                          }
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                  child: Text('Team channel banner image', style: titleStyle),
                ),
                MyPageCommonWidget.profileImgComponent(
                  width: 200,
                  height: 200,
                  profileImgUrl: widget.teamModel.channelBannerImg,
                  profileImgBytes: _selectedBannerImgBytes,
                  userName: widget.teamModel.name,
                  replaceColor: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                  editBtn: Center(
                    child: BTN.opacity_gray_i_l(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white).icon!,
                        onPressed: () async {
                          try {
                            _selectedBannerImg =
                                await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (_selectedBannerImg != null) {
                              _selectedBannerImg!.readAsBytes().then((value) {
                                setState(() {
                                  _selectedBannerImgBytes = value;
                                });
                                HycopFactory.storage!
                                    .uploadFile(_selectedBannerImg!.name,
                                        _selectedBannerImg!.mimeType!, _selectedBannerImgBytes!)
                                    .then((value) {
                                  if (value != null) {
                                    widget.teamModel.channelBannerImg = value.url;
                                  }
                                });
                              });
                            }
                          } catch (error) {
                            logger.severe("error at team image >> $error");
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _managers() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: managerTextController,
              //initialValue: '',
              decoration: InputDecoration(labelText: 'Add manager email', labelStyle: titleStyle),
              onSaved: (value) {
                // if (value != null && value.isNotEmpty) {
                //   if (!widget.teamModel.admins.contains(value)) {
                //     widget.teamModel.admins.add(value);
                //   }
                // }
              },
            ),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () async {
              String value = managerTextController.text;
              _messageManager = '';
              if (value.isNotEmpty) {
                if (CretaCommonUtils.isValidEmail(value)) {
                  if (!widget.teamModel.managers.contains(value)) {
                    late bool result;
                    late String message;
                    (result, message) = await checkTeamMember(value);
                    if (!result) {
                      _messageManager = message;
                    } else {
                      widget.teamModel.managers.add(value);
                      widget.teamModel.teamMembers.add(value);
                    }
                  }
                } else {
                  _messageManager = CretaDeviceLang['Invalidemail'];
                }
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      if (_messageManager.isNotEmpty)
        Text(_messageManager, style: const TextStyle(color: Colors.red)),
      //if (widget.teamModel.managers.isNotEmpty)
      Container(
        color: Colors.grey[200],
        height: 200,
        child: ListView.builder(
          itemCount: widget.teamModel.managers.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: textWidth,
                    child: Text(widget.teamModel.managers[index], overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 15),
                BTN.fill_gray_100_i_s(
                  onPressed: () async {
                    String removed = widget.teamModel.managers.removeAt(index);
                    widget.teamModel.managers.remove(removed);
                    setState(() {});
                    // 여기서,  user 를 가져와서, user.team 에서 제거해야 한다.
                    UserPropertyModel? user =
                        await CretaAccountManager.getUserPropertyModel(removed);
                    user?.teams.remove(widget.teamModel.mid);
                    CretaAccountManager.userPropertyManagerHolder.setToDB(user!);
                  },
                  icon: Icons.close,
                ),
              ],
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _members() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: memberTextController,
              //initialValue: '',
              decoration: InputDecoration(labelText: 'Add member email', labelStyle: titleStyle),
              onSaved: (value) {
                // if (value != null && value.isNotEmpty) {
                //   if (!widget.teamModel.admins.contains(value)) {
                //     widget.teamModel.admins.add(value);
                //   }
                // }
              },
            ),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () async {
              String value = memberTextController.text;
              _messageMember = '';
              if (value.isNotEmpty) {
                if (CretaCommonUtils.isValidEmail(value)) {
                  if (!widget.teamModel.generalMembers.contains(value)) {
                    late bool result;
                    late String message;
                    (result, message) = await checkTeamMember(value);
                    if (!result) {
                      _messageMember = message;
                    } else {
                      widget.teamModel.generalMembers.add(value);
                      widget.teamModel.teamMembers.add(value);
                    }
                  }
                } else {
                  _messageMember = CretaDeviceLang['Invalidemail'];
                }
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      if (_messageMember.isNotEmpty)
        Text(_messageMember, style: const TextStyle(color: Colors.red)),
      //if (widget.teamModel.generalMembers.isNotEmpty)
      Container(
        color: Colors.grey[200],
        height: 200,
        child: ListView.builder(
          itemCount: widget.teamModel.generalMembers.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: textWidth,
                  child: Text(
                    widget.teamModel.generalMembers[index],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 15),
                BTN.fill_gray_100_i_s(
                  onPressed: () async {
                    String removed = widget.teamModel.generalMembers.removeAt(index);
                    widget.teamModel.teamMembers.remove(removed);
                    setState(() {});
                    // 여기서,  user 를 가져와서, user.team 에서 제거해야 한다.
                    UserPropertyModel? user =
                        await CretaAccountManager.getUserPropertyModel(removed);
                    user?.teams.remove(widget.teamModel.mid);
                    CretaAccountManager.userPropertyManagerHolder.setToDB(user!);
                  },
                  icon: Icons.close,
                ),
              ],
            );
          },
        ),
      ),
    ];
  }

  Widget _nvRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: dataStyle),
        ],
      ),
    );
  }

  Future<(bool, String)> checkTeamMember(String email) async {
    /*
    A.  Enterprise Case

      case 1 : 이미 있는 경우
          case 1-1 : 이미 이 엔터프라이즈의 다른 팀원이다.
            1) 그냥 그 USer 의 teams 에 추가해준다.
            2)  team 에 추가되었음을 이메일로 알려준다. 특별히 다른 조치를 취하지 않는다.
          case 1-2 : 개인회원으로 가입되어 있다.
            1) 해당 회원이 개인 회원으로 가입되어 있으므로, 이 이메일로 가입할 수 없다고 경고하고 끝낸다.
          case 1-3 : 이미 다른 엔터프라이즈의 팀원이다.
            1) 다른 엔터프라이즈의 팀원은 데려올 수 없다!!! 경고하고 끝낸다.
        
    
      case 2 :  아직 없는 경우
            1) 만들어 준다.  (user 의 teams 에도 값을 넣어주는 것을 잊지 말자)
            2) verify 이메일을 보낸다.  verify 하면 끝난다.
            3) 최초 로그인시 password 를 바꿀것을 강요한다.

    B.  Private Case

  case 1 : 이미 있는 경우
          case 1-1 : 엔터프라이즈의 팀원이다.
            1) 엔터프라이즈의 팀원은 데려올 수 없다!!! 경고하고 끝낸다.
          case 1-2 : 개인회원으로 가입되어 있다.
            1) 그냥 그 USer 의 teams 에 추가해준다.
            2)  team 에 추가되었음을 이메일로 알려준다. 특별히 다른 조치를 취하지 않는다.
       
    
      case 2 :  아직 없는 경우z
            1) 회원 가입한 경우만 회원으로 추가할 수 있다.

    */

    if (EnterpriseManager.isEnterpriseUser(enterprise: widget.teamModel.enterprise)) {
      // A.  Enterprise Case

      UserPropertyModel? user = await CretaAccountManager.getUserPropertyModel(email);
      if (user != null) {
        // case 1
        if (user.enterprise == widget.teamModel.enterprise) {
          // case 1-1
          user.teams.add(widget.teamModel.mid);
          CretaAccountManager.userPropertyManagerHolder.setToDB(user);
          CretaUtils.sendTeamNotify(
              email, widget.teamModel.name, AccountManager.currentLoginUser.email);
          return (true, '');
        }
        if (user.enterprise.isNotEmpty && user.enterprise == UserPropertyModel.defaultEnterprise) {
          // case 1-2
          String msg = CretaDeviceLang["alreayPrivateMember"] ??
              '이미 개인 회원으로 가입된 email입니다.  개인 회원으로 가입된 email로는 엔터프라이즈 소속 회원이 될 수 없습니다.  이 사람의 다른 email 로 시도하십시오.';
          return (false, msg);
        }
        // case 1-3
        String msg = CretaDeviceLang["alreayAnotherEnterpriseMember"] ??
            '이미 다른 엔터프라이즈의 팀원입니다.  다른 엔터프라이즈의 소속 회원은 중복 가입할 수 없습니다. 이 사람의 다른 email 로 시도하십시오.';
        return (false, msg);
      }
      // case 2
      // 1) 만들어 준다.  (user 의 teams 에도 값을 넣어주는 것을 잊지 말자)
      UserModel userAccount =
          await AccountManager.createAccountByAdmin(email, email); //EnterpriseModel model =

      UserPropertyModel userPropertyModel =
          CretaAccountManager.userPropertyManagerHolder.makeNewUserProperty(
        parentMid: userAccount.userId,
        email: userAccount.email,
        nickname: userAccount.name,
        enterprise: widget.teamModel.enterprise,
        teamMid: widget.teamModel.mid,
        verified: false,
      );

      await CretaAccountManager.userPropertyManagerHolder
          .createUserProperty(createModel: userPropertyModel);

      // 2) verify 이메일을 보낸다.  verify 하면 끝난다.
      CretaUtils.sendVerifyEmail(
          email, AccountManager.currentLoginUser.email, email, userPropertyModel.mid,
          password: userAccount.password);

      return (true, '');
    }

    //  B.  Private Case

    int total = widget.teamModel.generalMembers.length + widget.teamModel.managers.length;
    if (total >= 4) {
      String msg =
          CretaDeviceLang["memberLimitExceed"] ?? '팀원은 4명까지만 추가할 수 있습니다.  더 이상 추가할 수 없습니다.';
      return (false, msg);
    }

    UserPropertyModel? user = await CretaAccountManager.getUserPropertyModel(email);
    if (user != null) {
      // case 1
      if (EnterpriseManager.isEnterpriseUser(enterprise: user.enterprise)) {
        // case 1-1
        String msg = CretaDeviceLang["enterpriseCantbePrivateTeamMember"] ??
            '엔터프라이즈의 팀원입니다.  엔터프라이즈의 소속 회원은 개인회원의 팀에 소속될 수 없습니다. 이 사람의 다른 email 로 시도하십시오.';
        return (false, msg);
      }
      // case 1-2

      user.teams.add(widget.teamModel.mid);
      CretaAccountManager.userPropertyManagerHolder.setToDB(user);
      CretaUtils.sendTeamNotify(
          email, widget.teamModel.name, AccountManager.currentLoginUser.email);
      return (true, '');
    }
    // case 2
    String msg = CretaDeviceLang["notRegisteredMember"] ??
        '아직 회원 가입되지 않은 이메일입니다. 회원 가입을 한 사람만 팀원이 될 수 있습니다.';
    return (false, msg);
  }
}
