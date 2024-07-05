import 'package:creta_user_model/model/user_property_model.dart';
import 'package:hycop/hycop.dart';
//import '../pages/login_page.dart';
//import '../pages/login/creta_account_manager.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import '../model/channel_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class ChannelManager extends CretaManager {
  //ChannelModel? channelModel;

  ChannelManager() : super('creta_channel', null) {
    saveManagerHolder?.registerManager('channel', this);
  }

  @override
  AbsExModel newModel(String mid) => ChannelModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    ChannelModel retval = newModel(src.mid) as ChannelModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.channel);
  //
  // Future<void> initChannel() async {
  //   if (LoginPage.userPropertyManagerHolder == null) return;
  //   if (LoginPage.teamManagerHolder == null) return;
  //   if (LoginPage.userPropertyManagerHolder?.userPropertyModel == null) return;
  //   // get user's channel
  //   bool isChannelExist = false;
  //   String channelId = LoginPage.userPropertyManagerHolder!.userPropertyModel!.channelId;
  //   if (channelId.isNotEmpty) {
  //     // exist channelId ==> get from DB
  //     addWhereClause('isRemoved', QueryValue(value: false));
  //     addWhereClause('mid', QueryValue(value: channelId));
  //     List<AbsExModel> retList = await queryByAddedContitions();
  //     if (retList.isNotEmpty) {
  //       channelModel = onlyOne() as ChannelModel;
  //       isChannelExist = true;
  //     }
  //   }
  //   if (isChannelExist == false) {
  //     // not exist channelId ==> create to DB
  //     channelModel = getNewChannel(userId: LoginPage.userPropertyManagerHolder!.userPropertyModel!.email);
  //     await createChannel(channelModel!);
  //     LoginPage.userPropertyManagerHolder!.userPropertyModel!.channelId = channelModel!.mid;
  //     await LoginPage.userPropertyManagerHolder!.setToDB(LoginPage.userPropertyManagerHolder!.userPropertyModel!);
  //   }
  //   // get my teams's channel
  //   for (var teamModel in LoginPage.teamManagerHolder!.teamModelList)
  //   {
  //     //bool isChannelExist = false;
  //     String channelId = teamModel.channelId;
  //     if (channelId.isEmpty) {
  //       // not exist team-channelId
  //       ChannelModel newChannelModel = getNewChannel(teamId: teamModel.mid);
  //       await createChannel(newChannelModel);
  //       teamModel.channelId = newChannelModel.mid;
  //       await LoginPage.teamManagerHolder!.setToDB(teamModel);
  //     }
  //   }
  // }

  ChannelModel makeNewChannel({
    String userId = '',
    String teamId = '',
  }) {
    ChannelModel channelModel = ChannelModel.withName(
      userId: userId,
      teamId: teamId,
    );
    return channelModel;
  }

  Future<bool> createChannel(ChannelModel channelModel) async {
    try {
      await createToDB(channelModel);
    } catch (error) {
      logger.fine('createTeam error >> $error');
      return false;
    }
    return true;
  }

  Future<ChannelModel?> createNewChannel({String userId = '', String teamId = ''}) async {
    ChannelModel newChannelModel = ChannelModel.withName(userId: userId, teamId: teamId);
    await createToDB(newChannelModel);
    return newChannelModel;
  }

  Future<ChannelModel?> getChannelById(String channelId) async {
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('mid', QueryValue(value: channelId));
    queryByAddedContitions().then((value) {
      if (value.isEmpty) {
        return null;
      }
      ChannelModel chModel = modelList[0] as ChannelModel;
      return chModel;
    });
    return null;
  }

  Future<List<ChannelModel>> getChannelFromList(List<String> channelIdList) async {
    List<ChannelModel> channelList = [];
    for (String channelId in channelIdList) {
      if (channelId == UserPropertyModel.defaultEmail) {
        // do nothing
      } else {
        Map<String, QueryValue> query = {};
        query['mid'] = QueryValue(value: channelId);
        query['isRemoved'] = QueryValue(value: false);
        await queryFromDB(query);
        for (var model in modelList) {
          channelList.add(model as ChannelModel);
        }
      }
    }
    return channelList;
  }
}
