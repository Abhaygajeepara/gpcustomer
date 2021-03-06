import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProjectRetrieve{
 String? brokerId;
  String? customerId;
  String? customerName;
  String? loadId;
  String? projectName;
  String? typeOfProject;
  String? adsId;
 // String partOfSociety;
 // String propertiesNumber;
// String typeOfProject;
setAds(String ad){
  this.adsId = ad;
}
 setProjectName(String? val,String? projectType){
   this.projectName  = val;
   this.typeOfProject = projectType;

 }
 // setPropertiesLoanRef(String loanrefs, ){
 //
 //   this.loanRef = loanrefs;
 // }
 // setPartOfSociety(String part,String propertyId){
 //   this.partOfSociety = part;
 //   this.propertiesNumber =propertyId;
 // }
  setCustomer(String? id,){
    this.customerId = id;

  }
  setCustomerMobileNumber(String name){
   this.customerName =name;
  }
  setLoanRef(String? ref){
    this.loadId = ref;
  }

  final CollectionReference _projectReference = FirebaseFirestore.instance.collection("Project");
  final CollectionReference _loanReference = FirebaseFirestore.instance.collection("Loan");
  final CollectionReference brokerReference = FirebaseFirestore.instance.collection('Broker');
  final CollectionReference infoReference = FirebaseFirestore.instance.collection('Info');
  final CollectionReference customerReference = FirebaseFirestore.instance.collection('Customer');
  final CollectionReference adsReference = FirebaseFirestore.instance.collection('Advertise');

  CustomerInfoModel _singleCustomer(DocumentSnapshot snapshot){
    return CustomerInfoModel.of(snapshot);
  }
  Stream<CustomerInfoModel> get SINGLECUSTOMERDATA{
    return customerReference.doc(customerId).snapshots().map(_singleCustomer);
  }

  List<AdvertiseModel> _advertise(QuerySnapshot querySnapshot){

    return querySnapshot.docs.map((e){
      return AdvertiseModel.of(e);
    }).toList();
  }
  Stream<List<AdvertiseModel>> get THREEADVERTISE{
    return adsReference.where('IsActive',isEqualTo: true).limit(3).snapshots().map(_advertise);
  }
  AdvertiseModel _advertiseSingle(DocumentSnapshot snapshot){
    return AdvertiseModel.of(snapshot);

  }
  Stream<AdvertiseModel> get SINGLEADVERTISE{
    return adsReference.doc(adsId).snapshots().map(_advertiseSingle);
  }
  Stream<CustomerAndAdvertise> BROKERDATAANDADVERTISE(){
    return Rx.combineLatest2(SINGLECUSTOMERDATA, THREEADVERTISE, (CustomerInfoModel _customerInfoModel, List<AdvertiseModel> _adver,) {
      return CustomerAndAdvertise(customerInfoModel:   _customerInfoModel, advertiseList:  _adver,);
    } );
  }
  List<SinglePropertiesLoanInfo> _listLoanData (QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e){
      return SinglePropertiesLoanInfo.of(e);
    }).toList();
  }
  Stream<List<SinglePropertiesLoanInfo>> get LOANINFO{
    return FirebaseFirestore.instance.collection('Loan').doc(projectName).collection(loadId!).orderBy("InstallmentDate",descending:false ).snapshots().map((_listLoanData));
  }

  List<IncomeModel> _brokerSales(QuerySnapshot snapshot){

    return  snapshot.docs.map((e) {
      // return IncomeModel.of(e);
      return IncomeModel(
          clientData: List.from(e['Transfer']),
          month: e.id,
          emiMonthTimestamp: e['MonthTimeStamp']
      );
    }).toList();
  }

  AppVersion appVersion(DocumentSnapshot snapshot){
    return AppVersion.of(snapshot);
  }
  Stream<AppVersion> get APPVERSION{
    return infoReference.doc('CustomerApp').snapshots().map(appVersion);
  }
 Stream<BookingDataModel> get CUSTOMERSINGLEPROPETIES{
   return _loanReference.doc(projectName).collection(loadId!).doc('BasicDetails').snapshots().map(_bookingDataModel);
 }
 BookingDataModel _bookingDataModel(DocumentSnapshot snapshot){
   return  BookingDataModel.of(snapshot,loadId);
 }
 Stream<BookingAndLoan> BOOKINGANDLOAN(){
   return Rx.combineLatest2(CUSTOMERSINGLEPROPETIES, LOANINFO, (BookingDataModel bookingDataModel, List<SinglePropertiesLoanInfo> loanData) {
     return BookingAndLoan(bookingData: bookingDataModel, loanData : loanData);
   } );
 }

 StreamController<CustomerOwnAndSellPropertiesProjects> controller = BehaviorSubject<CustomerOwnAndSellPropertiesProjects>();
  Stream<CustomerOwnAndSellPropertiesProjects>  get PROJECTLIST =>controller.stream;

  addDataIntoStreamController(List<String?> nameOfOwnProject,List<String?> nameOfSoldProject)async{
    CustomerOwnAndSellPropertiesProjects customerOwnAndSellPropertiesProjects;
    List<ProjectNameList> ownProperties =[];
    List<ProjectNameList> soldProperties =[];
    
    for(int  i=0;i<nameOfOwnProject.length;i++){

    final ownData = await   _projectReference.doc(nameOfOwnProject[i]).get();
       ProjectNameList   projectData = ProjectNameList.of(ownData);

      ownProperties.add(projectData);
    }
    
    for(int j=0;j<nameOfSoldProject.length;j++){
    final sodData = await     _projectReference.doc(nameOfSoldProject[j]).get();
       ProjectNameList  projectData = ProjectNameList.of(sodData);
      soldProperties.add(projectData);



     // final docProject = await _projectReference.doc(nameOfSoldProject[j]).get()

    }

     for(int  i=0;i<nameOfOwnProject.length;i++){

       _projectReference.doc(nameOfOwnProject[i]).snapshots().listen((event) {
         ProjectNameList projectData = ProjectNameList.of(event);
         ownProperties.removeAt(i);
         ownProperties.insert(i,projectData);

      });

    }

    for(int j=0;j<nameOfSoldProject.length;j++){

       _projectReference.doc(nameOfSoldProject[j]).snapshots().listen((event) {
         ProjectNameList projectData = ProjectNameList.of(event);
        soldProperties.removeAt(j);
        soldProperties.insert(j, projectData);
      });
     // final docProject = await _projectReference.doc(nameOfSoldProject[j]).get()

    }


     customerOwnAndSellPropertiesProjects  = CustomerOwnAndSellPropertiesProjects.of(ownProperties,soldProperties) ;
    controller.sink.add(customerOwnAndSellPropertiesProjects);
  }

  StreamController<String> splashController = BehaviorSubject<String>();
  Stream<String> get SPLASHSTREAM =>splashController.stream;

  Future  storeFile()async{
    String filepath = (await getExternalStorageDirectory())!.path;

    print(filepath);
    String mainfolder = "";
    String statementFolder ="" ;
    List<String> listFolders = filepath.split("/");
    for (int i = 1; i < listFolders.length; i++) {
      String s = listFolders[i];
      if (s != "Android") {
        mainfolder = mainfolder + "/" + s;
        statementFolder = statementFolder + "/" + s;
      }
      else {
        break;
      }
    }
    mainfolder = mainfolder + "/" + "Vrajraj";
    statementFolder = statementFolder + "/" + "Vrajraj"+"/"+"Statement";




    Directory _mainFolder = Directory(mainfolder);
    Directory _statementFolder = Directory(statementFolder);
    print(_mainFolder);
    print(_statementFolder);
    if(!await _mainFolder.exists()){
      _mainFolder.create(recursive: true);
    }
    if(!await _statementFolder.exists()){
      _statementFolder.create(recursive: true);
    }
    return mainfolder;
  }
}
