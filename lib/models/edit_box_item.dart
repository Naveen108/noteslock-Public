import 'package:noteslock/data/data.dart';

class EditBoxItem {
  var texttype;
  final String hinttext;
  final String errortext;
  final String errorcheck;
  final String hinttext2;
  final String noteText;
  static String noteStaticText;
  final DataModel dataModel;
  var iconType;
  var onSave;
  EditBoxItem(
      {this.texttype,
      this.hinttext,
      this.hinttext2,
      this.iconType,
      this.errortext,
      this.errorcheck,
      this.noteText,
      this.onSave,
      this.dataModel});
}
