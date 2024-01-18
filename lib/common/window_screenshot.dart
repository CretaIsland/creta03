// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'dart:typed_data';
import 'dart:ui';
import 'package:hycop/hycop.dart';
import 'dart:js_interop';

@JS()
external dynamic jsScreenshot(double x, double y, double width, double height);
//external String jsScreenshot(double x, double y, double width, double height); // => for flutter-3.16.x

class WindowScreenshot {
  // return screenshot image url
  static Future<String> uploadScreenshot(
      {required String bookId,
      Offset offset = Offset.zero,
      Size size = const Size(210, 150)}) async {
    try {
      dynamic screenshot =
          await promiseToFuture(jsScreenshot(offset.dx, offset.dy, size.width, size.height));
      if (screenshot != null) {
        UriData screenshotBytes = Uri.parse(screenshot).data!;
        FileModel? result = await HycopFactory.storage!.uploadFile(
            '${bookId}_thumbnail.png', screenshotBytes.mimeType, screenshotBytes.contentAsBytes(),
            makeThumbnail: false, usageType: 'bookThumbnail');
        if (result != null) {
          return result.url;
        }
      }
    } catch (error) {
      return '';
    }
    return '';
  }

  // return screenshot image bytes
  static Future<Uint8List?> getScreenshotBytes(
      {required String bookId,
      Offset offset = Offset.zero,
      Size size = const Size(210, 150)}) async {
    try {
      dynamic screenshot =
          await promiseToFuture(jsScreenshot(offset.dx, offset.dy, size.width, size.height));
      if (screenshot != null) {
        return Uri.parse(screenshot).data!.contentAsBytes();
      }
    } catch (error) {
      return null;
    }
    return null;
  }
}
