import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'config/environment.dart';
import 'config/firebase_options_dev.dart' as dev;
import 'config/firebase_options_prod.dart' as prod;

Future<void> mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setea el entorno actual (dev o prod)
  AppConfig.environment = env;

  // Inicializa Firebase según entorno
  await Firebase.initializeApp(
    options: env == Environment.prod
        ? prod.DefaultFirebaseOptions.currentPlatform
        : dev.DefaultFirebaseOptions.currentPlatform,
  );

  // Lanza la aplicación
  runApp(const MyApp());
}
