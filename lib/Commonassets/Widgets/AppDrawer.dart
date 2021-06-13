
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

import 'package:gpgroup/Pages/Setting/Lang/Lang.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    final size = MediaQuery.of(context).size;

    final fontSize= size.height *0.02;
    final titleFontSize= size.height *0.02;
    final spaceVertical = size.height *0.01;
    final fontWeight = FontWeight.bold;
    final spaceHor =size.width*0.01;
    Color iconColor = CommonAssets.appBarDrawerColor;
    return Drawer(

      child: ListView(

        children: [

          DrawerHeader(
              child:Image.asset('assets/vrajraj.png') ),

          ListTile(
            onTap: ()async{
              Navigator.pop(context);
                 await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SelectLanguage(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.language,color: iconColor,),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context)!.translate('Language')!)
              ],
            ),
          ),
          ListTile(
            onTap: ()async{

              await LogInAndSignIn().signouts(_projectRetrieve.customerId);

              // return Navigator.push(context,MaterialPageRoute(builder: (context)=>Home() ));

            },
            title: Row(

              children: [
                Icon(Icons.exit_to_app,color: iconColor,),
                SizedBox(width: spaceHor,),
                Text(AppLocalizations.of(context)!.translate('LogOut')!)
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
