import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AppVersion{
  String version;
  String download;
  bool active;
  AppVersion({
    @required this.active,
    @required this.download,
    @required this.version
});
  factory AppVersion.of(DocumentSnapshot snapshot){
    return AppVersion(
        active: snapshot['Service'],
        download: snapshot['DownloadLink'],
        version: snapshot['Version']
    );
  }
}