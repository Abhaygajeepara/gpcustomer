import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';


import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gpgroup/Service/Lang/LangChange.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(Provider<LangChange>.value(
      value: LangChange(),
      child: MyApp()),
  );
}

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences preferences;
  Locale _oldLocale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitting();
  }
  waitting()async{
    preferences = await SharedPreferences.getInstance();
    await preferences.setString('Version',"1.0.0");
    preferences.getString('Language').isEmpty?await preferences.setString('Language', "en_US"): preferences.getString('Language');
    print('pref =${ preferences.getString('Language')}');
    if( preferences.getString('Language') == 'hi_IN'){
      print('select hindi');
      _oldLocale = Locale('hi', 'IN');
    }
    else if( preferences.getString('Language') == 'gu_IN'){
      _oldLocale = Locale('gu', 'IN');

      print('select gujarati');
    }
    else{
      _oldLocale = Locale('en', 'US');

      print('select english');
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LangChange>(context);
    lang.out.listen((event) {_oldLocale = event;});
    lang.controller.add(_oldLocale);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder<Locale>(
        stream:   lang.out,
        builder: (context,local){
          return StreamBuilder<AppVersion>(
            stream: ProjectRetrieve().APPVERSION,
            builder: (context,snapshot){
              if(snapshot.hasData){
                return Provider<ProjectRetrieve>.value(
                  value: ProjectRetrieve(),
                  child: MaterialApp(

                    color: Color(0xff0b4cbc),

                    theme: ThemeData(
                      primaryColor:  Color(0xff0cb1b7),
                      buttonColor: Colors.black,


                      //  primaryColor:  Colors.black.withOpacity(0.6),
                      bottomAppBarColor:Color(0xff0cb1b7),

                    ),

                    supportedLocales: [
                      Locale('en', 'US'),
                      Locale('gu', 'IN'),
                      Locale('hi', 'IN'),
                    ],
                    locale: local.data,
                    // These delegates make sure that the localization data for the proper language is loaded
                    localizationsDelegates: [
                      // THIS CLASS WILL BE ADDED LATER
                      // A class which loads the translations from JSON files
                      AppLocalizations.delegate,
                      // Built-in localization of basic text for Material widgets
                      GlobalMaterialLocalizations.delegate,
                      // Built-in localization for text direction LTR/RTL
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    // Returns a locale which will be used by the app
                    // localeResolutionCallback: (locale, supportedLocales) {
                    //   // Check if the current device locale is supported
                    //   for (var supportedLocale in supportedLocales) {
                    //     if (supportedLocale.languageCode == locale.languageCode &&
                    //         supportedLocale.countryCode == locale.countryCode) {
                    //
                    //       return supportedLocale;
                    //     }
                    //   }
                    //   // If the locale of the device is not supported, use the first one
                    //   // from the list (English, in this case).
                    //   return supportedLocales.first;
                    // },
                    home: redirectWidget(snapshot.data),
                  ),
                );

              }
              else if(snapshot.hasError){
                return Container(child: Center(
                  child: Text(
                    snapshot.error.toString(),
                    //CommonAssets.snapshoterror.toString(),
                    style: TextStyle(
                        color: CommonAssets.errorColor
                    ),),
                ));
              }
              else{
                return CircularLoading();
              }
            },

          );
        });

  }
  Widget redirectWidget(AppVersion appVersion){
    final appcastURL =
       appVersion.download;
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    if(appVersion.active){
      if(preferences.getString('Version')== appVersion.version){
        return Wrapper();
      }else{
        return Scaffold(
          body: UpgradeAlert(

            child: Center(child: Padding(
              padding:  EdgeInsets.all(15.0),
              child: RaisedButton(
                color: CommonAssets.buttonColor,
                shape: StadiumBorder(),
                child: Text(
                  "Download",

                  style: TextStyle(
                    color: CommonAssets.buttonTextColor,
                        fontSize: 20,
                  ),
                ),
                onPressed: ()async{
                  final storageRequest = await Permission.storage.request();
                  if(storageRequest.isGranted){
                    final directory = await getExternalStorageDirectory();
                    final path= Directory("storage/emulated/0/Download/GPGroup");
                    print(directory.path);
                    if ((await path.exists())){

                      print("exist");
                    }else{

                      print("not exist");
                      path.create();

                    }
                    final taskId = await FlutterDownloader.enqueue(
                      url: appVersion.download,
                      savedDir: path.path,
                      showNotification: true, // show download progress in status bar (for Android)
                      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                    );
                    print(taskId.length);


                  }

                },
              ),
            )),
          ),
        );
      }
     
    }
    else{
      return Scaffold(
        body: Center(child: Text(
          'Customer App Is Block For Some Time',

          style: TextStyle(
              color: CommonAssets.errorColor,
              fontSize:25
          ),
        )),
      );
    }
  }
}

