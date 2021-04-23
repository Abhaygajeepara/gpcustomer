
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';

// Widget CommonAppbarForHome(BuildContext context){
//   return AppBar(
//     title : Text(CommonAssets.apptitle,style: TextStyle(color: Colors.white),),
//     backgroundColor: CommonAssets.AppbarColor,
//
//   );
// }
Widget CommonappBar(String  titleString,Widget appwidget,BuildContext  context){
  return AppBar(
    title : Text(
      titleString
    ,style: TextStyle(color: CommonAssets.AppbarTextColor),),
  iconTheme:IconThemeData(color: CommonAssets.appBarDrawerColor) ,
    actions: [
      appwidget
    ],
  );
}