import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final TextStyle buttonTextStyle;
  final TextAlign textAlign;
  final Color textFieldColor;
  double elevation;
  final width;
  final height;
  BoxButton(
      {this.buttonName,
      this.onPressed,
      this.buttonTextStyle,
      this.textAlign,
      this.textFieldColor,
      this.elevation,
      this.width,
      this.height});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: RaisedButton(
          elevation: elevation,
          child: Text(
            buttonName,
            //maxLines: 1,
            overflow: TextOverflow.clip,
            textAlign: textAlign,
            style: buttonTextStyle,
          ),
          onPressed: onPressed,
          color: textFieldColor,
        ));
  }
}
