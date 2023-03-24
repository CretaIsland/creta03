//import 'package:flutter/cupertino.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:hycop/common/util/logger.dart';

import '../../model/contents_model.dart';
//import 'package:dotted_border/dotted_border.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<ContentsModel> onDroppedFile;
  final String parentId;

  const DropZoneWidget({Key? key, required this.onDroppedFile, required this.parentId})
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
  Widget build(BuildContext context) {
    return buildDecoration(
        // child: DropzoneView(
        //   // attach an configure the controller
        //   onCreated: (controller) => this.controller = controller,
        //   // call UploadedFile method when user drop the file
        //   onDrop: uploadedFile,
        //   // change UI when user hover file on dropzone
        //   onHover: () => setState(() => highlight = true),
        //   onLeave: () => setState(() => highlight = false),
        //   onLoaded: () => logger.info('Zone Loaded'),
        //   onError: (err) => logger.info('run when error found : $err'),
        //),

        child: Stack(
      children: [
        kIsWeb
            ?
            // dropzone area
            DropzoneView(
                // attach an configure the controller
                onCreated: (controller) => this.controller = controller,
                // call UploadedFile method when user drop the file
                onDrop: uploadedFile,
                // change UI when user hover file on dropzone
                onHover: () => setState(() => highlight = true),
                onLeave: () => setState(() => highlight = false),
                onLoaded: () => logger.info('Zone Loaded'),
                onError: (err) => logger.info('run when error found : $err'),
              )
            : Container(),
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Icon(
        //         Icons.cloud_upload_outlined,
        //         size: 80,
        //         color: Colors.white,
        //       ),
        //       const Text(
        //         'Drop Files Here',
        //         style: TextStyle(color: Colors.white, fontSize: 24),
        //       ),
        //       const SizedBox(
        //         height: 16,
        //       ),
        //       // a button to pickfile from computer
        //       ElevatedButton.icon(
        //         onPressed: () async {
        //           final events = await controller.pickFiles();
        //           if (events.isEmpty) return;
        //           uploadedFile(events.first);
        //         },
        //         icon: const Icon(Icons.search),
        //         label: const Text(
        //           'Choose File',
        //           style: TextStyle(color: Colors.white, fontSize: 15),
        //         ),
        //         style: ElevatedButton.styleFrom(
        //             padding: const EdgeInsets.symmetric(horizontal: 20),
        //             primary: highlight ? Colors.blue : Colors.green.shade300,
        //             shape: const RoundedRectangleBorder()),
        //       )
        //     ],
        //   ),
        //),
      ],
    ));
  }

  Future uploadedFile(dynamic event) async {
    // this method is called when user drop the file in drop area in flutter
    File file = event as File;
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
    final droppedFile = ContentsModel.withFile(widget.parentId,
        name: name, mime: mime, bytes: byte, url: url, file: file);

    //Update the UI
    widget.onDroppedFile(droppedFile);
    setState(() {
      highlight = false;
    });
  }

  Widget buildDecoration({required Widget child}) {
    final colorBackground = highlight ? Colors.blue : Colors.transparent;
    return ClipRRect(
      //borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        // DottedBorder(
        // borderType: BorderType.RRect,
        // color: Colors.white,
        // strokeWidth: 3,
        // dashPattern: const [8, 4],
        // radius: const Radius.circular(10),
        // padding: EdgeInsets.zero,
        // child: child),
        color: colorBackground,
        child: child,
      ),
    );
  }
}
