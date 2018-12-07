//NotePage
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/noteEditPage/index.dart';
import 'package:noteslock/screens/settingBook/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/floating_action_button_notes.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:noteslock/widgets/custom_drawer.dart';

class NotesPage extends StatefulWidget {
  DataModel dataModel;

  NotesPage({this.dataModel});
  @override
  _NotesPageState createState() => _NotesPageState(dataModel: dataModel);
}

class _NotesPageState extends State<NotesPage> {
  final index = 1;
  DataModel dataModel;

  final keyNote = GlobalKey<ScaffoldState>();
  UserModel userModel = UserModel();
  // BannerAd _bannerAdNoteScreen;
  // InterstitialAd _innterstitialAdNoteScreen;
  _NotesPageState({this.dataModel});
  bool bannerOn;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdNoteScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data == true) {
    //       _bannerAdNoteScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
    setState(() {
      if (DataModel.currentBook != null) {
        pageTitle = DataModel.currentBook.bookName;
      } else {
        print('setting the page name herer in notes');
        pageTitle = 'Quick Notes';
      }
    });
  }

  @override
  void dispose() {
    // if (bannerOn) {
    //   _bannerAdNoteScreen.dispose();
    // }
    super.dispose();
  }

  String pageTitle;
  @override
  Widget build(BuildContext context) {
    Size screensizes = MediaQuery.of(context).size;

    int boxcount;
    double cardWidth;
    double cardHeight;
    if (screensizes.width / 3 >= 170.0) {
      boxcount = 3;
      cardWidth = screensizes.width / 3.1;
      cardHeight = 150.0;
    } else {
      boxcount = 2;
      cardWidth = screensizes.width / 2.5;
      cardHeight = 120.0;
    }

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete ${DataModel.currentNote.noteTitle} ?"),
            content: Text("${DataModel.currentNote.noteContent}"),
            actions: <Widget>[
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
                      Icons.delete,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      String query1 =
                          'DELETE FROM notes WHERE ${DataModel.currentNote.noteId}=noteid ';
                      await dataModel.transaction(5, query1).then((data) async {
                        String fetchNotes =
                            'SELECT * FROM notes WHERE ${DataModel.currentBook.bookId}=bookid';
                        await dataModel.transaction(4, fetchNotes);
                        DataModel.currentNote = null;
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    ontap(int index) async {
      DataModel.currentNote = DataModel.listOfNotes[index];
      // if (bannerOn) {
      //   _bannerAdNoteScreen.dispose();
      // }

      print(DataModel.currentNote.noteContent);
      Navigator.pushReplacement(
        context,
        SlideRightRoute(
          widget: NoteEditPage(
            dataModel: dataModel,
            noteData: DataModel.listOfNotes[index],
          ),
        ),
      );
    }

    Widget gridORListP() {
      if (DataModel.gird == true) {
        return GridView.builder(
            itemCount: DataModel.listOfNotes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boxcount),
            itemBuilder: (BuildContext context, int index) {
              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                Image image2Display = listBookIconImages[
                        DataModel.listOfNotes[index].noteicon - 1]
                    .child;

                return GestureDetector(
                    onTap: () {
                      ontap(index);
                    },
                    onLongPress: () {
                      DataModel.currentNote = DataModel.listOfNotes[index];
                      _showDialog();
                    },
                    child: Card(
                        color: selectedColor[
                                DataModel.listOfNotes[index].notecolor - 1]
                            .primaryColor,
                        child: GridTile(
                          child: Center(
                            child: ListTile(
                              title: Text(
                                DataModel.listOfNotes[index].noteContent,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: listOfFonts[
                                      DataModel.listOfNotes[index].notefont],
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                          footer: ListTile(
                            title: Text(
                              DataModel.listOfNotes[index].bookcategory,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              DataModel.listOfNotes[index].lastEditTime,
                              maxLines: 2,
                            ),
                          ),
                          header: ListTile(
                            leading: Image(
                              image: image2Display.image,
                              width: 30.0,
                              height: 30.0,
                            ),
                            title: Text(
                              DataModel.listOfNotes[index].noteTitle,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: listOfFonts[
                                    DataModel.listOfNotes[index].notefont],
                              ),
                            ),
                          ),
                        )));
              });
            });
      } else if (DataModel.gird != true) {
        return ListView.builder(
          itemBuilder: (context, index) => (LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                Image image2Display = listBookIconImages[
                        DataModel.listOfNotes[index].noteicon - 1]
                    .child;
                return Card(
                    color: selectedColor[
                            DataModel.listOfNotes[index].notecolor - 1]
                        .primaryColor,
                    child: ListTile(
                      leading: Image(
                        image: image2Display.image,
                        width: 30.0,
                        height: 30.0,
                      ),
                      title: Text(
                        DataModel.listOfNotes[index].noteTitle,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: listOfFonts[
                              DataModel.listOfNotes[index].notefont],
                        ),
                      ),
                      trailing: Text(
                        DataModel.listOfNotes[index].lastEditTime,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      subtitle: Text(
                        DataModel.listOfNotes[index].noteContent,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: listOfFonts[
                              DataModel.listOfNotes[index].notefont],
                        ),
                        maxLines: 3,
                      ),
                      onTap: () {
                        ontap(index);
                      },
                      onLongPress: () {
                        DataModel.currentNote = DataModel.listOfNotes[index];
                        _showDialog();
                      },
                    ));
              })),
          itemCount: DataModel.listOfNotes.length,
        );
      }
    }

    return ScopedModel<DataModel>(
      model: dataModel,
      child: Scaffold(
        key: keyNote,
        floatingActionButton:
            FancyFabNote(dataModel: dataModel, scaffoldKey: keyNote),
        appBar: AppBar(
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                if (DataModel.currentBook != null) {
                  // _innterstitialAdNoteScreen = userModel.craeteInterstitialAd();
                  // _innterstitialAdNoteScreen.load().then((data) {
                  //   if (data == true) {
                  //     _innterstitialAdNoteScreen.show().then((data) {
                        Navigator.pushReplacement(context,
                            SlideRightRoute(widget: BookSettingsPage()));
                    //   });
                    // } else {
                    //   print(
                    //       'Error loading banner intern on opening the setting page for books');
                    // }
                  // });
                } else {
                  final snackbar = SnackBar(
                    content: Text('You need to create a book or select one'),
                  );
                  keyNote.currentState.showSnackBar(snackbar);
                }
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
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
              overflow: TextOverflow.clip,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        drawer: CustomDrawer(
          index: index,
          //bannerAdonScreen: _bannerAdNoteScreen,
        ),
        body: ScopedModelDescendant<DataModel>(
            rebuildOnChange: true,
            builder: (context, child, dataModel) {
              print("inside menu screen = ${DataModel.listOfNotes.length}");
              return DataModel.listOfNotes.length != 0
                  ? SizedBox(
                      width: screensizes.width / 1.0,
                      height: screensizes.height /
                          1.0, //- screensizes.height / 8.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(98, 0, 238, 0.1),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: gridORListP(),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.blue,
                      child: listBookIconImages[29].child,
                    ));
            }),
      ),
    );
  }
}
