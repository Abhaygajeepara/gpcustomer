import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Pages/Home.dart';
import 'package:gpgroup/Wrapper.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isHome = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueChange();
  }
  void valueChange(){
    Timer(Duration(seconds: 3), (){
      setState(() {
        isHome = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isHome?Wrapper(): Scaffold(
      //assets/vrajraj.png
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              CommonAssets.apptitle,
            style: TextStyle(
              fontSize: size.height*0.05,
              fontWeight: FontWeight.bold,
              color: CommonAssets.splashTextColor
            ),
            ),
            SizedBox(height: size.height*0.02,),
            Image.asset(
                'assets/splashImage.png',
              width: size.width*0.8,
               fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }
}
