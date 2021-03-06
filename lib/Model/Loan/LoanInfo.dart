import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
class SinglePropertiesLoanInfo{
  int emiId; // which emi
  Timestamp/*?*//*?*//*?*//*?*/ installmentDate;
  bool?/*?*//*?*/ emiPending;
  String?/*?*//*?*/ typeOfPayment;
  String?/*?*//*?*/ ifsc;
  String?/*?*//*?*/  upiId;
  String?/*?*//*?*/ bankAccountNumber;
  String?/*?*//*?*//*?*/ payerName;
  String?/*?*//*?*/ receiverName;
  String?/*?*//*?*/ relation;
  int?/*?*//*?*/ amount;
  Timestamp?/*?*//*?*//*?*/ paymentTime;
  String?/*?*//*?*/ loadId;


  SinglePropertiesLoanInfo({
    /*required*/ /*required*/ /*required*/ /*required*/ required  this.emiId,
  /*required*/ /*required*/ /*required*/ /*required*/ required this.installmentDate,
    /*required*/ /*required*/ required this.emiPending,
    /*required*/ /*required*/ /*required*/ required this.typeOfPayment,
    /*required*/ /*required*/ /*required*/ required this.ifsc,
    /*required*/ /*required*/ /*required*/ required this.upiId,
    /*required*/ /*required*/ /*required*/ required  this.bankAccountNumber,
    /*required*/ /*required*/ /*required*/ required  this.payerName,
    /*required*/ /*required*/ /*required*/ required this.receiverName,
  /*required*/ /*required*/ /*required*/ /*required*/ /*required*/ required this.relation,
    /*required*/ /*required*/ required this.amount,
    /*required*/ /*required*/ required this.paymentTime,
    /*required*/ /*required*/ /*required*/ required this.loadId

  });
  factory SinglePropertiesLoanInfo.of(DocumentSnapshot snapshot){

    return  SinglePropertiesLoanInfo(
      emiId: int.parse(snapshot.id),
      installmentDate: snapshot['InstallmentDate'],
      emiPending: snapshot['EMIPending'],
      typeOfPayment: snapshot['TypeOfPayment'],
      ifsc: snapshot['IFSC'],
      upiId: snapshot['UPIID'],
      bankAccountNumber: snapshot['BankAccountNumber'],
      payerName: snapshot['PayerName'],
      receiverName: snapshot['ReceiverName'],
      relation: snapshot['Relation'],
      amount: snapshot['Amount'],
      paymentTime: snapshot['PaymentDate'],
      loadId: snapshot['LoanId']


    );
  }

}
// filed in database
// "InstallmentDate":_emi[i],
// "EMIPending":true,
// "TypeOfPayment":"",
// "IFSC":"",
// "UPIID":"",
// "BankAccountNumber":"",
// 'PayerName':"",
// "ReceiverName":"",
// "Relation":"",
// "Amount":0