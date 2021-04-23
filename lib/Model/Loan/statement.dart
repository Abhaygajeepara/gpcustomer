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
    @required this.emiNo,
    @required this.emiDate,
    @required this.amount,
    @required this.isPending,
    @required this.paidAmount,
    @required this.remainingAmount,
    @required this.paymentDate,
    @required this.delayDuration,
  //  @required this.textColor
});
  factory StatementModel.of(SinglePropertiesLoanInfo singlePropertiesLoanInfo,
      int emiNumber,int paidAmount,int remainingEmi){
   // String paymentDate = singlePropertiesLoanInfo.emiPending?"":singlePropertiesLoanInfo.paymentTime.toDate().toString().substring(0,10);
    DateTime timeEmi = singlePropertiesLoanInfo.installmentDate.toDate();
    DateTime timeOfPayment = singlePropertiesLoanInfo.paymentTime.toDate();
    int difference = timeEmi.difference(timeOfPayment).inDays;
    print(difference);
       return StatementModel(
        emiNo: emiNumber,
        emiDate: singlePropertiesLoanInfo.installmentDate,
        amount: singlePropertiesLoanInfo.amount,
        isPending: singlePropertiesLoanInfo.emiPending,
        paidAmount: paidAmount,
           remainingAmount: remainingEmi,
        paymentDate: singlePropertiesLoanInfo.paymentTime,
        delayDuration: difference,
     //  textColor: textColor
       );
  }
}