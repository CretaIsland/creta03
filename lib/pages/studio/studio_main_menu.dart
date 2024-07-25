import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';

import 'package:creta_common/common/creta_vars.dart';
import '../../data_io/book_manager.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../routes.dart';
import 'book_grid_page.dart';
import 'book_main_page.dart';
import 'containees/containee_nofifier.dart';
import 'left_menu/left_menu_page.dart';
import 'studio_variables.dart';

class StudioMainMenu extends StatefulWidget {
  //final Function onPressed;

  const StudioMainMenu({
    super.key, //required this.onPressed,
  });

  @override
  State<StudioMainMenu> createState() => _StudioMainMenuState();

  static void downloadDialog(BuildContext context) {
    CretaPopup.yesNoDialog(
      context: context,
      title: "${CretaStudioLang['export']!}      ",
      icon: Icons.file_download_outlined,
      question: CretaStudioLang['downloadConfirm']!,
      noBtText: CretaVars.instance.isDeveloper
          ? CretaStudioLang['noBtDnTextDeloper']!
          : CretaStudioLang['noBtDnText']!,
      yesBtText: CretaStudioLang['yesBtDnText']!,
      yesIsDefault: true,
      onNo: () {
        if (CretaVars.instance.isDeveloper) {
          BookMainPage.bookManagerHolder?.download(context, BookMainPage.pageManagerHolder, false);
        }
      },
      onYes: () {
        BookMainPage.bookManagerHolder?.download(context, BookMainPage.pageManagerHolder, true);
      },
    );
  }
}

class _StudioMainMenuState extends State<StudioMainMenu> {
  // ignore: unused_field
  late List<CretaMenuItem> _popupMenuList;
  bool _isHover = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    _popupMenuList = [
      CretaMenuItem(
          // 새로운 북을 만든다.
          caption: CretaStudioLang['newBook']!,
          onPressed: () {
            BookModel newBook = BookMainPage.bookManagerHolder!.createSample();
            BookMainPage.bookManagerHolder!.saveSample(newBook).then((value) {
              String url = '${AppRoutes.studioBookMainPage}?${newBook.mid}';
              AppRoutes.launchTab(url);
            });
          }),
      CretaMenuItem(
        // 사본을 만든다.
        caption: CretaLang['makeCopy']!,
        onPressed: () {
          BookModel? model = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
          if (model == null) {
            return;
          }
          BookManager.newbBackgroundMusicFrame = '';
          BookMainPage.bookManagerHolder!.makeCopy(model.mid, model, null).then((newOne) {
            BookMainPage.pageManagerHolder!.copyBook(newOne.mid, newOne.mid).then((value) {
              String url = '${AppRoutes.studioBookMainPage}?${newOne.mid}';
              if (BookManager.newbBackgroundMusicFrame.isNotEmpty) {
                //  백그라운드 뮤직을 복사한다.
                (newOne as BookModel)
                    .backgroundMusicFrame
                    .set(BookManager.newbBackgroundMusicFrame, save: false);
                BookMainPage.bookManagerHolder!.setToDB(newOne);
              }
              AppRoutes.launchTab(url);
              return null;
            });
          });
        },
      ),
      CretaMenuItem(
        // 목록화면을 오픈다.new
        caption: CretaLang['open']!,
        onPressed: () {
          StudioVariables.selectedBookMid = '';
          //Routemaster.of(context).pop();
          if (BookGridPage.lastGridMenu != null) {
            Routemaster.of(context).push(BookGridPage.lastGridMenu!);
          } else {
            Routemaster.of(context).push(AppRoutes.studioBookGridPage);
          }
        },
      ),
      CretaMenuItem(
        // 다운로드 한다.
        caption: CretaLang['download']!,
        onPressed: () {
          logger.fine('download CretaBook !!! in list');
          StudioMainMenu.downloadDialog(context);
        },
      ),
      CretaMenuItem(
        // 출력한다.
        caption: CretaLang['printCommand']!,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 그리드 보기.
        caption: CretaStudioLang['showGrid']!,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 눈금자 보기.
        caption: CretaStudioLang['showRuler']!,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 상세정보를 보여준다
        caption: CretaLang['details']!,
        onPressed: () {
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Book);
          LeftMenuPage.treeInvalidate();
        },
      ),
      CretaMenuItem(
        // 삭제한다.
        caption: CretaLang['delete']!,
        onPressed: () {
          BookModel? thisOne = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
          if (thisOne == null) return;
          CretaPopup.yesNoDialog(
            context: context,
            title: CretaLang['deleteConfirmTitle']!,
            icon: Icons.file_download_outlined,
            question: CretaLang['deleteConfirm']!,
            noBtText: CretaStudioLang['noBtDnText']!,
            yesBtText: CretaStudioLang['yesBtDnText']!,
            yesIsDefault: true,
            onNo: () {},
            onYes: () async {
              logger.fine('onPressedOK()');
              String name = thisOne.name.value;
              await BookMainPage.bookManagerHolder!
                  .removeBook(thisOne, BookMainPage.pageManagerHolder!);
              // ignore: use_build_context_synchronously
              showSnackBar(context, '$name${CretaLang['bookDeleted']!}');
              // ignore: use_build_context_synchronously
              Routemaster.of(context).push(AppRoutes.studioBookGridPage);
              // ignore: use_build_context_synchronously
            },
          );

          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       BookModel? thisOne = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
          //       if (thisOne == null) return const SizedBox.square();
          //       return CretaAlertDialog(
          //         height: 200,
          //         title: CretaLang['deleteConfirmTitle']!,
          //         content: Text(
          //           CretaLang['deleteConfirm']!,
          //           style: CretaFont.titleMedium,
          //         ),
          //         onPressedOK: () async {
          //           logger.fine('onPressedOK()');
          //           String name = thisOne.name.value;
          //           await BookMainPage.bookManagerHolder!
          //               .removeBook(thisOne, BookMainPage.pageManagerHolder!);
          //           // ignore: use_build_context_synchronously
          //           showSnackBar(context, '$name${CretaLang['bookDeleted']!}');
          //           // ignore: use_build_context_synchronously
          //           Routemaster.of(context).push(AppRoutes.studioBookGridPage);
          //           // ignore: use_build_context_synchronously
          //           Navigator.of(context).pop();
          //         },
          //       );
          //     });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (value) {
        _isHover = true;
        setState(() {});
      },
      onExit: (value) {
        _isHover = false;
        setState(() {});
      },
      child: IconButton(
        icon: Icon(
          Icons.menu_outlined,
          //Icons.keyboard_double_arrow_right_outlined,
          size: _isHover ? 24 : 20,
        ),
        onPressed: () {
          //widget.onPressed();
          Snippet.studioScaffoldKey.currentState?.openDrawer();

          // if (AccountManager.currentLoginUser.isLoginedUser == false) {
          //   BookMainPage.warningNeedToLogin(context);
          //   return;
          // }

          // logger.finest('menu pressed');
          // CretaPopupMenu.showMenu(
          //   width: 150,
          //   position: const Offset(10, 100),
          //   context: context,
          //   popupMenu: _popupMenuList,
          //   textAlign: Alignment.centerLeft,
          //   initFunc: () {},
          // );
        },
      ),
    );
  }
}
