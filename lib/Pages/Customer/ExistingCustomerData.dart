import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/CommonLoading.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';
import 'package:gpgroup/Commonassets/InputDecoration/CommonInputDecoration.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:gpgroup/Model/Loan/LoanInfo.dart';
import 'package:gpgroup/Model/Project/InnerData.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:gpgroup/Pages/Customer/PaidEmiDetails.dart';

import 'package:gpgroup/Service/ProjectRetrieve.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
import 'package:provider/provider.dart';
class LoanInfo extends StatefulWidget {
 
  @override
  _LoanInfoState createState() => _LoanInfoState();
}

class _LoanInfoState extends State<LoanInfo> {
  final  _formKey = GlobalKey<FormState>();

  bool emiPage = false;
  int totalAmount =  0;
  int paidAmount = 0;
  int remainingAmount = 0;

  @override
  Widget build(BuildContext context) {
    final projectRetrieve = Provider.of<ProjectRetrieve>(context);

    final size = MediaQuery.of(context).size;
    final titileSize = size.height /size.width  *8 ;
    final mainTitileSize = size.height /size.width *16 ;
    final normatTextSize = size.height /size.width  *7;
    final fontWeight =FontWeight.bold;
    final  verticalSizeBox = size.height *0.05;
    final  expanedTileSpace =size.height *0.012;
    final fontSize = size.height *0.02;
  calculation(List<SinglePropertiesLoanInfo> loanData,BookingDataModel bookingDataModel){
    totalAmount =  0;
     paidAmount = 0;
     remainingAmount = 0;
      for(int i=0;i<loanData.length;i++){
        totalAmount = totalAmount+bookingDataModel.perMonthEMI;
        if(loanData[i].emiPending){
          remainingAmount = remainingAmount+bookingDataModel.perMonthEMI;
        }
        else{
          paidAmount =paidAmount +bookingDataModel.perMonthEMI;
        }
      }

  }

    return Scaffold(

      appBar: CommonappBar(Container()),
      body:SingleChildScrollView(
        child: StreamBuilder<BookingAndLoan>(
          stream: projectRetrieve.BOOKINGANDLOAN(),
          builder: (context,snapshot){
            if(snapshot.hasData)
              {
                calculation(snapshot.data.loanData,snapshot.data.bookingData);
                   return !emiPage? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                              snapshot.data.bookingData.id.toString(),
                              style: TextStyle(
                                  fontSize: mainTitileSize,
                                  fontWeight: fontWeight
                              ),
                            )
                        ),
                        Divider(color: Theme.of(context).primaryColor,thickness:2 ,),
                        // customer information
                        ExpansionTile(
                          //childrenPadding: EdgeInsets.all(8),
                          //childrenPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context).translate('CustomerInformation'),
                            style: TextStyle(
                                fontSize: titileSize,
                                fontWeight: fontWeight
                            ),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('CustomerName'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                SizedBox(width: size.width *0.01,),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: size.width *0.65,
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,//.horizontal
                                    child: new Text(
                                      snapshot.data.bookingData.customerName,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        fontSize: titileSize,

                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ), SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('CustomerId'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                AutoSizeText(

                                  snapshot.data.bookingData.customerId,

                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                          ],
                        ),
                        // SizedBox(height: verticalSizeBox,),
                        ExpansionTile(
                          childrenPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context).translate('BrokerInformation'),
                            style: TextStyle(
                                fontSize: titileSize,
                                fontWeight: fontWeight
                            ),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('BrokerID'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: size.width *0.65,
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,//.horizontal
                                    child: new Text(
                                      snapshot.data.bookingData.brokerReference,
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        fontSize: titileSize,

                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('BrokerCommission'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.brokerCommission.toString(),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                          ],
                        ),
                        ExpansionTile(
                          childrenPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context).translate('PropertyInformation'),
                            style: TextStyle(
                                fontSize: titileSize,
                                fontWeight: fontWeight
                            ),
                          ),

                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('SquareFeet'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.squareFeet.toString(),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('PricePerSqFt'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.pricePerSquareFeet.toString(),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('BookingDate'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.cusBookingDate.toDate().toString().substring(0,19),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                          ],
                        ),
                        ExpansionTile(
                          childrenPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context).translate('LoanInformation'),
                            style: TextStyle(
                                fontSize: titileSize,
                                fontWeight: fontWeight
                            ),
                          ),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('LoanId'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.loanReferenceCollectionName,
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('MonthlyEMI'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.perMonthEMI.toString(),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('TotalEMI'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.totalEMI.toString(),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('StartingDateOfLoan'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.loanStartingDate.toDate().toString().substring(0,10),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('EndingDateOfLoan'),
                                  style: TextStyle(
                                      fontSize: titileSize,
                                      fontWeight: fontWeight
                                  ),
                                ),
                                Text(
                                  snapshot.data.bookingData.loanStartingDate.toDate().toString().substring(0,10),
                                  style: TextStyle(
                                    fontSize: normatTextSize,

                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: expanedTileSpace,),

                          ],
                        ),
                      ],
                    ),
                  ),
                ):


                   Padding(
                     padding: EdgeInsets.symmetric(vertical: size.height *0.01,horizontal: size.width *0.01),
                   child: Container(
                     height: size.height *0.8,
                     child: ListView.builder(
                       itemCount: snapshot.data.loanData.length,
                         itemBuilder: (context,emiIndex){
                         return Card(
                           shape: RoundedRectangleBorder(
                             side: BorderSide(
                               color: CommonAssets.boxBorderColors
                             )
                           ),
                          color: snapshot.data.loanData[emiIndex].emiPending ? CommonAssets.paidEmiCardColor:Colors.white,
                           child: ListTile(
                             onTap: (){


                                 return    Navigator.push(context, PageRouteBuilder(
                                   pageBuilder: (_, __, ___) =>PaidEmiDetails(singlePropertiesLoanInfo:  snapshot.data.loanData[emiIndex],),
                                   transitionDuration: Duration(seconds: 0),
                                 ),);


                             },
                              title: Text(snapshot.data.loanData[emiIndex].emiId.toString(),style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                             subtitle: Text(snapshot.data.loanData[emiIndex].installmentDate.toDate().toString().substring(0,10)),
                           ),
                         );
                         }
                         ),
                   ),
                   );

              }
            else if(snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(
                  //snapshot.error.toString(),
                   CommonAssets.snapshoterror,
                    style: TextStyle(
                        color: CommonAssets.errorColor
                    ),
                  ),
                ),
              );
            }
            else{
              return CircularLoading();
            }
          }
        ),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:  RaisedButton(
          shape: StadiumBorder(),
          onPressed: (){
            setState(() {
              emiPage = !emiPage;
              print(emiPage);
            });
          },
          child: Text(emiPage ?
          AppLocalizations.of(context).translate('LoanInformation')
              :AppLocalizations.of(context).translate('PropertyInformation'),
            style: TextStyle(
                color: CommonAssets.buttonTextColor
            ),
          ),
        ),

      bottomNavigationBar: !emiPage?Container(height: 1,): Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).primaryColor,
          ),
          child:

          Padding(
              padding:  EdgeInsets.all(8.0),
              child: Container(

                decoration: BoxDecoration(
                  color:  Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0),

                ),

                child: Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                AppLocalizations.of(context).translate('Total'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translate('Income'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),

                              SizedBox(
                                height: titileSize /2,
                              ),
                              Text(
                                totalAmount .toString(),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,

                                    fontSize: fontSize
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                AppLocalizations.of(context).translate('Received'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translate('Income'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),
                              SizedBox(
                                height: titileSize /2,
                              ),
                              Text(
                                paidAmount.toString(),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,

                                    fontSize: fontSize
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                AppLocalizations.of(context).translate('Remaining'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context).translate('Income'),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize
                                ),
                              ),

                              SizedBox(
                                height: titileSize /2,
                              ),
                              Text(
                                remainingAmount.toString(),
                                style: TextStyle(
                                    color: CommonAssets.AppbarTextColor,

                                    fontSize: fontSize
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              )
          )
      ),

    );
  }
}
