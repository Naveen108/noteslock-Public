import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/gridViewBooksPage/index.dart';
import 'package:noteslock/screens/notesPage/index.dart';
import 'package:noteslock/widgets/box_button.dart';
import 'package:noteslock/widgets/custom_Input_pass_form_field.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  String lockType;
  LoginPage({this.lockType});
  @override
  _LoginPage createState() => new _LoginPage(lockType: lockType);
}

class _LoginPage extends State<LoginPage> {
  String lockType;
  _LoginPage({this.lockType});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();
  //BannerAd _bannerAdNoteEditScreen;
  bool bannerOn;
  @override
  void initState() {
    super.initState();

    // FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdNoteEditScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data) {
    //       _bannerAdNoteEditScreen.show();
    //     }
    //   });
  }

  @override
  void dispose() {
    // if (bannerOn) {
    //   _bannerAdNoteEditScreen.dispose();
    // }

    super.dispose();
  }

  String _password;
  Future _perfomSingUp() async {
    if (_password == UserModel.userpass) {
      print('User Pass matched !');
      //navigate to the menu
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('lock', false);
      DataModel dataModel = DataModel();
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
    print('Signup called');
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _perfomSingUp();
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';

  Future<Null> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth
          .authenticateWithBiometrics(
              localizedReason: 'notesLock need to scan Finger Print',
              useErrorDialogs: true,
              stickyAuth: false)
          .then((data) {
        if (data == true) {
          DataModel dataModel = DataModel();
          Navigator.pushReplacement(
              context,
              SlideRightRoute(
                  widget: BooksGridPage(
                dataModel: dataModel,
              )));
        } else {
          print('wrong finger print in authentication');
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Widget lockTypeWidget() {
      if (lockType == 'Key Pad') {
        return Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    top: 35.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomInputTextFormField(
                      passvalidator: (val) => val != UserModel.userpass
                          ? 'Krishna...Wrong Password'
                          : null,
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
                          top: 30.0, left: 30.0, right: 30.0, bottom: 30.0),
                      child: Center(
                        child: BoxButton(
                          width: screenSize.width / 1.1,
                          height: 50.0,
                          elevation: 0.0,
                          buttonName: 'UNLOCK',
                          onPressed: () {
                            _submit();
                          },
                          buttonTextStyle:
                              TextStyle(fontSize: 14.0, color: Colors.white),
                          textFieldColor: Colors.blue,
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        );
      } else if (lockType == 'Finger Print') {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) async => _authenticate());
          return Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
                child: IconButton(
              icon: Icon(
                Icons.fingerprint,
                color: Colors.blue,
                size: 60.0,
              ),
              onPressed: () {
                _authenticate();
              },
            )),
          );
        });
      }
    }

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white70,
        body: ListView(
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
                            top: 40.0,
                            left: 30.0,
                          ),
                          child: Text(
                            'Welcome back !  ' + UserModel.username,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                        ),
                        lockTypeWidget(),
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
