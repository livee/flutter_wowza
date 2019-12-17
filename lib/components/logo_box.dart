import 'package:flutter/material.dart';
import 'package:flutter_wowza/constants/assets.dart';

class LogoBox extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  LogoBox({Key key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin != null ? margin : EdgeInsets.only(bottom: 50),
      child: Image.asset(
        Assets.logo,
        width: 80,
        height: 80,
      ),
      width: 150,
      height: 150,
      padding: EdgeInsets.all(10),
    );
  }
}
