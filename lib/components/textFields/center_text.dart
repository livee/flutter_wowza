import 'package:flutter/material.dart';
import 'package:flutter_wowza/utils/color.dart';

class CenterTextField extends StatefulWidget {
  final TextEditingController textController;
  final String textError;
  final String label;
  final TextInputType textInputType;
  final double width;
  final Color mainColor;
  final Color secondColor;
  final bool enabled;

  CenterTextField(
      {Key key,
      this.textController,
      this.textError,
      this.label,
      this.textInputType,
      this.width,
      this.mainColor = ColorUtils.textHintColor,
      this.secondColor = ColorUtils.textHintColor,
      this.enabled = true})
      : super(key: key);

  @override
  _CenterTextFieldState createState() => _CenterTextFieldState();
}

class _CenterTextFieldState extends State<CenterTextField> {
  FocusNode _focus = FocusNode();
  Color currentColor;

  @override
  void initState() {
    currentColor = widget.mainColor;

    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    currentColor = _focus.hasFocus ? widget.secondColor : widget.mainColor;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textBorder = OutlineInputBorder(
        borderSide: BorderSide(
            color: widget.textError != null ? ColorUtils.red : currentColor,
            width: 2.0),
        borderRadius: BorderRadius.circular(8.0));

    var errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: ColorUtils.red, width: 2.0),
      borderRadius: BorderRadius.circular(8.0),
    );

    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
              constraints: BoxConstraints(
                  maxWidth:
                      widget.width ?? MediaQuery.of(context).size.width * 0.9,
                  minWidth:
                      widget.width ?? MediaQuery.of(context).size.width * 0.9),
              margin: EdgeInsets.only(bottom: 10),
              child: Theme(
                  data: ThemeData(
                      primaryColor: widget.secondColor,
                      accentColor: widget.secondColor,
                      disabledColor: widget.textError != null
                          ? ColorUtils.red
                          : currentColor,
                      hintColor: widget.textError != null
                          ? ColorUtils.red
                          : currentColor),
                  child: TextField(
                    focusNode: _focus,
                    style: TextStyle(color: widget.secondColor),
                    keyboardType: widget.textInputType,
                    controller: widget.textController,
                    cursorColor: ColorUtils.red,
                    decoration: InputDecoration(
                        enabled: widget.enabled,
                        focusedBorder: textBorder,
                        disabledBorder: textBorder,
                        enabledBorder: textBorder,
                        errorBorder: errorBorder,
                        focusedErrorBorder: errorBorder,
                        suffixStyle:
                            TextStyle(color: ColorUtils.red, fontSize: 12),
                        suffixText: widget.textError,
                        labelText: widget.label),
                  )))
        ]));
  }
}
