// ignore_for_file: prefer_const_constructors

//import 'package:creta03/design_system/buttons/creta_button.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import 'package:creta_common/common/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
//import 'community_sample_data.dart';
//import '../../design_system/component/custom_image.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
//import '../../../common/creta_utils.dart';
//import '../../../routes.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_launcher/link.dart';
//import '../../../design_system/buttons/creta_button_wrapper.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/component/custom_image.dart';
// import 'package:creta_common/common/creta_font.dart';
// import 'package:creta_common/common/creta_color.dart';
//import '../../../design_system/buttons/creta_button.dart';
//import '../../../design_system/component/snippet.dart';
// import 'package:creta_studio_model/model/book_model.dart';
// import '../../../model/watch_history_model.dart';
// import 'package:creta_user_model/model/user_property_model.dart';
// import '../../../model/channel_model.dart';
import '../../lang/creta_commu_lang.dart';
import '../../model/subscription_model.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
// const double _rightViewBannerMinHeight = 188;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
//const double _itemDescriptionHeight = 56;

class SubscriptionItem extends StatefulWidget {
  const SubscriptionItem({
    super.key,
    required this.subscriptionModel,
    this.width = 286,
    this.height = 80,
    required this.onChangeSelectUser,
    required this.isSelectedUser,
  });
  final SubscriptionModel subscriptionModel;
  final double width;
  final double height;
  final Function(SubscriptionModel?) onChangeSelectUser;
  final bool isSelectedUser;

  @override
  State<SubscriptionItem> createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  bool _mouseOver = false;
  late Color? textColor;

  @override
  void initState() {
    super.initState();
    textColor = widget.isSelectedUser ? CretaColor.primary[400] : CretaColor.text[700];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _mouseOver ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (event) {
        setState(() {
          _mouseOver = true;
        });
      },
      onExit: (event) {
        setState(() {
          _mouseOver = false;
        });
      },
      child: InkWell(
        onTap: () {
          widget.onChangeSelectUser.call(widget.isSelectedUser ? null : widget.subscriptionModel);
        },
        child: Container(
          width: 246,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: widget.isSelectedUser ? Colors.white : null,
          ),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(
            children: [
              //Icon(Icons.account_circle, size:40),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomImage(
                  image: widget.subscriptionModel.subscriptionChannel!.bannerImgUrl,
                  height: 40,
                  width: 40,
                  hasAni: false,
                  hasMouseOverEffect: false,
                ),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 246 - 40 - 12 - 20 - 20,
                    child: Text(
                      widget.subscriptionModel.subscriptionChannel!.name,
                      style: CretaFont.buttonLarge.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${CretaCommuLang['subsriber']} ${widget.subscriptionModel.subscriptionChannel!.followerCount}',
                    style: CretaFont.bodySmall.copyWith(color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
