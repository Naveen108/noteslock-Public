//NotePage
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/user_model.dart';
import 'package:noteslock/screens/gridViewBooksPage/index.dart';
import 'package:noteslock/widgets/custom_drawer.dart';

import 'package:noteslock/widgets/slide_right_route.dart';
import 'package:url_launcher/url_launcher.dart';
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final index = 1;
  String user = UserModel.username;
  DataModel dataModel = DataModel();
  String autoLock = DataModel.autoLock;
  bool currentView = DataModel.gird;
  UserModel userModel = UserModel();
  //BannerAd _bannerAdSettingsScreen;
  bool  bannerOn;
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: userModel.appID);
    // _bannerAdSettingsScreen = userModel.craeteBannerAd()
    //   ..load().then((data) {
    //     bannerOn=data;
    //     if (data == true) {
    //       _bannerAdSettingsScreen.show();
    //     } else {
    //       print('Error loading banner');
    //     }
    //   });
  
  }
  launchURL() async {
  const url = 'https://play.google.com/store/apps/details?id=naveensoni.noteslock';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  void dispose() {
  // if(bannerOn){

  //   _bannerAdSettingsScreen.dispose();
  // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   

    Size screensizes = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20.0,
          ),
          onPressed: () {
           // print('called navigator');
            // if(bannerOn){_bannerAdSettingsScreen.dispose();}
            
            Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            widget: BooksGridPage(
                          dataModel: dataModel,
                        )));
          },
        ),
        actions: <Widget>[
          // action button
        ],
        centerTitle: true,
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50.0),
            child: Text(
              'ABOUT APP',
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
      drawer: CustomDrawer(
        index: index,
        //bannerAdonScreen: _bannerAdSettingsScreen,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //_changeUserName();
                },
                child: Card(
                  child: SizedBox(
                    width: screensizes.width / 1.1,
                    height: screensizes.height / 2.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width / 2.2,
                          //height: screensizes.height / 5.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: ExactAssetImage(
                                    "assets/noteslockicon.png",
                                    scale: 3.5),
                              ),
                              Text(
                                'notesLock',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screensizes.width / 2.2,
                          //height: screensizes.height / 5.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                             Text(
                                UserModel.aboutApp,
                                style: TextStyle(fontSize: 10.0,fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: screensizes.width /1.1,
                         // height: screensizes.height / 4.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              
                             Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 40.0,),child: 
                               Text(
                                UserModel.developerNote1,
                                style: TextStyle(fontSize: 12.0,fontStyle: FontStyle.italic),
                              ),),
                               Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 40.0,),child: 
                               InkWell(onTap: ()async{launchURL();},
                                 child:  Text(
                               'Rate and Comment Here!',
                                style: TextStyle(fontSize: 12.0,fontStyle: FontStyle.italic,color: Colors.blue),
                              ),
                               )
                              ),
                            ],
                          ),
                        ),
                      
                      ],
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
