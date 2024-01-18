import 'dart:math';
import 'dart:typed_data';

import 'package:creta03/data_io/channel_manager.dart';
import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/model/team_model.dart';
import 'package:creta03/model/user_property_model.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';
import 'package:creta03/pages/mypage/popup/edit_banner_popup.dart';
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

  String? selectedTeamMid = CretaAccountManager.getCurrentTeam!.mid;
  String? selectedChannelMid = CretaAccountManager.getCurrentTeam!.channelId;
  XFile? _selectedProfileImg;
  Uint8List? _selectedProfileImgBytes;
  XFile? _selectedBannerImg;
  Color replaceColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  final TextEditingController _teamNameController = TextEditingController();


  int checkPermission(String memberId, TeamModel team) {
    if (memberId == team.owner) {
      return 0;
    } else if (team.managers.contains(memberId)) {
      return 1;
    } else {
      return 2;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer3<UserPropertyManager, TeamManager, ChannelManager>(
      builder: (context, userPropertyManager, teamManager, channelManager, child) {
        _teamNameController.text = CretaAccountManager.getCurrentTeam!.name;
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: widget.width > 700 ? Padding(
              padding: const EdgeInsets.only(top: 72, left: 165),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("팀 관리", style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 32),
                      CretaWidgetDropDown(
                        width: 140,
                        items: [
                          for(var team in teamManager.teamModelList)
                            Text(team.name, style: CretaFont.bodyMedium)
                        ], 
                        defaultValue: 0, 
                        onSelected: (value) {
                          setState(() {
                            // 팀이 바뀌는 것에 따라서 currentTeam, currentChannel 모두 바뀌어야함
                            replaceColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                          });
                        }
                      )
                    ],
                  ),
                  MyPageCommonWidget.divideLine(width: widget.width * .6, padding: const EdgeInsets.only(top: 22, bottom: 32)),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("팀 정보", style: CretaFont.titleELarge),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("사진", style: CretaFont.titleMedium),
                                const SizedBox(height: 220),
                                Text("팀 이름", style: CretaFont.titleMedium),
                                const SizedBox(height: 32),
                                Text("요금제", style: CretaFont.titleMedium)
                              ],
                            ),
                            const SizedBox(width: 76.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyPageCommonWidget.profileImgComponent(
                                  width: 200, 
                                  height: 200, 
                                  profileImgUrl: CretaAccountManager.getCurrentTeam!.profileImgUrl,
                                  profileImgBytes: _selectedProfileImgBytes,
                                  userName: teamManager.currentTeam!.name,
                                  replaceColor: replaceColor,
                                  borderRadius: BorderRadius.circular(20),
                                  editBtn: Center(
                                    child: BTN.opacity_gray_i_l(
                                      icon: const Icon(Icons.camera_alt_outlined, color: Colors.white).icon!, 
                                      onPressed: () async {
                                        try {
                                          _selectedProfileImg = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          if(_selectedProfileImg != null) {
                                            _selectedProfileImg!.readAsBytes().then((value) {
                                              setState(() {
                                                _selectedProfileImgBytes = value;
                                              });
                                              HycopFactory.storage!.uploadFile(_selectedProfileImg!.name, _selectedProfileImg!.mimeType!, _selectedProfileImgBytes!).then((value) {
                                                if(value != null) {
                                                  CretaAccountManager.getCurrentTeam!.profileImgUrl = value.url;
                                                  teamManager.setToDB(CretaAccountManager.getCurrentTeam!);
                                                }
                                              });
                                            });
                                          }
                                        } catch (error) {
                                          logger.info("error at mypage info >> $error");
                                        }
                                      }
                                    ),
                                  )
                                ),
                                const SizedBox(height: 38),
                                SizedBox(
                                  width: 200,
                                  height: 20,
                                  child: TextField(
                                    controller: _teamNameController, 
                                    style: CretaFont.bodyMedium,
                                    decoration: const InputDecoration(
                                      hintText: '팀 이름을 입력해주세요',
                                      border: InputBorder.none,
                                    ),
                                    onEditingComplete: () { },
                                  )
                                ),
                                const SizedBox(height: 26),
                                Row(
                                  children: [
                                    Text("팀 for 4", style: CretaFont.titleMedium),
                                    const SizedBox(width: 60),
                                    BTN.line_blue_t_m(height: 32, text: "요금제 변경", onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => PopUpRatePlan.ratePlanPopUp(context),
                                      );
                                    })
                                  ],
                                )
                                
                              ],
                            )
                          ],
                        ),
                        MyPageCommonWidget.divideLine(width: widget.width * .6, padding: const EdgeInsets.only(top: 32, bottom: 32)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("팀원 관리", style: CretaFont.titleELarge),
                                  const SizedBox(width: 40.0),
                                  Text('초대 가능 인원 1 / 4', style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400))
                                ],
                              ),
                              const SizedBox(height: 16),
                              for (var member in teamManager.teamMemberMap[teamManager.currentTeam!.mid]!) ...[
                                const SizedBox(height: 16.0),
                                memberComponent(member, teamManager)
                              ],
                              const SizedBox(height: 32.0),
                              BTN.fill_blue_t_m(text: "팀원 추가", width: 81.0, onPressed: () {})
                            ],
                          ),
                        ),
                        MyPageCommonWidget.divideLine(width: widget.width * .6, padding: const EdgeInsets.only(top: 32, bottom: 32)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("팀 채널", style: CretaFont.titleELarge),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Text("채널 공개", style: CretaFont.titleMedium),
                                  const SizedBox(width: 200),
                                  CretaToggleButton(
                                    defaultValue: CretaAccountManager.getCurrentTeam!.isPublicProfile,
                                    onSelected: (value) {
                                      CretaAccountManager.getCurrentTeam!.isPublicProfile = value;
                                      teamManager.setToDB(CretaAccountManager.getCurrentTeam!);
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text("모든 사람들에게 채널이 공개됩니다.", style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text("팀원 공개", style: CretaFont.titleMedium),
                                  const SizedBox(width: 200),
                                  CretaToggleButton(
                                    defaultValue: CretaAccountManager.getCurrentTeam!.isPublicProfile,
                                    onSelected: (value) {
                                      CretaAccountManager.getCurrentTeam!.isPublicProfile = value;
                                      teamManager.setToDB(CretaAccountManager.getCurrentTeam!);
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text("팀 채널에 팀원의 채널이 공개됩니다.", style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                              const SizedBox(height: 30.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("배경 이미지", style: CretaFont.titleMedium),
                                  const SizedBox(width: 50),
                                  MyPageCommonWidget.channelBannerImgComponent(
                                    width: widget.width * .6, 
                                    bannerImgUrl: CretaAccountManager.getChannel!.bannerImgUrl,
                                    onPressed: () async {
                                      try {
                                        _selectedBannerImg = await ImagePicker().pickImage(source: ImageSource.gallery);
                                        if (_selectedBannerImg != null) {
                                          _selectedBannerImg!.readAsBytes().then((fileBytes) {
                                            if (fileBytes.isNotEmpty) {
                                            // popup 호출
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return EditBannerImgPopUp(bannerImgBytes: fileBytes, selectedImg: _selectedBannerImg!);
                                                }
                                              );
                                            }
                                          });
                                        }
                                      } catch (error) {
                                        logger.info('something wrong in my_page_team_manage >> $error');
                                      }
                                    }
                                  )
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("채널 소개", style: CretaFont.titleMedium),
                                  const SizedBox(width: 64),
                                  MyPageCommonWidget.channelDescriptionComponent(width: widget.width * .6)
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 120)
                      ],
                    ),
                  )
                ],
              ),
            ) : const SizedBox.shrink(),
          ),
        );
      },
    );
  }



  Widget memberComponent(UserPropertyModel memberModel, TeamManager teamManager) {
    int permission = checkPermission(CretaAccountManager.currentLoginUser.email, CretaAccountManager.getCurrentTeam!);
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: memberModel.profileImgUrl.isEmpty ? replaceColor : null,
            image: memberModel.profileImgUrl.isEmpty? null : DecorationImage(image: NetworkImage(memberModel.profileImgUrl), fit: BoxFit.cover)
          ),
          child: memberModel.profileImgUrl.isEmpty ? Center(
            child: Text(memberModel.nickname.substring(0, 1), style: CretaFont.bodyESmall.copyWith(color: Colors.white))
          ) : null, 
        ),
        const SizedBox(width: 14),
        SizedBox(
          width: 120.0,
          child: Text(
            memberModel.nickname,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 50.0),
        (permission == 0 || permission == 1) && memberModel.email != CretaAccountManager.currentLoginUser.email  ? BTN.line_blue_t_m(
          text: "내보내기", 
          onPressed: () {
            teamManager.deleteTeamMember(memberModel.email, checkPermission(memberModel.email, CretaAccountManager.getCurrentTeam!));
          }
        ) : const SizedBox.shrink()
      ],
    );
  }


}