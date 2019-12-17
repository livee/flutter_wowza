import 'package:flutter/material.dart';
import 'package:flutter_wowza/utils/color.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double minWidth;
  final Color color;
  final BorderRadius borderRadius;
  final Widget afterIcon;
  final bool enabled;
  final double fontSize;
  final double width;

  ActionButton(
      {Key key,
      this.text,
      this.onPressed,
      this.minWidth = 200,
      this.color,
      this.borderRadius = BorderRadius.zero,
      this.afterIcon,
      this.enabled = true,
      this.fontSize = 14,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color localColor = enabled ? color : ColorUtils.grey;
    Widget textContainer = Text(text,
        style: TextStyle(color: ColorUtils.white, fontSize: fontSize));

    if (afterIcon != null) {
      textContainer = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: ColorUtils.white,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(text, style: TextStyle(color: ColorUtils.white))),
            afterIcon
          ]);
    }

    return Container(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: ButtonTheme(
                          minWidth:
                              width ?? MediaQuery.of(context).size.width * 0.9,
                          height: 56,
                          buttonColor: localColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                          ),
                          padding: EdgeInsets.all(12),
                          child: RaisedButton(
                              elevation: 10,
                              onPressed: enabled ? onPressed : () => {},
                              child: textContainer)))
                ])));
  }
}
