import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpgroup/Commonassets/Commonassets.dart';

import 'package:gpgroup/Model/Loan/statement.dart';
import 'package:gpgroup/Model/Users/CustomerModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class GeneratePdf{
  Future createPdf(List<StatementModel> statementList,BookingAndLoan customerData,String projectName)async{
    // final projectRetrieve = Provider.of<ProjectRetrieve>(context);
    Timestamp now = Timestamp.now();
    String pdfName = "${customerData.bookingData.propertiesNumber}+${now.toDate().toString().substring(0,16)}";
    final pdf = pw.Document();
    pdf.addPage(

        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,


            build: (context)=>[
             pw.Header(
                  child: pw.Text(CommonAssets.apptitle,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold

                  )
                  )
              ),
              details(customerData, projectName),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Loan Statement',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 25
                )
              ),
              pw.SizedBox(height: 10),
              tablePdf(statementList)
            ]
        )
    );
    //  final dir = await getApplicationDocumentsDirectory();
    final storageRequest = await Permission.storage.request();
    if(storageRequest.isGranted){
    final path= Directory("storage/emulated/0/Download/GPGroup/Statement");
    if ((!await path.exists())){
      path.create();
    }

    final file = File('storage/emulated/0/Download/GPGroup/Statement/${pdfName}.pdf');

    await   file.writeAsBytes(await pdf.save());

    return file.path;

  }else{
      openAppSettings();
    }
  }


  static  Widget details(BookingAndLoan customerDate,String projectName){
    double spaceVer = 5;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(

          children: [
            pw.Expanded(
              child: pw.Text(
                  'Project Name',
                  style: TextStyle(
                      fontWeight: pw.FontWeight.bold
                  )
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                  'Part/Floor',
                  style: TextStyle(
                      fontWeight: pw.FontWeight.bold
                  )
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                  'PropertyNumber',
                  style: TextStyle(
                      fontWeight: pw.FontWeight.bold
                  )
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                  'LoanID',
                  style: TextStyle(
                      fontWeight: pw.FontWeight.bold
                  )
              ),
            )
          ]
        ),
        pw.Row(

            children: [
              pw.Expanded(
                child: pw.Text(
    projectName.substring(0,1).toUpperCase()+projectName.substring(1)

                ),
              ),
              pw.Expanded(
                child: pw.Text(
                    customerDate.bookingData.part
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  customerDate.bookingData.propertiesNumber
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                    customerDate.bookingData.loanReferenceCollectionName
                ),
              )
            ]
        ),



      ]
    );
  }
  static  Widget tablePdf(List<StatementModel> statementList){
    final headerList=[
      'EMI No',
      'EMI Date',
      'Payment Date',
      'Monthly EMI',
      'Paid Amount',
      'Remaining Amount',
      'Delay '
    ];
    final data =statementList.map((e) {
      return [
        e.emiNo.toString(),
        e.emiDate.toDate().toString().substring(0,10) ,
        e.isPending?"": e.paymentDate.toDate().toString().substring(0,10),
        e.amount.toString(),
        e.paidAmount.toString(),
        e.remainingAmount.toString(),
        e.delayDuration.toString(),



      ];
    }).toList();


     return pw.Table.fromTextArray(
         headers: headerList,

        data: data,
        border: null,
       headerStyle: pw.TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
       cellStyle: pw.TextStyle(fontSize: 8)






    );
  }

}


