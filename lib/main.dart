import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wowza/utils/color.dart';
import 'package:flutter_wowza/config/development.dart';
import 'package:flutter_wowza/env.dart';
import 'package:flutter_wowza/home.dart';
import 'package:flutter_wowza/utils/routes.dart';

import 'constants/locales.dart';
import 'localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: ColorUtils.backgroundMain,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: ColorUtils.backgroundMain,
    systemNavigationBarDividerColor: ColorUtils.backgroundMain,
  ));
  runApp(MyApp(Development()));
}

class MyApp extends StatelessWidget {
  final Env env;
  MyApp(this.env);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [Locale(Locales.en), Locale(Locales.fr)],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,
      theme: ThemeData(
          primaryColor: ColorUtils.backgroundMain,
          accentColor: ColorUtils.secondColor,
          fontFamily: 'Roboto'),
      home: HomePage(),
      locale: Locale(Locales.en),
      routes: routes,
    );
  }
}
