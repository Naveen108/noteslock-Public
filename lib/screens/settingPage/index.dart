//NotePage
import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/GridViewBooksPage/index.dart';
import 'package:noteslock/screens/signUpPage/index.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/Input_text_form_field.dart';
import 'package:noteslock/widgets/custom_Input_pass_form_field.dart';
import 'package:noteslock/widgets/custom_drawer.dart';
import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final index = 1;
  String user = UserModel.username;
  DataModel dataModel = DataModel();
  String autoLock = DataModel.autoLock;
  String quickNote = DataModel.quickNote;
  String lockType = DataModel.lockType;
  bool currentView = DataModel.gird;
  String setUserFinally = UserModel.username;

  String setAutoLockFinally = DataModel.autoLock;
  String setQuickNoteFinally = DataModel.quickNote;
  String setLockTypeFinally = DataModel.lockType;
  bool setCurrentViewFinally = DataModel.gird;
  UserModel userModel = UserModel();
  // BannerAd _bannerAdSettingsScreen;
  bool bannerOn;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdSettingsScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn = data;
    //     if (data == true) {
    //       _bannerAdSettingsScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
  }

  @override
  void dispose() {
    // if (bannerOn) {
    //   _bannerAdSettingsScreen.dispose();
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newUserName;
    String checkPass;
    final formKey = GlobalKey<FormState>();
    final formViewLockKey = GlobalKey<FormState>();

    final formLockTypeKey = GlobalKey<FormState>();
    final formAutoLockKey = GlobalKey<FormState>();
    final formQuickNoteKey = GlobalKey<FormState>();
    final formResetKey = GlobalKey<FormState>();
    final scaffoldSettingPageKey = GlobalKey<ScaffoldState>();
    final formPassKey = GlobalKey<FormState>();
    Size screensizes = MediaQuery.of(context).size;

    _perfomSetPass() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userpass', checkPass);
      UserModel.userpass = prefs.getString('userpass');
    }

    changePas() async {
      final form = formPassKey.currentState;
      print('in setPass');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomSetPass();

        Navigator.of(context).pop();
      }
    }

    _perfomSetUser() async {
      print('called set username $newUserName');
      setState(() {
        print('called setstate username $newUserName');
        user = newUserName;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', newUserName);
      UserModel.username = prefs.getString('username');
    }

    setUser() {
      final form = formKey.currentState;
      print('in setUSer');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _perfomSetUser();

        Navigator.of(context).pop();
      }
    }

    void _changeUserName() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Currently User Name is ${UserModel.username} !"),
            content: Container(
              height: 150.0,
              width: 200.0,
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InputTextFormField(
                              obscure: false,
                              texttype: TextInputType.text,
                              hinttext: "New username",
                              iconType: Icon(Icons.work),
                              errortext: "Enter new username here",
                              errorcheck: "",
                              onSave: (val) => newUserName = val,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CustomInputTextFormField(
                              passvalidator: (val) => val != UserModel.userpass
                                  ? 'Wrong Password'
                                  : null,
                              obscure: true,
                              texttype: TextInputType.text,
                              hinttext: "Your Password",
                              iconType: Icon(Icons.work),
                              errortext: "Enter Password here",
                              errorcheck: "",
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
                      print('called set username');
                      setUser();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    void _changePassword() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Passoward"),
            content: Container(
              height: 150.0,
              width: 200.0,
              child: Form(
                  key: formPassKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CustomInputTextFormField(
                              passvalidator: (val) => val != UserModel.userpass
                                  ? 'Wrong Password'
                                  : null,
                              obscure: true,
                              texttype: TextInputType.text,
                              hinttext: "Current Password",
                              iconType: Icon(Icons.work),
                              errortext: "Enter Current Password here",
                              errorcheck: "",
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CustomInputTextFormField(
                              passvalidator: (val) =>
                                  val.length < 0 ? 'Enter Password' : null,
                              obscure: true,
                              texttype: TextInputType.text,
                              hinttext: "New Password",
                              iconType: Icon(Icons.work),
                              errortext: "Enter New Password here",
                              errorcheck: "",
                              onSave: (val) => checkPass = val,
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
                      changePas();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    resetDeleteAccount() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userpass');
      await prefs.remove('username');
      await dataModel.transaction(3, '').then((data) {
        Navigator.pushReplacement(
          context,
          SlideRightRoute(widget: SignUpPage()),
        );
      });
    }

    resetUser() {
      final form = formResetKey.currentState;
      print('in resetUser');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        resetDeleteAccount();
      }
    }

    void _changeReset() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Are you Sure ?"),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formResetKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CustomInputTextFormField(
                              passvalidator: (val) => val != UserModel.userpass
                                  ? 'Wrong Password'
                                  : null,
                              obscure: true,
                              texttype: TextInputType.text,
                              hinttext: "Your Password",
                              iconType: Icon(Icons.work),
                              errortext: "Enter Password here",
                              errorcheck: "",
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
                      print('called reset user');
                      resetUser();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    autoLockAccount() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (autoLock == 'OFF') {
        await prefs.setBool('lock', false);
      } else if (autoLock == 'ON') {
        await prefs.setBool('lock', true);
      }
    }

    autoLockUser() {
      final form = formAutoLockKey.currentState;
      print('in autolock reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        DataModel.autoLock = setAutoLockFinally;
        autoLock = setAutoLockFinally;
        autoLockAccount();
        Navigator.of(context).pop();
      }
    }

    bool _canCheckBiometrics;
    List<BiometricType> _availableBiometrics;
    String _authorized = 'Not Authorized';
    final LocalAuthentication auth = LocalAuthentication();
    Future<Null> _checkBiometrics() async {
      bool canCheckBiometrics;
      try {
        canCheckBiometrics = await auth.canCheckBiometrics;
      } on PlatformException catch (e) {
        print(e);
      }
      if (!mounted) return;

      setState(() {
        _canCheckBiometrics = canCheckBiometrics;

        print('canCheckBiometrics $_canCheckBiometrics');
      });
    }

    Future<Null> _getAvailableBiometrics() async {
      List<BiometricType> availableBiometrics;
      try {
        availableBiometrics = await auth.getAvailableBiometrics();
      } on PlatformException catch (e) {
        print(e);
      }
      if (!mounted) return;

      setState(() {
        _availableBiometrics = availableBiometrics;
        print('_getAvailableBiometrics $_availableBiometrics');
      });
    }

    setLockType() async {  setState(() { lockType = setLockTypeFinally;
            });
     
      DataModel.lockType = setLockTypeFinally;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (lockType == 'Finger Print') {
        await prefs.setString('locktype', 'Finger Print');
      } else if (lockType == 'Key Pad') {
        await prefs.setString('locktype', 'Key Pad');
      }
    }

    changelockType() {
      final form = formLockTypeKey.currentState;
      print('in autolock reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();
        _getAvailableBiometrics().then((data) {
          _checkBiometrics().then((data) {
            print('in changeLockType is $_canCheckBiometrics');
            if (_canCheckBiometrics) {
              setLockType();
            } else {
              final snackbar = SnackBar(
                content: Text('Device Error,HariBol'),
              );
              scaffoldSettingPageKey.currentState.showSnackBar(snackbar);
            }
          });
        });

        Navigator.of(context).pop();
      }
    }

    _changeLockType() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Lock Type ?"),
            content: Container(
              height: 75.0,
              width: 400.0,
              child: Form(
                  key: formLockTypeKey,
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
                                    'Currently Lock Type \nis  ${lockType}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 40.0,
                                        value: setLockTypeFinally,
                                        items: listlockType,
                                        onChanged: (String val) {
                                          setState(() {
                                            setLockTypeFinally = val;
                                            state.didChange(setLockTypeFinally);
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
                      print('called set autolock  type user');
                      changelockType();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    setQuickNoteType() async {
      setState(() {
               quickNote = setQuickNoteFinally;
            });
     
      DataModel.quickNote = setQuickNoteFinally;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (quickNote == 'ON') {
        await prefs.setString('quickNote', 'ON');
      } else if (quickNote == 'OFF') {
        await prefs.setString('quickNote', 'OFF');
      }
    }

    changeQuickNoteType() {
      final form = formQuickNoteKey.currentState;
      print('in formQuickNoteKey reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();

        setQuickNoteType();

        Navigator.of(context).pop();
      }
    }

    _changeQuickNoteType() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Quick Note Setting ?"),
            content: Container(
              height: 75.0,
              width: 400.0,
              child: Form(
                  key: formQuickNoteKey,
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
                                    'Currently Quick Note  \nis  ${quickNote}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 40.0,
                                        value: setQuickNoteFinally,
                                        items: listautolock,
                                        onChanged: (String val) {
                                          setState(() {
                                            setQuickNoteFinally = val;
                                            state.didChange(setQuickNoteFinally);
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
                      print('called set autolock  type user');
                      changeQuickNoteType();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    autoViewAccount() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (DataModel.gird == true) {
        await prefs.setBool('grid', true);
      } else if (DataModel.gird == false) {
        await prefs.setBool('grid', false);
      }
    }

    autoViewUser() {
      final form = formViewLockKey.currentState;
      print('in autolock reset');
      bool f = form.validate();
      print(f);
      if (f) {
        print('${form.validate()}');
        form.save();  setState(() {  currentView = setCurrentViewFinally;
            });
     
       
        DataModel.gird = currentView;

        autoViewAccount();
        Navigator.of(context).pop();
      }
    }

    _changeView() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String view = DataModel.gird == true ? 'Grid' : 'List';
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Auto Lock Settings?"),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formViewLockKey,
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
                                    'Currently View  \nis ' + view,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 40.0,
                                        value: setCurrentViewFinally,
                                        items: listview,
                                        onChanged: (bool val) {
                                          setState(() {
                                            print(
                                                'Setstate was called in view');

                                            setCurrentViewFinally = val;
                                            state.didChange(
                                                setCurrentViewFinally);
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
                      print('called set view user');
                      autoViewUser();
                    },
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    _changeAutoLock() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Change Auto Lock Settings?"),
            content: Container(
              height: 75.0,
              width: 200.0,
              child: Form(
                  key: formAutoLockKey,
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
                                    'Currently autoLock \nis  ${autoLock}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              new FormField(builder: (FormFieldState state) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 40.0,
                                        value: setAutoLockFinally,
                                        items: listautolock,
                                        onChanged: (String val) {
                                          setState(() {
                                            print(
                                                'Setstate was called in autolock');

                                            setAutoLockFinally = val;
                                            state.didChange(setAutoLockFinally);
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
                      print('called set autolcok user');
                      autoLockUser();
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
      key: scaffoldSettingPageKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: () {
            print('called navigator');
            // if (bannerOn) {
            //   _bannerAdSettingsScreen.dispose();
            // }
            Navigator.pushReplacement(
                context,
                SlideRightRoute(
                    widget: BooksGridPage(
                  dataModel: dataModel,
                )));
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          // action button
        ],
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          overflow: TextOverflow.clip,
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: CustomDrawer(
        index: index,
        // bannerAdonScreen: _bannerAdSettingsScreen,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _changeUserName();
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
                              Text('Change User Name : '),
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
                              Text(user),
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
                  _changePassword();
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
                              Text('Change Password : '),
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
                              Text('Tap to change'),
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
                  _changeAutoLock();
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
                              Text('Auto Lock  : '),
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
                              Text(autoLock),
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
                  _changeLockType();
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
                              Text('Lock Type  : '),
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
                              Text(lockType),
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
                  _changeQuickNoteType();
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
                              Text('Quick Note   : '),
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
                              Text(quickNote),
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
                  _changeView();
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
                              Text('Change View : '),
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
                              Text(currentView != true ? 'List' : 'Grid'),
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
                  _changeReset();
                },
                child: Card(
                  color: Colors.red[100],
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
                              Text('Reset Account : '),
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
                              Text('Tap to Reset everything'),
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
