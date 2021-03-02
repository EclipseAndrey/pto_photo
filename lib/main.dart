import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pto_photo/Pages/Home/Home.dart';
import 'package:pto_photo/Pages/Login/Login.dart';
import 'package:pto_photo/utils/app_keys.dart';
import 'package:pto_photo/Pages/widgets/ConnectionProvider.dart';
import 'generated/l10n.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppKeys.navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        return MediaQuery(
          child: Scaffold(
            key: AppKeys.scaffoldKey,
            body: ConnectionProvider(
              child: child,
            ),
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      initialRoute: Routes.initial,
      routes: <String, WidgetBuilder>{
        Routes.initial: (BuildContext context) => Login(),
      },
    );
  }
}




