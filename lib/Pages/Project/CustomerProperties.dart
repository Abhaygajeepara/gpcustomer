import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Pages/Customer/ExistingCustomerData.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:provider/provider.dart';

class CustomerProperties extends StatefulWidget {
  List<Map<String ,dynamic>> customerProperties ;
  CustomerProperties({@required this.customerProperties});
  @override
  _CustomerPropertiesState createState() => _CustomerPropertiesState();
}

class _CustomerPropertiesState extends State<CustomerProperties> {

  List<String> imageList =[
    'assets/house.png',
    'assets/apartment.png',
    'assets/Commercial.png',
    'assets/mixed-use.png'

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    String image ;
    final size = MediaQuery.of(context).size;
    final partFontSize = size.height*0.025;
    final propertiesFontSize = size.height*0.02;
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);

    String typeofProject =_projectRetrieve.typeOfProject;
    print(typeofProject);
    if(typeofProject=='Society'){
      image = imageList[0];
    }
    else  if(typeofProject=='Apartment'){
      image = imageList[1];
    }
    else  if(typeofProject=='CommercialArcade'){
      image = imageList[2];
    }
    else {
      image =  imageList[3];
    }
    return Scaffold(
      appBar: CommonappBar(
          _projectRetrieve.projectName,
          Container(),context),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount:widget.customerProperties.length,
          itemBuilder: (context,index){

            return GestureDetector(
             onTap: ()async{
               await _projectRetrieve.setLoanRef(widget.customerProperties[index]['LoanRef']);
               await _projectRetrieve.setPartOfSociety(widget.customerProperties[index]['Part'],widget.customerProperties[index]['PropertyNumber']);
               Navigator.push(context, PageRouteBuilder(
                 pageBuilder: (_,__,___)=> LoanInfo(),
                 transitionDuration: Duration(milliseconds: 0),
               ));
               },
              child: Card(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: CommonAssets.boxBorderColors
                    )
                ),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(image)),
                    Text(
                        widget.customerProperties[index]['Part'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:partFontSize
                    ),
                    ),
                     Text(widget.customerProperties[index]['PropertyNumber'],
                     style: TextStyle(
                       fontSize: propertiesFontSize,
                     ),
                     ),
                  ],
                )
              ),
            );
          }
      ),

    );
  }
}
