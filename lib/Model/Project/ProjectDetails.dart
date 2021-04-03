import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpgroup/Model/Advertise/AdvertiseMode.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';

class  ProjectNameList{
   String projectName;
  String address;
  String landmark;
  String description;
  String typeofBuilding;
  List<String> englishRules;
  List<String> gujaratiRules;
  List<String> hindiRules;
  List<String> reference;
  List<Map<String,dynamic>> Structure;
  List<String> imagesUrl;
  bool isSiteOn;
int siteVisit;

  ProjectNameList({
    @required  this.projectName,
   @required  this.address,
    @required this.landmark,
    @required this.description,
    @required  this.typeofBuilding,
    @required  this.englishRules,
    @required this.gujaratiRules,
    @required this.hindiRules,
    @required this.reference,
    @required this.Structure,
    @required this.imagesUrl,
    @required this.isSiteOn,
    @required this.siteVisit

  });
  factory ProjectNameList.of(DocumentSnapshot snapshot){
    return ProjectNameList(
      projectName: snapshot.id,
      address: snapshot.data()['Address'],
      landmark: snapshot.data()['Landmark'],
      description: snapshot.data()['Description'],
      typeofBuilding: snapshot.data()['TypeofBuilding'],
      englishRules:List.from( snapshot.data()['EnglishRules']),
      gujaratiRules: List.from( snapshot.data()['GujaratiRules']),
      hindiRules: List.from( snapshot.data()['HindiRules']),
      reference: List.from( snapshot.data()['Reference']),
      Structure: List.from(snapshot.data()['Structure']),
      imagesUrl : List.from(snapshot.data()['ImageUrl']),
      isSiteOn: snapshot.data()['IsSiteOn'],
      siteVisit: snapshot.data()['SiteVisit']


    );
  }
}

class CustomerOwnAndSellPropertiesProjects{
  List<ProjectNameList> ownProperties ;
  List<ProjectNameList> soldProperties ;
  CustomerOwnAndSellPropertiesProjects({this.ownProperties,this.soldProperties  });

  setOwn( List<ProjectNameList> ownProperty){
    this.ownProperties =ownProperty;
  }
  setSold( List<ProjectNameList> soldProperty){
    this.soldProperties =soldProperty;
  }

  factory CustomerOwnAndSellPropertiesProjects.of(List<ProjectNameList> ownProperties,List<ProjectNameList> soldProperties){
    return CustomerOwnAndSellPropertiesProjects(ownProperties: ownProperties,soldProperties: soldProperties );
  }

}

class CustomerAndAdvertise{
  CustomerInfoModel customerInfoModel;
    List<AdvertiseModel> advertiseList;

    CustomerAndAdvertise({@required this.customerInfoModel,@required this.advertiseList});
    factory CustomerAndAdvertise.of(  CustomerInfoModel _customerInfoModel,  List<AdvertiseModel> _advertiseList, List<IncomeModel> _commission){
      return CustomerAndAdvertise(customerInfoModel: _customerInfoModel, advertiseList: _advertiseList,);
    }
}