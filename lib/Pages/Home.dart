import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/Widgets/AppDrawer.dart';

import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Income/Income.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';

import 'package:gpgroup/Model/User.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpgroup/Model/Users/BrokerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Pages/Customer/CustomerData.dart';
import 'package:gpgroup/Pages/Customer/RemainingEMIDetails.dart';
import 'package:gpgroup/Pages/Customer/ZoomImage.dart';
import 'package:gpgroup/Pages/Project/ProjectInfo.dart';
import 'Ads/SingleAds.dart';
import 'package:gpgroup/Pages/Setting/Lang/Lang.dart';
import 'package:gpgroup/Service/Auth/LoginAuto.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  PageController pageController = PageController();
  String? customerId;
  String? token ;
  bool loading = true;

  int receivedCommission = 0;
  int totalCommission = 0;
  int remainingCommission =0;
  String? currentMonth;

  List<Map<String ,dynamic>>? dataList ;
  bool cancelProperties = false;
  DateTime now = DateTime.now();

  List<List<Map<String ,dynamic>>> ownProperties =[];
  List<List<Map<String ,dynamic>>> soldProperties =[];
  List<String?> availableOwnProject = [];
  List<String?> availableSoldProject = [];
  late CustomerInfoModel profileData;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prfs();
     currentMonth  ="${now.month}-${now.year}";
    notification();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     final notification = message['notification'];
    //
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //
    //     final notification = message['data'];
    //
    //   },
    //   // onBackgroundMessage: (Map<String, dynamic> message) async {
    //   //   await Firebase.initializeApp();
    //   //   await FirebaseFirestore.instance.collection("jaydip").doc("d").set({"jaydip":"dip"});
    //   // },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));

  }
  Future notification()async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
  Future prfs()async {
  token =await _firebaseMessaging.getToken();
   await preferences.then((SharedPreferences prefs) {

        customerId = prefs.getString('CustomerId');

    });if(customerId  != ''){
    setState(() {
      loading = false;
    });
  }
   // await Future.delayed(Duration(seconds: 1));

  }
  categorize(CustomerInfoModel model,ProjectRetrieve projectRetrieve)async{
     ownProperties =[];
     soldProperties =[];
   availableOwnProject = [];
    availableSoldProject = [];
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

    ////  AppLocalizations.of(context).translate('Profile'),
  //    // AppLocalizations.of(context).translate('Language'),
  //    // AppLocalizations.of(context).translate('LogOut'),
    return Scaffold(
      appBar: CommonappBar(
          CommonAssets.apptitle,
         IconButton(icon: Icon(Icons.person), onPressed: (){
           AwesomeDialog(
         context: context,

         dialogType: DialogType.INFO,
         animType: AnimType.BOTTOMSLIDE,
         title: 'Dialog Title',
        body:loading?CircularLoading():   Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('CustomerName')!,

              style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: titleFontSize
              ),
            ),
            SizedBox(height: spaceVertical,),
            Text(
              profileData.customerName!,
              style: TextStyle(
                  fontSize: fontSize
              ),
            ),
            SizedBox(height: spaceVertical,),
            Text(
              AppLocalizations.of(context)!.translate('MobileNumber')!,
              style: TextStyle(
                  fontWeight: fontWeight,
                  fontSize: titleFontSize
              ),
            ),
            SizedBox(height: spaceVertical,),
            Text(
              profileData.number.toString(),
              style: TextStyle(
                  fontSize: fontSize
              ),
            ),
            SizedBox(height: spaceVertical,),
          ],
        ),
         // btnCancelOnPress: () {},
         // btnOkOnPress: () {},
       )..show();
         }),context
      ) as PreferredSizeWidget?,
      body: loading ?CircularLoading(): SingleChildScrollView(
        child: StreamBuilder<CustomerAndAdvertise>(
            stream: _projectRetrieve.BROKERDATAANDADVERTISE(),
            builder:(context,snapshot){

              if(snapshot.hasData){
                //_projectRetrieve.setCustomerMobileNumber(snapshot.data.customerInfoModel.customerName);
                //profileData use to display customer data
                profileData = snapshot.data!.customerInfoModel;

                categorize(snapshot.data!.customerInfoModel,_projectRetrieve);
                !cancelProperties?
                dataList = snapshot.data!.customerInfoModel.propertiesList:
                dataList = snapshot.data!.customerInfoModel.soldPropertiesList;
                return StreamBuilder<CustomerOwnAndSellPropertiesProjects>(
                  stream: _projectRetrieve.PROJECTLIST,
                  builder: (context,projectNameSnapshot) {
                    if (projectNameSnapshot.hasData) {

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider.builder(
                            itemCount:   snapshot.data!.advertiseList.length,
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
                            itemBuilder: (ctx, index, realIdx) {
                              return snapshot.data!.advertiseList.length <= 0 ?Image.asset(
                    'assets/default.jpg',

                    )
                        : GestureDetector(
                                              onTap: () async {
                                                _projectRetrieve.setAds(snapshot
                                                    .data!
                                                    .advertiseList[index]
                                                    .id);
                                                Navigator.push(context,
                                                    PageRouteBuilder(
                                                    pageBuilder:(_, __, ___) =>SingleAds(),transitionDuration:Duration(milliseconds: 0),
                                                    ));
                                              },
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data!
                                                          .advertiseList[index]
                                                          .imageUrl
                                                          .first,
                                                      fit: BoxFit.cover,
                                                      width: size.width * 0.8,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularLoading(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    // Image.network(
                                                    //   snapshot.data.advertiseList[index]
                                                    //       .imageUrl.first,
                                                    //   width: size.width,
                                                    //   height: size.height * 0.3,
                                                    //   fit: BoxFit.fill,
                                                    //
                                                    //
                                                    // ),
                                                  ),
                                                  AutoSizeText(
                                                    snapshot
                                                        .data!
                                                        .advertiseList[index]
                                                        .description!,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            size.width * 0.05),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            );
                                    },
                          ),



                          SizedBox(height: size.height * 0.01,),

                         Divider(color: CommonAssets.dividercolor,thickness: 2,),
                          remainingEmi(snapshot.data!.customerInfoModel),
                          propertiesShow(projectNameSnapshot.data!.ownProperties!,true,size),

                         // Divider(color: CommonAssets.AppbarTextColor,thickness: 2,),


                          projectNameSnapshot.data!.soldProperties!.length <= 0?Container(): propertiesShow(projectNameSnapshot.data!.soldProperties!,false,size),


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
                      return Container(
                          height: size.height,
                          child: Center(child: CircularLoading()));
                    }
                  });
              }
              else if(snapshot.hasError){
                return Container(

                    child: Center(
                  child: Text(
                    snapshot.error.toString(),
                    //CommonAssets.snapshoterror.toString(),
                    style: TextStyle(
                      color: CommonAssets.errorColor
                  ),),
                ));
              }
              else{
                return Container(
                    height: size.height,
                    child: Center(child: CircularLoading()));
              }
            } ),
      ),
  drawer: AppDrawer(),
    );
  }
// Widget redirect(CustomerAndAdvertise snaspshot,ProjectRetrieve _projectRetrieve,Size size){
//     if(pageIndex == 2){
//       return profile(snaspshot.customerInfoModel,size);
//     }
//     else {
//        return properties(dataList,_projectRetrieve);
//     }
// }
Widget remainingEmi( CustomerInfoModel customerInfoModel){
   final size = MediaQuery.of(context).size;
    final fontSize = size.height*0.02;
    return customerInfoModel.remainingEMIList.length <=0?Container():GestureDetector(
      onTap: (){
         Navigator.push(context, PageRouteBuilder(pageBuilder:(_,__,___)=>
            RemainingEMIDetails(
              customerInfoModel: customerInfoModel,
            )));
      },
      child: Card(

        margin: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.04),
        child: Padding(

          padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Flexible(
                  child: Text(
                      AppLocalizations.of(context)!.translate('Total')!+" "+AppLocalizations.of(context)!.translate('RemainingEMI')!,
                    style: TextStyle(
                      color: CommonAssets.totalRemainingEmiColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold
                    ),
                  )
              ),
              Text(customerInfoModel.totalRemainingEMIs.toString(),
                style: TextStyle(
                    color: CommonAssets.totalRemainingEmiColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),
      ),
    );
}
Widget propertiesShow(List<ProjectNameList> projectDataList,bool isOwn,Size size,){
    final titleSize = size.height*0.02;
    String title = isOwn? AppLocalizations.of(context)!.translate('OwnProperty')!
        :AppLocalizations.of(context)!.translate('CancelProperty')!;
    List<Map<String ,dynamic>> dataProperties ;
    bool isOwnPropertiesPage;
    final fontSize = size.height*0.02;
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: size.height*0.01,vertical: size.height*0.01),
          child: Text(
              title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: size.height*0.02,),
        Container(
          height: size.height *0.18,
          //color: CommonAssets.cardBackGround,
          decoration: BoxDecoration(

              // border: Border.all(
              //     color: Theme.of(context).primaryColor
              // )
          ),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: projectDataList.length,itemBuilder: (context,index){
         //   print(projectDataList[index].projectName);
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: size.width *0.04),
              child: GestureDetector(
                onTap: ()async{
                  int projectFindIndex = isOwn?
                  availableOwnProject.indexWhere((element) =>element ==projectDataList[index].projectName)
                      : availableSoldProject.indexWhere((element) =>element ==projectDataList[index].projectName);

                  dataProperties  = isOwn?ownProperties[projectFindIndex]:soldProperties[projectFindIndex];
                  isOwnPropertiesPage = isOwn?true:false;

                  // print(projectDataList[index].projectName);
                  // print(projectFindIndex);
                   Navigator.push(context, PageRouteBuilder(pageBuilder:(_,__,___)=>
                      ProjectData(projectNameList: projectDataList[projectFindIndex], isOwnPropertiesPage: isOwnPropertiesPage, ownProperties: dataProperties)));
                },
                child: Column(
                //  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        elevation: 10,
                        child: Container(
                          width: size.width /4,
                       //clipBehavior: Clip.hardEdge,
                         decoration: BoxDecoration(

                          // borderRadius: BorderRadius.circular(10.0),
                         ),
                          child:

                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:  projectDataList[index].imagesUrl.first,
                            placeholder: (context, url) => Center(child: CircularLoading(),),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),

                        ),
                      )
                    ),
                     SizedBox(height:size.height*0.01),
                     AutoSizeText(
                          projectDataList[index].projectName,
                       style: TextStyle(
                          fontSize: fontSize
                       ),

                    )
                  ],
                ),
              ),
            );
          }),
        )
      ],
    );
}

  Widget properties(  List<Map<String ,dynamic>>  customerProperties,ProjectRetrieve _projectRetrieve) {
    return ListView.builder(
        itemCount:customerProperties.length,
        itemBuilder: (context,index){

          return Card(

            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).primaryColor
                )
            ),
            child: ListTile(
              onTap: ()async{
                await _projectRetrieve.setProjectName(customerProperties[index]['ProjectName'],'');
                await _projectRetrieve.setLoanRef(customerProperties[index]['LoanRef']);
              //  await _projectRetrieve.setPartOfSociety(customerProperties[index]['Part'],customerProperties[index]['PropertyNumber']);
                print(_projectRetrieve.projectName);
                print(_projectRetrieve.loadId);

                Navigator.push(context, PageRouteBuilder(
                  //    pageBuilder: (_,__,____) => BuildingStructure(),
                  pageBuilder: (_,__,___)=> LoanInfo(),
                  transitionDuration: Duration(milliseconds: 0),
                ));
              },
              title: Text(customerProperties[index]['ProjectName']),
              subtitle: Text(customerProperties[index]['PropertyNumber']),
            ),
          );
        }
    );
  }



  // Widget profile(CustomerInfoModel customerInfoModel,Size size) {
  //
  //
  //   return
  // }
}
