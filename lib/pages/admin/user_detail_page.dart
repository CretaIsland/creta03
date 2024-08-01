//import 'package:creta_common/common/creta_common_utils.dart';

import 'dart:typed_data';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../design_system/buttons/creta_toggle_button.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../lang/creta_device_lang.dart';
import '../mypage/mypage_common_widget.dart';
//import 'book_select_filter.dart';

class UserDetailPage extends StatefulWidget {
  final UserPropertyModel userModel;
  final GlobalKey<FormState> formKey;
  final double width;

  const UserDetailPage({
    super.key,
    required this.userModel,
    required this.formKey,
    required this.width,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  TextEditingController teamTextController = TextEditingController();
  String _message = '';

  XFile? _selectedProfileImg;
  Uint8List? _selectedProfileImgBytes;

  TeamManager? teamManagerHolder;
  bool _onceDBGetComplete = false;

  final double textWidth = 210;

  void _initData() {
    if (widget.userModel.enterprise.isNotEmpty) {
      teamManagerHolder!
          .myDataOnly(
        widget.userModel.enterprise,
        limit: 1000,
      )
          .then((value) {
        // if (value.isNotEmpty) {
        //   teamManagerHolder!.addRealTimeListen(value.first.mid);
        // }
        // print(
        //     'Team length of Enterprise(${widget.userModel.enterprise} = ${value.length}) -----------------------');
      });
    } else {
      _onceDBGetComplete = true;
    }
  }

  @override
  void initState() {
    super.initState();

    teamManagerHolder = TeamManager();
    teamManagerHolder!.configEvent(notifyModify: false);
    teamManagerHolder!.clearAll();

    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    teamTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');
    return MultiProvider(providers: [
      ChangeNotifierProvider<TeamManager>.value(
        value: teamManagerHolder!,
      ),
    ], child: _mainWidget(context));
  }

  Widget _mainWidget(BuildContext context) {
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: teamManagerHolder!,
      consumerFunc: consumerFunc,
      completeFunc: () {
        _onceDBGetComplete = true;
      },
    );

    return retval;
  }

  Widget consumerFunc() {
    logger.finest('consumerFunc');
    _onceDBGetComplete = true;

    return Consumer<TeamManager>(builder: (context, teamManager, child) {
      return _details();
    });
  }

  Widget _details() {
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
                _nvRow('User ID', widget.userModel.email),
                _nvRow('NickName', widget.userModel.nickname),
                _nvRow('Enterprise', widget.userModel.enterprise),
                _nvRow('createTime', widget.userModel.createTime.toString()),
                _nvRow('Grade', widget.userModel.cretaGrade.name),
                _nvRow('Rate Plan', widget.userModel.ratePlan.name),
                _nvRow('Country', widget.userModel.country.name),
                _nvRow('Language', widget.userModel.language.name),
                _nvRow('Job', widget.userModel.job.name),

                _nvRow('FreeSpace', '${widget.userModel.freeSpace} MByte'),
                _nvRow('BookCount', widget.userModel.bookCount.toString()),
                _nvRow('BookViewCount', widget.userModel.bookViewCount.toString()),
                _nvRow('BookViewTime', widget.userModel.bookViewTime.toString()),
                _nvRow('LikeCount', widget.userModel.likeCount.toString()),
                _nvRow('CommentCount', widget.userModel.commentCount.toString()),
                _nvRow('LikeCount', widget.userModel.likeCount.toString()),
                _nvRow('UsePushNotice', widget.userModel.usePushNotice.toString()),
                _nvRow('UseEmailNotice', widget.userModel.useEmailNotice.toString()),
                _nvRow('IsPublicProfile', widget.userModel.isPublicProfile.toString()),

                _nvRow('GenderType', widget.userModel.genderType.name),
                _nvRow('AgreeUsingMarketing', widget.userModel.agreeUsingMarketing.toString()),
                _nvRow('UsingPurpose', widget.userModel.usingPurpose.name),
                _nvRow('BirthYear', widget.userModel.birthYear.toString()),

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
                  child: Text('User Logo image', style: titleStyle),
                ),
                _boolRow('Verified', widget.userModel.verified, true, onChanged: (v) {
                  widget.userModel.verified = v;
                }),
                MyPageCommonWidget.profileImgComponent(
                  width: 200,
                  height: 200,
                  profileImgUrl: widget.userModel.profileImgUrl,
                  profileImgBytes: _selectedProfileImgBytes,
                  userName: widget.userModel.nickname,
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
                                    widget.userModel.profileImgUrl = value.url;
                                  }
                                });
                              });
                            }
                          } catch (error) {
                            logger.severe("error at user image >> $error");
                          }
                        }),
                  ),
                ),
                TextFormField(
                  initialValue: widget.userModel.phoneNumber,
                  decoration: InputDecoration(labelText: 'phoneNumber', labelStyle: titleStyle),
                  onSaved: (value) => widget.userModel.phoneNumber = value ?? '',
                ),
                ..._teams(),
              ],
            ),
          ),
        ],
      ),
    );
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

  List<Widget> _teams() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: teamTextController,
              //initialValue: '',
              decoration: InputDecoration(labelText: 'Add Team name', labelStyle: titleStyle),
              onSaved: (value) {
                // if (value != null && value.isNotEmpty) {
                //   if (!widget.userModel.teams.contains(value)) {
                //     widget.userModel.teams.add(value);
                //   }
                // }
              },
            ),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () async {
              String value = teamTextController.text;
              _message = '';
              if (value.isNotEmpty) {
                TeamModel? teamModel = teamManagerHolder!.findTeamModelByName(value);
                if (teamModel != null) {
                  widget.userModel.teams.add(teamModel.mid);
                  teamModel.addMember(widget.userModel.email);
                  teamManagerHolder!.setToDB(teamModel);
                } else {
                  _message = CretaDeviceLang['noTeamExist'] ?? '존재하지 않는 팀 이름입니다.';
                }
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.red)),
      if (widget.userModel.teams.isNotEmpty)
        Container(
          color: Colors.grey[200],
          height: 200,
          width: widget.width * 0.45,
          child: ListView.builder(
            itemCount: widget.userModel.teams.length,
            itemBuilder: (context, index) {
              TeamModel? teamModel =
                  teamManagerHolder!.findTeamModelByMid(widget.userModel.teams[index]);
              if (teamModel == null) {
                //print('${widget.userModel.teams[index]} not founded -------------------');
                return const SizedBox.shrink();
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      teamModel.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  BTN.fill_gray_100_i_s(
                    onPressed: () {
                      setState(() {
                        TeamModel? teamModel =
                            teamManagerHolder!.findTeamModelByMid(widget.userModel.teams[index]);
                        widget.userModel.teams.removeAt(index);
                        if (teamModel != null) {
                          teamModel.removeMember(widget.userModel.email);
                        }
                      });
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

  Widget _boolRow(String name, bool value, bool isActive, {void Function(bool)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          CretaToggleButton(
            width: 54 * (onChanged == null ? 0.9 : 1.0),
            height: 28 * (onChanged == null ? 0.66 : 1.0),
            defaultValue: value,
            onSelected: (v) {
              onChanged?.call(v);
            },
            isActive: isActive,
          ),
        ],
      ),
    );
  }
}
