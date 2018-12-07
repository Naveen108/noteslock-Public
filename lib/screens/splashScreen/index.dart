//Splash screen
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/gridViewBooksPage/index.dart';
import 'package:noteslock/screens/loginPage/index.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/screens/signUpPage/index.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    pathfunctions();
    connect2Db();
  }

  DataModel dataModel = DataModel();

  pathfunctions() async {
    await dataModel.requestAppDocumentsDirectory().then((data) {
      if (data == true) {
      } else {
        print('Error in getting DB path $data');
      }
    });
  }

  bool lock;
  Future<Null> connect2Db() async {
    print('Hi connect@Db called here');
    await new Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().length != 0) {
      print(prefs.getKeys().length);
      if (prefs.get('userpass') != null) {
        if (prefs.get('userpass').length != 0) {
          print('any user ? ' + prefs.getString('username'));
          UserModel.userpass = prefs.getString('userpass');
          UserModel.username = prefs.getString('username');
          print(prefs.getString('username'));
          lock = prefs.getBool('lock');
          DataModel.gird = prefs.getBool('grid');
          DataModel.lockType = prefs.getString('locktype');
          DataModel.quickNote = prefs.getString('quickNote');
          String fetchNotes = '''
                              SELECT *
                              FROM notes
                              WHERE
                              4 = bookid
                              ''';
          dataModel.openDB().then((data) {
            dataModel.queryFunction(fethBooks).then((data) async {
              dataModel.bookListMaker(data);
              dataModel.transaction(4, fetchNotes).then((data) {
                if (lock == true) {
                  DataModel.autoLock = 'ON';
                   if (DataModel.quickNote == 'ON') {
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            widget: NotesPage(
                          dataModel: dataModel,
                        )));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            widget: BooksGridPage(
                          dataModel: dataModel,
                        )));
                  }
                } else {
                  DataModel.autoLock = 'OFF';
                  if (DataModel.quickNote == 'ON') {
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            widget: NotesPage(
                          dataModel: dataModel,
                        )));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            widget: BooksGridPage(
                          dataModel: dataModel,
                        )));
                  }
                }
              });
            });
          });

          print('${DataModel.gird} is the grid value');
        } else {
          Timer(Duration(seconds: 5), onClose);
          print("not navigate pass length is zero means user reseted password");
        }
      } else {
        Timer(Duration(seconds: 5), onClose);
        print("not navigate after checking null");
      }
    } else {
      Timer(Duration(seconds: 5), onClose);
      print("not navigate no keys found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blue),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      child: Image(
                        image: ExactAssetImage("assets/noteslockicon.png",
                            scale: 2.5),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "notesLock",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: Text(
                      "keep your notes secret",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }

  void onClose() {
    Navigator.pushReplacement(context, SlideRightRoute(widget: SignUpPage()));
  }
}
