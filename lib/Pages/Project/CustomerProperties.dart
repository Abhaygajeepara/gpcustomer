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
  @override
  Widget build(BuildContext context) {
    final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    return Scaffold(
      appBar: CommonappBar(
          _projectRetrieve.projectName,
          Container()),
      body: ListView.builder(
          itemCount:widget.customerProperties.length,
          itemBuilder: (context,index){

            return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: CommonAssets.boxBorderColors
                  )
              ),
              child: ListTile(
                onTap: ()async{
                  await _projectRetrieve.setProjectName(widget.customerProperties[index]['ProjectName'], '');
                  await _projectRetrieve.setLoanRef(widget.customerProperties[index]['LoanRef']);
                  await _projectRetrieve.setPartOfSociety(widget.customerProperties[index]['Part'],widget.customerProperties[index]['PropertyNumber']);
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
                title: Text(widget.customerProperties[index]['ProjectName']),
                subtitle: Text(widget.customerProperties[index]['PropertyNumber']),
              ),
            );
          }
      ),

    );
  }
}
