// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:hycop/hycop.dart';
import 'dart:js_interop';


@JS()
external dynamic jsScreenshot(double x, double y, double width, double height);

class WindowScreenshot {

  static Future<String> screenshot({required String bookId, double x = 0, double y = 0, double width = 210, double height = 150}) async {
    try {
      dynamic screenshot = await promiseToFuture(jsScreenshot(x, y, width, height));
      if(screenshot != null) {
        UriData screenshotBytes = Uri.parse(screenshot).data!;
        FileModel? result = await HycopFactory.storage!.uploadFile('${bookId}_thumbnail.png', screenshotBytes.mimeType , screenshotBytes.contentAsBytes(), makeThumbnail: false);
        if(result != null) {
          return result.fileView;
        }
      }
    } catch (error) {
      return '';
    }
    return '';
  }


}