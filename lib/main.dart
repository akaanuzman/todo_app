import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/base/base_singleton.dart';
import 'core/constants/app_constants.dart';
import 'products/views/auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppConstants constants = AppConstants.instance;
  runApp(
    MultiProvider(
      providers: constants.providers,
      child: const MyApp(),
    ),
  );
}

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
