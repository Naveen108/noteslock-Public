//Queries

String newSignUpQuery1 = '''CREATE TABLE books 
            (bookid INTEGER PRIMARY KEY,
            booktitle TEXT, category TEXT,
            bookcolor INTEGER,bookicon INTEGER,
            bookimage TEXT,
            bookrating INTEGER,
            bookfavourite INTEGER,
            booksubtitle TEXT,bookcreationtime TEXT,
            booklasteditime TEXT,bookfont INTEGER
          )''';
String newSignUpQuery2 = '''CREATE TABLE notes 
            (noteid INTEGER PRIMARY KEY,
            bookid INTEGER NOT NULL,
            notetitle TEXT, bookcategory TEXT,
            notecolor INTEGER,noteicon INTEGER,
            notecontent TEXT,notecreationtime TEXT,
            notelasteditime TEXT,
            noteimage TEXT,
            noterating INTEGER,
            notefavourite INTEGER,notefont INTEGER,
            FOREIGN KEY(bookid) REFERENCES books(bookid)
            ON DELETE CASCADE
          )''';
String fethBooks = 'SELECT * FROM books';

//notes can be fetched using the id

class Query {
  static var currentTimeString;
  

  String datetimefucntion() {
    return DateTime.now().day.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().year.toString() +
        ' '
        ' ' +
        DateTime.now().hour.toString() +
        ':' +
        DateTime.now().minute.toString();
  }
  static String newSignUpQuery3 = '''
          INSERT INTO books
          (booktitle,category,bookcolor,
          bookicon,bookimage,booksubtitle,
          bookcreationtime,booklasteditime,
          bookrating,bookfavourite,bookfont
          ) 
          VALUES
          ("Quotes", "General",1,
          17,"life","World,Life and Struggle"
          ,'${currentTimeString}','${currentTimeString}',1,1,2)
          
          ''';
           static String newSignUpQuery9 = '''
          INSERT INTO books
          (booktitle,category,bookcolor,
          bookicon,bookimage,booksubtitle,
          bookcreationtime,booklasteditime,
          bookrating,bookfavourite,bookfont
          ) 
          VALUES
          ("Quick Notes", "Quick Notes",1,
          4,"haribol","I am in Hurry"
          ,'${currentTimeString}','${currentTimeString}',1,1,3)
          
          ''';
  static String newSignUpQuery4 = '''
          INSERT INTO books
          (booktitle,category,bookcolor,
          bookicon,bookimage,booksubtitle,
          bookcreationtime,booklasteditime,
          bookrating,bookfavourite,bookfont) 
          VALUES
          ("Perceptions", "Mind",2,
          12,"Mind","All about Minds Perceptions"
          ,'${currentTimeString}','${currentTimeString}',3,1,5)
          
          ''';
  static String newSignUpQuery5 = '''
          INSERT INTO books
          (booktitle,category,bookcolor,
          bookicon,bookimage,booksubtitle,
          bookcreationtime,booklasteditime,
          bookrating,bookfavourite,bookfont) 
          VALUES
          ("Love & Trust", "Trust and love",6,
          26,"food","Trust Builds Love"
          ,'${currentTimeString}','${currentTimeString}',0,0,4)
          
          ''';

  static String newSignUpQuery6 = '''
          INSERT INTO notes
          (notetitle,bookid,bookcategory,notecolor,
          noteicon,noteimage,notecontent,
          notecreationtime,notelasteditime,
           noterating,notefavourite,notefont) 
          VALUES
          ("Failures", 1,"General",
          4,18,"dance","Every failure contains a seed of success"
          ,'${currentTimeString}','${currentTimeString}',1,1,1)
          
          ''';
  static String newSignUpQuery7 = '''
          INSERT INTO notes
          (notetitle,bookid,bookcategory,notecolor,
          noteicon,noteimage,notecontent,
          notecreationtime,notelasteditime,
           noterating,notefavourite,notefont) 
          VALUES
         ("Perception", 2,"Mind",
          3,12,"Mind","How we interpret our experience determines what our experience will be."
          ,'${currentTimeString}','${currentTimeString}',3,0,8)
          
          ''';
  static String newSignUpQuery8 = '''
          INSERT INTO notes
          (notetitle,bookid,bookcategory,notecolor,
          noteicon,noteimage,notecontent,
          notecreationtime,notelasteditime,
           noterating,notefavourite,notefont) 
          VALUES
          ("Love & Trust", 3,"Trust and Love",
          3,26,"Love","There cannot be love without trust and there cannot be trust unless we take the responsibility to act in a way that people can trust us"
          ,'${currentTimeString}','${currentTimeString}',1,1,9)
          
          ''';
}
