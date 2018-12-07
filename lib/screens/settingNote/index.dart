//NotePage
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/noteEditPage/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/Input_text_form_field.dart';
import 'package:noteslock/widgets/slide_right_route.dart';

class NotesSettingsPage extends StatefulWidget {
  @override
  _NotesSettingsPageState createState() => _NotesSettingsPageState();
}

class _NotesSettingsPageState extends State<NotesSettingsPage> {
  final index = 1;
  String user = UserModel.username;
  DataModel dataModel = DataModel();
  String newnoteTitle = DataModel.currentNote.noteTitle;

  String boxSetNoteTitle = DataModel.currentNote.noteTitle;
  String newSubtitle = DataModel.currentNote.noteContent;
  Query query = Query();
  String boxSetSubtitle = DataModel.currentNote.noteContent;
  int currentFontFamily = DataModel.fontFamily;
  int boxSetFontFamily = DataModel.fontFamily;
  int noteIcon = DataModel.currentNote.noteicon;
  int boxSetNoteIcon = DataModel.currentNote.noteicon;
  double currentFontsize = DataModel.fontSizeCurrent;

  double boxSetFontsize = DataModel.fontSizeCurrent;
  int noteColor = DataModel.currentNote.notecolor;
  int boxSetNoteColor = DataModel.currentNote.notecolor;
  UserModel userModel = UserModel();
  // BannerAd _bannerAdSeetingsNoteScreen;
  bool bannerOn;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdSeetingsNoteScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data == true) {
    //       _bannerAdSeetingsNoteScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
  }

  @override
  void dispose() {
    // _bannerAdSeetingsNoteScreen.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formIconKey = GlobalKey<FormState>();
    final formColorKey = GlobalKey<FormState>();
    final formTitleKey = GlobalKey<FormState>();
    final formFontSizeKey = GlobalKey<FormState>();
    final formFontFamilyKey = GlobalKey<FormState>();
    final scaffoldSettingNoteKey = GlobalKey<ScaffoldState>();

    Size screensizes = MediaQuery.of(context).size;

    String fetchNotes = '''
      SELECT * 
      FROM notes 
      WHERE 
      '${DataModel.currentBook.bookId}' = bookid
      ''';

    _perfomSetNoteTitle() async {
      print('called set username $newnoteTitle');
      setState(() {
        print('called setstate username $newnoteTitle');
        user = newSubtitle;
      });
      Query.currentTimeString = query.datetimefucntion();
      //update query to be done here
      String bookUpdate = ''' 
      UPDATE notes
      SET notetitle = '$newnoteTitle', notelasteditime = '${Query.currentTimeString}'
      WHERE
      noteid = ${DataModel.currentNote.noteId}  
      ''';
      DataModel.currentNote.noteTitle = newnoteTitle;
      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(4, fetchNotes);
      });
    }

    setNoteTitle() {
      final form = formTitleKey.currentState;
      print('in setUSer');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomSetNoteTitle().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    void _changeNoteTitle() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
                "Currently Note title is \"${DataModel.currentNote.noteTitle}\" !"),
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
                              hinttext: "New Note Title",
                              iconType: Icon(Icons.work),
                              errortext: "Enter New Note Title here",
                              errorcheck: "",
                              onSave: (val) => newnoteTitle = val,
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
                      print('called set notename');
                      setNoteTitle();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    _perfomchangeColor() async {
      Query.currentTimeString = query.datetimefucntion();
      String noteUpdate = ''' 
      UPDATE notes
      SET notecolor = $noteColor , notelasteditime = '${Query.currentTimeString}'
      WHERE
      noteid = ${DataModel.currentNote.noteId}  
      ''';
      DataModel.currentNote.notecolor = noteColor;
      await dataModel.transaction(7, noteUpdate).then((data) {
        dataModel.transaction(4, fetchNotes);
      });
    }

    setNoteColor() {
      final form = formColorKey.currentState;
      print('in note color set');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          noteColor = boxSetNoteColor;
        });
        _perfomchangeColor().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    void _changeNoteColor() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Note Color ?"),
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
                                    'Note\'s Color',
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
                                        value: boxSetNoteColor,
                                        items: listBookColor,
                                        onChanged: (int val) {
                                          boxSetNoteColor = val;
                                          setState(() {
                                            boxSetNoteColor = val;

                                            state.didChange(boxSetNoteColor);
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
                      print('called color chnage');
                      setNoteColor();
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
      String noteUpdate = ''' 
      UPDATE notes
      SET noteicon = $noteIcon, notelasteditime = '${Query.currentTimeString}'
      WHERE
      noteid = ${DataModel.currentNote.noteId}  
      ''';

      DataModel.currentNote.noteicon = noteIcon;
      await dataModel.transaction(7, noteUpdate).then((data) {
        dataModel.transaction(4, fetchNotes);
      });
    }

    setNoteIcon() {
      final form = formIconKey.currentState;
      print('in icon reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          noteIcon = boxSetNoteIcon;
        });

        _perfomchangeIcon().then((data) {
          Navigator.of(context).pop();
        });
      }
    }

    _changeNoteIcon() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Note Icon ?"),
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
                                    'Note\'s Icon',
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
                                        value: boxSetNoteIcon,
                                        items: listBookIconImages,
                                        onChanged: (int val) {
                                          //bookIcon = val;
                                          setState(() {
                                            print(
                                                'Setstate was called in icon');
                                            boxSetNoteIcon = val;
                                            state.didChange(boxSetNoteIcon);
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
                      setNoteIcon();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    _perfomSetNoteFontFamily() async {
      print('called set username $currentFontFamily');

      Query.currentTimeString = query.datetimefucntion();
      //update query to be done here
      String bookUpdate = ''' 
      UPDATE notes
      SET notefont = $currentFontFamily, notelasteditime = '${Query.currentTimeString}'
      WHERE
      noteid = ${DataModel.currentNote.noteId}  
      ''';

      await dataModel.transaction(7, bookUpdate).then((data) {
        dataModel.transaction(4, fetchNotes);
      });
    }

    setNoteFontFamily() {
      final form = formFontFamilyKey.currentState;
      print('in font family reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          currentFontFamily = boxSetFontFamily;
          
       
        }); DataModel.currentNote.notefont = currentFontFamily;
        _perfomSetNoteFontFamily();
        Navigator.of(context).pop();
      }
    }

    _changeNoteFontFamily() {
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
                                      listFontFamily[currentFontFamily].child,
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
                                        value: boxSetFontFamily,
                                        items: listFontFamily,
                                        onChanged: (int val) {
                                          setState(() {
                                            print(
                                                'Setstate was called in fonstSIze');
                                            boxSetFontFamily = val;

                                            state.didChange(boxSetFontFamily);
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
                      setNoteFontFamily();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    setNoteFontSize() {
      final form = formFontSizeKey.currentState;
      print('in fontsize reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        setState(() {
          currentFontsize = boxSetFontsize;
        });
        DataModel.fontSizeCurrent = currentFontsize;
        Navigator.of(context).pop();
      }
    }

    _changeNoteFontSize() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Note\'s FontSize ? "),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formFontSizeKey,
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
                                    'Currently it \n is ${DataModel.fontSizeCurrent}',
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
                                        value: boxSetFontsize.toInt(),
                                        items: listFontSize,
                                        onChanged: (int val) {
                                          //bookIcon = val;
                                          setState(() {
                                            print(
                                                'Setstate was called in fonstSIze');
                                            boxSetFontsize = val.toDouble();

                                            state.didChange(boxSetFontsize);
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
                      setNoteFontSize();
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
      key: scaffoldSettingNoteKey,
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
            //   _bannerAdSeetingsNoteScreen.dispose();
            // }
            Navigator.pushReplacement(
              context,SlideRightRoute(
              widget:NoteEditPage(
                      dataModel: dataModel,
                      noteData: DataModel.currentNote,
                    ),
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
                  _changeNoteTitle();
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
                              Text('Change Note Title : '),
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
                              Text(newnoteTitle),
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
                  _changeNoteIcon();
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
                              Text('Change Note Icon : '),
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
                                child: listBookIconImages[noteIcon - 1],
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
                  _changeNoteColor();
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
                              Text('Change Note Color : '),
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
                                    selectedColor[noteColor - 1].primaryColor,
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
                  _changeNoteFontFamily();
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
                                child: listFontFamily[DataModel.currentNote.notefont].child,
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
                  _changeNoteFontSize();
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
                              Text('Change Font Size : '),
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
                                child: Text(currentFontsize.toString()),
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
