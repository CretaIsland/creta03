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
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/team_model.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MyPageTeamManage extends StatefulWidget {

  final double width;
  final double height;
  final Color replaceColor;
  const MyPageTeamManage({super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageTeamManage> createState() => _MyPageTeamManageState();
}

class _MyPageTeamManageState extends State<MyPageTeamManage> {

  // load local image file for profile, banner
  XFile? _pickedFile;
  List<String> teamList = [];
  List<Text> teamPermissionList = [];
  final TextEditingController scopeController = TextEditingController();


  int checkPermission(String memberId, TeamModel team) {
    if(memberId == team.owner) {
      return 0;
    } else if(team.managers.contains(memberId)) {
      return 1;
    } else {
      return 2;
    }
  }

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
        border: Border.all(color: Colors.grey.shade200),
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
                  logger.info('something wrong in my_page_team_manage >> $error');
                }
              }
            ) 
          ],
        ),
      ),
    );
  }

  Widget bannerImageComponent(TeamManager teamManager) {
    return Container(
      width: widget.width * .6,
      height: 181.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0),
        color: CretaColor.primary.shade200,
        image: teamManager.currentTeam!.channelBannerImg == '' ? null : DecorationImage(
          image: Image.network(teamManager.currentTeam!.channelBannerImg).image,
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Stack(
          children: [
            teamManager.currentTeam!.channelBannerImg != '' ? const SizedBox() : 
              Text(
                '선택된 배경 이미지가 없습니다.',
                style: CretaFont.bodySmall
              ),
            Container(
              margin: EdgeInsets.only(top: 110, left: widget.width * .6 - 68.0),
              child: BTN.opacity_gray_i_l(
                icon: Icons.photo_camera_outlined, 
                onPressed: () async {
                  try {
                    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(_pickedFile != null) {
                      _pickedFile!.readAsBytes().then((fileBytes) {
                        if(fileBytes.isNotEmpty) {
                          // popup 호출
                          showDialog(
                            context: context, 
                            builder: (context) => editBannerImgPopUp(fileBytes, teamManager),
                          );
                        }
                      });
                    }
                  } catch (error) {
                    logger.info('something wrong in my_page_team_manage >> $error');
                  }
                }
              ),
            ) 
          ],
        ),
      ),
    );
  }

  Widget memberComponent(UserPropertyModel memberData, TeamManager teamManager, UserPropertyManager userPropertyManager) {
    return Row(
      children: [
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: memberData.profileImg == '' ?  Colors.primaries[Random().nextInt(Colors.primaries.length)] : null,
            image: memberData.profileImg != '' ? DecorationImage(image: Image.network(memberData.profileImg).image, fit: BoxFit.cover) : null
          ),
          child: memberData.profileImg != '' ? null : Center(
            child: Text(
              memberData.nickname.toString().substring(0, 1),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 12,
                color: Colors.white
              )
            ),
          ),
        ),
        const SizedBox(width: 14.0),
        SizedBox(
          width: 120.0,
          child: Text(
            memberData.nickname,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 50.0),
        // ignore: unrelated_type_equality_checks
        checkPermission(memberData.email, teamManager.currentTeam!) == 2 ? IgnorePointer(
          ignoring: true,
          child: CretaWidgetDropDown(
            items: teamPermissionList, 
            defaultValue: checkPermission(memberData.email, teamManager.currentTeam!), 
            onSelected: (value) { }
          ),
        ) : CretaWidgetDropDown(
          items: teamPermissionList, 
          defaultValue: checkPermission(memberData.email, teamManager.currentTeam!), 
          onSelected: (value) {
            teamManager.changePermission(memberData.email, checkPermission(memberData.email, teamManager.currentTeam!), value);
          }
        ),
        const SizedBox(width: 20.0),
        checkPermission(userPropertyManager.userPropertyModel!.email, teamManager.currentTeam!) == 2 ||  memberData.email == userPropertyManager.userPropertyModel!.email ? const SizedBox() :
        BTN.line_blue_t_m(
          text: '내보내기', 
          onPressed: () {
            teamManager.deleteTeamMember(memberData.email, checkPermission(memberData.email, teamManager.currentTeam!));
            teamManager.notify();
          }
        )
      ],
    );
  }


  // popup screen
  Widget editBannerImgPopUp(Uint8List bannerImgBytes, TeamManager teamManager) {
    return CretaDialog(
      width: 897,
      height: 518,
      title: '배경 이미지 설정',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 865,
            height: 375,
            margin: const EdgeInsets.only(top: 20.0, left: 16.0),
            decoration: BoxDecoration(
              image: DecorationImage(image: Image.memory(bannerImgBytes).image, fit: BoxFit.cover)
            ),
          ),
          divideLine(topPadding: 10.0, bottomPadding: 10.0, width: 897),
          Padding(
            padding: const EdgeInsets.only(left: 826.0),
            child: BTN.fill_blue_t_m(
              text: '완료', 
              width: 55,
              onPressed: () {
                HycopFactory.storage!.uploadFile('banner/${_pickedFile!.name}', _pickedFile!.mimeType!, bannerImgBytes).then((fileModel) {
                  if(fileModel != null) {
                    teamManager.currentTeam!.channelBannerImg = fileModel.fileView;
                    teamManager.setToDB(teamManager.currentTeam!);
                    teamManager.notify();
                    Navigator.of(context).pop();
                  }
                });
              }
            ),
          )
        ],
      )
    );
  }

  Widget addMemberPopUp(TeamManager teamManager, UserPropertyManager userPropertyManager) {
    return ChangeNotifierProvider.value(
           value: teamManager,
           child: Consumer<TeamManager>(
            builder: (context, model, child) {
              return CretaDialog(
                width: 364,
                height: 372,
                title: '팀원 추가',
                content: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 13),
                        child: Text(
                          '추가하기',
                          style: CretaFont.titleSmall,
                        ),
                      ),
                      Row(
                        children: [
                          CretaTextField.short(
                            textFieldKey: GlobalKey(), 
                            value: '', 
                            hintText: '',
                            width: 244,
                            height: 30,
                            controller: scopeController,
                            onEditComplete: (value) { }
                          ),
                          const SizedBox(width: 11),
                          BTN.line_blue_t_m(
                            text: '초대하기', 
                            width: 50,
                            height: 32,
                            onPressed: () async {
                              UserPropertyModel? newMember = await userPropertyManager.emailToModel(scopeController.text);
                              if(newMember != null) {
                                teamManager.addTeamMember(newMember.email);
                                newMember.teams.add(teamManager.currentTeam!.mid);
                                userPropertyManager.setToDB(newMember);
                              }
                            }
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 19, left: 8),
                        child: Text(
                          '추가된 팀원',
                          style: CretaFont.titleSmall,
                        ),
                      ),
                      Container(
                        width: 333,
                        height: 124,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for(var member in teamManager.teamMemberMap[teamManager.currentTeam!.mid]!)...[
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: member.profileImg == '' ? Colors.primaries[Random().nextInt(Colors.primaries.length)] : Colors.white,
                                        image: member.profileImg != '' ? DecorationImage(image: Image.network(member.profileImg).image, fit: BoxFit.cover ) : null
                                      ),
                                      child: member.profileImg =='' ? Center(
                                        child: Text(
                                          member.nickname.substring(0, 1),
                                          style: const TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 8,
                                            color: Colors.white
                                          ),
                                        ),
                                      ) : null, 
                                    ),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: 120.0,
                                      child: Text(
                                        member.nickname,
                                        style: CretaFont.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 20)
                                    ],
                                  ),
                                const SizedBox(height: 16.0)
                              ]
                            ],
                          ),
                        ),
                      ),
                      divideLine(topPadding: 16, bottomPadding: 12, width: 364),
                      Padding(
                        padding: const EdgeInsets.only(left: 277.0),
                        child: BTN.fill_blue_t_m(
                          text: '완료', 
                          width: 55,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      )
                    ],
                  ),
                )
              );
            }
           )
       );
    
  }







  @override
  Widget build(BuildContext context) {
    return LoginPage.teamManagerHolder!.teamModelList.isEmpty ? const SizedBox.shrink() : 
    Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: widget.width > 700 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CretaMyPageLang.teamManage,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: CretaFont.semiBold,
                          fontSize: 40,
                          color: CretaColor.text
                        )
                      ),
                      const SizedBox(width: 32.0),
                      CretaWidgetDropDown(
                        items: [for(var team in teamManager.teamModelList) Text(team.name, style: CretaFont.bodyMedium)], 
                        defaultValue: 0, 
                        width: 140.0,
                        onSelected: (value) {}
                      )
                    ],
                  ),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.teamInfo,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 31.0),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CretaMyPageLang.profileImage,
                                  style: CretaFont.titleMedium,
                                ),
                                const SizedBox(height: 220.0),
                                Text(
                                  CretaMyPageLang.teamName,
                                  style: CretaFont.titleMedium,
                                ),
                                const SizedBox(height: 32.0),
                                Text(
                                  '팀 for 4',
                                  //CretaMyPageLang.ratePlan,
                                  style: CretaFont.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(width: 76.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileImageComponent(teamManager),
                                const SizedBox(height: 39.0),
                                Text(
                                  teamManager.currentTeam!.name,
                                  style: CretaFont.bodyMedium,
                                ),
                                const SizedBox(height: 28.0),
                                BTN.line_blue_t_m(
                                  text: CretaMyPageLang.ratePlanChangeBTN, 
                                  width: 92.0,
                                  height: 32.0,
                                  onPressed: () {
                                    showDialog(
                                      context: context, 
                                      builder: (context) => PopUpRatePlan.ratePlanPopUp(context),
                                    );
                                  }
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  divideLine(topPadding: 32.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.teamChannel,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Text(
                              CretaMyPageLang.publicProfile,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 199.0),
                            CretaToggleButton(
                              defaultValue: teamManager.currentTeam!.isPublicProfile,
                              onSelected: (value) {}
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          CretaMyPageLang.profileTip,
                          style: CretaFont.bodySmall
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.backgroundImg,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 49.0),
                            // bannerBox
                            bannerImageComponent(teamManager)
                          ],
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 32.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CretaMyPageLang.teamMemberManage,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 40.0),
                            Text(
                              '초대 가능 인원 2 / 4',
                              style: CretaFont.bodySmall,
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        for(var member in teamManager.teamMemberMap[teamManager.currentTeam!.mid]!)...[
                          const SizedBox(height: 16.0),
                          memberComponent(member, teamManager, userPropertyManager)
                        ],
                        const SizedBox(height: 32.0),
                        BTN.fill_blue_t_m(
                          text: '팀원 추가', 
                          width: 81.0,
                          onPressed: () {
                            showDialog(context: context, builder: (context) => addMemberPopUp(teamManager, userPropertyManager));
                          }
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 32.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Text(
                          '팀에서 나가기',
                          style: CretaFont.titleMedium,
                        ),
                        const SizedBox(width: 25.0),
                        BTN.line_red_t_m(
                          text: '나가기', 
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return CretaAlertDialog
                                (
                                  width: 387,
                                  height: 308,
                                  content: Container(
                                    width: 30,
                                    height: 30,
                                    color: Colors.red,
                                  ), 
                                  onPressedOK: () {}
                                );
                              },
                            );
                          }
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 120.0)
                ],
              ),
            ) : const SizedBox(),
          ),
        );
      },
    );
  }
}