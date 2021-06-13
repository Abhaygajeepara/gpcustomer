import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Pages/Customer/CustomerData.dart';
import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
class RemainingEMIDetails extends StatefulWidget {
  CustomerInfoModel customerInfoModel;
  RemainingEMIDetails({required this.customerInfoModel});
  @override
  _RemainingEMIDetailsState createState() => _RemainingEMIDetailsState();
}

class _RemainingEMIDetailsState extends State<RemainingEMIDetails> {
  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final _projectRetrieve = Provider.of<ProjectRetrieve>(context);
    return Scaffold(
      appBar: CommonappBar( AppLocalizations.of(context)!.translate('Total')!+" "+AppLocalizations.of(context)!.translate('RemainingEMI')!, Container(), context) as PreferredSizeWidget?,
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
        child: ListView.builder(
            itemCount: widget.customerInfoModel.remainingEMIList.length,
            itemBuilder: (context,index){
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: CommonAssets.boxBorderColors
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.005,horizontal: size.width*0.01),
                  child: ListTile(
                    onTap: ()async{
                      String _projectName = widget.customerInfoModel.remainingEMIList[index].projectName!;
                      var  propertiesPosition = _projectName.indexOf('/');
                      String setProjectName = _projectName.substring(0,propertiesPosition);
                      await _projectRetrieve.setProjectName(setProjectName, '');
                      await _projectRetrieve.setLoanRef(widget.customerInfoModel.remainingEMIList[index].loanRef);
                      print(setProjectName);
                      print(_projectRetrieve.loadId);
                    //  await _projectRetrieve.setPartOfSociety(widget.customerProperties[index]['Part'],widget.customerProperties[index]['PropertyNumber']);
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (_,__,___)=> LoanInfo(),
                        transitionDuration: Duration(milliseconds: 0),
                      ));
                    },
                    title: Text(widget.customerInfoModel.remainingEMIList[index].projectName!),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.customerInfoModel.remainingEMIList[index].loanRef!),
                        Text(widget.customerInfoModel.remainingEMIList[index].pendingEmi.toString()),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
