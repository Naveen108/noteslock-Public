import 'package:flutter/material.dart';

class InputTextFormField extends StatelessWidget {
  var texttype;
  final String hinttext;
  final String errortext;
  final String errorcheck;
  final String hinttext2;
  var iconType;
  var onSave;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      child: new TextFormField(
      
        obscureText: obscure,
        autocorrect: false,
        keyboardType: texttype,
        onSaved: onSave,
        validator: (val) => val.length < 1 ? errortext : null,
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

  InputTextFormField(
      {this.texttype,
      this.hinttext,
      this.hinttext2,
      this.iconType,
      this.errortext,
      this.errorcheck,this.obscure,
      this.onSave});
}
