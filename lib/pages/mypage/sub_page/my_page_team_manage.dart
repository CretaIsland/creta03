import 'dart:math';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:image_picker/image_picker.dart';

import '../../../design_system/buttons/creta_toggle_button.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';


class MyPageTeamManage extends StatefulWidget {
  final double width;
  final double height;
  const MyPageTeamManage({super.key, required this.width, required this.height});

  @override
  State<MyPageTeamManage> createState() => _MyPageTeamManageState();
}

class _MyPageTeamManageState extends State<MyPageTeamManage> {

  List<String> teamList = [];
  XFile? _pickedFile;


  @override
  void initState() {
    super.initState();
    if(LoginPage.teamManagerHolder!.teamModelList.isNotEmpty) {
      for (var element in LoginPage.teamManagerHolder!.teamModelList) {
        teamList.add(element.name);
      }
    }
  }


  // 구분선
  Widget divideLine(
      {double leftPadding = 0,
      double topPadding = 0,
      double rightPadding = 0,
      double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding),
      child: Container(
        width: widget.width * .7,
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  // 팀 프로필 이미지 박스
  Widget teamProfileImageBox(TeamManager teamManager, double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: teamManager.nowTeam!.profileImg != '' ? Colors.transparent : Colors.primaries[Random().nextInt(Colors.primaries.length)],
        image: teamManager.nowTeam!.profileImg != '' ? DecorationImage(image: Image.network(teamManager.nowTeam!.profileImg).image, fit: BoxFit.cover) : null
      ),
      child: Stack(
        children: [
          teamManager.nowTeam!.profileImg != '' ? const SizedBox() : 
            Center(
              child: Text(
                teamManager.nowTeam!.name.substring(0, 1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: CretaFont.semiBold,
                  fontSize: 64,
                  color: Colors.white
                )
              )
            ),
          Center(
            child: BTN.opacity_gray_i_l(
              icon: Icons.photo_camera_outlined, 
              onPressed: () async {
                try {
                  _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(_pickedFile != null) {
                    _pickedFile!.readAsBytes().then((fileBytes) {
                      HycopFactory.storage!.uploadFile('profile/${_pickedFile!.name}', _pickedFile!.mimeType.toString(), fileBytes).then((value){
                        setState(() {
                          if(value != null) {
                            teamManager.nowTeam!.profileImg = value.fileView;
                            teamManager.setToDB(teamManager.nowTeam!);
                          } else {
                            logger.info("upload error");
                          }
                        });
                      });
                      _pickedFile = null;
                    });
                  }
                } catch (error) {
                  logger.info(error);
                }
              }
            ),
          )
        ],
      ),
    );
  }

  // 팀 채널 배너 이미지 박스
  Widget channelBannerImageBox(TeamManager teamManager, double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: CretaColor.primary,
        image: teamManager.nowTeam!.channelBannerImg != '' ? DecorationImage(image: Image.network(teamManager.nowTeam!.channelBannerImg).image, fit: BoxFit.cover) : null
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 130.0, right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BTN.opacity_gray_i_l(
                  icon: Icons.photo_camera_outlined, 
                  onPressed: () async {
                    try {
                      _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(_pickedFile != null) {
                        _pickedFile!.readAsBytes().then((fileBytes) {
                          HycopFactory.storage!.uploadFile('banner /${_pickedFile!.name}', _pickedFile!.mimeType.toString(), fileBytes).then((value){
                            setState(() {
                              if(value != null) {
                                teamManager.nowTeam!.channelBannerImg = value.fileView;
                                teamManager.setToDB(teamManager.nowTeam!);
                              } else {
                                logger.info("upload error");
                              }
                            });
                          });
                          _pickedFile = null;
                        });
                      }
                    } catch (error) {
                      logger.info(error);
                    }
                  }
                ),
                const SizedBox(width: 8.0),
                BTN.opacity_gray_i_l(
                  icon: Icons.edit, 
                  onPressed: () async { }
                ),
              ]
            ),
          )
        ],
      ),
    );
  }


  List<Widget> memberComponent(TeamManager teamManager, UserPropertyManager userPropertyManager, List<UserPropertyModel> members, double width, double height, double radius) {
    List<Widget> memberComponents = [];

    for (var member in members) {
      memberComponents.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: member.profileImg != '' ? Colors.transparent : Colors.primaries[Random().nextInt(Colors.primaries.length)],
                  image: member.profileImg != '' ? DecorationImage(image: Image.network(member.profileImg).image, fit: BoxFit.cover) : null
                ),
                child: member.profileImg != '' ? null : 
                  Center(
                    child: Text(
                      member.nickname.substring(0, 1),
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: CretaFont.semiBold,
                        fontSize: 12,
                        color: Colors.white
                      )
                    ),
                  ),
              ),
              const SizedBox(width: 14.0),
              Text(member.nickname),
              const SizedBox(width: 190.0),
              member.parentMid.value == userPropertyManager.userModel.userId ? const SizedBox() : 
                BTN.line_blue_t_m(text: CretaMyPageLang.throwBTN, onPressed: () {
                  
                })
            ],
          ),
        )
      );  
    }

    return memberComponents;
  }

  Widget mainComponent() {
    return Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 400 ? 
              Padding(
                padding: const EdgeInsets.only(left: 165.0, top: 72.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                         CretaMyPageLang.teamManage
                        ),
                        const SizedBox(width: 32.0),
                        CretaDropDown.large(
                          items: teamList,
                          defaultValue: teamManager.nowTeam!.name,
                          onSelected: (value) {
                            setState(() {
                              teamManager.selectedTeam(teamManager.teamModelList.indexWhere((element) => element.name == value));
                            });
                          }
                        )
                      ]
                    ),
                    divideLine(topPadding: 22.0, bottomPadding: 32.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CretaMyPageLang.teamInfo,
                            style: CretaFont.titleELarge
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(CretaMyPageLang.profileImage, style: CretaFont.titleMedium),
                                  const SizedBox(height: 215.0),
                                  Text(CretaMyPageLang.nickname, style: CretaFont.titleMedium),
                                  const SizedBox(height: 32.0),
                                  Text('팀 for 4', style: CretaFont.titleMedium)
                                ],
                              ),
                              const SizedBox(width: 95.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  teamProfileImageBox(teamManager, 200.0, 200.0, 20.0),
                                  const SizedBox(height: 32.0),
                                  Text(teamManager.nowTeam!.name),
                                  const SizedBox(height: 28.0),
                                  BTN.line_blue_t_m(
                                    text: CretaMyPageLang.ratePlanChangeBTN, 
                                    onPressed: () {}
                                  )
                                ]
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    divideLine(topPadding: 32.0, bottomPadding: 32.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CretaMyPageLang.teamChannel, style: CretaFont.titleELarge),
                          const SizedBox(height: 32.0),
                          Row(
                            children: [
                              Text(CretaMyPageLang.publicProfile, style: CretaFont.titleMedium),
                              const SizedBox(width: 199.0),
                              CretaToggleButton(
                                defaultValue: teamManager.nowTeam!.isPublicProfile,
                                onSelected: (value) {
                                  teamManager.nowTeam!.isPublicProfile = value;
                                  teamManager.setToDB(teamManager.nowTeam!);
                                }
                              )
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Text(CretaMyPageLang.profileTip, style: CretaFont.bodySmall),
                          const SizedBox(height: 23.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(CretaMyPageLang.backgroundImgSetting,
                                style: CretaFont.titleMedium),
                              const SizedBox(width: 24.0),
                              channelBannerImageBox(teamManager, 865.0, 180, 20.0)
                            ]
                          )
                        ],
                      ), 
                    ),
                    divideLine(topPadding: 32.0, bottomPadding: 32.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                CretaMyPageLang.teamMemberManage, 
                                style: CretaFont.titleELarge
                              ),
                              const SizedBox(width: 40.0),
                              Text(
                                '${CretaMyPageLang.inviteablePeopleNumber} 2/4',
                                style: CretaFont.bodySmall
                              )
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: memberComponent(teamManager, userPropertyManager, teamManager.teamMemberMap[teamManager.nowTeam!.mid]!, 24.0, 24.0, 20),
                          ),
                          const SizedBox(height: 32.0),
                          BTN.fill_blue_t_m(
                            width: 81.0, 
                            text: CretaMyPageLang.addMemberBTN, 
                            onPressed: () {}
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 120.0)
                  ],
                ),
              ) : Container()
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}
