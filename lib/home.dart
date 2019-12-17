import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wowza/utils/color.dart';

import 'components/buttons/action_button.dart';
import 'components/logo_box.dart';
import 'components/textFields/center_text.dart';
import 'localizations.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';
  static const platform = const MethodChannel('test_activity');

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscurePassword, _isLoading, _agreeDataProcessing;
  TextEditingController _hostController,
      _portController,
      _appNameController,
      _streamNameController;
  String _hostError, _portError, _appNameError, _streamNameError;

  AppLocalizations _local(context) => AppLocalizations.of(context);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _obscurePassword = true;
    _isLoading = false;
    _agreeDataProcessing = true;

    _hostController = TextEditingController();
    _portController = TextEditingController();
    _appNameController = TextEditingController();
    _streamNameController = TextEditingController();
    _hostController.text = 'video1.livee.com';
    _portController.text = '1935';
    _appNameController.text = 'live';
    _streamNameController.text = 'livetest.633503';
  }

  Future _loadSurveyMonkey() async {
    try {
      await HomePage.platform
          .invokeMethod('helloFromNativeCode', <String, dynamic>{
        'cloud_connection_code': '',
        'host_address': _hostController.text,
        'port_number': _portController.text,
        'app_name': _appNameController.text,
        'stream_name': _streamNameController.text,
        'source_user_name': '',
        'source_password': '',
        'source_password': '',
        'vide_frame': '',
        'bitrate': '1500',
        'framerate': '30',
        'keyframe_interval': '30',
        'enable_audio': false,
      });
      //.then((result) {
      //Fluttertoast.showToast(
      //    msg: result,
      //    toastLength: Toast.LENGTH_SHORT,
      //    gravity: ToastGravity.CENTER,
      //    timeInSecForIos: 1,
      //    backgroundColor: Colors.red,
      //    textColor: Colors.white,
      //    fontSize: 16.0);
      //});
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget _homeScreen() {
    var fieldWidth = MediaQuery.of(context).size.width - 32;

    return Center(
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          LogoBox(margin: EdgeInsets.only(bottom: 16)),
          CenterTextField(
              width: fieldWidth,
              textController: _hostController,
              textError: _hostError,
              label: "Host",
              textInputType: TextInputType.text),
          CenterTextField(
              width: fieldWidth,
              textController: _portController,
              textError: _portError,
              label: "Port",
              textInputType: TextInputType.number),
          CenterTextField(
              width: fieldWidth,
              textController: _appNameController,
              textError: _appNameError,
              label: "App Name",
              textInputType: TextInputType.text),
          CenterTextField(
              width: fieldWidth,
              textController: _streamNameController,
              textError: _streamNameError,
              label: "Stream Name",
              textInputType: TextInputType.text),
          ActionButton(
              width: fieldWidth,
              text: "OPEN STREAM VIEW",
              onPressed: () async => await _loadSurveyMonkey(),
              enabled: _agreeDataProcessing,
              color: ColorUtils.secondColor,
              fontSize: 18,
              borderRadius: BorderRadius.circular(8)),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtils.white,
        key: _scaffoldKey,
        body: _homeScreen());
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(_local(context).appName),
  //     ),
  //     body: Center(
  //       child: RaisedButton(
  //         onPressed: _loadSurveyMonkey,
  //         child: Text("Open stream view"),
  //       ),
  //     ),
  //   );
  // }
}
