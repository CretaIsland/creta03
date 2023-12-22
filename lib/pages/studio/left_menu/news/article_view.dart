import 'package:flutter/material.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  const ArticleView({super.key, required this.postUrl});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: Colors.pink[200],
    );
  }
}
