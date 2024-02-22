import 'package:creta_common/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:creta_studio_model/model/frame_model.dart';

class NewsTile extends StatefulWidget {
  final String? imgUrl, title, desc, content, posturl;
  final FrameModel frameModel;
  const NewsTile({
    super.key,
    this.imgUrl,
    this.title,
    this.desc,
    this.content,
    this.posturl,
    required this.frameModel,
  });

  @override
  State<NewsTile> createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  @override
  Widget build(BuildContext context) {
    switch (widget.frameModel.newsSizeType) {
      case NewsSizeEnum.Big:
        return newsTileFull(context);
      case NewsSizeEnum.Medium:
        return newsTileMed(context);
      case NewsSizeEnum.Small:
        return newsTileSmall(context);
      default:
        return newsTileFull(context);
    }
  }

  Widget newsTileFull(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                widget.imgUrl!,
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              )),
          const SizedBox(height: 12),
          Text(
            widget.title!,
            maxLines: 2,
            style:
                const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            widget.desc!,
            maxLines: 2,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget newsTileMed(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title!,
            maxLines: 2,
            style:
                const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            widget.desc!,
            maxLines: 2,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget newsTileSmall(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          widget.title!,
          maxLines: 1,
          style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
