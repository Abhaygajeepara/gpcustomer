import 'package:flutter/material.dart';


InputDecoration commoninputdecoration = InputDecoration(

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
    ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),

  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),

  ),
  labelStyle: TextStyle(color: Colors.black)
);

InputDecoration loginAndsignincommoninputdecoration = InputDecoration(

    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
      borderRadius: BorderRadius.circular(10.0)
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10.0)
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0)
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0)

    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0)

    ),
    labelStyle: TextStyle(color: Colors.black)
);
InputDecoration searchInputdecoration = InputDecoration(

    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blueGrey),
    // ),
    // disabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blueGrey),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black),
    // ),
    // focusedErrorBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.red),
    //
    // ),
    //
    // errorBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.red),
    //
    // ),
    labelStyle: TextStyle(color: Colors.black)
);