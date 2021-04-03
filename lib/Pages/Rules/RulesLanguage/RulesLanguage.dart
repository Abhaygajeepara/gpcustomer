import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';


import 'package:gpgroup/app_localization/app_localizations.dart';
class RulesLanguage extends StatefulWidget {
  List<String> rulesdata ;


  RulesLanguage({@required this.rulesdata,});

  @override
  _RulesLanguageState createState() => _RulesLanguageState();
}

class _RulesLanguageState extends State<RulesLanguage> {


  final _fomrkey= GlobalKey<FormState>();
  List<bool> _rulescheck ;
  List<int> _selectedrules=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.selectedrulesindex);
    // _rulescheck = List<bool>.filled(widget.rulesdata.length, false);
    //   for(int i = 0;i<widget.selectedrulesindex.length;i++){
    //       setState(() {
    //         _rulescheck[widget.selectedrulesindex[i]] = true;
    //         _selectedrules.add(widget.selectedrulesindex[i]);
    //       });
    //   }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
    Expanded(
      child: ListView.builder(
      itemCount: widget.rulesdata.length,
          itemBuilder: (context,index){

            return

            Card(

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(

                      color: Colors.black.withOpacity(0.3)
                  )
              ),
              child: ListTile(

                onLongPress: ()async{

                  return showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context).translate('AreYouSure')),
                          content: Text(AppLocalizations.of(context).translate('YouWantToDeleteThisRule')),
                          actions: [
                            RaisedButton(
                              color: Theme.of(context).buttonColor,
                              shape: StadiumBorder(),
                              onPressed: ()async{
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('Cancel'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor
                                ),
                              ),

                            ),


                          ],
                        );
                      }
                  );
                },
                // color: index % 2 ==0?Colors.black:Colors.tealAccent,
                // elevation: index % 2 ==0? 0.0:50.0,

                title: Text(
                  widget.rulesdata[index],
                  style: TextStyle(
                      fontSize: size.height *0.02
                  ),
                ),
              ),
            );
          }),
    ),

      ],
    );

  }
}
