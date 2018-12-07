//NotePage
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/models/note_item.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/screens/settingNote/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/custom_drawer.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:share/share.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

class NoteEditPage extends StatefulWidget {
  DataModel dataModel;
  Note noteData;
  NoteEditPage({this.dataModel, this.noteData});
  @override
  _NoteEditPageState createState() =>
      _NoteEditPageState(noteData: noteData, dataModel: dataModel);
}

class _NoteEditPageState extends State<NoteEditPage> {
  final index = 4;
  DataModel dataModel;
  Note noteData;
  UserModel userModel = UserModel();
  //BannerAd _bannerAdNoteEditScreen;
  InterstitialAd _innterstitialAdNoteEditScreen;
  final scaffoldNoteEditKey = GlobalKey<ScaffoldState>();
  bool bannerOn;
  _NoteEditPageState({this.dataModel, this.noteData});
  Query query = Query();
  final myController =
      TextEditingController(text: DataModel.currentNote.noteContent);
  _printLatestValue() {
    //print("Second text field: ${myController.text} + first is  ${DataModel.currentNote.noteContent}");
    setState(() {
      DataModel.currentNote.noteContent = myController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdNoteEditScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data == true) {
    //       _bannerAdNoteEditScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
    _innterstitialAdNoteEditScreen = userModel.craeteInterstitialAd()..load();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    myController.dispose();
    // if (bannerOn) {
    //   _bannerAdNoteEditScreen.dispose();
    // }
    //_innterstitialAdNoteEditScreen.dispose();
    super.dispose();
  }

  void save() {
    String escape(String input) {
      int index = 0;

      while (input.length >= index + 1) {
        if (input[index] == "'") {
          if (input.length == index + 1) {
            input = input.substring(0, index) + "*&@&*";
          } else {
            input = input.substring(0, index) +
                "*&@&*" +
                input.substring(index + 1);
          }

          print('found special character at $index now string is $input');
          index = index + 3;
        }
        index++;
      }
      index = 0;

      return input;
    }

    DataModel.currentNote.noteContent =
        escape(DataModel.currentNote.noteContent);
    Query.currentTimeString = query.datetimefucntion();
    String updateQuery = '''
                              UPDATE notes
                              SET notecontent = '${DataModel.currentNote.noteContent}' , notelasteditime = '${Query.currentTimeString}'
                              WHERE noteid = ${DataModel.currentNote.noteId}
                              ''';

    dataModel.transaction(7, updateQuery).then((data) {
      print('Updating note Completed with $data');
    });
    final snackbar = SnackBar(
      content: Text('Hare Krishna Note Saved!'),
    );
    scaffoldNoteEditKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    Size screensizes = MediaQuery.of(context).size;
    String pageTitle = DataModel.currentNote.noteTitle == ''
        ? 'Notes'
        : DataModel.currentNote.noteTitle;

    return Scaffold(
      key: scaffoldNoteEditKey,
      backgroundColor:
          selectedColor[DataModel.currentNote.notecolor - 1].primaryColor,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        highlightElevation: 12.0,
        onPressed: () {save();},
        //action for saving
        //escape function for ' .
        //   String escape(String input) {
        //     int index = 0;

        //     while (input.length >= index + 1) {
        //       if (input[index] == "'") {
        //         if (input.length == index + 1) {
        //           input = input.substring(0, index) + "*&@&*";
        //         } else {
        //           input = input.substring(0, index) +
        //               "*&@&*" +
        //               input.substring(index + 1);
        //         }

        //         print('found special character at $index now string is $input');
        //         index = index + 3;
        //       }
        //       index++;
        //     }
        //     index = 0;

        //     return input;
        //   }

        //   DataModel.currentNote.noteContent =
        //       escape(DataModel.currentNote.noteContent);
        //   Query.currentTimeString = query.datetimefucntion();
        //   String updateQuery = '''
        //                       UPDATE notes
        //                       SET notecontent = '${DataModel.currentNote.noteContent}' , notelasteditime = '${Query.currentTimeString}'
        //                       WHERE noteid = ${DataModel.currentNote.noteId}
        //                       ''';

        //   dataModel.transaction(7, updateQuery).then((data) {
        //     print('Updating note Completed with $data');
        //   });
        //   final snackbar = SnackBar(
        //     content: Text('Hare Krishna Note Saved!'),
        //   );
        //   scaffoldNoteEditKey.currentState.showSnackBar(snackbar);
        // },
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //save changes here !
            save();
            Navigator.pushReplacement(
                context,
                SlideRightRoute(
                    widget: NotesPage(
                  dataModel: dataModel,
                )));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share(myController.text,
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // if (bannerOn) {
              //   _bannerAdNoteEditScreen.dispose();
              // }
              _innterstitialAdNoteEditScreen = userModel.craeteInterstitialAd();
              _innterstitialAdNoteEditScreen.load().then((data) {
                if (data == true) {
                  _innterstitialAdNoteEditScreen.show();
                } else {
                  print('Error loading banner');
                }
                Navigator.pushReplacement(
                    context, SlideRightRoute(widget: NotesSettingsPage()));
              });

              // Navigator.pushReplacement(
              //     context, SlideRightRoute(widget: NotesSettingsPage()));
            },
          ),
        ],
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Text(
            pageTitle,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(
        index: index,
        //bannerAdonScreen: _bannerAdNoteEditScreen,
      ),
      body: Container(
        decoration: BoxDecoration(
          color:
              selectedColor[DataModel.currentNote.notecolor - 1].primaryColor,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: TextField(
          autocorrect: false,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: 10000000000,
          controller: myController,
          style: TextStyle(
              fontFamily: listOfFonts[DataModel.currentNote.notefont],
              fontSize: DataModel.fontSizeCurrent,
              color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: DataModel.fontSizeCurrent, color: Colors.black45),
            contentPadding: const EdgeInsets.all(20.0),
          ),
        ),
      ),
    );
  }
}
