import 'dart:math';
import 'dart:typed_data';

import 'package:creta03/data_io/channel_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';
import 'package:creta03/pages/mypage/popup/edit_banner_popup.dart';
import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../data_io/enterprise_manager.dart';
import '../../../lang/creta_device_lang.dart';
import '../../../lang/creta_mypage_lang.dart';
import '../../admin/team_detail_page.dart';

class MyPageTeamManage extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageTeamManage(
      {super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageTeamManage> createState() => _MyPageTeamManageState();
}

class _MyPageTeamManageState extends State<MyPageTeamManage> {
  // late String? selectedTeamMid;
  // late String? selectedChannelMid;
  XFile? _selectedProfileImg;
  Uint8List? _selectedProfileImgBytes;
  XFile? _selectedBannerImg;
  Color replaceColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  //final TextEditingController _teamNameController = TextEditingController();
  bool hasTeam = true;
  late String enterprise;
  bool isEnterprise = false;
  bool hasPermition = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    if (TeamManager.getCurrentTeam == null || CretaAccountManager.getUserProperty == null) {
      hasTeam = false;
    }
    if (TeamManager.getCurrentTeam != null) {
      hasPermition = CretaAccountManager.currentLoginUser.email ==
              TeamManager.getCurrentTeam!.owner ||
          TeamManager.getCurrentTeam!.managers.contains(CretaAccountManager.currentLoginUser.email);

      //   selectedTeamMid = TeamManager.getCurrentTeam!.mid;
      //   selectedChannelMid = TeamManager.getCurrentTeam!.channelId;
    }
    enterprise = CretaAccountManager.getUserProperty?.enterprise ?? '';
    isEnterprise = EnterpriseManager.isEnterpriseUser();
  }

  @override
  Widget build(BuildContext context) {
    // if (UserPropertyManager.getUserProperty == null) {
    //   print('build-------------------------------------------------2');
    //   return const SizedBox.shrink();
    // }
    return Consumer3<UserPropertyManager, TeamManager, ChannelManager>(
      builder: (context, userPropertyManager, teamManager, channelManager, child) {
        if (hasTeam && isEnterprise && teamManager.teamModelList.isEmpty) {
          hasTeam = false;
        }

        if (TeamManager.getCurrentTeam == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: widget.width > 605
                ? Padding(
                    padding: EdgeInsets.only(top: 72, left: widget.width * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _teamHeader(teamManager),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 22, bottom: 32)),
                        hasTeam
                            ? _teamBody(teamManager)
                            : Padding(
                                padding: const EdgeInsets.only(top: 72, left: 100),
                                child: Text(CretaMyPageLang['noTeam'] ?? '소속된 팀이 없습니다.',
                                    style: CretaFont.titleMedium)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _teamHeader(TeamManager teamManager) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(CretaMyPageLang['teamManage']!,
            style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 32),
        CretaWidgetDropDown(
            width: 220,
            items: [
              for (var team in teamManager.teamModelList)
                Text(team.name, style: CretaFont.bodyMedium)
            ],
            defaultValue: 0,
            onSelected: (value) {
              setState(() {
                // 팀이 바뀌는 것에 따라서 currentTeam, currentChannel 모두 바뀌어야함
                replaceColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
                CretaAccountManager.setCurrentTeam(value);
                _initData();
              });
            })
      ],
    );
  }

  Widget _teamBody(TeamManager teamManager) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(CretaMyPageLang['teamInfo']!, style: CretaFont.titleELarge),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang['profileImage']!, style: CretaFont.titleMedium),
                  const SizedBox(height: 220),
                  Text(CretaMyPageLang['teamName']!, style: CretaFont.titleMedium),
                  const SizedBox(height: 32),
                  Text(CretaMyPageLang['ratePlan']!, style: CretaFont.titleMedium)
                ],
              ),
              const SizedBox(width: 76.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyPageCommonWidget.profileImgComponent(
                    width: 200,
                    height: 200,
                    profileImgUrl: TeamManager.getCurrentTeam!.profileImgUrl,
                    profileImgBytes: _selectedProfileImgBytes,
                    userName: teamManager.currentTeam!.name,
                    replaceColor: replaceColor,
                    borderRadius: BorderRadius.circular(20),
                    editBtn: hasPermition
                        ? Center(
                            child: BTN.opacity_gray_i_l(
                                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white)
                                    .icon!,
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
                                            .uploadFile(
                                                _selectedProfileImg!.name,
                                                _selectedProfileImg!.mimeType!,
                                                _selectedProfileImgBytes!)
                                            .then((value) {
                                          if (value != null) {
                                            TeamManager.getCurrentTeam!.profileImgUrl = value.url;
                                            teamManager
                                                .setToDB(CretaAccountManager.getCurrentTeam!);
                                          }
                                        });
                                      });
                                    }
                                  } catch (error) {
                                    logger.info("error at mypage info >> $error");
                                  }
                                }))
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 36),
                  Text(TeamManager.getCurrentTeam!.name, style: CretaFont.titleMedium),
                  const SizedBox(height: 20),
                  isEnterprise
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text('Enterprise Plan', style: CretaFont.titleMedium),
                        )
                      : Row(
                          children: [
                            Text("Team for 4", style: CretaFont.titleMedium),
                            const SizedBox(width: 60),
                            if (hasPermition)
                              BTN.line_blue_t_m(
                                  height: 32,
                                  text: CretaMyPageLang['ratePlanChangeBTN']!,
                                  onPressed: () {
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
          MyPageCommonWidget.divideLine(
              width: widget.width * .6, padding: const EdgeInsets.only(top: 32, bottom: 32)),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(CretaMyPageLang['teamMemberManage']!, style: CretaFont.titleELarge),
                    const SizedBox(width: 40.0),
                    if (isEnterprise == false)
                      Text('${CretaMyPageLang['inviteablePeopleNumber']!} 4',
                          style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400))
                  ],
                ),
                const SizedBox(height: 16),
                for (var member in teamManager.teamMemberMap[teamManager.currentTeam!.mid]!) ...[
                  const SizedBox(height: 16.0),
                  memberComponent(member, teamManager)
                ],
                const SizedBox(height: 32.0),
                if (hasPermition)
                  BTN.fill_blue_t_m(
                      text: CretaMyPageLang['addMemberBTN']!,
                      width: 200,
                      onPressed: () {
                        _editTeam(teamManager: teamManager);
                      })
              ],
            ),
          ),
          MyPageCommonWidget.divideLine(
              width: widget.width * .6, padding: const EdgeInsets.only(top: 32, bottom: 32)),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CretaMyPageLang['teamChannel']! /*"팀 채널"*/, style: CretaFont.titleELarge),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Text(CretaMyPageLang['openChannel']! /*"채널 공개"*/, style: CretaFont.titleMedium),
                    const SizedBox(width: 200),
                    CretaToggleButton(
                      isActive: hasPermition,
                      defaultValue: TeamManager.getCurrentTeam!.isPublicProfile,
                      onSelected: (value) {
                        TeamManager.getCurrentTeam!.isPublicProfile = value;
                        teamManager.setToDB(TeamManager.getCurrentTeam!);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(CretaMyPageLang['openChannelForEverybody']!,
                    style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(CretaMyPageLang['openTeamMember']! /* "팀원 공개" */,
                        style: CretaFont.titleMedium),
                    const SizedBox(width: 200),
                    CretaToggleButton(
                      isActive: hasPermition,
                      defaultValue: TeamManager.getCurrentTeam!.isPublicProfile,
                      onSelected: (value) {
                        TeamManager.getCurrentTeam!.isPublicProfile = value;
                        teamManager.setToDB(TeamManager.getCurrentTeam!);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(CretaMyPageLang['openTeamChannel']!,
                    /* "팀 채널에 팀원의 채널이 공개됩니다.", */
                    style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                const SizedBox(height: 30.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaMyPageLang['backgroundImg']! /*"배경 이미지" */,
                        style: CretaFont.titleMedium),
                    //const SizedBox(width: 50),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: MyPageCommonWidget.channelBannerImgComponent(
                            //width: widget.width * .6,
                            bannerImgUrl: CretaAccountManager.getChannel!.bannerImgUrl,
                            onPressed: () async {
                              if (hasPermition) {
                                try {
                                  _selectedBannerImg =
                                      await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (_selectedBannerImg != null) {
                                    _selectedBannerImg!.readAsBytes().then((fileBytes) {
                                      if (fileBytes.isNotEmpty) {
                                        // popup 호출
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return EditBannerImgPopUp(
                                                  bannerImgBytes: fileBytes,
                                                  selectedImg: _selectedBannerImg!);
                                            });
                                      }
                                    });
                                  }
                                } catch (error) {
                                  logger.info('something wrong in my_page_team_manage >> $error');
                                }
                              }
                            }),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaMyPageLang['introChannel']!,
                        /*"채널 소개",*/ style: CretaFont.titleMedium),
                    //const SizedBox(width: 64),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 64, right: 50),
                        child: MyPageCommonWidget.channelDescriptionComponent(
                            //width: widget.width * .6,
                            ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 120)
        ],
      ),
    );
  }

  Widget memberComponent(UserPropertyModel memberModel, TeamManager teamManager) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: memberModel.profileImgUrl.isEmpty ? replaceColor : null,
              image: memberModel.profileImgUrl.isEmpty
                  ? null
                  : DecorationImage(
                      image: NetworkImage(memberModel.profileImgUrl), fit: BoxFit.cover)),
          child: memberModel.profileImgUrl.isEmpty
              ? Center(
                  child: Text(memberModel.nickname.substring(0, 1),
                      style: CretaFont.bodyESmall.copyWith(color: Colors.white)))
              : null,
        ),
        const SizedBox(width: 14),
        SizedBox(
          width: 240.0,
          child: Text(
            memberModel.email != memberModel.nickname
                ? '${memberModel.nickname}, ${memberModel.email}'
                : memberModel.email,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 50.0),
        SizedBox(
          width: 120.0,
          child: Text(
            TeamManager.isManager(memberModel.email)
                ? CretaMyPageLang['memberAuth'] ?? '관리자 권한'
                : CretaMyPageLang['managerAuth'] ?? '팀원 권한',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const SizedBox(width: 50.0),
        // (hasPermition) && memberModel.email != CretaAccountManager.currentLoginUser.email
        //     ? BTN.line_blue_t_m(
        //         text: CretaMyPageLang['throwBTN'] ?? "내보내기",
        //         onPressed: () {
        //           teamManager.deleteTeamMember(memberModel.email);
        //         })
        //     : const SizedBox.shrink()
      ],
    );
  }

  Future<void> _editTeam({
    required TeamManager teamManager,
    double width = 600,
    double height = 600,
  }) async {
    if (TeamManager.getCurrentTeam == null) return;

    final formKey = GlobalKey<FormState>();
    TeamModel newOne = TeamManager.getCurrentTeam!;
    String title = '${CretaDeviceLang['teamDetail']!}  ${newOne.name}';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: width,
            height: height,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            color: Colors.white,
            child: TeamDetailPage(
              formKey: formKey,
              teamModel: newOne,
              width: width,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    //print('formKey.currentState!.validate()====================');
                    formKey.currentState?.save();
                    newOne.setUpdateTime();
                    teamManager.setToDB(newOne);
                    //managers 에 등록된 user 들에 대해서, user_property model 의 team 정보를 갱신해야 한다.
                    CretaAccountManager.userPropertyManagerHolder
                        .updateTeams(newOne.managers, newOne.name);

                    await teamManager.resetTeamMemberMap(
                        [...newOne.managers, ...newOne.generalMembers],
                        CretaAccountManager.userPropertyManagerHolder);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    setState(() {});
  }
}
