import 'package:flutter/material.dart';
import 'core/base/base_singleton.dart';
import 'products/views/auth/login_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget with BaseSingleton {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.appTitle,
      theme: theme.themeData,
      debugShowCheckedModeBanner: constants.debugShowCheckedModeBanner,
      localizationsDelegates: constants.localizationsDelegates,
      supportedLocales: constants.supportedLocales,
      navigatorKey: constants.navigatorKey,
      home: const LoginView(),
    );
  }
}
