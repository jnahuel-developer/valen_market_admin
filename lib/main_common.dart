import 'package:flutter/material.dart';
import 'config/environment.dart';
import 'app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options_dev.dart' as dev;
import 'config/firebase_options_prod.dart' as prod;

void mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.environment = env;

  await Firebase.initializeApp(
    options: env == Environment.prod
        ? prod.DefaultFirebaseOptions.currentPlatform
        : dev.DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
