import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class  BrokerModel{
  String id;
  String name;
  int number;
  int alterNativeNumber;
  String image;
  bool isActiveUser;
  String password;
  List<Map<String,dynamic>> clients;
  List remainingEmi;
  List<String> notificationKey;
  BrokerModel({
    @required this.id,
    @required this.name,
  @required this.number,
    @required this.alterNativeNumber,
    @required  this.image,
    @required this.password,
    @required  this.isActiveUser,
    @required this.clients,
    @required this.remainingEmi,
    @required this.notificationKey
  });

    factory BrokerModel.of(DocumentSnapshot snapshot ){
      return BrokerModel(
          id: snapshot.id,
          name: snapshot['Name'],
          number: snapshot['PhoneNumber'],
          alterNativeNumber: snapshot['AlterNativeNumber'],
          image: snapshot['ProfileUrl'],
          isActiveUser: snapshot['IsActive'],
          password: snapshot['Password'],
          remainingEmi:  List.from(snapshot['RemainingEMI']),
          clients: List.from(snapshot['ClientsList']),
        notificationKey: List.from(snapshot['NotificationKey'])
      );
    }
}

// fields of database
// "LoanId":loanId,
// "Property":"${projectName}/${innerCollection}/${allocatedNumber}",
// "Commission":brokerageList[i],
// "CustomerId":cusPhoneNumber,
// "BookingDate":bookingDate,
// "EMIDate":_emi[i],
// "CustomerName":customerName,
// "IsPay":false,
//ClientsList [LoanRef,]ProjectName,PhoneNumber,CustomerName