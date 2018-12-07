import 'dart:async';
import 'dart:io';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/models/book_item.dart';
import 'package:noteslock/models/note_item.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//DataModel for handling logins and regiter , as well the invited requestes
class DataModel extends Model {
  Query query = Query();
  static String iconWeb1 = 'https://beta.icons8.com/icon/set/science/color';
  static String iconWeb2 = 'https://www.flaticon.com/free-icon/';

  //Current Note under editing
  static Note currentNote;
  static double fontSizeCurrent = 16.0;
  static String autoLock;
  static String quickNote;
  static String lockType;
  static bool gird;
  static int fontFamily = 1;

  //Current Book under editing
  static Book currentBook;
  //user's name
  static String username;
  //user's Phone
  static String userPhoneNumber;
  //user password
  static String userpass;

  //the variable where the path is stored
  static Directory _appDocumentsDirectory;
  static String path;

  //Book List
  List<Map> bookList;
  //Database DB
  static Database database;

  //List of Notes
  static List<Note> listOfNotes = <Note>[];
  //List of Books
  static List<Book> listOfBooks = <Book>[];

  //function for getting the path of the app installation
  //should run before openDB funtction to get Path.
  Future<dynamic> requestAppDocumentsDirectory() async {
    await getApplicationDocumentsDirectory().then((data) async {
      path = '';
      _appDocumentsDirectory = data.absolute;
      path = join(data.path, 'noteslock.db');
      print(path);
    });
    if (path != null) {
      return true;
    } else {
      print(path);
      return false;
    }
  }

  //function for deleting the DB
  Future deleteDB() async {}

  //function to open the DB
  Future openDB() async {
    database = await openDatabase(
      path,
      version: 1,
    );
    print(' ${database.isOpen} in the openDB ${database.path}');
  }

  // Insert some records in a transaction, uses option parameter
  Future transaction(int action,
      [String txnQuery, Book book, Note note]) async {
    await database.transaction((txn) async {
      if (action == 0) {
        int id1 = await txn.rawInsert(txnQuery);
        print("query: $id1");
      } else if (action == 1) {
        //insert the books
        Query.currentTimeString = query.datetimefucntion();
        String txnQuery1 = '''
      INSERT INTO books
          (booktitle,category,bookcolor,
          bookicon,bookimage,booksubtitle,
          bookcreationtime,booklasteditime,
          bookrating,bookfavourite,bookfont
          ) 
          VALUES
          ('${book.bookName}', '${book.category}',${book.bookcolor},
          ${book.bookicon},'${book.bookimage}','${book.bookSubtitle}'
          ,'${Query.currentTimeString}','${Query.currentTimeString}',
          ${book.bookrating},${book.favoriteBook},${book.bookFont})
      ''';

        int id1 = await txn.rawInsert(txnQuery1).then((data) async {
          print("inserted in the function print  book 1: $data");
          await txn.rawQuery(fethBooks).then((data) async {
            await bookListMaker(data);
            notifyListeners();
          });
        });

        print("inserted book 1: $id1");
        notifyListeners();
      } else if (action == 2) {
        Query.currentTimeString = query.datetimefucntion();
        String txnQuery2 = '''
       INSERT INTO notes
          (notetitle,bookid,bookcategory,notecolor,
          noteicon,noteimage,notecontent,
          notecreationtime,notelasteditime,
           noterating,notefavourite,notefont) 
          VALUES
          ('${note.noteTitle}',${DataModel.currentBook.bookId},'${DataModel.currentBook.category}',${note.notecolor},
          ${note.noteicon},'${note.noteimage}','${note.noteContent}'
          ,'${Query.currentTimeString}','${Query.currentTimeString}'
          ,${note.rating},${note.favoriteNote},${note.notefont})
      ''';

        int id1 = await txn.rawInsert(txnQuery2);
        print("inserted a note in the book : $id1");
        await txn.rawQuery(txnQuery).then((data) async {
          print("fetched all notes of the book : $data");
          await notesListMaker(data);
          notifyListeners();
        });
        notifyListeners();
      } else if (action == 3) {
        //for delete the boks and notes table
        await txn.delete('books').then((data) async {
          await txn.delete('notes').then((data) async {
            print('tables deleted');
          });
        });
      } else if (action == 4) {
        //for fetching notes
        await txn.rawQuery(txnQuery).then((data) async {
          await notesListMaker(data);
          print('trasncation for notes fetch completed with $data');

          notifyListeners();
        });
      } else if (action == 5) {
        //query for deleting a book or deleting a note
        await txn.rawDelete(txnQuery).then((data) async {
          print('trasncation  for action 5 delete completed with $data');
        });
      } else if (action == 6) {
        //for fetching books

        await txn.rawQuery(txnQuery).then((data) async {
          await bookListMaker(data);
          print('trasncation for notes fetch completed with $data');

          notifyListeners();
        });
      } else if (action == 7) {
        //for simple query like update a note on save

        await txn.rawQuery(txnQuery).then((data) async {
          print('trasncation for noteedit or update save completed with $data');
        });
      }
    });
  }

  //QueryFunction to get data
  Future queryFunction(String query) async {
    // Get the records
    return await database.rawQuery(query).then((data) {
      return data;
    });
    //print(bookList[0]);
  }

  //List Building  Function for Books
  bookListMaker(List<Map> bookList) {
    print('called book maker');
    listOfBooks = <Book>[];
    bookList.forEach((item) {
      Book newBook = Book(
        bookId: item['bookid'],
        bookName: item['booktitle'],
        category: item['category'],
        bookcolor: item['bookcolor'],
        bookicon: item['bookicon'],
        bookimage: item['bookimage'],
        bookSubtitle: item['booksubtitle'],
        creationDate: item['bookcreationtime'],
        lastEdit: item['booklasteditime'],
        bookFont: item['bookfont'],
      );
      if(item['bookid']==4){
        DataModel.currentBook = newBook;
      print('found book with id = ${item['bookid']} this is quickBOok ');
      }
      print('found book with id = ${item['bookid']} ');
      listOfBooks.add(newBook);
      print(newBook);
    });
    notifyListeners();
  }

  //List Building  Function for Books
  notesListMaker(List<Map> noteList) {
    listOfNotes = <Note>[];
    noteList.forEach((item) {
      Note newnote = Note(
        noteId: item['noteid'],
        bookId: item['bookid'],
        noteTitle: item['notetitle'],
        bookcategory: item['bookcategory'],
        notecolor: item['notecolor'],
        noteicon: item['noteicon'],
        noteimage: item['noteimage'],
        noteContent: item['notecontent'],
        creationTime: item['notecreationtime'],
        lastEditTime: item['notelasteditime'],
        favoriteNote: item['notefavourite'],
        rating: item['noterating'],
        notefont: item['notefont'],
      );

      //substring
      int start = 0, j = 0;
      while (newnote.noteContent.contains('*&@&*')) {
        if (start != 0) {
          start = j + 5;
        }
        j = newnote.noteContent.indexOf('*&@&*');

        newnote.noteContent = newnote.noteContent.substring(0, start) +
            newnote.noteContent.substring(start, j) +
            "'" +
            newnote.noteContent.substring(j + 5);
      }
      listOfNotes.add(newnote);
      print(newnote);
    });

    notifyListeners();
  }

  //Function to open DB and create the DB as well
  Future<dynamic> createOpenDB() async {
    print('called createOpenDB');
    database = await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      await database.execute(newSignUpQuery1);
      await database.execute(newSignUpQuery2);
    });

    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery3);
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery4);
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery5);
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery6);
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery7);
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery8);
    ;
    Query.currentTimeString = query.datetimefucntion();
    await transaction(0, Query.newSignUpQuery9);

    print(' ${database.isOpen} in createOpendDB  ${database.path}');
  }
}
