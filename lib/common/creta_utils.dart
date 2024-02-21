//ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously

//import 'dart:math';
//import 'dart:typed_data';
//import 'dart:ui' as ui;
//import 'dart:html' as html;
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:hycop/hycop.dart';
//import 'package:image/image.dart' as img;

import '../design_system/menu/creta_popup_menu.dart';
//import '../lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import '../model/app_enums.dart';
import '../pages/login/creta_account_manager.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import '../routes.dart';

class ShadowData {
  final double spread;
  final double blur;
  final double direction;
  final double distance;
  final double opacity;
  final String? title;

  ShadowData({
    required this.spread,
    required this.blur,
    required this.direction,
    required this.distance,
    required this.opacity,
    this.title,
  });
}

class CretaUtils {
  static DateTime debugTime = DateTime.now();

  static Size getDisplaySize(BuildContext context) {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;
    StudioVariables.displaySize = Size(StudioVariables.displayWidth, StudioVariables.displayHeight);
    return StudioVariables.displaySize;
  }

  static StrokeCap borderCap(BorderCapType aType) {
    switch (aType) {
      case BorderCapType.bevel:
        return StrokeCap.butt;
      case BorderCapType.miter:
        return StrokeCap.square;
      case BorderCapType.round:
        return StrokeCap.round;
      default:
        return StrokeCap.round;
    }
  }

  static StrokeJoin borderJoin(BorderCapType aType) {
    switch (aType) {
      case BorderCapType.bevel:
        return StrokeJoin.bevel;
      case BorderCapType.miter:
        return StrokeJoin.miter;
      case BorderCapType.round:
        return StrokeJoin.round;
      default:
        return StrokeJoin.round;
    }
  }

  static List<ShadowData> shadowDataList = [
    ShadowData(spread: 30, blur: 4, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 30, blur: 0, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 30, blur: 4, direction: 135, distance: 10, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 135, distance: 10, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 90, distance: 10, opacity: 0.5),
    //ShadowData(spread: 0, blur: 0, direction: 45, distance: 3, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 90, distance: 0, opacity: 1.0, title: 'custom'),

    //   ShadowData(spread: 3, blur: 4, direction: 0, distance: 0),
    //   ShadowData(spread: 3, blur: 0, direction: 0, distance: 0),
    //   ShadowData(spread: 3, blur: 4, direction: 135, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 135, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 90, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 90, distance: 3),
  ];

  static List<CretaMenuItem> getLangItem(
      {required String defaultValue, required void Function(String) onChanged}) {
    return StudioConst.code2LangMap.keys.map(
      (code) {
        String langStr = StudioConst.code2LangMap[code]!;

        return CretaMenuItem(
          caption: langStr,
          onPressed: () {
            onChanged(StudioConst.lang2CodeMap[langStr]!);
          },
          selected: code == defaultValue,
        );
      },
    ).toList();
  }

  static (double, double) getTextBoxSize(
    String text,
    AutoSizeType autoSizeType,
    double boxWidth,
    double boxHeight,
    TextStyle? style,
    TextAlign? align,
    double padding,
    double outlineWidth, {
    double adjust = 2.0,
  }) {
    //print('text lenght = ${text.length}----------------');
    if (text.isEmpty) {
      text = ' '; // 비어있으면 계산을 못하기 때문에, 그냥 Space 를 넣는다.
      // if (style != null && style.fontSize != null) {
      //   double height = (style.fontSize! * StudioVariables.applyScale) + (padding * 2);
      //   //print('empty case height=$height');
      //   return (boxWidth, height);
      // }
      // //print('empty case height=100');
      // return (boxWidth, 100);
    }

    //int offset = 0;
    List<String> lines = text.split('\n');
    double textLineWidth = 0;
    double textLineHeight = 0;
    List<int> eachLineCount = [];

    for (var line in lines) {
      TextPainter textPainter = CretaCommonUtils.getTextPainter(line, style, align);

      //TextRange range =
      // 글자수를 구할 수 있다.
      //int charCount = textPainter.getLineBoundary(TextPosition(offset: text.length)).end;

      final double lineWidth = textPainter.width; // + wMargin;
      if (textLineWidth < lineWidth) {
        textLineWidth = lineWidth;
      }
      int count = 1;
      if (autoSizeType != AutoSizeType.autoFrameSize) {
        count = (lineWidth / boxWidth).ceil();
      }
      if (count == 0) count = 1; // 빈줄의 경우이다.
      eachLineCount.add(count);
      // 텍스트 하이트는 나중에, frameSize 를 늘리기 위해서 필요하다.
      textLineHeight = textPainter.preferredLineHeight; // + hMargin; //textPainter.height;
    }

    int textLineCount = 0;
    for (var ele in eachLineCount) {
      textLineCount += ele;
    }

    double width = textLineWidth + (padding * 2) + (outlineWidth * 2);
    double height =
        (textLineHeight * textLineCount.toDouble()) + (padding * 2) + (outlineWidth * 2);

    //print('textLineCount=$textLineCount, textLineHeight=$textLineHeight, height=$height');

    if (autoSizeType == AutoSizeType.autoFrameHeight ||
        autoSizeType == AutoSizeType.autoFrameSize) {
      double wMargin = (style!.fontSize! / adjust);
      //double hMargin = wMargin * (height / width);
      width += wMargin;
      //height += hMargin;
    }

    //print('height=$height');

    //print('width=$width, height=$height, textLineCount=$textLineCount -------------');

    //print('lineCount=$textLineCount, lineHeight=$textLineHeight');
    return (width, height);
  }

  static double getOptimalFontSize({
    required String text,
    required TextStyle style,
    required double containerWidth,
    required double containerHeight,
    double delta = 1.0,
  }) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    double minFontSize = StudioConst.minFontSize; // 시작 폰트 크기
    double maxFontSize = StudioConst.maxFontSize; // 최대 시도할 폰트 크기
    double currentSize = StudioConst.defaultFontSize;

    while (maxFontSize - minFontSize > delta) {
      currentSize = (minFontSize + maxFontSize) / 2;
      textPainter.text = TextSpan(text: text, style: style.copyWith(fontSize: currentSize));
      textPainter.layout(maxWidth: containerWidth);

      if (textPainter.size.height > containerHeight) {
        maxFontSize = currentSize;
      } else {
        minFontSize = currentSize;
      }
    }

    return currentSize;
  }

  static MouseCursor getCursorShape() {
    if (BookMainPage.topMenuNotifier!.isTextCreate()) {
      return SystemMouseCursors.text;
    }
    if (BookMainPage.topMenuNotifier!.isFrameCreate()) {
      return SystemMouseCursors.cell;
    }
    return SystemMouseCursors.basic;
  }

  static Future<http.Response?> post(
    String url,
    Map<String, dynamic> body, {
    void Function(String code)? onError,
    void Function(String code)? onException,
  }) async {
    String jsonString = '{\n';
    int count = 0;
    for (var ele in body.entries) {
      if (count > 0) {
        jsonString += ',\n';
      }
      jsonString += '"${ele.key}": ${ele.value}';
      count++;
    }
    jsonString += '\n}';

    //String encodedJson = base64Encode(utf8.encode(jsonString));

    //print(jsonString);

    try {
      http.Client client = http.Client();
      if (client is BrowserClient) {
        client.withCredentials = true;
      }
      // HTTP POST 요청 수행
      http.Response response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 추가적인 헤더를 설정할 수 있습니다.
        },
        body: jsonString, //encodedJson, //jsonString,
      );
      if (response.statusCode != 200) {
        // 에러 처리
        logger.severe('$url Failed to send data');
        logger.severe('Status code: ${response.statusCode}');
        onError?.call('${response.statusCode}');
        return null;
      }

      logger.fine('pos $url succeed');
      return response;
    } catch (e) {
      // 예외 처리
      logger.severe('$url Failed to send data');
      logger.severe('An error occurred: $e');
      onException?.call('$e');
      return null;
    }
  }

  static Future<bool> inviteBook(
      BuildContext context, String email, String bookMid, String bookName, String userName) async {
    String base = Uri.base.origin;
    //print('---------------base=$base');

    String url = '${CretaAccountManager.getEnterprise!.mediaApiUrl}/sendEmail';
    String option = '''{
        "invitationUserName": "$userName",        
        "cretaBookName": "$bookName",        
        "cretaBookLink": "$base${AppRoutes.communityBook}?$bookMid"        
    }''';
    Map<String, dynamic> body = {
      "receiverEmail": ['"$email"'], // 수신인
      "emailType": '"invite"',
      "emailOption": option,
    };

    http.Response? res = await CretaUtils.post(url, body, onError: (code) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($code)');
    }, onException: (e) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($e)');
    });

    if (res != null) {
      showSnackBar(context, CretaStudioLang.inviteEmailSucceed);
      return true;
    }
    return false;
  }

  static Future<bool> sendResetPasswordEmail(
    String email,
    String nickname,
    String userId,
    String secret,
  ) async {
    String base = Uri.base.origin;
    //print('---------------base=$base');

    String url = '${CretaAccountManager.getEnterprise!.mediaApiUrl}/sendEmail';
    // String option = '''{
    //     "subject": "[크레타] 계정의 비밀번호 초기화 요청이 있습니다",
    //     "content": "비밀번호 초기화를 요청하셨다면 아래 링크를 클릭하시고\\n그렇지 않으시면 무시하세요.\\n\\n$base${AppRoutes.resetPasswordConfirm}?userId=$userId&secret=$secret\\n\\n크레타 팀으로부터."
    // }''';
    String option = '''{
        "resetPasswordUserName": "$nickname",        
        "resetPasswordUrl": "$base${AppRoutes.resetPasswordConfirm}?userId=$userId&secret=$secret"        
    }''';
    Map<String, dynamic> body = {
      "receiverEmail": ['"$email"'], // 수신인
      "emailType": '"resetPassword"',
      "emailOption": option,
    };

    http.Response? res = await CretaUtils.post(url, body, onError: (code) {
      //showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($code)');
    }, onException: (e) {
      //showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($e)');
    });

    if (res != null) {
      //showSnackBar(context, '비밀번호 초기화 실패');
      return true;
    }
    return false;
  }

  static Future<bool> sendVerifyEmail(
      String nickname, String userId, String email, String secret) async {
    String base = Uri.base.origin;
    //print('---------------base=$base');

    String url = '${CretaAccountManager.getEnterprise!.mediaApiUrl}/sendEmail';
    // String option = '''{
    //     "subject": "[크레타] 가입을 환영합니다",
    //     "content": "크레타에 오신 것을 환영합니다\\n\\n아래 URL링크를 눌러서 회원가입을 완료해주세요.\\n\\n$base${AppRoutes.verifyEmail}?userId=$userId&secret=$secret\\n\\n크레타 팀으로부터."
    // }''';
    String option = '''{
        "verifyUserName": "$nickname",        
        "verifyUserUrl": "$base${AppRoutes.verifyEmail}?userId=$userId&secret=$secret"        
    }''';
    Map<String, dynamic> body = {
      "receiverEmail": ['"$email"'], // 수신인
      "emailType": '"verify"',
      "emailOption": option,
    };

    http.Response? res = await CretaUtils.post(url, body, onError: (code) {
      //showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($code)');
    }, onException: (e) {
      //showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($e)');
    });

    if (res != null) {
      //showSnackBar(context, '비밀벊');
      return true;
    }
    return false;
  }
}
