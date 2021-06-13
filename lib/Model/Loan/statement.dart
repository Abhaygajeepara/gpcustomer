import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';

class StatementModel{
  int emiNo;
  Timestamp emiDate;
  int amount;
  bool isPending;
  int paidAmount;
  int remainingAmount;
  Timestamp paymentDate;
  int delayDuration;
  //Color textColor;
  StatementModel({
    /*required*/ /*required*/ /*required*/ /*required*/ /*required*/ required this.emiNo,
    /*required*/ required this.emiDate,
    /*required*/ required this.amount,
    /*required*/ /*required*/ required this.isPending,
    /*required*/ required this.paidAmount,
    /*required*/ required this.remainingAmount,
    /*required*/ required this.paymentDate,
    /*required*/ required this.delayDuration,
  //  @required this.textColor
});
  factory StatementModel.of(SinglePropertiesLoanInfo singlePropertiesLoanInfo,
      int emiNumber,int paidAmount,int remainingEmi){
   // String paymentDate = singlePropertiesLoanInfo.emiPending?"":singlePropertiesLoanInfo.paymentTime.toDate().toString().substring(0,10);
    DateTime timeEmi = singlePropertiesLoanInfo.installmentDate.toDate();
    DateTime timeOfPayment = singlePropertiesLoanInfo.paymentTime!.toDate();
    int difference = timeEmi.difference(timeOfPayment).inDays;
    print(difference);
       return StatementModel(
        emiNo: emiNumber,
        emiDate: singlePropertiesLoanInfo.installmentDate,
        amount: singlePropertiesLoanInfo.amount!,
        isPending: singlePropertiesLoanInfo.emiPending!,
        paidAmount: paidAmount,
           remainingAmount: remainingEmi,
        paymentDate: singlePropertiesLoanInfo.paymentTime!,
        delayDuration: difference,
     //  textColor: textColor
       );
  }
}