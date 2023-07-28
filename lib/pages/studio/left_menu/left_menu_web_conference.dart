// stream list


import 'package:creta03/pages/studio/left_menu/left_template_mixin.dart';
import 'package:creta03/pages/studio/left_menu/web_conference/stream/list_remote_stream.dart';
import 'package:creta03/pages/studio/left_menu/web_conference/stream/local_stream.dart';
import 'package:flutter/material.dart';

class LeftMenuWebConference extends StatefulWidget {
  final double maxHeight;
  const LeftMenuWebConference({super.key, required this.maxHeight});

  @override
  State<LeftMenuWebConference> createState() => _LeftMenuWebConferenceState();
}

class _LeftMenuWebConferenceState extends State<LeftMenuWebConference> with LeftTemplateMixin  {

  @override
  void initState() {
    super.initState();
    initMixin();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: horizontalPadding),
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  LocalStream(),
                  ListRemoteStreams()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}