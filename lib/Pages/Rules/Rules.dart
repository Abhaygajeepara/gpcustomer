import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Setting/RulesModel.dart';
import 'package:gpgroup/Pages/Rules/RulesLanguage/RulesLanguage.dart';


import 'package:gpgroup/app_localization/app_localizations.dart';

class Rules extends StatefulWidget {
  List<String> englishRules;
  List<String> gujaratiRules;
  List<String> hindiRules;
  Rules({
    @required this.englishRules,
    @required this.gujaratiRules,
    @required this.hindiRules
});
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  final _pageContoller = PageController(initialPage: 0);
  final _fomrkey = GlobalKey<FormState>();
  String english;
  String gujarati;
  String hindi;

  @override
  Widget build(BuildContext context) {
    bool _isdeleteon  ;

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CommonappBar(

          AppLocalizations.of(context).translate('Rules'),
            Container()

            //     PopupMenuButton(itemBuilder: (BuildContext contex){
            //   return {'Logout', 'Settings'}.map((String choice) {
            //     return PopupMenuItem<String>(
            //       value: choice,
            //       child: Text(choice),
            //     );
            //   }).toList();
            // })
            ),
        body: Padding(
          padding:  EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.01),
          child: Card(
            child:       PageView(
              controller: _pageContoller,
              children: [
                // isdeleteon's local variable define above
                RulesLanguage(rulesdata: widget.englishRules, ),
                RulesLanguage(rulesdata: widget.gujaratiRules,),
                RulesLanguage(rulesdata: widget.hindiRules,),
              ],
            ),
          ),
        ));
  }


  }

