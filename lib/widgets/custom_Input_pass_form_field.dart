import 'package:flutter/material.dart';

class CustomInputTextFormField extends StatelessWidget {
  var texttype;
  final String hinttext;
  final String errortext;
  final String errorcheck;
  final String hinttext2;
  var iconType;
  var onSave;
  final bool obscure;
  var passvalidator;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: new TextFormField(
        obscureText: true,
        autocorrect: false,
        keyboardType: texttype,
        onSaved: onSave,
        validator: passvalidator,
        style: new TextStyle(fontSize: 15.0, color: Colors.black),
        decoration: new InputDecoration(
          border: InputBorder.none,
          labelText: hinttext,
          hintText: hinttext2,
          labelStyle: new TextStyle(fontSize: 15.0, color: Colors.black45),
          contentPadding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  CustomInputTextFormField(
      {this.texttype,
      this.hinttext,
      this.hinttext2,
      this.iconType,
      this.errortext,
      this.errorcheck,this.obscure,this.passvalidator,
      this.onSave});
}
