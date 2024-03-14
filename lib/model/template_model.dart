// ignore_for_file: prefer_const_constructors
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

// ignore: must_be_immutable
class TemplateModel extends PageModel {
  TemplateModel(String pmid) : super(pmid, BookModel(''), type: ExModelType.template);
}
