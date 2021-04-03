import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/AppVersion/Version.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:rxdart/rxdart.dart';

class ProjectRetrieve{
 String brokerId;
  String customerId;
  String loadId;
  String projectName;
 String partOfSociety;
 String propertiesNumber;
 String typeOfProject;

 setProjectName(String val,String projectType,){
   this.projectName  = val;
   this.typeOfProject = projectType;

 }
 // setPropertiesLoanRef(String loanrefs, ){
 //
 //   this.loanRef = loanrefs;
 // }
 setPartOfSociety(String part,String propertyId){
   this.partOfSociety = part;
   this.propertiesNumber =propertyId;
 }
  setCustomer(String id){
    this.customerId = id;
  }
  setLoanRef(String ref){
    this.loadId = ref;
  }

  final CollectionReference _projectReference = FirebaseFirestore.instance.collection("Project");
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
    return adsReference.orderBy('IsActive',descending: false).limit(2).snapshots().map(_advertise);
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
    return FirebaseFirestore.instance.collection('Loan').doc(projectName).collection(loadId).orderBy("InstallmentDate",descending:false ).snapshots().map((_listLoanData));
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
   return _projectReference.doc(projectName).collection(partOfSociety).doc(propertiesNumber).snapshots().map(_bookingDataModel);
 }
 BookingDataModel _bookingDataModel(DocumentSnapshot snapshot){
   return  BookingDataModel.of(snapshot);
 }
 Stream<BookingAndLoan> BOOKINGANDLOAN(){
   return Rx.combineLatest2(CUSTOMERSINGLEPROPETIES, LOANINFO, (BookingDataModel bookingDataModel, List<SinglePropertiesLoanInfo> loanData) {
     return BookingAndLoan(bookingData: bookingDataModel, loanData : loanData);
   } );
 }

 StreamController<CustomerOwnAndSellPropertiesProjects> controller = BehaviorSubject<CustomerOwnAndSellPropertiesProjects>();
  Stream<CustomerOwnAndSellPropertiesProjects>  get PROJECTLIST =>controller.stream;

  addDataIntoStreamController(List<String> nameOfOwnProject,List<String> nameOfSoldProject)async{
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
}
