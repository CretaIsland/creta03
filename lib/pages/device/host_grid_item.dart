// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../data_io/host_manager.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_elibated_button.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/host_model.dart';
import '../studio/studio_constant.dart';
import 'device_main_page.dart';

class HostGridItem extends StatefulWidget {
  final int index;
  final HostModel? hostModel;
  final double width;
  final double height;
  final HostManager hostManager;
  final GlobalKey<HostGridItemState> itemKey;
  final DeviceSelectedPage selectedPage;
  final void Function(HostModel? hostModel) onClick;

  const HostGridItem({
    required this.itemKey,
    required this.hostManager,
    required this.index,
    this.hostModel,
    required this.width,
    required this.height,
    required this.selectedPage,
    required this.onClick,
  }) : super(key: itemKey);

  @override
  HostGridItemState createState() => HostGridItemState();
}

class HostGridItemState extends State<HostGridItem> {
  late List<CretaMenuItem> _popupMenuList;
  bool mouseOver = false;
  int counter = 0;
  final Random random = Random();
  bool dropDownButtonOpened = false;
  int defaultThumbnailNumber = 100;
  double aWidth = 0;
  double aHeight = 0;
  final double borderWidth = 6.0;

  @override
  void initState() {
    super.initState();

    defaultThumbnailNumber = random.nextInt(1000);

    _popupMenuList = [
      CretaMenuItem(
        caption: CretaLang.play,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: CretaLang.edit,
        onPressed: () {
          //openHost(AppRoutes.deviceDetailPage);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _eachItem();
  }

  Widget _eachItem() {
    aWidth = widget.width - (borderWidth * 2);
    aHeight = widget.height - (borderWidth * 2);

    //double margin = mouseOver ? 0 : LayoutConst.hostThumbSpacing / 2;
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
            border: widget.hostModel != null
                ? Border.all(
                    color: widget.hostModel!.isConnected ? Colors.yellow : Colors.grey,
                    width: borderWidth,
                  )
                : null,
          ),
          clipBehavior: Clip.antiAlias, // crop method
          child: (widget.hostModel == null && widget.index < 0) ? _drawInsertButton() : _drawhost()
          // : widget.hostManager.getLength() <= widget.index && widget.hostManager.isNotEnd()
          //     ? _drawCount()
          //     : _drawhost(),
          ),
    );
  }

  // Widget _drawCount() {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     color: CretaColor.text[100]!.withOpacity(0.2),
  //     child: Center(
  //       child: Text(
  //         '${widget.hostManager.getLength()} \nCreta host founded \n Press this button to more ...',
  //         style: CretaFont.bodyLarge,
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

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
      caption: CretaDeviceLang.newHost,
      captionStyle: CretaFont.bodyMedium,
      radius: 20.0,
      onPressed: insertItem,
      icon: const Icon(
        Icons.add_outlined,
        size: 96,
        color: CretaColor.primary,
      ),
    );
  }

  Widget _drawhost() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0 - borderWidth),
                topRight: Radius.circular(20.0 - borderWidth)),
            child: Stack(
              children: [
                _thumnailArea(),
                _controllArea(),
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
    );
  }

  void openHost(String route) {
    //Get.offAllNamed("${AppRoutes.deviceDetailPage}?${CretaManager.hostPrefix}${widget.hostModel!.hostName}");
    //Routemaster.of(context).push('$route?${widget.hostModel!.mid}');
    //studiohostPreviewPage
  }

  Widget _controllArea() {
    bool readOnly = false;

    //String url = '${AppRoutes.deviceDetailPage}?${widget.hostModel!.mid}';
    double controllAreaHeight = aHeight - LayoutConst.bookDescriptionHeight;

    //print('hostItemHeight = $aHeight');
    //print('controllAreaHeight = $controllAreaHeight');

    if (mouseOver) {
      return InkWell(
        onTap: () async {
          //openHost(AppRoutes.deviceDetailPage);
          widget.onClick.call(widget.hostModel);
        },
        onDoubleTap: () {
          // if (readOnly == false) {
          //   logger.finest('${widget.hostModel!.hostName} double clicked');
          //   AppRoutes.launchTab(url);
          // }
        },
        child: Container(
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
                  Icon(
                    widget.hostModel!.isValidLicense ? Icons.label : Icons.label_off,
                    color: Colors.white,
                    size: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      widget.hostModel!.isValidLicense
                          ? CretaDeviceLang.licensed
                          : CretaDeviceLang.unLicensed,
                      overflow: TextOverflow.fade,
                      style: CretaFont.buttonSmall.copyWith(color: Colors.white),
                    ),
                  ),
                  Icon(
                    widget.hostModel!.isUsed ? Icons.circle_outlined : Icons.close_outlined,
                    color: Colors.white,
                    size: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      widget.hostModel!.isUsed ? CretaDeviceLang.used : CretaDeviceLang.unUsed,
                      overflow: TextOverflow.fade,
                      style: CretaFont.buttonSmall.copyWith(color: Colors.white),
                    ),
                  ),
                  if (readOnly == false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: BTN.opacity_gray_i_s(
                        icon: Icons.delete_outline,
                        onPressed: () {
                          logger.finest('delete pressed');
                          CretaPopup.yesNoDialog(
                            context: context,
                            title: CretaLang.deleteConfirmTitle,
                            icon: Icons.file_download_outlined,
                            question: CretaLang.deleteConfirm,
                            noBtText: CretaStudioLang.noBtDnText,
                            yesBtText: CretaStudioLang.yesBtDnText,
                            yesIsDefault: true,
                            onNo: () {
                              //Navigator.of(context).pop();
                            },
                            onYes: () {
                              logger.fine('onPressedOK(${widget.hostModel!.hostName})');

                              _removeItem(widget.hostModel).then((value) {
                                if (value == null) return null;
                                if (widget.hostManager.isShort(offset: 1)) {
                                  widget.hostManager.reGet(AccountManager.currentLoginUser.email,
                                      onModelFiltered: () {
                                    widget.hostManager.notify();
                                    logger.fine('removeItem complete');
                                    return value;
                                  });
                                }
                                // ignore: use_build_context_synchronously

                                return value;
                              });
                              // ignore: use_build_context_synchronously
                              //Navigator.of(context).pop();
                            },
                          );
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return CretaAlertDialog(
                          //         height: 200,
                          //         title: CretaLang.deleteConfirmTitle,
                          //         content: Text(
                          //           CretaLang.deleteConfirm,
                          //           style: CretaFont.titleMedium,
                          //         ),
                          //         onPressedOK: () async {
                          //           logger
                          //               .fine('onPressedOK(${widget.hostModel!.hostName})');

                          //           _removeItem(widget.hostModel).then((value) {
                          //             if (value == null) return null;
                          //             if (widget.hostManager.isShort(offset: 1)) {
                          //               widget.hostManager
                          //                   .reGet(AccountManager.currentLoginUser.email,
                          //                       onModelFiltered: () {
                          //                 widget.hostManager.notify();
                          //                 logger.fine('removeItem complete');
                          //                 return value;
                          //               });
                          //             }
                          //             // ignore: use_build_context_synchronously

                          //             return value;
                          //           });
                          //           // ignore: use_build_context_synchronously
                          //           Navigator.of(context).pop();
                          //         },
                          //       );
                          //     });
                        },
                        tooltip: CretaStudioLang.tooltipDelete,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: BTN.opacity_gray_i_s(
                      icon: Icons.menu_outlined,
                      onPressed: () {
                        logger.finest('menu pressed');
                        setState(() {
                          CretaPopupMenu.showMenu(
                              context: context,
                              globalKey: widget.itemKey,
                              popupMenu: _popupMenuList,
                              initFunc: () {
                                dropDownButtonOpened = true;
                              }).then((value) {
                            logger.finest('팝업메뉴 닫기');
                            setState(() {
                              dropDownButtonOpened = false;
                            });
                          });
                          dropDownButtonOpened = !dropDownButtonOpened;
                        });
                      },
                      tooltip: CretaStudioLang.tooltipMenu,
                    ),
                  ),
                ],
              ),
              if (aHeight > 186)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                  child: Container(
                    color: Colors.transparent,
                    height: 16,
                    child: Text(
                      widget.hostModel!.description,
                      overflow: TextOverflow.ellipsis,
                      style: CretaFont.bodyESmall.copyWith(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget _thumnailArea() {
    int randomNumber = random.nextInt(1000);
    int duration = widget.index == 0 ? 500 : 500 + randomNumber;
    String url = widget.hostModel!.thumbnailUrl;
    if (url.isEmpty) {
      url = 'https://picsum.photos/200/?random=$defaultThumbnailNumber';
    }
    logger.fine('_thumnailArea ${widget.hostModel!.hostName} = <$url>');
    try {
      return SizedBox(
          width: aWidth,
          height: aHeight - LayoutConst.bookDescriptionHeight,
          child: CustomImage(
              key: UniqueKey(),
              hasMouseOverEffect: true,
              duration: duration,
              width: aWidth,
              height: aHeight,
              image: url));
    } catch (err) {
      logger.warning('CustomeImage failed $err');
      return SizedBox.shrink();
    }
  }

  Widget _bottomArea() {
    return Container(
      //width: aWidth,
      height: LayoutConst.bookDescriptionHeight,
      color: (mouseOver) ? Colors.grey[100] : Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                    color: (mouseOver) ? Colors.grey[100] : Colors.white,
                    child: Snippet.TooltipWrapper(
                      tooltip: widget.hostModel!.hostName,
                      fgColor: Colors.black,
                      bgColor: CretaColor.text[200]!,
                      child: Text(
                        widget.hostModel!.hostName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: CretaFont.bodyMedium,
                      ),
                    )),
              ),
              widget.selectedPage != DeviceSelectedPage.myPage
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        color: (mouseOver) ? Colors.grey[100] : Colors.white,
                        child: Text(
                          widget.hostModel!.hostId,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: CretaFont.buttonMedium,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Container(
            color: (mouseOver) ? Colors.grey[100] : Colors.white,
            child: Text(
              CretaCommonUtils.dateToDurationString(widget.hostModel!.updateTime),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: CretaFont.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  void insertItem() async {
    // int randomNumber = random.nextInt(1000);
    // int modelIdx = randomNumber % 10;
    // HostModel host = HostModel.withName(
    //   '${CretaStudioLang.newhost}_$randomNumber',
    //   creator: AccountManager.currentLoginUser.email,
    //   creatorName: AccountManager.currentLoginUser.name,
    //   imageUrl: 'https://picsum.photos/200/?random=$modelIdx',
    //   viewCount: randomNumber,
    //   likeCount: 1000 - randomNumber,
    //   hostTypeVal: hostType.fromInt(randomNumber % 4 + 1),
    //   ownerList: const [],
    //   readerList: const [],
    //   writerList: const [],
    //   desc: SampleData.sampleDesc[randomNumber % SampleData.sampleDesc.length],
    // );

    // host.hashTag.set('#${randomNumber}tag');

    // await widget.hostManager.createToDB(host);
    // widget.hostManager.insert(host);

    String hostId = '';
    String hostName = '';
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(CretaDeviceLang.inputHostInfo),
          content: SizedBox(
            height: 200,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) => hostId = value,
                      decoration: InputDecoration(hintText: CretaDeviceLang.deviceId),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CretaDeviceLang.shouldInputDeviceId;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) => hostName = value,
                      decoration: InputDecoration(hintText: CretaDeviceLang.deviceName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CretaDeviceLang.shouldInputDeviceName;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                hostId = '';
                hostName = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (hostId.isEmpty || hostName.isEmpty) {
      return;
    }

    HostModel host = widget.hostManager.createSample(hostId, hostName);
    await widget.hostManager.createNewHost(host);
    //StudioVariables.selectedhostMid = host.mid;
    // ignore: use_build_context_synchronously
    //Routemaster.of(context).push('${AppRoutes.deviceDetailPage}?${host.mid}');
    widget.hostManager.notify();
  }

  Future<HostModel?> _removeItem(HostModel? removedItem) async {
    if (removedItem != null) {
      //await widget.hostManager.removeChildren(removedItem);
      removedItem.isRemoved.set(true, save: false, noUndo: true);
      await widget.hostManager.setToDB(removedItem);
      widget.hostManager.remove(removedItem);
    }
    return removedItem;
  }
}
