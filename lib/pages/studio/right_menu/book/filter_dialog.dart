import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/buttons/creta_checkbox.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../design_system/text_field/creta_text_field.dart';
import '../../../../lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/book_model.dart';
import '../../../../model/filter_model.dart';
import '../../../login_page.dart';
import '../property_mixin.dart';

class FilterDialog extends StatefulWidget {
  final double width;
  final double height;
  final BookModel model;
  final bool isNew;
  final void Function(bool) onComplete;
  const FilterDialog({
    super.key,
    required this.width,
    required this.height,
    required this.model,
    required this.onComplete,
    this.isNew = false,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> with PropertyMixin {
  String _newName = '';
  bool _isNew = false;
  late TextEditingController _textController;
  late TextEditingController _includeController;
  late TextEditingController _excludeController;
  FilterModel? _filter;

  @override
  void initState() {
    super.initState();
    initMixin();
    _isNew = widget.isNew;

    //('model.filter=${widget.model.filter.value}=====$_isNew=========================');

    _filter = BookMainPage.filterManagerHolder!.findFilter(widget.model.filter.value);
    _filter ??= FilterModel(LoginPage.userPropertyManagerHolder!.userModel.email);

    _textController = TextEditingController();
    _includeController = TextEditingController();
    _excludeController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _includeController.dispose();
    _excludeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setName();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SafeArea(
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    // 타이틀
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          CretaStudioLang.editFilterDialog,
                          style: CretaFont.titleMedium,
                        ),
                        BTN.fill_gray_i_m(
                            icon: Icons.close_outlined,
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 22,
                    indent: 0,
                  ),
                ],
              ),
              SizedBox(
                height: widget.height - 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (widget.isNew)
                        CretaCheckbox(
                          //enable: !widget.isNew,
                          valueMap: {
                            CretaStudioLang.newfilter: _isNew,
                          },
                          onSelected: (name, isChecked, valueMap) {
                            setState(() {
                              _isNew = isChecked;
                              if (isChecked) {
                                _newName = '';
                                _filter = FilterModel(
                                    LoginPage.userPropertyManagerHolder!.userModel.email);
                              }
                            });
                          },
                        ),
                      Padding(
                          // 필터 이름
                          padding: const EdgeInsets.only(top: 12, left: 30, right: 30, bottom: 6),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  CretaStudioLang.filterName,
                                  style: titleStyle,
                                ),
                                CretaTextField.long(
                                  defaultBorder: Border.all(color: CretaColor.text[100]!),
                                  height: 28,
                                  width: 210,
                                  maxLines: 1,
                                  textFieldKey: GlobalKey(),
                                  value: _filter!.name,
                                  enabled: _isNew ? true : false,
                                  hintText: '',
                                  controller: _textController,
                                  onEditComplete: ((value) {
                                    _newName = value;
                                    _filter!.name = _newName;
                                  }),
                                ),
                              ])),
                      Padding(
                        // excludes
                        padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              CretaStudioLang.excludeTag,
                              style: titleStyle,
                            ),
                            SizedBox(
                              width: 210,
                              child: tagWidget(
                                controller: _excludeController,
                                hashTagList: _filter!.excludes,
                                onTagChanged: (newValue) {
                                  setState(() {
                                    _filter!.excludes.add(newValue);
                                  });
                                },
                                onSubmitted: (outstandingValue) {
                                  setState(() {
                                    _filter!.excludes.add(outstandingValue);
                                  });
                                },
                                onDeleted: (idx) {
                                  setState(() {
                                    _filter!.excludes.removeAt(idx);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        // includes
                        padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              CretaStudioLang.includeTag,
                              style: titleStyle,
                            ),
                            SizedBox(
                              width: 210,
                              child: tagWidget(
                                controller: _includeController,
                                hashTagList: _filter!.includes,
                                onTagChanged: (newValue) {
                                  setState(() {
                                    _filter!.includes.add(newValue);
                                  });
                                },
                                onSubmitted: (outstandingValue) {
                                  setState(() {
                                    _filter!.includes.add(outstandingValue);
                                  });
                                },
                                onDeleted: (idx) {
                                  setState(() {
                                    _filter!.includes.removeAt(idx);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // 저장과 취소, 삭제 버튼
                padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BTN.fill_blue_t_m(
                      width: 55,
                      text: _isNew ? CretaLang.create : CretaLang.save,
                      onPressed: () async {
                        if (_filter!.excludes.isEmpty) {
                          if (_excludeController.text.isNotEmpty) {
                            _filter!.excludes.add(_excludeController.text);
                          }
                        }
                        if (_filter!.includes.isEmpty) {
                          if (_includeController.text.isNotEmpty) {
                            _filter!.includes.add(_includeController.text);
                          }
                        }

                        if (_isNew) {
                          if (_textController.text.isNotEmpty) {
                            if (BookMainPage.filterManagerHolder!.isDup(_textController.text)) {
                              showSnackBar(context, CretaStudioLang.filterAlreadyExist);
                              return;
                            }
                          }
                          _setName();
                          if (_filter!.name.isEmpty) {
                            showSnackBar(context, CretaStudioLang.filterHasNoName);
                            return;
                          }

                          await BookMainPage.filterManagerHolder!.createNext(
                              filter: _filter!, doNotify: false, onComplete: (undo, value) {});
                        } else {
                          if (_filter!.name.isEmpty) {
                            showSnackBar(context, CretaStudioLang.filterHasNoName);
                            return;
                          }
                          await BookMainPage.filterManagerHolder!
                              .update(filter: _filter!, doNotify: false);
                        }
                        widget.onComplete.call(true);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // if (!_isNew)
                    //   BTN.fill_blue_t_m(
                    //     width: 55,
                    //     text: CretaLang.remove,
                    //     onPressed: () {
                    //       showDialog(
                    //           context: context,
                    //           builder: (context) {
                    //             return CretaAlertDialog(
                    //               height: 140,
                    //               content: Text(
                    //                 CretaLang.deleteConfirm,
                    //                 style: CretaFont.titleMedium,
                    //               ),
                    //               onPressedOK: () async {
                    //                 logger.info('onPressedOK()');
                    //                 BookMainPage.filterManagerHolder!.delete(filter: _filter!);
                    //                 Navigator.of(context).pop();
                    //               },
                    //             );
                    //           });
                    //     },
                    //   ),
                    BTN.fill_blue_t_m(
                      width: 55,
                      text: CretaLang.close,
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setName() {
    if (_isNew && _newName.isEmpty && _textController.text.isNotEmpty) {
      _newName = _textController.text;
      _filter!.name = _newName;
    }
  }
}
