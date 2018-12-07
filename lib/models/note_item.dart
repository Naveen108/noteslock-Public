class Note {
  String noteTitle;
  String noteContent;
  String auhtor;
  String lastEditTime;
  String creationTime;
  String noteBookName;
  String noteimage;
  String bookcategory;
  int rating;
  int favoriteNote;
  int bookId;
  int noteId;
  int notecolor;
  int noteicon;
  int notefont;
  Note(
      {this.auhtor,
      this.noteicon,
      this.bookId,
      this.notecolor,
      this.noteId,
      this.bookcategory,
      this.creationTime,
      this.noteimage,
      this.lastEditTime,
      this.noteBookName,
      this.noteContent,
      this.noteTitle,
      this.rating,
      this.notefont,
      this.favoriteNote});
}
