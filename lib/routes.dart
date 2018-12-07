import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteslock/screens/gridViewBooksPage/index.dart';
import 'package:noteslock/screens/loginPage/index.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/screens/signUpPage/index.dart';
import 'package:noteslock/screens/splashScreen/index.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/signUp': (BuildContext context) => SignUpPage(),
    '/login': (BuildContext context) => LoginPage(),
    '/notesPage': (BuildContext context) => NotesPage(),
    '/booksGridPage': (BuildContext context) => BooksGridPage(),
  };

  Routes() {
    SystemChrome
        .setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      runApp(MaterialApp(
        title: "noteslock",
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: routes,
      ));
    });
  }
}
