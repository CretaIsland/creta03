import 'package:flutter/material.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';

class ContentsOrderedList extends StatefulWidget {
  final double width;
  final double height;
  final ContentsManager contentsManager;
  const ContentsOrderedList(
      {super.key, required this.width, required this.height, required this.contentsManager});

  @override
  State<ContentsOrderedList> createState() => _ContentsOrderedListState();
}

class _ContentsOrderedListState extends State<ContentsOrderedList> {
  @override
  Widget build(BuildContext context) {
    final List<CretaModel> items = [...widget.contentsManager.valueList()];

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.amber,
      child: ReorderableListView.builder(
        itemCount: widget.contentsManager.getAvailLength(),
        itemBuilder: (BuildContext context, int index) {
          ContentsModel model = items[index] as ContentsModel;

          return ListTile(
            key: Key('$index'),
            title: Text(model.name, style: CretaFont.bodySmall),
            leading: const Icon(Icons.drag_handle),
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final ContentsModel item = items.removeAt(oldIndex) as ContentsModel;
            items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
