//import 'package:flutter/cupertino.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:hycop/common/util/logger.dart';

import '../../model/contents_model.dart';
//import 'package:dotted_border/dotted_border.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<List<ContentsModel>> onDroppedFile;
  final String bookMid;
  final String parentId;
  final Widget? child;
  final Color bgColor;

  const DropZoneWidget(
      {Key? key,
      required this.onDroppedFile,
      required this.bookMid,
      required this.parentId,
      this.child,
      this.bgColor = Colors.black})
      : super(key: key);
  @override
  DropZoneWidgetState createState() => DropZoneWidgetState();
}

class DropZoneWidgetState extends State<DropZoneWidget> {
  //controller to hold data of file dropped by user
  late DropzoneViewController controller;
  // a variable just to update UI color when user hover or leave the drop zone
  bool highlight = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final colorBackground = highlight ? widget.bgColor : Colors.transparent;
    //return ClipRRect(
    //child:
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (kIsWeb)
          IgnorePointer(
            //child: SizedBox.shrink(),
            child: DropzoneView(
              onCreated: (controller) => this.controller = controller,
              //onDrop: uploadedFile,
              onDropMultiple: (list) async {
                if (list == null) return;
                logger.info('onDropMultiple -------------- ${list.length}');
                List<ContentsModel> contentsList = [];
                for (var event in list) {
                  logger.info('onDropMultiple -------------- ${event.name}');
                  contentsList.add(await uploadedFile(event, widget.bookMid));
                }
                widget.onDroppedFile(contentsList);
                setState(() {
                  highlight = false;
                });
              },
              onHover: () => setState(() => highlight = true),
              onLeave: () => setState(() => highlight = false),
              onLoaded: () => logger.fine('Zone Loaded'),
              onError: (err) => logger.fine('run when error found : $err'),
            ),
          ),
        if (highlight) IgnorePointer(child: Container(color: colorBackground.withOpacity(0.25))),
      ],
      //),
    );
  }

  Future<ContentsModel> uploadedFile(dynamic event, String bookMid) async {
    // this method is called when user drop the file in drop area in flutter
    html.File file = event as html.File;
    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final byte = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    //final blob = await controller.getFileData(event);

    logger.info('Name : $name');
    logger.info('Mime: $mime');

    logger.info('Size : ${byte / (1024 * 1024)}');
    logger.info('URL: $url');

    // update the data model with recent file uploaded
    final droppedFile = ContentsModel.withFile(widget.parentId, bookMid,
        name: name, mime: mime, bytes: byte, url: url, file: file);

    //Update the UI
    return droppedFile;
  }
}
