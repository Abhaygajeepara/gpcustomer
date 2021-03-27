import 'package:flutter/material.dart';
import 'package:gpgroup/Commonassets/commonAppbar.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ImageZoom extends StatefulWidget {
  List<String> image;
  ImageZoom({@required this.image});
  @override
  _ImageZoomState createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  String selectedUrl ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedUrl = widget.image.first;
  }
  @override

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonappBar(Container()),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width *0.2,

            child: ListView.builder(
            itemCount: widget.image.length   ,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectedUrl =   widget.image[index];
                  });
                },
                child: Card(
                  child: Image.network(
                    widget.image[index],
                    width: size.width *0.2,
                    height: size.height*0.1,
                    fit:BoxFit.cover,


                  ),
                ),
              );
            }),
          ),
          VerticalDivider(
            color: Theme.of(context).primaryColor,
            thickness: 2,
          ),
          Expanded(
            child: Zoom(
              backgroundColor: Colors.transparent,
              initZoom: 0.0,
              width: size.width*4,
              height: size.height*4,
              child: Image.network(
               selectedUrl,

                // fit:BoxFit.cover,


              ),
            ),
          ),
        ],
      ),

    );
  }
}
