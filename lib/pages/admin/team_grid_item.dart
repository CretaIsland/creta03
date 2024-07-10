// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

//import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hycop/common/util/logger.dart';

//import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../login/creta_account_manager.dart';
import '../studio/studio_constant.dart';

class TeamGridItem extends StatefulWidget {
  final int index;
  final TeamModel? teamModel;
  final double width;
  final double height;
  final TeamManager teamManager;
  //final GlobalKey<TeamGridItemState> itemKey;
  final void Function(TeamModel? teamModel) onEdit;
  //final void Function(TeamModel? teamModel) onTap;
  final void Function() onInsert;
  //final bool isSelected;

  const TeamGridItem({
    super.key,
    //required this.itemKey,
    required this.teamManager,
    required this.index,
    this.teamModel,
    required this.width,
    required this.height,
    required this.onEdit,
    //required this.onTap,
    required this.onInsert,
    //required this.isSelected,
  });

  @override
  TeamGridItemState createState() => TeamGridItemState();
}

class TeamGridItemState extends State<TeamGridItem> {
  //List<CretaMenuItem> _popupMenuList = [];
  bool mouseOver = false;
  int counter = 0;
  final Random random = Random();
  bool dropDownButtonOpened = false;
  int defaultThumbnailNumber = 100;
  double aWidth = 0;
  double aHeight = 0;
  final double borderWidth = 6.0;

  void notify(String mid) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    defaultThumbnailNumber = random.nextInt(1000);

    // _popupMenuList = [
    //   CretaMenuItem(
    //     caption: CretaLang['edit']!,
    //     onPressed: () {
    //       widget.onEdit.call(widget.teamModel);
    //     },
    //   ),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return _eachItem();
  }

  Widget _eachItem() {
    aWidth = widget.width - (borderWidth * 2);
    aHeight = widget.height - (borderWidth * 2);

    //double margin = mouseOver ? 0 : LayoutConst.teamThumbSpacing / 2;
    //double margin = 0;

    // if (mouseOver) {
    //   aWidth = widget.width + 10;
    //   aHeight = widget.height + 10;
    // } else {
    //   aWidth = widget.width;
    //   aHeight = widget.height;
    // }

    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
          //logger.finest('mouse over');
        });
      },
      onHover: (event) {
        //logger.finest('onHover');
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          width: aWidth,
          height: aHeight,
          decoration: BoxDecoration(
            //boxShadow: mouseOver ? StudioSnippet.basicShadow(offset: 4) : null,
            borderRadius: BorderRadius.circular(20.0),
            border: widget.teamModel != null
                ? Border.all(
                    //color: widget.isSelected ? Colors.yellow : Colors.grey.withOpacity(0.1),
                    color: Colors.grey.withOpacity(0.1),
                    width: borderWidth,
                  )
                : null,
          ),
          clipBehavior: Clip.antiAlias, // crop method
          child:
              (widget.teamModel == null && widget.index < 0) ? _drawInsertButton() : _drawteam()),
    );
  }

  Widget _drawInsertButton() {
    return CretaElevatedButton(
      isVertical: true,
      height: aHeight,
      bgHoverColor: CretaColor.text[100]!,
      bgHoverSelectedColor: CretaColor.text[100]!,
      bgSelectedColor: CretaColor.text[100]!,
      bgColor: CretaColor.text[100]!,
      fgColor: CretaColor.primary[300]!,
      fgSelectedColor: CretaColor.primary,
      caption: CretaDeviceLang['newTeam']!,
      captionStyle: CretaFont.bodyMedium,
      radius: 20.0,
      onPressed: widget.onInsert,
      icon: const Icon(
        Icons.add_outlined,
        size: 96,
        color: CretaColor.primary,
      ),
    );
  }

  Widget _drawteam() {
    return InkWell(
      // onDoubleTap: () {
      //   widget.onEdit.call(widget.teamModel);
      // },
      onTap: () {
        //widget.onTap.call(widget.teamModel);
        widget.onEdit.call(widget.teamModel);
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0 - borderWidth),
                  topRight: Radius.circular(20.0 - borderWidth)),
              child: Stack(
                children: [
                  _thumbnailArea(),
                  _controllArea(),
                  //if (widget.teamModel != null && selectNotifierHolder.isSelected(widget.teamModel!.mid))
                  // Positioned(
                  //   top: 4,
                  //   left: 4,
                  //   child: Container(
                  //     //padding: EdgeInsets.all(2), // Adjust padding as needed
                  //     decoration: BoxDecoration(
                  //       // border: Border.all(
                  //       //   color: Colors.white, // Change border color as needed
                  //       //   width: 2, // Change border width as needed
                  //       // ),
                  //       shape: BoxShape.circle,
                  //       color: Colors.white.withOpacity(0.5),
                  //     ),
                  //     child: Icon(
                  //       Icons.check_outlined,
                  //       size: 42,
                  //       color: Colors.red,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0 - borderWidth),
                    bottomRight: Radius.circular(20.0 - borderWidth)),
                child: _bottomArea()),
          ],
        ),
      ),
    );
  }

  Widget _controllArea() {
    //String url = '${AppRoutes.deviceDetailPage}?${widget.hostModel!.mid}';
    double controllAreaHeight = aHeight - LayoutConst.bookDescriptionHeight;

    //print('hostItemHeight = $aHeight');
    //print('controllAreaHeight = $controllAreaHeight');

    if (mouseOver) {
      return Container(
        padding: const EdgeInsets.only(top: 8.0, right: 8),
        alignment: AlignmentDirectional.topEnd,
        decoration: mouseOver
            ? Snippet.gradationShadowDeco()
            : BoxDecoration(
                color: Colors.transparent,
              ),
        //width: aWidth,
        height: controllAreaHeight, //aHeight - LayoutConst.hostDescriptionHeight,
        //color: CretaColor.text[200]!.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: BTN.opacity_gray_i_s(
                    icon: Icons.delete_outline,
                    onPressed: () async {
                      logger.finest('delete pressed');

                      // 팀을 지우려면
                      // 1) 소속 멤버의 teams 에서 해당 탬을 지워야 함
                      // 3) 팀을 지워야 함
                      if (widget.teamModel == null) {
                        return;
                      }
                      if (widget.teamManager.isCurrentTeam(widget.teamModel!)) {
                        showSnackBar(
                            context,
                            CretaDeviceLang['currentTeamCantDelete'] ??
                                'Current team can not be deleted');
                        return;
                      }

                      List<UserPropertyModel> users = await teamWillbeDeleted(widget.teamModel!);
                      // if (users.isEmpty) {
                      //   showSnackBar(
                      //       // ignore: use_build_context_synchronously
                      //       context,
                      //       CretaDeviceLang['onlyChild'] ??
                      //           'There is a user whose only team is this team.  In this case, you must first delete the user and then delete the team.');
                      //   return;
                      // }

                      CretaPopup.yesNoDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        title: CretaLang['deleteConfirmTitle']!,
                        icon: Icons.warning_amber_outlined,
                        question: CretaLang['deleteConfirm']!,
                        noBtText: CretaStudioLang['noBtDnText']!,
                        yesBtText: CretaStudioLang['yesBtDnText']!,
                        yesIsDefault: true,
                        onNo: () {
                          //Navigator.of(context).pop();
                        },
                        onYes: () async {
                          for (var user in users) {
                            user.teams.remove(widget.teamModel!.mid);
                            await CretaAccountManager.userPropertyManagerHolder.setToDB(user);
                          }
                          widget.teamManager.deleteTeam(widget.teamModel!);
                        },
                      );
                    },
                    tooltip: CretaStudioLang['tooltipDelete']!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: BTN.opacity_gray_i_s(
                    icon: Icons.edit_outlined,
                    onPressed: () {
                      logger.finest('edit pressed');
                      widget.onEdit.call(widget.teamModel);
                    },
                    tooltip: CretaStudioLang['tooltipEdit'] ?? 'Edit',
                  ),
                ),
              ],
            ),
          ],
        ),
        //),
      );
    }
    return Container();
  }

  Future<List<UserPropertyModel>> teamWillbeDeleted(TeamModel team) async {
    List<UserPropertyModel> retval = [];
    for (var element in widget.teamModel!.teamMembers) {
      UserPropertyModel? user = await CretaAccountManager.getUserPropertyModel(element);
      if (user != null) {
        // // 1) 소속 멤버의 teams 에서 해당 탬을 지워야 함
        // // 2) 그런데, 만약 어느 User 가 소속한 유일한 팀이 이팀이라면  User 를 먼저 삭제하라고 해야함
        // if (user.teams.length == 1 && user.teams[0] == team.mid) {
        //   return [];
        // }
        retval.add(user);
      }
    }
    return retval;
  }

  Widget _thumbnailArea() {
    int randomNumber = random.nextInt(1000);
    int duration = widget.index == 0 ? 500 : 500 + randomNumber;
    String url = '';

    if (widget.teamModel == null || widget.teamModel!.profileImgUrl.isEmpty) {
      url = 'https://picsum.photos/200/?random=$defaultThumbnailNumber';
    } else {
      url = widget.teamModel!.profileImgUrl;
    }

    try {
      return SizedBox(
          width: aWidth,
          height: aHeight - LayoutConst.bookDescriptionHeight,
          child: CustomImage(
              key: UniqueKey(),
              hasMouseOverEffect: true,
              duration: duration,
              width: aWidth,
              height: aHeight - LayoutConst.bookDescriptionHeight,
              image: url));
    } catch (err) {
      logger.warning('CustomeImage failed $err');
      return SizedBox.shrink();
    }
  }

  Widget _bottomArea() {
    String firstAdmin = widget.teamModel!.owner.isEmpty ? 'no owner' : widget.teamModel!.owner;
    return Container(
      //width: aWidth,
      height: LayoutConst.bookDescriptionHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
                color: Colors.white,
                child: Snippet.TooltipWrapper(
                  tooltip: widget.teamModel!.name,
                  fgColor: Colors.black,
                  bgColor: CretaColor.text[200]!,
                  child: Text(
                    widget.teamModel!.name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: CretaFont.bodyLarge,
                    maxLines: 1,
                  ),
                )),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Snippet.TooltipWrapper(
                tooltip: firstAdmin,
                fgColor: Colors.black,
                bgColor: CretaColor.text[200]!,
                child: Text(
                  //CretaCommonUtils.dateToDurationString(widget.teamModel!.updateTime),
                  firstAdmin,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: CretaFont.buttonMedium,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
