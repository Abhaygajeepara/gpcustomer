import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Project/ProjectDetails.dart';
import 'package:gpgroup/Pages/Customer/ZoomImage.dart';
import 'package:gpgroup/Pages/Project/CustomerProperties.dart';
import 'package:gpgroup/Pages/Rules/Rules.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
class ProjectData extends StatefulWidget {
  ProjectNameList projectNameList;
List<Map<String ,dynamic>> ownProperties ;
  bool isOwnPropertiesPage;
  ProjectData({@required this.projectNameList,
    @required this.isOwnPropertiesPage,
  @required this.ownProperties});
  @override
  _ProjectDataState createState() => _ProjectDataState();
}

class _ProjectDataState extends State<ProjectData> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double titleTextSize = size.height *0.023;
    double valueTextSize = size.height *0.02;
    double normalSpacce = size.height *0.02;
    String ProjectNameUpperCase  = widget.projectNameList.projectName.substring(0,1).toUpperCase()+ widget.projectNameList.projectName.substring(1);
    return Scaffold(
      appBar: CommonappBar(Container()),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric( vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              Container(
                //color: Colors.green,

                child: CarouselSlider.builder(
                    options: CarouselOptions(

                      // height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,

                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: widget.projectNameList.imagesUrl.length,
                    itemBuilder: (BuildContext context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageRouteBuilder(
                            //    pageBuilder: (_,__,____) => BuildingStructure(),
                            pageBuilder: (_, __, ___) => ImageZoom(
                                image: widget.projectNameList.imagesUrl),
                            transitionDuration: Duration(
                                milliseconds: 0),
                          ));
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext  context){
                          //       return Dialog(
                          //         child: Image.network(
                          //           widget.projectNameList.imagesUrl[index],
                          //
                          //         ),
                          //       );
                          //     }
                          // );
                        },
                        child: Image.network(
                          widget.projectNameList.imagesUrl[index],
                          width: size.width,
                          height:size.height *0.3 ,
                          fit:BoxFit.fill,


                        ),
                      );
                    }
                ),

              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(icon: Icon(Icons.notes), onPressed: (){
                    return Navigator.push(context,
                        PageRouteBuilder(pageBuilder:(_,__,___)=>Rules(
                            englishRules: widget.projectNameList.englishRules,
                            gujaratiRules: widget.projectNameList.gujaratiRules,
                            hindiRules: widget.projectNameList.hindiRules
                        )));
                  },color: CommonAssets.editIconColor,),
                  SizedBox(width: size.width *0.03,),
                  // IconButton(icon: Icon(Icons.edit,color: CommonAssets.editIconColor,),
                  //     // onPressed: (){
                  //     //
                  //     // }),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('ProjectName'),
                      style: TextStyle(
                        fontSize:titleTextSize,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      ProjectNameUpperCase,
                      style: TextStyle(
                        fontSize:valueTextSize,


                      ),
                    ),
                    SizedBox(
                      height:normalSpacce,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Landmark'),
                      style: TextStyle(
                        fontSize:titleTextSize,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      widget.projectNameList.landmark,
                      style: TextStyle(
                        fontSize:valueTextSize,


                      ),
                    ),
                    SizedBox(
                      height:normalSpacce,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Address'),
                      style: TextStyle(
                        fontSize:titleTextSize,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      widget.projectNameList.address,
                      style: TextStyle(
                        fontSize:valueTextSize,


                      ),
                    ),
                    SizedBox(
                      height:normalSpacce,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('Description'),
                      style: TextStyle(
                        fontSize:titleTextSize,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      widget.projectNameList.description,
                      style: TextStyle(
                        fontSize:valueTextSize,


                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat ,
      floatingActionButton: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: size.width *0.1),
        shape: StadiumBorder(),
        child: Text(
          AppLocalizations.of(context).translate('Property'),
          style: TextStyle(
              fontSize: size.height*0.02,
            color: CommonAssets.buttonTextColor
          ),
        ),
        color: Theme.of(context).buttonColor,
        onPressed: (){
          return Navigator.push(context,
              PageRouteBuilder(pageBuilder:(_,__,___)=>
                  CustomerProperties(
                  customerProperties: widget.ownProperties,
              )));
        },
      ),
    );
    
  }
}
