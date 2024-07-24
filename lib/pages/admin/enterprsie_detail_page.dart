//import 'package:creta_common/common/creta_common_utils.dart';

import 'dart:typed_data';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../lang/creta_device_lang.dart';
import '../../model/enterprise_model.dart';
import '../login/creta_account_manager.dart';
import '../mypage/mypage_common_widget.dart';
//import 'book_select_filter.dart';

class EnterpriseDetailPage extends StatefulWidget {
  final EnterpriseModel enterpriseModel;
  final GlobalKey<FormState> formKey;
  final double width;

  const EnterpriseDetailPage({
    super.key,
    required this.enterpriseModel,
    required this.formKey,
    required this.width,
  });

  @override
  State<EnterpriseDetailPage> createState() => _EnterpriseDetailPageState();
}

class _EnterpriseDetailPageState extends State<EnterpriseDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  TextEditingController adminEmailTextController = TextEditingController();

  String _message = '';

  Uint8List? _selectedImgBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    adminEmailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    // double width = screenSize.width * 0.5;
    // double height = screenSize.height * 0.5;

    return
        // Container(
        //   width: width,
        //   height: height,
        //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        //   color: Colors.white,
        //   child:
        Form(
      key: widget.formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: widget.width * 0.45,
            child: ListView(
              children: <Widget>[
                _nvRow('Enterprise ID', widget.enterpriseModel.name),
                ..._admin(),

                TextFormField(
                  initialValue: widget.enterpriseModel.description,
                  decoration: InputDecoration(labelText: 'Description', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.description = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.enterpriseUrl,
                  decoration: InputDecoration(labelText: 'Enterprise Url', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.enterpriseUrl = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.openAiKey,
                  decoration: InputDecoration(labelText: 'openAiKey', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.openAiKey = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.socketUrl,
                  decoration: InputDecoration(labelText: 'socketUrl', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.socketUrl = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.mediaApiUrl,
                  decoration: InputDecoration(labelText: 'mediaApiUrl', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.mediaApiUrl = value ?? '',
                ),

                TextFormField(
                  initialValue: widget.enterpriseModel.webrtcUrl.toString(),
                  decoration: InputDecoration(labelText: 'webrtcUrl', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.webrtcUrl = value ?? '',
                ),

                // Add more widgets for the second column here
              ],
            ),
          ),
          SizedBox(
            width: widget.width * 0.45,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Enterprise Logo image', style: titleStyle),
                ),
                MyPageCommonWidget.profileImgComponent(
                    width: 200,
                    height: 200,
                    profileImgUrl: widget.enterpriseModel.imageUrl,
                    profileImgBytes: _selectedImgBytes,
                    userName: widget.enterpriseModel.name,
                    replaceColor: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(20),
                    editBtn: Center(
                      child: BTN.opacity_gray_i_l(
                          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white).icon!,
                          onPressed: () async {
                            try {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null) {
                                PlatformFile selectedFile = result.files.first;
                                Uint8List? fileBytes = selectedFile.bytes;
                                String fileName = selectedFile.name;
                                String? mimeType = selectedFile.extension;

                                FileModel? value = await HycopFactory.storage!
                                    .uploadFile(fileName, mimeType!, fileBytes!);
                                if (value != null) {
                                  widget.enterpriseModel.imageUrl = value.url;
                                  //print('upload complete !!!  ${widget.enterpriseModel.imageUrl}');
                                }
                                setState(() {});
                              }
                            } catch (error) {
                              logger.severe("error at enterprise image >> $error");
                            }

                            // try {
                            //   XFile? selectedImg =
                            //       await ImagePicker().pickImage(source: ImageSource.gallery);
                            //   if (selectedImg != null) {
                            //     _selectedImgBytes = await selectedImg.readAsBytes();
                            //     FileModel? value = await HycopFactory.storage!.uploadFile(
                            //         selectedImg.name, selectedImg.mimeType!, _selectedImgBytes!);
                            //     if (value != null) {
                            //       widget.enterpriseModel.imageUrl = value.url;
                            //       print('uplodad complete !!!  ${widget.enterpriseModel.imageUrl}');
                            //     }
                            //     setState(() {});
                            //   }
                            // } catch (error) {
                            //   logger.severe("error at enterprise image >> $error");
                            // }
                          }),
                    )),

                TextFormField(
                  initialValue: widget.enterpriseModel.openWeatherApiKey,
                  decoration:
                      InputDecoration(labelText: 'openWeatherApiKey', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.openWeatherApiKey = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.giphyApiKey.toString(),
                  decoration: InputDecoration(labelText: 'giphyApiKey', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.giphyApiKey = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.newsApiKey,
                  decoration: InputDecoration(labelText: 'newsApiKey', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.newsApiKey = value ?? '',
                ),
                TextFormField(
                  initialValue: widget.enterpriseModel.dailyWordApi,
                  decoration: InputDecoration(labelText: 'dailyWordApi', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.dailyWordApi = value ?? '',
                ),

                TextFormField(
                  initialValue: widget.enterpriseModel.currencyXchangeApi.toString(),
                  decoration:
                      InputDecoration(labelText: 'currencyXchangeApi', labelStyle: titleStyle),
                  onSaved: (value) => widget.enterpriseModel.currencyXchangeApi = value ?? '',
                ),

                // Add more widgets for the second column here
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _admin() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: adminEmailTextController,
              //initialValue: '',
              decoration: InputDecoration(labelText: 'Add admin email', labelStyle: titleStyle),
              onSaved: (value) {
                // if (value != null && value.isNotEmpty) {
                //   if (!widget.enterpriseModel.admins.contains(value)) {
                //     widget.enterpriseModel.admins.add(value);
                //   }
                // }
              },
            ),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () async {
              String value = adminEmailTextController.text;
              _message = '';
              if (value.isNotEmpty) {
                if (CretaCommonUtils.isValidEmail(value)) {
                  if (!widget.enterpriseModel.admins.contains(value)) {
                    // 여기서 value 가  현재 user table  에 존재하는 email  인지 체크해야함.
                    UserPropertyModel? userModel =
                        await CretaAccountManager.getUserPropertyModel(value);
                    if (userModel != null) {
                      if (userModel.enterprise != widget.enterpriseModel.name) {
                        _message = CretaDeviceLang['onlyTeamMemberCanbeAdmin'] ??
                            "오직 현재 소속 팀의 팀원만 어드민이 될 수 있습니다.  먼저 팀관리 화면에서 팀원으로 등록후 어드민으로 등록해주세요";
                      } else {
                        widget.enterpriseModel.admins.add(value);
                      }
                    } else {
                      _message = CretaDeviceLang['noUserExist'];
                    }
                  }
                } else {
                  _message = CretaDeviceLang['Invalidemail'];
                }
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.red)),
      if (widget.enterpriseModel.admins.isNotEmpty)
        Container(
          color: Colors.grey[200],
          height: 100,
          child: ListView.builder(
            itemCount: widget.enterpriseModel.admins.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.enterpriseModel.admins[index]),
                  const SizedBox(width: 15),
                  BTN.fill_gray_100_i_s(
                    onPressed: () {
                      setState(() {
                        widget.enterpriseModel.admins.removeAt(index);
                      });
                    },
                    icon: Icons.close,
                  ),
                ],
              );
            },
          ),
        ),
    ];
  }

  Widget _nvRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          Text(value.isEmpty ? '-' : value, textAlign: TextAlign.right, style: dataStyle),
        ],
      ),
    );
  }
}
