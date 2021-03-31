import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Pages/Customer/ExistingCustomerData.dart';
import 'package:gpgroup/Pages/Customer/ZoomImage.dart';
import 'package:gpgroup/Pages/Setting/Lang/Lang.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_widget/zoom_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String customerId;
  String token ;
  bool loading = true;
  List<IncomeModel> _data;
  int receivedCommission = 0;
  int totalCommission = 0;
  int remainingCommission =0;
  String currentMonth;
  int pageIndex= 0;
  List<Map<String ,dynamic>> dataList ;
  bool cancelProperties = false;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prfs();
     currentMonth  ="${now.month}-${now.year}";

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];

      },
      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   await Firebase.initializeApp();
      //   await FirebaseFirestore.instance.collection("jaydip").doc("d").set({"jaydip":"dip"});
      // },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

  }
  Future prfs()async {
  token =await _firebaseMessaging.getToken();
   await preferences.then((SharedPreferences prefs) {

        customerId = prefs.getString('CustomerId');

    });
   // await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }
  categorize(CustomerInfoModel model,ProjectRetrieve projectRetrieve)async{
    List<List<Map<String ,dynamic>>> ownProperties =[];
    List<List<Map<String ,dynamic>>> soldProperties =[];
    List<String> availableOwnProject = [];
    List<String> availableSoldProject = [];
      for(int i=0;i<model.propertiesList.length;i++){
        if(!availableOwnProject.contains(model.propertiesList[i]['ProjectName'])){
        availableOwnProject.add(model.propertiesList[i]['ProjectName']);
        }
      }

    for(int k=0;k<model.soldPropertiesList.length;k++){
      if(!availableSoldProject.contains(model.soldPropertiesList[k]['ProjectName'])){
        availableSoldProject.add(model.soldPropertiesList[k]['ProjectName']);
      }
    }
      for(int j=0;j<availableOwnProject.length;j++){
        List<Map<String ,dynamic>> localOwnProperties = [];
        for(int i=0;i<model.propertiesList.length;i++){
          if(availableOwnProject[j] == model.propertiesList[i]['ProjectName']){
            localOwnProperties.add(model.propertiesList[i]);
          }
        }
        ownProperties.add(localOwnProperties);
      }
  for(int j=0;j<availableSoldProject.length;j++){
    List<Map<String ,dynamic>> localSoldProperties = [];
    for(int i=0;i<model.soldPropertiesList.length;i++){
      if(availableSoldProject[j] == model.soldPropertiesList[i]['ProjectName']){
        localSoldProperties.add(model.soldPropertiesList[i]);
      }

  }
    soldProperties.add(localSoldProperties);
    }
  // call stream  to store data in streamController
    projectRetrieve.addDataIntoStreamController(availableOwnProject,availableSoldProject);

  // print(availableSoldProject);
  // print('ow');
  // print(ownProperties);
  // print('sold');
  // print(soldProperties);
  }


  @override
  Widget build(BuildContext context) {
  
  final _projectRetrieve = Provider.of<ProjectRetrieve>(context);


  final size = MediaQuery.of(context).size;
  final fontSize= size.height *0.02;
  final titleFontSize= size.height *0.02;
  final spaceVertical = size.height *0.01;
  final fontWeight = FontWeight.bold;
 _projectRetrieve.setCustomer(customerId);

    return Scaffold(
      appBar: CommonappBar(
        Row(
          children: [
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: ()async{
              await LogInAndSignIn().signouts(customerId);
            }),
            IconButton(icon: Icon(Icons.language), onPressed: ()async{
              Navigator.push(context, PageRouteBuilder(
                //    pageBuilder: (_,__,____) => BuildingStructure(),
                pageBuilder: (_,__,___)=> SelectLanguage(),
                transitionDuration: Duration(milliseconds: 0),
              ));
            })
          ],
        )
      ),
      body: loading ?CircularLoading(): SingleChildScrollView(
        child: StreamBuilder<CustomerAndAdvertise>(
            stream: _projectRetrieve.BROKERDATAANDADVERTISE(),
            builder:(context,snapshot){
              if(snapshot.hasData){
                categorize(snapshot.data.customerInfoModel,_projectRetrieve);
                !cancelProperties?
                dataList = snapshot.data.customerInfoModel.propertiesList:
                dataList = snapshot.data.customerInfoModel.soldPropertiesList;
                return StreamBuilder<CustomerOwnAndSellPropertiesProjects>(
                  stream: _projectRetrieve.PROJECTLIST,
                  builder: (context,projectNameSnapshot) {
                    if (projectNameSnapshot.hasData) {

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider.builder(
                              options: CarouselOptions(

                                // height: 400,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration: Duration(
                                    milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,

                                scrollDirection: Axis.horizontal,
                              ),
                              itemCount: snapshot.data.advertiseList.length,
                              itemBuilder: (BuildContext context, index) {
                                return snapshot.data.advertiseList.length <= 0 ?
                                Image.asset(
                                    'assets/defaultads.png'


                                )
                                    : GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, PageRouteBuilder(
                                      //    pageBuilder: (_,__,____) => BuildingStructure(),
                                      pageBuilder: (_, __, ___) => ImageZoom(
                                          image: snapshot.data
                                              .advertiseList[index].imageUrl),
                                      transitionDuration: Duration(
                                          milliseconds: 0),
                                    ));
                                  },
                                  child: Card(
                                    child:
                                    Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            snapshot.data.advertiseList[index]
                                                .imageUrl.first,
                                            width: size.width,
                                            height: size.height * 0.3,
                                            fit: BoxFit.fill,


                                          ),
                                        ),
                                        AutoSizeText(
                                          snapshot.data.advertiseList[index]
                                              .description,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.width * 0.05
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          ),
                          SizedBox(height: size.height * 0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(icon: Icon(
                                  cancelProperties ? Icons.history : Icons
                                      .new_releases), onPressed: () {
                                setState(() {
                                  cancelProperties = !cancelProperties;
                                  pageIndex = 1;
                                });
                              }),
                              IconButton(
                                  icon: Icon(Icons.person), onPressed: () {
                                setState(() {
                                  pageIndex = 2;
                                });
                              })
                            ],
                          ),
                          SizedBox(height: size.height * 0.01,),
                          propertiesShow(projectNameSnapshot.data.ownProperties,true,size),
                          //  Expanded(child: redirect(snapshot.data,_projectRetrieve,size))

                        ],
                      );
                    }

                    else if (projectNameSnapshot.hasError) {
                      return Container(child: Center(
                        child: Text(
                          snapshot.error.toString(),
                          //CommonAssets.snapshoterror.toString(),
                          style: TextStyle(
                              color: CommonAssets.errorColor
                          ),),
                      ));
                    }
                    else {
                      return Center(child: CircularLoading());
                    }
                  });
              }
              else if(snapshot.hasError){
                return Container(child: Center(
                  child: Text(
                    snapshot.error.toString(),
                    //CommonAssets.snapshoterror.toString(),
                    style: TextStyle(
                      color: CommonAssets.errorColor
                  ),),
                ));
              }
              else{
                return CircularLoading();
              }
            } ),
      ),

    );
  }
Widget redirect(CustomerAndAdvertise snaspshot,ProjectRetrieve _projectRetrieve,Size size){
    if(pageIndex == 2){
      return profile(snaspshot.customerInfoModel,size);
    }
    else {
       return properties(dataList,_projectRetrieve);
    }
}

Widget propertiesShow(List<ProjectNameList> projectName,bool isOwn,Size size){
    String title = isOwn? "Own addinto Locals":"sold add into loca";
    return Container(
      height: size.height *0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: projectName.length,itemBuilder: (context,index){
        return Container(
          width: size.width *0.15,
            height: size.height *0.15,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(150.0)
              // color: Colors
         ),
         // height: size.height *0.10,
          child: Image.network(projectName[index].imagesUrl.first)

          // CircleAvatar(
          //   //radius: 10.0,
          // //  backgroundImage: NetworkImage(projectName[index].imagesUrl.first),
          //   backgroundColor: Colors.transparent,
          //   child: Image.network(projectName[index].imagesUrl.first),
          // )
        );
      }),
    );
}

  Widget properties(  List<Map<String ,dynamic>>  customerInfoModel,ProjectRetrieve _projectRetrieve) {
    return ListView.builder(
        itemCount:customerInfoModel.length,
        itemBuilder: (context,index){

          return Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).primaryColor
                )
            ),
            child: ListTile(
              onTap: ()async{
                await _projectRetrieve.setProjectName(customerInfoModel[index]['ProjectName'], '');
                await _projectRetrieve.setLoanRef(customerInfoModel[index]['LoanRef']);
                await _projectRetrieve.setPartOfSociety(customerInfoModel[index]['Part'],customerInfoModel[index]['PropertyNumber']);
                print(_projectRetrieve.projectName);
                print(_projectRetrieve.loadId);
                print(_projectRetrieve.partOfSociety);
                print(_projectRetrieve.propertiesNumber);
                Navigator.push(context, PageRouteBuilder(
                  //    pageBuilder: (_,__,____) => BuildingStructure(),
                  pageBuilder: (_,__,___)=> LoanInfo(),
                  transitionDuration: Duration(milliseconds: 0),
                ));
              },
              title: Text(customerInfoModel[index]['ProjectName']),
              subtitle: Text(customerInfoModel[index]['PropertyNumber']),
            ),
          );
        }
    );
  }

  Widget profile(CustomerInfoModel customerInfoModel,Size size) {

    final fontSize= size.height *0.02;
    final titleFontSize= size.height *0.02;
    final spaceVertical = size.height *0.01;
    final fontWeight = FontWeight.bold;
    return Column(


      children: [
        Text(
          AppLocalizations.of(context).translate('CustomerName'),

          style: TextStyle(
              fontWeight: fontWeight,
              fontSize: titleFontSize
          ),
        ),
        SizedBox(height: spaceVertical,),
        Text(
          customerInfoModel.customerName,
          style: TextStyle(
              fontSize: fontSize
          ),
        ),
        SizedBox(height: spaceVertical,),
        Text(
          AppLocalizations.of(context).translate('MobileNumber'),
          style: TextStyle(
              fontWeight: fontWeight,
              fontSize: titleFontSize
          ),
        ),
        SizedBox(height: spaceVertical,),
        Text(
          customerInfoModel.number.toString(),
          style: TextStyle(
              fontSize: fontSize
          ),
        ),
        SizedBox(height: spaceVertical,),
      ],
    );
  }
}
