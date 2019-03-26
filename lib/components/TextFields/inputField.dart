import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  IconData icon;
  String hintText;
  String errorText;
  TextInputType textInputType;
  Color textFieldColor, iconColor;
  bool obscureText;
  double bottomMargin;
  TextStyle textStyle, hintStyle;
  var onChanged;
  Key key;

  //passing props in the Constructor.
  InputField(
      {this.key,
      this.hintText,
      this.errorText,
      this.obscureText,
      this.textInputType,
      this.textFieldColor,
      this.icon,
      this.iconColor,
      this.bottomMargin,
      this.textStyle,
      this.onChanged,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin),
        child: new DecoratedBox(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                color: textFieldColor),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: iconColor,
                ),
                new Flexible(
                  child: new TextField(
                    style: textStyle,
                    key: key,
                    obscureText: obscureText,
                    keyboardType: textInputType,
                    onChanged: onChanged,
                    decoration: new InputDecoration(
                        hintText: hintText,
                        hintStyle: hintStyle,
                        errorText: errorText),
                  ),
                ),
              ],
            ))));
  }
}
