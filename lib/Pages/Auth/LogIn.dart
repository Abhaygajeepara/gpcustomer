import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool error = false;
  String phoneNumber ;

  bool loading = false;
  String errorMessage='';
  final _formkey = GlobalKey<FormState>();
  bool _vision = true;
  void _visibility(){
    setState(() {
      print(_vision);
      _vision = ! _vision;
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
     resizeToAvoidBottomInset: false,
     body: loading ?CircularLoading(): Center(
       child: Container(
         child:  Form(
           key: _formkey,
           child: Padding(
               padding:  EdgeInsets.symmetric(horizontal: size.width * 0.10),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
               TextFormField(
                 keyboardType: TextInputType.phone,
                 maxLength: 10,
               decoration: loginAndsignincommoninputdecoration.copyWith(labelText:  AppLocalizations.of(context).translate('MobileNumber')),
           validator: numbervalidtion,
           onChanged: (val)=> phoneNumber =val,
         ),
                     SizedBox(height: size.height*0.02,),

                   error?  AutoSizeText(
                       errorMessage,
                      maxLines: 2,
                      style: TextStyle(
                        color: CommonAssets.errorColor,
                        fontSize: size.height*0.02
                      ),
                     ):Container(),
                     SizedBox(height: size.height*0.015,),
           RaisedButton(
             padding: EdgeInsets.symmetric(horizontal: size.width * 0.15,vertical: size.height * 0.02),
             shape: StadiumBorder(),
             color: CommonAssets.buttonColor,
             onPressed: ()async{
              if(_formkey.currentState.validate()){
                setState(() {
                  loading = true;
                });
            final result =  await LogInAndSignIn().Login(phoneNumber);
            if(result ==false){

              setState(() {
                error = true;
                loading = false;
                errorMessage =AppLocalizations.of(context).translate('Thisuserhasnopermissiontologin');
              });
            }
            else{
              // setState(() {
              //   error = true;
              //   loading = false;
              //
              // });
            }
            // else{
            //   setState(() {
            //     error = true;
            //     loading = false;
            //   });
            // }

              }

             },
             child: Text(
               AppLocalizations.of(context).translate('Login'),
               style: TextStyle(
                   color: Colors.white
               ),
             ),
           ),]),),)
       ),
     ),
    );
  }
  String numbervalidtion(String value){
    Pattern pattern = '^[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).translate("NumberOnly");
      return 'Enter The Number Only';
    }
    else if(value.length <10){
      return AppLocalizations.of(context).translate("NumberIsLessThan10");
      return "Digits Is Grater Than One";
    }else {
      return null;
    }
  }
}
