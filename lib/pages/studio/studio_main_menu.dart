import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';

import '../../design_system/creta_font.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/book_model.dart';
import '../../routes.dart';
import 'book_grid_page.dart';
import 'book_main_page.dart';
import 'containees/containee_nofifier.dart';
import 'left_menu/left_menu_page.dart';

class StudioMainMenu extends StatefulWidget {
  const StudioMainMenu({super.key});

  @override
  State<StudioMainMenu> createState() => _StudioMainMenuState();
}

class _StudioMainMenuState extends State<StudioMainMenu> {
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
          caption: CretaStudioLang.newBook,
          onPressed: () {
            BookModel newBook = BookMainPage.bookManagerHolder!.createSample();
            BookMainPage.bookManagerHolder!.saveSample(newBook).then((value) {
              String url = '${AppRoutes.studioBookMainPage}?${newBook.mid}';
              AppRoutes.launchTab(url);
            });
          }),
      CretaMenuItem(
        // 사본을 만든다.
        caption: CretaLang.makeCopy,
        onPressed: () {
          BookModel? model = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
          if (model == null) {
            return;
          }
          BookMainPage.bookManagerHolder!.makeCopy(model.mid, model, null).then((newOne) {
            BookMainPage.pageManagerHolder!.copyBook(newOne.mid, newOne.mid).then((value) {
              String url = '${AppRoutes.studioBookMainPage}?${newOne.mid}';
              AppRoutes.launchTab(url);
              return null;
            });
          });
        },
      ),
      CretaMenuItem(
        // 목록화면을 오픈다.new
        caption: CretaLang.open,
        onPressed: () {
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
        caption: CretaLang.download,
        onPressed: () {
          logger.fine('download CretaBook !!! in list');
        },
        disabled: true,
      ),
      CretaMenuItem(
        // 출력한다.
        caption: CretaLang.print,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 그리드 보기.
        caption: CretaStudioLang.showGrid,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 눈금자 보기.
        caption: CretaStudioLang.showRuler,
        onPressed: () {},
        disabled: true,
      ),
      CretaMenuItem(
        // 상세정보를 보여준다
        caption: CretaLang.details,
        onPressed: () {
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Book);
          LeftMenuPage.treeInvalidate();
        },
      ),
      CretaMenuItem(
        // 삭제한다.
        caption: CretaLang.delete,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                BookModel? thisOne = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
                if (thisOne == null) return const SizedBox.square();
                return CretaAlertDialog(
                  content: Text(
                    CretaLang.deleteConfirm,
                    style: CretaFont.titleMedium,
                  ),
                  onPressedOK: () async {
                    logger.fine('onPressedOK()');
                    String name = thisOne.name.value;
                    await BookMainPage.bookManagerHolder!
                        .removeBook(thisOne, BookMainPage.pageManagerHolder!);
                    // ignore: use_build_context_synchronously
                    showSnackBar(context, '$name${CretaLang.bookDeleted}');
                    // ignore: use_build_context_synchronously
                    Routemaster.of(context).push(AppRoutes.studioBookGridPage);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                );
              });
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
        icon: Icon(Icons.menu_outlined, size: _isHover ? 24 : 20),
        onPressed: () {
          logger.finest('menu pressed');
          CretaPopupMenu.showMenu(
            width: 150,
            position: const Offset(10, 100),
            context: context,
            popupMenu: _popupMenuList,
            textAlign: Alignment.centerLeft,
            initFunc: () {},
          );
        },
      ),
    );
  }
}
