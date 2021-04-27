import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';

class CustomerInfoModel{
  String customerName;
  int number;
  List<Map<String,dynamic>> propertiesList;
  List<RemainingEmiModel> remainingEMIList;
  List<String> notificationKey;
  List<Map<String,dynamic>> soldPropertiesList;
  int totalRemainingEMIs;
  CustomerInfoModel({
    @required this.customerName,
    @required this.number,
    @required this.propertiesList,
    @required this.notificationKey,
    @required this.remainingEMIList,
    @required this.soldPropertiesList,
    @required this.totalRemainingEMIs
  });
  factory CustomerInfoModel.of(DocumentSnapshot snapshot){
    int totalRemainingEMI = 0;
    List data = List.from(snapshot['RemainingEMI']);
    List<RemainingEmiModel> remainingEMIList = [];
    data.map((e)  {
      RemainingEmiModel remainingEmiModel = RemainingEmiModel.of(e);
      totalRemainingEMI = totalRemainingEMI +remainingEmiModel.pendingEmi;
      remainingEMIList.add(remainingEmiModel);
    }).toList();
    // print(data.length);
    // print(remainingEMIList.length);
    return CustomerInfoModel(
        customerName: snapshot['CustomerName'],
        number: snapshot['CustomerPhoneNumber'],
        propertiesList: List.from(snapshot['Properties']),
        notificationKey: List.from(snapshot['NotificationKey']),
        remainingEMIList: remainingEMIList,
        soldPropertiesList: List.from(snapshot['SoldProperties']),
      totalRemainingEMIs: totalRemainingEMI

    );
  }
}
//Part,ProjectName,PropertyNumber,LoanRef
class BookingAndLoan{
  BookingDataModel bookingData;
  List<SinglePropertiesLoanInfo> loanData;
  BookingAndLoan({@required this.bookingData,@required this.loanData});
  factory BookingAndLoan.of( BookingDataModel _bookingData,List<SinglePropertiesLoanInfo> _loanData){
    return BookingAndLoan(bookingData: _bookingData, loanData: _loanData);
  }
}
class RemainingEmiModel{
  String projectName;
  String loanRef;
  int pendingEmi;
  RemainingEmiModel({
    @required this.projectName,
    @required this.loanRef,
    @required this.pendingEmi
});
  factory RemainingEmiModel.of(Map<String,dynamic> data){
    return RemainingEmiModel(projectName: data['ProjectName'], loanRef: data['LoanRef'], pendingEmi: data['TotalPendingEmi']);
  }
}