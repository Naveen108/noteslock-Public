//NotePage
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/Input_text_form_field.dart';
import 'package:noteslock/widgets/slide_right_route.dart';

class BookSettingsPage extends StatefulWidget {
  @override
  _BookSettingsPageState createState() => _BookSettingsPageState();
}

// Define a corresponding State class. This class will hold the data related to
// our Form.
class _BookSettingsPageState extends State<BookSettingsPage> {
  final index = 1;
  String user = UserModel.username;
  DataModel dataModel = DataModel();
  String newBookTitle = DataModel.currentBook.bookName;
  String newSubtitle = DataModel.currentBook.bookSubtitle;
  String newBookCategory = DataModel.currentBook.category;

  int bookIcon = DataModel.currentBook.bookicon;
  int bookColor = DataModel.currentBook.bookcolor;
  int boxSetBookIcon = DataModel.currentBook.bookicon;
  int boxSetBookColor = DataModel.currentBook.bookcolor;
  
  int bookfont = DataModel.currentBook.bookFont;
  int boxSetBookFont = DataModel.currentBook.bookFont;
  UserModel userModel = UserModel();
  //BannerAd _bannerAdBookSettingsScreen;
  bool bannerOn;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdBookSettingsScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data == true) {
    //       _bannerAdBookSettingsScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
  }

  @override
  void dispose() {
    // if (bannerOn) {
    //   _bannerAdBookSettingsScreen.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Query query = Query();
    final formIconKey = GlobalKey<FormState>();   final formFontFamilyKey = GlobalKey<FormState>();
    final formColorKey = GlobalKey<FormState>();
    final formTitleKey = GlobalKey<FormState>();
    final formSubtitleKey = GlobalKey<FormState>();
    final scaffoldSettingBookPageKey = GlobalKey<ScaffoldState>();
    final formCategoryKey = GlobalKey<FormState>();
    Size screensizes = MediaQuery.of(context).size;
    String fetchNotes = '''
      SELECT * 
      FROM notes 
      WHERE 
      '${DataModel.currentBook.bookId}' = bookid
      ''';
    _perfomSetCategory() async {
      
      Query.currentTimeString = query.datetimefucntion();
      String bookUpdate = ''' 
      UPDATE books
      SET category = '$newBookCategory', booklasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      
      Query.currentTimeString = query.datetimefucntion();
      String bookNotesUpdate = ''' 
      UPDATE notes
      SET bookcategory = '$newBookCategory', notelasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      DataModel.currentBook.category = newBookCategory;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(7, bookNotesUpdate).then((data) {
          dataModel.transaction(6, fethBooks).then((data) {
            dataModel.transaction(4, fetchNotes);
          });
        });
      });
    }

    changeCategory() async {
      final form = formCategoryKey.currentState;
      print('in setPass');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomSetCategory().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    _perfomchangeSubtitle() async {
      
      Query.currentTimeString = query.datetimefucntion();
      String bookUpdate = ''' 
      UPDATE books
      SET booksubtitle = '$newSubtitle', booklasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      DataModel.currentBook.bookSubtitle = newSubtitle;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(6, fethBooks).then((data) {
          dataModel.transaction(4, fetchNotes);
        });
      });
    }

    setBookSubTitle() async {
      final form = formSubtitleKey.currentState;
      print('in setsubtitle');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomchangeSubtitle().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    _perfomSetBookTitle() async {
      print('called set username $newBookTitle');
      setState(() {
        print('called setstate username $newBookTitle');
        user = newSubtitle;
      });
      Query.currentTimeString = query.datetimefucntion();
      //update query to be done here
      String bookUpdate = ''' 
      UPDATE books
      SET booktitle = '$newBookTitle', booklasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      DataModel.currentBook.bookName = newBookTitle;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(6, fethBooks).then((data) {
          dataModel.transaction(4, fetchNotes);
        });
      });
    }

    setBookTitle() {
      final form = formTitleKey.currentState;
      print('in setUSer');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomSetBookTitle().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    void _changeBookTitle() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
                "Currently Book Name is ${DataModel.currentBook.bookName} !"),
            content: Container(
              height: 150.0,
              width: 200.0,
              child: Form(
                  key: formTitleKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InputTextFormField(
                              obscure: false,
                              texttype: TextInputType.text,
                              hinttext: "New Book Title",
                              iconType: Icon(Icons.work),
                              errortext: "Enter New Book Title here",
                              errorcheck: "",
                              onSave: (val) => newBookTitle = val,
                            ),
                          )),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print('called set bookname');
                      setBookTitle();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    void _changeBookSubtitle() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
                "Currently Book Subtitle is ${DataModel.currentBook.bookSubtitle} !"),
            content: Container(
              height: 150.0,
              width: 200.0,
              child: Form(
                  key: formSubtitleKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InputTextFormField(
                              obscure: false,
                              texttype: TextInputType.text,
                              hinttext: "New Book Subtitle",
                              iconType: Icon(Icons.work),
                              errortext: "Enter New Book Subitle here",
                              errorcheck: "",
                              onSave: (val) => newSubtitle = val,
                            ),
                          )),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print('called set bookname');
                      setBookSubTitle();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    void _changeCategory() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Book Category! "),
            content: Container(
              height: 150.0,
              width: 200.0,
              child: Form(
                  key: formCategoryKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InputTextFormField(
                              obscure: false,
                              texttype: TextInputType.text,
                              hinttext: "New Book Category",
                              iconType: Icon(Icons.work),
                              errortext: "Enter New Book Category here",
                              errorcheck: "",
                              onSave: (val) => newBookCategory = val,
                            ),
                          )),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      changeCategory();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    _perfomchangeColor(int bookColor) async {
      
      Query.currentTimeString = query.datetimefucntion();
      String bookUpdate = ''' 
      UPDATE books
      SET bookcolor = $bookColor, booklasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      DataModel.currentBook.bookcolor = bookColor;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(6, fethBooks).then((data) {
          dataModel.transaction(4, fetchNotes);
        });
      });
    }

    setBookColor() {
      final form = formColorKey.currentState;
      print('in book color set');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          bookColor = boxSetBookColor;
        });
        _perfomchangeColor(bookColor).then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    void _changeBookColor() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Book Color ?"),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formColorKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, right: 25.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    'Book\'s Color',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(
                                  //key: formIconKey2,
                                  builder: (FormFieldState state) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: DropdownButton(
                                        iconSize: 40.0,
                                        value: boxSetBookColor,
                                        items: listBookColor,
                                        onChanged: (int val) {
                                          boxSetBookColor = val;
                                          setState(() {
                                            boxSetBookColor = val;

                                            state.didChange(boxSetBookColor);
                                          });
                                        }),
                                  ),
                                );
                              }),
                            ]),
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print('called color change');
                      setBookColor();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    _perfomchangeIcon() async {
      
      Query.currentTimeString = query.datetimefucntion();
      String bookUpdate = ''' 
      UPDATE books
      SET bookicon = $bookIcon, booklasteditime = '${Query.currentTimeString}'
      WHERE
      bookid = ${DataModel.currentBook.bookId}  
      ''';
      DataModel.currentBook.bookicon = bookIcon;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(6, fethBooks).then((data) {
          dataModel.transaction(4, fetchNotes);
        });
      });
    }

    setBookIcon() {
      final form = formIconKey.currentState;
      print('in resetUser');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          bookIcon = boxSetBookIcon;
        });
        _perfomchangeIcon().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    _changeBookIcon() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Book Icon ?"),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formIconKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, right: 25.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    'Book\'s Icon',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(
                                  //key: formIconKey2,
                                  builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 40.0,
                                        value: boxSetBookIcon,
                                        items: listBookIconImages,
                                        onChanged: (int val) {
                                          //boxSetBookIcon = val;
                                          setState(() {
                                            print(
                                                'Setstate was called in icon');
                                            boxSetBookIcon = val;
                                            state.didChange(boxSetBookIcon);
                                          });
                                        }),
                                  ),
                                );
                              }),
                            ]),
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print('called set icon user');
                      setBookIcon();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }
    _perfomSetBookFontFamily() async {
      print('called set username $bookfont');

      Query.currentTimeString = query.datetimefucntion();
      //update query to be done here
      String bookUpdate = ''' 
      UPDATE books
      SET bookfont = $bookfont, booklasteditime = '${Query.currentTimeString}'
      WHERE
      noteid = ${DataModel.currentBook.bookId}  
      ''';

      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(4, fetchNotes);
      });
    }

    setBookFontFamily() {
      final form = formFontFamilyKey.currentState;
      print('in font family reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          bookfont = boxSetBookFont;
          
       
        }); DataModel.currentBook.bookFont = bookfont;
        _perfomSetBookFontFamily();
        Navigator.of(context).pop();
      }
    }

    _changeBookFontFamily() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Note\'s Font Family ? "),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formFontFamilyKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 15.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, right: 25.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child:
                                      listFontFamily[bookfont].child,
                                ),
                              ),
                              new FormField(
                                  //key: formIconKey2,
                                  builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 10.0,
                                        value: boxSetBookFont,
                                        items: listFontFamily,
                                        onChanged: (int val) {
                                          setState(() {
                                            print(
                                                'Setstate was called in fonstSIze');
                                            boxSetBookFont = val;

                                            state.didChange(boxSetBookFont);
                                          });
                                        }),
                                  ),
                                );
                              }),
                            ]),
                      ),
                    ],
                  )),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.cancel),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print('called set fontsize user');
                      setBookFontFamily();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      key: scaffoldSettingBookPageKey,
      //floatingActionButton: FancyFabNote(dataModel: dataModel),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: () {
            print('called navigator');
            // if (bannerOn) {
            //   _bannerAdBookSettingsScreen.dispose();
            // }
            Navigator.pushReplacement(
                context,SlideRightRoute(
              widget:NotesPage(
                          dataModel: DataModel(),
                        )
            )
               );
          },
        ),
        actions: <Widget>[
          // action button
        ],
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(
              right: 50.0,
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      //drawer: CustomDrawer(index: index),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _changeBookTitle();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Book Title : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(newBookTitle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _changeCategory();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Book Category : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(newBookCategory),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _changeBookSubtitle();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Book Subtitle : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(newSubtitle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _changeBookIcon();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Book Icon : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 30.0,
                                height: 30.0,
                                child: listBookIconImages[bookIcon - 1],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _changeBookColor();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Book Color : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 30.0,
                                height: 30.0,
                                color:
                                    selectedColor[bookColor - 1].primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), GestureDetector(
                onTap: () {
                  _changeBookFontFamily();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Change Font Family : '),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 90.0,
                                height: 30.0,
                                child: listFontFamily[DataModel.currentBook.bookFont].child,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
