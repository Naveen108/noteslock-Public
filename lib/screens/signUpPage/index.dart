import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/gridViewBooksPage/index.dart';
import 'package:noteslock/widgets/box_button.dart';
import 'package:noteslock/widgets/input_text_form_field.dart';
import 'package:noteslock/widgets/input_pass_form_field.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => new _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final scaffoldSignUpKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _userName;
  String _password;
  bool rememberPassword;
  UserModel userModel = UserModel();
  // BannerAd _bannerAdSingupScreen;
  bool bannerFound;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdSingupScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerFound = data;
    //     if (data == true) {
    //       _bannerAdSingupScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
  }

  @override
  void dispose() {
    // if (bannerFound) {
    //   _bannerAdSingupScreen.dispose();
    // }
    super.dispose();
  }

  Future _perfomSingUp() async {
    print('Signup called');
    DataModel dataModel = DataModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userpass', _password);
    prefs.setString('username', _userName);
    prefs.setBool('lock', true);
    prefs.setBool('grid', true);
    prefs.setString('locktype', 'Key Pad');
    prefs.setString('quickNote', 'OFF');
    DataModel.lockType = 'Key Pad';
    DataModel.autoLock = 'ON';
    DataModel.quickNote = 'OFF';
    DataModel.gird = true;
    print(prefs.getString('username'));
    print(prefs.getString('userpass'));
    
    UserModel.username = _userName;
    UserModel.userpass = _password;
    dataModel.deleteDB().then((data) async {
      //now open new DB
      await dataModel.createOpenDB().then((data) async {
        await dataModel.queryFunction(fethBooks).then((data) async {
          await dataModel.bookListMaker(data);
        });
      });
    });
    // if (bannerFound) {
    //   _bannerAdSingupScreen.dispose();
    // }
    //navigate to the book menu
    Navigator.pushReplacement(
        context,
        SlideRightRoute(
            widget: BooksGridPage(
          dataModel: dataModel,
        )));
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _perfomSingUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Scrollable.ensureVisible(context);
    return Scaffold(
        key: scaffoldSignUpKey,
        backgroundColor: Colors.white70,
        body: ListView(
          physics: ScrollPhysics(),
          children: <Widget>[
            Container(
              height: screenSize.height,
              width: screenSize.width,
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                          ),
                          child: Center(
                            child: Text(
                              'notesLock',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 30.0,
                            //bottom: 20.0,
                          ),
                          child: CircleAvatar(
                            radius: 80.0,
                            child: Image(
                              image: ExactAssetImage("assets/noteslockicon.png",
                                  scale: 2.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 30.0,
                          ),
                          child: Text(
                            'Welcome! Let\'s Set things up',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                    //top: 35.0,
                                    left: 30.0,
                                    right: 30.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InputTextFormField(
                                      texttype: TextInputType.text,
                                      hinttext: "Username",
                                      obscure: false,
                                      iconType: Icon(Icons.vpn_key),
                                      errortext: "Enter username",
                                      errorcheck: "",
                                      onSave: (val) => _userName = val,
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 10.0,
                                    left: 30.0,
                                    right: 30.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InputPassFormField(
                                      obscure: true,
                                      texttype: TextInputType.text,
                                      hinttext: "Password",
                                      iconType: Icon(Icons.vpn_key),
                                      errortext: "Enter password",
                                      errorcheck: "",
                                      onSave: (val) => _password = val,
                                    ),
                                  )),
                              Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0,
                                          left: 30.0,
                                          right: 30.0,
                                          bottom: 20.0),
                                      child: Center(
                                        child: BoxButton(
                                          width: screenSize.width / 1.1,
                                          height: 50.0,
                                          elevation: 0.0,
                                          buttonName: 'All Set',
                                          onPressed: () {
                                            _submit();
                                          },
                                          buttonTextStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                          textFieldColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
