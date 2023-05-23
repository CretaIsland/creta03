import 'dart:math';
import 'dart:typed_data';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/dialog/creta_alert_dialog.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/design_system/menu/creta_drop_down.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/team_model.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

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
  List<Text> teamPermissionList = [];

  // local load image for profile
  XFile? _pickedFile;


  @override
  void initState() {
    super.initState();
    
    for(var element in CretaMyPageLang.teamPermissionList) {
      teamPermissionList.add(Text(element, style: CretaFont.bodyMedium));
    }
    
    if(LoginPage.teamManagerHolder!.teamModelList.isNotEmpty) {
      for (var element in LoginPage.teamManagerHolder!.teamModelList) {
        teamList.add(element.name);
      }
    }
  }

  int checkPermission(String memberId, TeamModel team) {
    if(memberId == team.owner) {
      return 0;
    } else if(team.managers.contains(memberId)) {
      return 1;
    } else {
      return 2;
    }
  }


  Widget divideLine({double leftPadding = 0.0, double topPadding = 0.0, double rightPadding = 0.0, double bottomPadding = 0.0, double width = 10.0, double height = 1.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget profileImageComponent(TeamManager teamManager) {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        image: teamManager.currentTeam!.profileImg == '' ? null : DecorationImage(
          image: Image.network(teamManager.currentTeam!.profileImg).image,
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Stack(
          children: [
            teamManager.currentTeam!.profileImg != '' ? const SizedBox() : 
              Text(
                teamManager.currentTeam!.name.substring(0, 1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: CretaFont.semiBold,
                  fontSize: 64,
                  color: Colors.white
                )
              ),
            BTN.opacity_gray_i_l(
              icon: Icons.photo_camera_outlined, 
              onPressed: () async {
                try {
                  _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(_pickedFile != null) {
                    Uint8List fileBytes = await _pickedFile!.readAsBytes();
                    if(fileBytes.isNotEmpty) {
                      HycopFactory.storage!.uploadFile('profile/${_pickedFile!.name}', _pickedFile!.mimeType!, fileBytes).then((fileModel) {
                        if(fileModel != null) {
                          teamManager.currentTeam!.profileImg = fileModel.fileView;
                          teamManager.setToDB(teamManager.currentTeam!);
                          teamManager.notify();
                        }
                      });
                    }
                    _pickedFile = null;
                  }
                } catch (error) {
                  logger.info('something wrong in my_page_info >> $error');
                }
              }
            ) 
          ],
        ),
      ),
    );
  }

  Widget editBannerImgPopUp(Uint8List bannerImgBytes, TeamManager teamManager) {
    return CretaDialog(
      width: 897.0,
      height: 518.0,
      title: '배경 이미지 설정',
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 865.0,
              height: 375.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: Image.memory(bannerImgBytes).image, fit: BoxFit.cover)
              ),
            ),
          ),
          divideLine(topPadding: 15.0, bottomPadding: 10.0, width: 897.0),
          Padding(
            padding: const EdgeInsets.only(left: 826.0),
            child: BTN.fill_blue_t_m(
              text: '완료', 
              width: 55.0,
              height: 32.0,
              onPressed: () {
                try {
                  if(bannerImgBytes.isNotEmpty) {
                    HycopFactory.storage!.uploadFile('banner/${_pickedFile!.name}', _pickedFile!.mimeType!, bannerImgBytes).then((fileModel) {
                      if(fileModel != null) {
                        teamManager.currentTeam!.channelBannerImg = fileModel.fileView;
                        teamManager.setToDB(teamManager.currentTeam!);
                        teamManager.notify();
                        Navigator.of(context).pop();
                      }
                    });
                  }
                  _pickedFile = null;
                } catch (error) {
                  logger.info('something wrong in my_page_info >> $error');
                }
              }
            )
          )
        ],
      ),
    );
  }

  Widget channelBannerImageComponent(TeamManager teamManager, double width) {
    return Container(
      width: width,
      height: 181.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: CretaColor.primary,
        image: teamManager.currentTeam!.channelBannerImg == '' ? null : DecorationImage(
          image: Image.network(teamManager.currentTeam!.channelBannerImg).image,
          fit: BoxFit.cover
        )
      ),
      child: Container(
        width: 28.0,
        height: 28.0,
        margin: EdgeInsets.only(top: 130.0, left: width * .9),
        child: BTN.opacity_gray_i_s(
          icon: Icons.photo_camera_outlined, 
          onPressed: () async {
            try {
              _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if(_pickedFile != null) {
                _pickedFile!.readAsBytes().then((value) => showDialog(
                  context: context, 
                  builder: (context) => editBannerImgPopUp(value, teamManager)
                ));
              }
            } catch (error) {
              logger.info(error);
            }
          }
        ),
      )
    );
  }

  Widget memberComponent(TeamModel teamModel, UserPropertyModel memberModel, UserPropertyManager userPropertyManager) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: memberModel.profileImg == '' ? Colors.primaries[Random().nextInt(Colors.primaries.length)] : null,
              image: memberModel.profileImg == '' ? null : DecorationImage(
                image: Image.network(memberModel.profileImg).image,
                fit: BoxFit.cover
              )
            ),
            child: memberModel.profileImg == '' ? Center(
              child: Text(
                memberModel.nickname.substring(0, 1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: CretaFont.semiBold,
                  fontSize: 12,
                  color: Colors.white
                ),
              ),
            ) : null,
          ),
          const SizedBox(width: 14.0),
          SizedBox(
            width: 120.0,
            child: Text(
              memberModel.nickname,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 50.0),
          CretaWidgetDropDown(
            items: teamPermissionList, 
            defaultValue:  checkPermission(memberModel.email, teamModel), 
            onSelected: (value) {
              
            }
          ),
          const SizedBox(width: 20.0),
          memberModel.parentMid.value == userPropertyManager.userModel.userId ? const SizedBox() : 
            BTN.line_blue_t_m(text: CretaMyPageLang.throwBTN, onPressed: () {
                  
            }
          ) 
        ],
      ),
    );
  }

  Widget deleteTeamPopUp(TeamManager teamManager) {
    return CretaAlertDialog(
      icon: const Icon(Icons.warning_amber_outlined, size: 32, color: CretaColor.red),
      content: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_outlined, color: CretaColor.red, size: 32.0),
            const SizedBox(height: 12.0),
            Text(
              '정말 삭제하시겠습니까?',
              style: CretaFont.titleMedium,
            ), 
            const SizedBox(height: 11.0),
            Text(
              '팀을 삭제하시는 경우, 팀에 속한 데이터도 모두 삭제됩니다.',
              style: CretaFont.bodySmall,
            ),
          ],
        ),
      ),
      cancelButtonText: '취소',
      okButtonText: '확인',
      onPressedOK: () {},
    );
  }

  Widget addMemberPopUp(TeamManager teamManager) {
    return CretaDialog(
      width: 364.0,
      height: 372.0,
      title: '팀원 추가',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '추가하기',
                    style: CretaFont.titleSmall,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CretaTextField.short(
                      textFieldKey: GlobalKey(),
                      width:  244.0,  
                      value: '', 
                      hintText: '플레이스 홀더',
                      onEditComplete: (value) {}
                    ),
                    const SizedBox(width: 11.0),
                    BTN.line_blue_t_m(
                      text: '초대하기', 
                      onPressed: () {}
                    )
                  ],
                ),
                const SizedBox(height: 19.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '추가된 팀원',
                    style: CretaFont.titleSmall,
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: 333,
                  height: 124,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                )
              ],
            ),
          ),
          divideLine(topPadding: 16.0, bottomPadding: 12.0, width: 364.0),
          Padding(
            padding: const EdgeInsets.only(left: 297.0),
            child: BTN.fill_blue_t_m(
              text: '완료',
              width: 55, 
              onPressed: () => Navigator.of(context).pop()
            ),
          )
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 700 ? Padding(
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
                        defaultValue: teamManager.currentTeam!.name,
                        onSelected: (value) {
                          setState(() {
                            teamManager.selectedTeam(teamManager.teamModelList.indexWhere((element) => element.name == value));
                          });
                        }
                      )
                    ]
                  ),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0, width: widget.width * .7),
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
                                Text(CretaMyPageLang.teamName, style: CretaFont.titleMedium),
                                const SizedBox(height: 32.0),
                                Text('팀 for 4', style: CretaFont.titleMedium)
                              ],
                            ),
                            const SizedBox(width: 95.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileImageComponent(teamManager),
                                const SizedBox(height: 32.0),
                                Text(teamManager.currentTeam!.name),
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
                                defaultValue: teamManager.currentTeam!.isPublicProfile,
                                onSelected: (value) {
                                  teamManager.currentTeam!.isPublicProfile = value;
                                  teamManager.setToDB(teamManager.currentTeam!);
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
                              channelBannerImageComponent(teamManager, widget.width * .53)
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
                            children: [
                              for(var member in teamManager.teamMemberMap[teamManager.currentTeam!.mid]!)...[
                                memberComponent(teamManager.currentTeam!, member, userPropertyManager)
                              ]
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          BTN.fill_blue_t_m(
                            width: 81.0, 
                            text: CretaMyPageLang.addMemberBTN, 
                            onPressed: () => showDialog(context: context, builder: (context) =>  addMemberPopUp(teamManager))
                          )
                        ],
                      ),
                    ),
                    divideLine(topPadding: 32.0, bottomPadding: 32.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Text(
                            CretaMyPageLang.teamExit,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(width: 25),
                          BTN.line_red_t_m(
                            text: CretaMyPageLang.exitBTN,
                            onPressed: () {}
                          ),
                          const SizedBox(width: 80),
                          Text(
                            CretaMyPageLang.deleteTeam,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(width: 25),
                          BTN.fill_red_t_m(
                            text: CretaMyPageLang.deleteTeamBTN, 
                            onPressed: () => showDialog(context: context, builder: (context) => deleteTeamPopUp(teamManager))
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 120.0)
                ]
              ),
            ) : const SizedBox(),
          ),
        );

      },
    );
  }

}