import 'package:noteslock/models/note_item.dart';

class Book {
  String creationDate;
  String bookName;
  String category;
  List<Note> listofNotes;
  String author;
  String lastEdit;
  int noofNotes = 0;
  int bookId;
  int bookicon;
  String bookimage;
  int bookcolor;
  String bookSubtitle;
  int favoriteBook;
  int bookrating;
  int bookFont;
  Book(
      {this.bookName,
      this.category,
      this.bookId,
      this.bookrating,
      this.bookSubtitle,
      this.creationDate,
      this.bookcolor,
      this.bookicon,
      this.bookimage,
      this.noofNotes,
      this.author,
      this.lastEdit,
      this.bookFont,
      this.listofNotes,
      this.favoriteBook});
}
