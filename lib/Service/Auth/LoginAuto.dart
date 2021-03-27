
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'file:///E:/Work/Flutter/Order/gpgroup/lib/Model/Users/UsersData.dart';
import 'package:gpgroup/Model/User.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LogInAndSignIn {
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final customerRef = FirebaseFirestore.instance.collection('Customer');
  Future Login(String id,)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();

    try{

      final customerExist = await customerRef.doc(id).get();
      if(customerExist.exists){


          String notificationToken = await _firebaseMessaging.getToken();

          await _auth.signInWithEmailAndPassword(email:'test@Broker.com', password: 'Brokerpassword');
          await customerRef.doc(id).update({
            "NotificationKey":FieldValue.arrayUnion([notificationToken]),
          });
          preferences.setString('CustomerId',id);
          return  UserData.of(customerExist);




      }
      else{
        print('false');
        return false;
      }
      
     
    }
    catch(e){
      
    }
  }




Future signouts(String customerID)async{
    try{
      String notificationToken = await _firebaseMessaging.getToken();
      print('notificationToken=${notificationToken}');
      await customerRef.doc(customerID).update({
        "NotificationKey":FieldValue.arrayRemove([notificationToken]),
      });
      await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
}

UsersData _userData (DocumentSnapshot snapshot){
    try{
     UserData.of(snapshot);
    }
    catch(e){
      print(e.toString());
    }
}
// Stream<UsersData> get USERDATA{
//     return _auth.authStateChanges().map(_userData);
// }
}