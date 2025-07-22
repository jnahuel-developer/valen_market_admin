import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'config/environment.dart';
import 'config/firebase_options_dev.dart' as dev;
import 'config/firebase_options_prod.dart' as prod;

Future<void> mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.environment = env;

  await Firebase.initializeApp(
    options: env == Environment.prod
        ? prod.DefaultFirebaseOptions.currentPlatform
        : dev.DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
