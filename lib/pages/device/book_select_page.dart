import 'package:hycop/hycop/absModel/abs_ex_model.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';

import '../../data_io/book_manager.dart';
import '../studio/book_grid_page.dart';

class BookSelectPage extends StatefulWidget {
  final void Function(String bookId, String name)? onSelected;
  final SelectedPage selectedPage;
  final String searchText;

  const BookSelectPage({
    super.key,
    required this.selectedPage,
    this.onSelected,
    required this.searchText,
  });

  @override
  State<BookSelectPage> createState() => _BookSelectPageState();
}

class _BookSelectPageState extends State<BookSelectPage> {
  BookManager? bookManagerHolder;
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();

    //_controller = ScrollController();
    //_controller.addListener(_scrollListener);

    bookManagerHolder = BookManager();
    bookManagerHolder!.configEvent(notifyModify: false);
    bookManagerHolder!.clearAll();

    if (widget.selectedPage == SelectedPage.myPage) {
      bookManagerHolder!
          .myDataOnly(
        AccountManager.currentLoginUser.email,
      )
          .then((value) {
        if (value.isNotEmpty) {
          bookManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    } else if (widget.selectedPage == SelectedPage.sharedPage) {
      bookManagerHolder!
          .sharedData(
        AccountManager.currentLoginUser.email,
      )
          .then((value) {
        if (value.isNotEmpty) {
          bookManagerHolder!.addRealTimeListen(value.first.mid);
        }
      });
    } else if (widget.selectedPage == SelectedPage.teamPage) {
      if (TeamManager.getCurrentTeam == null) {
        logger.warning('CurrentTeam is null}');
      } else {
        logger.fine('CurrentTeam=${TeamManager.getCurrentTeam!.name}');
        bookManagerHolder!.teamData().then((value) {
          if (value.isNotEmpty) {
            bookManagerHolder!.addRealTimeListen(value.first.mid);
          }
        });
      }
    }
    if (widget.searchText.isNotEmpty) {
      bookManagerHolder!.onSearch(widget.searchText, () {});
    }

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_BookGridPageState dispose');
    super.dispose();
    bookManagerHolder?.removeRealTimeListen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookManager>.value(
          value: bookManagerHolder!,
        ),
      ],
      child: _fetchBook(context),
    );
  }

  Widget _fetchBook(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: bookManagerHolder!,
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: consumerFunc,
    );
    _onceDBGetComplete = true;
    return retval;
  }

  Widget consumerFunc(
      /*List<AbsExModel>? data*/
      ) {
    logger.finest('consumerFunc');
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      logger.fine('Consumer  ${bookManager.getLength() + 1}');
      return _listView(bookManager.modelList);
    });
  }

  Widget _listView(List<AbsExModel> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        BookModel book = books[index] as BookModel;
        return ListTile(
          title: Text(book.name.value),
          subtitle: Text(book.description.value),
          trailing: Image.network(book.thumbnailUrl.value), //const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Do something with the selected book
            // For example, you might want to navigate to a detail page for the selected book
            widget.onSelected?.call(book.mid, book.name.value);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
