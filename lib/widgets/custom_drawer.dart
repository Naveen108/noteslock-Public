import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/GridViewBooksPage/index.dart';
import 'package:noteslock/screens/aboutPage/index.dart';
import 'package:noteslock/screens/loginPage/index.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/screens/settingPage/index.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final int index;
  //BannerAd bannerAdonScreen;this.bannerAdonScreen
  DataModel dataModel = DataModel();
  CustomDrawer({this.index, });
  @override
  Widget build(BuildContext context) {
    print(UserModel.username);
    //logout function

    _lockMe() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lock', true);
      // bannerAdonScreen.dispose();
      // Navigator
      //     .of(context)
      //     .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      Navigator.pushAndRemoveUntil(
        context,
        SlideRightRoute(
          widget: LoginPage(lockType: DataModel.lockType),
        ),
        ModalRoute.withName('/'),
      );
    }

    Size screensizes = MediaQuery.of(context).size;
    return Drawer(
      elevation: 10.0,
      child: Container(
        height: screensizes.height / 2.0,
        width: screensizes.width / 2.0,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage("assets/notesimage.jpg"),
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(98, 0, 238, 0.5), BlendMode.dstATop),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                    width: screensizes.width / 4.0,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                      child: CircleAvatar(
                        radius: 60.0,
                        child: Image(
                          image: ExactAssetImage("assets/noteslockicon.png",
                              scale: 4.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                    width: screensizes.width / 2.2,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 0.0,
                        left: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'notesLock',
                              style: TextStyle(
                                  decorationStyle: TextDecorationStyle.dotted,
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
                                  color: Colors.black87.withOpacity(0.9)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Divider(height: 5.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'USERNAME: ' + UserModel.username,
                      ),
                    ),
                    onTap: () {}),
              ],
            ),
            Divider(height: 5.0),
            Divider(height: 5.0),
            ListTile(
                title: Text("BOOKS"),
                leading: Image(
                  image: ExactAssetImage('assets/books2.png', scale: 2.5),
                ),
                onTap: () {
                  if (index != 0) {
                    // bannerAdonScreen.dispose();
                    Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                        widget: BooksGridPage(
                          dataModel: dataModel,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            Divider(height: 5.0),
            ListTile(
                title: Text("NOTES"),
                leading: Image(
                  image: ExactAssetImage('assets/notes.png', scale: 2.5),
                ),
                onTap: () async {
                  print('called notes with index = $index');
                  if (index != 1) {
                    if (DataModel.currentBook == null ||
                        DataModel.currentBook == 4) {
                      DataModel.listOfBooks.forEach((item) {
                        if (item.bookId == 4) {
                          DataModel.currentBook = item;
                        }
                      });

                      print(
                          'the curent book id found on tap is ${DataModel.currentBook.bookId}');
                      String fetchNotes = '''
                                      SELECT *
                                      FROM notes
                                      WHERE
                                      4 = bookid
                                      ''';
                      await dataModel.transaction(4, fetchNotes).then((data) {
                        print(
                            'final return from transaction notes on book page moving for navigate');

                        // bannerAdonScreen.dispose();
                        Navigator.pushReplacement(
                            context,
                            SlideRightRoute(
                                widget: NotesPage(
                              dataModel: dataModel,
                            )));
                      });
                    } else {
                      print('the current id is ${DataModel.currentBook.bookId}');
                      String fetchNotes = '''
                                      SELECT *
                                      FROM notes
                                      WHERE
                                      ${DataModel.currentBook.bookId} = bookid
                                      ''';
                      await dataModel.transaction(4, fetchNotes).then((data) {
                        print(
                            'final return from transaction notes on book page moving for navigate');

                        // bannerAdonScreen.dispose();
                        Navigator.pushReplacement(
                            context,
                            SlideRightRoute(
                                widget: NotesPage(
                              dataModel: dataModel,
                            )));
                      });
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                }),
            Divider(height: 5.0),
            ListTile(
              title: Text("LOCK NOTES"),
              leading: Image(
                image: ExactAssetImage('assets/key.png', scale: 2.5),
              ),
              onTap: () {
                _lockMe();
              },
            ),
            Divider(height: 5.0),
            ListTile(
              title: Text("SETTINGS"),
              leading: Icon(
                Icons.settings,
                color: Colors.blue,
                size: 25.0,
              ),
              onTap: () {
                // bannerAdonScreen.dispose();
                //_resetDeleteAccount();
                Navigator.pushReplacement(
                    context, SlideRightRoute(widget: SettingsPage()));
              },
            ),
            Divider(height: 5.0),
            ListTile(
              title: Text("ABOUT APP"),
              leading: Icon(
                Icons.apps,
                color: Colors.blue,
                size: 25.0,
              ),
              onTap: () {
                // bannerAdonScreen.dispose();
                //_resetDeleteAccount();
                Navigator.pushReplacement(
                    context, SlideRightRoute(widget: AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
