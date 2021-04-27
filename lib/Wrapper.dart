import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Pages/Auth/LogIn.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';

import 'package:provider/provider.dart';




class Wrapper extends StatefulWidget {
  @override
  //
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override


  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
          return CircularLoading();
        if(!snapshot.hasData || snapshot.data == null)
        {
          return Login();
        }
        else{
          return Home();
        }
      },
    );
  }
}
