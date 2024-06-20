import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';

import '../../data_io/host_manager.dart';
import '../../design_system/dialog/creta_alert_dialog.dart';
import '../../design_system/text_field/creta_search_bar.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../model/enterprise_model.dart';
import '../../model/host_model.dart';
import '../../routes.dart';
import '../login/creta_account_manager.dart';

class HostUtil {
  static Future<void> broadCast(
    BuildContext context,
    HostManager hostManagerHolder,
    String publishedBookMid,
    String publishedBookName,
  ) async {
    List<HostModel> selectedHosts = [];
    String message = '';
    //String errMessage = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CretaAlertDialog(
            width: 420,
            height: 600,
            title: CretaStudioLang['selectDevice'] ?? "Select the device you want to broadcast.",
            padding: const EdgeInsets.only(left: 20, right: 20),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            //child: Container(
            content: Container(
              width: 420,
              height: 560,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: HostSelectPage(
                hostManager: hostManagerHolder,
                selectedHosts: selectedHosts,
                onSelected: (hostId, name) {
                  logger.fine('onSelected $hostId, $name');
                },
                //searchText: '',
              ),
            ),
            okButtonText: CretaLang['apply'] ?? 'Apply',

            okButtonWidth: 110,
            onPressedOK: () async {
              //errMessage = '';
              if (selectedHosts.isEmpty) {
                //errMessage = CretaStudioLang['selectDevice'] ?? 'Please select a device.';
                return;
              }

              for (var host in selectedHosts) {
                host.requestedBook1Id = publishedBookMid;
                host.requestedBook1 = publishedBookName;
                host.requestedBook1Time = DateTime.now().toUtc();
                await hostManagerHolder.setToDB(host);
              }
              message = CretaStudioLang['broadcastComplete'] ?? 'Broadcast complete.';
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            onPressedCancel: () {
              //errMessage = '';
              message = '';
              Navigator.of(context).pop();
            },
          );
        });

    if (message.isNotEmpty) {
      await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return CretaAlertDialog(
              width: 420,
              height: 300,
              title: CretaStudioLang['broadcastComplete'] ?? "The broadcast has been applied.",
              padding: const EdgeInsets.only(left: 20, right: 20),
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              //child: Container(
              content: Center(
                  child: Text(
                      CretaDeviceLang['moveToDevice'] ??
                          'Would you like to go to the device management page ?',
                      style: CretaFont.bodyMedium)),
              okButtonText: 'Yes',
              okButtonWidth: 110,
              onPressedOK: () async {
                Navigator.of(context).pop();
                Routemaster.of(context).push(AppRoutes.deviceSharedPage);
              },
              onPressedCancel: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }
}

class HostSelectPage extends StatefulWidget {
  final void Function(String hostId, String name)? onSelected;
  //final String searchText;
  final List<HostModel> selectedHosts;
  final HostManager hostManager;

  const HostSelectPage({
    super.key,
    this.onSelected,
    //required this.searchText,
    required this.selectedHosts,
    required this.hostManager,
  });

  @override
  State<HostSelectPage> createState() => _HostSelectPageState();
}

class _HostSelectPageState extends State<HostSelectPage> {
  //HostManager? hostManagerHolder;
  bool _onceDBGetComplete = false;
  List<AbsExModel> _filteredHosts = []; // List to keep track of selected hosts
  bool isAllSelected = false;

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();

    //_controller = ScrollController();
    //_controller.addListener(_scrollListener);

    // hostManagerHolder = HostManager();
    // widget.hostManager.configEvent(notifyModify: false);
    // widget.hostManager.clearAll();

    String email = AccountManager.currentLoginUser.email;

    EnterpriseModel? enterpriseModel =
        CretaAccountManager.enterpriseManagerHolder.onlyOne() as EnterpriseModel?;

    if (enterpriseModel != null && enterpriseModel.isAdmin(email)) {
      String enterpriseName = enterpriseModel.name;
      widget.hostManager.sharedData(enterpriseName).then((value) {
        if (value.isNotEmpty) {
          _filteredHosts = [...value];
          widget.hostManager.addRealTimeListen(value.first.mid);
        }
      });
    } else {
      widget.hostManager.myDataOnly(email).then((value) {
        if (value.isNotEmpty) {
          _filteredHosts = [...value];
          widget.hostManager.addRealTimeListen(value.first.mid);
        }
      });
    }

    // if (widget.searchText.isNotEmpty) {
    //   widget.hostManager.onSearch(widget.searchText, () {});
    // }

    logger.fine('initState end');
  }

  @override
  void dispose() {
    logger.finest('_HostGridPageState dispose');
    super.dispose();
    widget.hostManager.removeRealTimeListen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HostManager>.value(
          value: widget.hostManager,
        ),
      ],
      child: _fetchHost(context),
    );
  }

  Widget _fetchHost(BuildContext context) {
    // if (sizeListener.isResizing()) {
    //   return consumerFunc(context, null);
    // }
    if (_onceDBGetComplete) {
      return consumerFunc();
    }
    var retval = CretaManager.waitData(
      manager: widget.hostManager,
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
    return Consumer<HostManager>(builder: (context, hostManager, child) {
      logger.fine('Consumer  ${hostManager.getLength() + 1}');
      return _listView(_filteredHosts);
    });
  }

  Widget _listView(List<AbsExModel> hosts) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CretaSearchBar(
          hintText: CretaLang['searchBar']!,
          onSearch: (value) {
            //print('widget.onSearch($value)');
            setState(() {
              _filteredHosts.clear();
              _filteredHosts = widget.hostManager.modelList.where((ele) {
                // 각 호스트의 attribute를 확인하여 "star" 문자열이 포함되어 있는지 검사
                HostModel host = ele as HostModel;
                return host.hostId.contains(value) ||
                    host.description.contains(value) ||
                    host.hostName.contains(value);
              }).toList();
            });
          },
          width: 246,
          height: 32,
        ),
        const Divider(),
        CheckboxListTile(
          title: const Text("Select All"),
          value: isAllSelected,
          onChanged: (bool? value) {
            setState(() {
              isAllSelected = value!;
              if (isAllSelected) {
                for (var host in hosts) {
                  widget.selectedHosts.add(host as HostModel);
                }
              } else {
                widget.selectedHosts.clear();
              }
            });
          },
        ),
        SizedBox(
          height: 344,
          child: hosts.isEmpty
              ? Center(
                  child: Text(CretaStudioLang['noDevcieAvailable']),
                )
              : ListView.builder(
                  itemCount: hosts.length, // + 1, // 헤더를 위해 +1
                  itemBuilder: (context, index) {
                    // if (index == 0) {
                    //   // 헤더
                    //   return CheckboxListTile(
                    //     title: const Text("Select All"),
                    //     value: isAllSelected,
                    //     onChanged: (bool? value) {
                    //       setState(() {
                    //         isAllSelected = value!;
                    //         if (isAllSelected) {
                    //           for (var host in hosts) {
                    //             widget.selectedHosts.add(host as HostModel);
                    //           }
                    //         } else {
                    //           widget.selectedHosts.clear();
                    //         }
                    //       });
                    //     },
                    //   );
                    // }
                    // index -= 1; // 헤더를 고려하여 인덱스 조정

                    HostModel host = hosts[index] as HostModel;
                    return ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(host.hostId),
                          Text(host.description.isEmpty ? host.hostName : host.description),
                        ],
                      ),
                      subtitle: Text(host.creator),
                      trailing: Checkbox(
                        value: widget.selectedHosts.contains(host),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              widget.selectedHosts.add(host);
                            } else {
                              widget.selectedHosts.remove(host);
                            }
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          if (widget.selectedHosts.contains(host) == true) {
                            widget.selectedHosts.remove(host);
                          } else {
                            widget.selectedHosts.add(host);
                          }
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
