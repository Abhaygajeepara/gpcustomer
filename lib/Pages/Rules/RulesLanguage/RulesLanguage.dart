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
    final indexFontSize = size.height *0.023;
    return ListView.builder(
        itemCount: widget.rulesdata.length,
        itemBuilder: (context,index){
          int rulesNumber =index+1;
          return Padding(
            padding:  EdgeInsets.symmetric(vertical: size.height*0.005),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(

                  rulesNumber.toString(),

                  style: TextStyle(

                      fontSize:indexFontSize,
                      fontWeight: FontWeight.bold
                  ),

                ),
                SizedBox(width: size.width*0.02,),
                Flexible(
                  child: Text(
                    widget.rulesdata[index].substring(0,1).toUpperCase()+widget.rulesdata[index].substring(1),

                    style: TextStyle(
                        fontSize: size.height *0.02
                    ),
                  ),
                ),
              ],
            ),
          );
        });

  }
}
