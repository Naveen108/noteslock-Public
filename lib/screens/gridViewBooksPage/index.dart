//BooksGridPage
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/floating_action_button.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:noteslock/widgets/custom_drawer.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

class BooksGridPage extends StatefulWidget {
  DataModel dataModel;

  BooksGridPage({this.dataModel});
  @override
  _BooksGridPageState createState() =>
      _BooksGridPageState(dataModel: dataModel);
}

class _BooksGridPageState extends State<BooksGridPage> {
  final index = 0;
  final DataModel dataModel;
  _BooksGridPageState({this.dataModel});
  UserModel userModel = UserModel();
  BannerAd _bannerAdBookScreen;
  bool bannerOn;
  final keyBook = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);

    _bannerAdBookScreen = userModel.craeteBannerAd()
      ..load().then((data) {
        bannerOn = data;
        if (data == true) {
          _bannerAdBookScreen.show();
        } else {
          print('Error loading banner');
        }
      });
  }

  @override
  void dispose() {
    // if (bannerOn) {
      // _bannerAdBookScreen.dispose();
    // }
    super.dispose();
  }

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
      cardWidth = screensizes.width / 2.2;
      cardHeight = 150.0;
    }

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete ${DataModel.currentBook.bookName} ?"),
            content: Text("${DataModel.currentBook.bookSubtitle}"),
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
                          'DELETE FROM books WHERE ${DataModel.currentBook.bookId}=bookid ';
                      await dataModel.transaction(5, query1).then((data) async {
                        String query1 =
                            'DELETE FROM notes WHERE ${DataModel.currentBook.bookId}=bookid ';
                        await dataModel
                            .transaction(5, query1)
                            .then((data) async {
                          await dataModel.transaction(6, fethBooks);
                        });
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
      UserModel.currentBookName = DataModel.listOfBooks[index].bookName;
      UserModel.currentBookId = DataModel.listOfBooks[index].bookId;
      // if (bannerOn) {
      //   _bannerAdBookScreen.dispose();
      // }

      DataModel.currentBook = DataModel.listOfBooks[index];
      // print(
      //     'the curent book id found on tap is ${DataModel.currentBook.bookId}');
      String fetchNotes = '''
                                      SELECT *
                                      FROM notes
                                      WHERE
                                      '${DataModel.currentBook.bookId}' = bookid
                                      ''';
      await dataModel.transaction(4, fetchNotes).then((data) {
        // print(
        //     'final return from transaction notes on book page moving for navigate');
        Navigator.pushReplacement(
            context,
            SlideRightRoute(
                widget: NotesPage(
              dataModel: dataModel,
            )));
      });
    }

    Widget gridORListP() {
      if (DataModel.gird == true) {
        return GridView.builder(
            itemCount: DataModel.listOfBooks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boxcount),
            itemBuilder: (BuildContext context, int index) {
              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                Image image2Display = listBookIconImages[
                        DataModel.listOfBooks[index].bookicon - 1]
                    .child;

                return GestureDetector(
                    onTap: () {
                      ontap(index);
                    },
                    onLongPress: () {
                     // print('u pressed long');
                      DataModel.currentBook = DataModel.listOfBooks[index];
                      if (DataModel.currentBook.bookId != 4) {
                        _showDialog();
                      } else {
                        final snackbar = SnackBar(
                          content: Text('Quick Notes Book can\'t be Deleted!'),
                        );
                        keyBook.currentState.showSnackBar(snackbar);
                      }
                    },
                    child: Card(
                        color: selectedColor[
                                DataModel.listOfBooks[index].bookcolor - 1]
                            .primaryColor,
                        child: GridTile(
                          child: Center(
                            child: ListTile(
                              title: Text(
                                DataModel.listOfBooks[index].bookSubtitle,
                                maxLines: 4,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: listOfFonts[
                                      DataModel.listOfBooks[index].bookFont],
                                ),
                              ),
                            ),
                          ),
                          footer: ListTile(
                            title: Text(
                              DataModel.listOfBooks[index].category,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              DataModel.listOfBooks[index].lastEdit,
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
                              DataModel.listOfBooks[index].bookName,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: listOfFonts[
                                      DataModel.listOfBooks[index].bookFont],
                                  fontSize: 18.0),
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
                        DataModel.listOfBooks[index].bookicon - 1]
                    .child;
                return Card(
                    color: selectedColor[
                            DataModel.listOfBooks[index].bookcolor - 1]
                        .primaryColor,
                    child: ListTile(
                      leading: Image(
                        image: image2Display.image,
                        width: 30.0,
                        height: 30.0,
                      ),
                      title: Text(
                        DataModel.listOfBooks[index].bookName,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: listOfFonts[
                              DataModel.listOfBooks[index].bookFont],
                        ),
                      ),
                      subtitle: Text(
                        DataModel.listOfBooks[index].bookSubtitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: listOfFonts[
                              DataModel.listOfBooks[index].bookFont],
                        ),
                      ),
                      trailing: Text(
                        DataModel.listOfBooks[index].lastEdit,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onTap: () async {
                        ontap(index);
                      },
                      onLongPress: () async {
                        print('u pressed long');
                        DataModel.currentBook = DataModel.listOfBooks[index];
                        if (DataModel.currentBook.bookId != 4) {
                          _showDialog();
                        } else {
                          final snackbar = SnackBar(
                            content:
                                Text('Quick Notes Book can\'t be Deleted!'),
                          );
                          keyBook.currentState.showSnackBar(snackbar);
                        }
                      },
                    ));
              })),
          itemCount: DataModel.listOfBooks.length,
        );
      }
    }

    return ScopedModel<DataModel>(
      model: dataModel,
      child: Scaffold(
        key: keyBook,
        floatingActionButton: FancyFab(dataModel: dataModel),
        appBar: AppBar(
          actions: <Widget>[],
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Text(
              'Note Books',
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
         // bannerAdonScreen: _bannerAdBookScreen,
        ),
        body: ScopedModelDescendant<DataModel>(
            rebuildOnChange: true,
            builder: (context, child, dataModel) {
              print("inside menu screen = ${DataModel.listOfBooks.length}");
              //change mode to be implemented here for grid view and list view option
              return DataModel.listOfBooks.length != 0
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
                      child: listBookIconImages[32].child,
                    ));
            }),
      ),
      //),
    );
  }
}
