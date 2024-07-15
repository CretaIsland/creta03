//import 'package:creta_common/common/creta_common_utils.dart';

import 'dart:typed_data';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../mypage/mypage_common_widget.dart';
//import 'book_select_filter.dart';

class UserDetailPage extends StatefulWidget {
  final UserPropertyModel userModel;
  final GlobalKey<FormState> formKey;
  final double width;

  const UserDetailPage({
    super.key,
    required this.userModel,
    required this.formKey,
    required this.width,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  TextStyle dataStyle = CretaFont.bodySmall;
  TextEditingController managerTextController = TextEditingController();
  TextEditingController memberTextController = TextEditingController();

  XFile? _selectedProfileImg;
  Uint8List? _selectedProfileImgBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    managerTextController.dispose();
    memberTextController.dispose();
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
                _nvRow('User ID', widget.userModel.email),
                _nvRow('NickName', widget.userModel.nickname),
                _nvRow('Verified', widget.userModel.verified.toString()),
                _nvRow('Enterprise', widget.userModel.enterprise),
                _nvRow('Grade', widget.userModel.cretaGrade.name),
                _nvRow('Rate Plan', widget.userModel.ratePlan.name),
                _nvRow('Country', widget.userModel.country.name),
                _nvRow('Language', widget.userModel.language.name),
                _nvRow('Job', widget.userModel.job.name),

                _nvRow('FreeSpace', '${widget.userModel.freeSpace} MByte'),
                _nvRow('BookCount', widget.userModel.bookCount.toString()),
                _nvRow('BookViewCount', widget.userModel.bookViewCount.toString()),
                _nvRow('BookViewTime', widget.userModel.bookViewTime.toString()),
                _nvRow('LikeCount', widget.userModel.likeCount.toString()),
                _nvRow('CommentCount', widget.userModel.commentCount.toString()),
                _nvRow('LikeCount', widget.userModel.likeCount.toString()),
                _nvRow('UsePushNotice', widget.userModel.usePushNotice.toString()),
                _nvRow('UseEmailNotice', widget.userModel.useEmailNotice.toString()),
                _nvRow('IsPublicProfile', widget.userModel.isPublicProfile.toString()),

                _nvRow('GenderType', widget.userModel.genderType.name),
                _nvRow('AgreeUsingMarketing', widget.userModel.agreeUsingMarketing.toString()),
                _nvRow('UsingPurpose', widget.userModel.usingPurpose.name),
                _nvRow('BirthYear', widget.userModel.birthYear.toString()),

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
                  child: Text('User Logo image', style: titleStyle),
                ),
                MyPageCommonWidget.profileImgComponent(
                  width: 200,
                  height: 200,
                  profileImgUrl: widget.userModel.profileImgUrl,
                  profileImgBytes: _selectedProfileImgBytes,
                  userName: widget.userModel.nickname,
                  replaceColor: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                  editBtn: Center(
                    child: BTN.opacity_gray_i_l(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white).icon!,
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
                                    .uploadFile(_selectedProfileImg!.name,
                                        _selectedProfileImg!.mimeType!, _selectedProfileImgBytes!)
                                    .then((value) {
                                  if (value != null) {
                                    widget.userModel.profileImgUrl = value.url;
                                  }
                                });
                              });
                            }
                          } catch (error) {
                            logger.severe("error at user image >> $error");
                          }
                        }),
                  ),
                ),
                TextFormField(
                  initialValue: widget.userModel.phoneNumber,
                  decoration: InputDecoration(labelText: 'phoneNumber', labelStyle: titleStyle),
                  onSaved: (value) => widget.userModel.phoneNumber = value ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
