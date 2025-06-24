import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'config/environment.dart';
import 'config/firebase_options_dev.dart' as dev;
import 'config/firebase_options_prod.dart' as prod;

Future<void> mainCommon(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.environment = env;

  try {
    await Firebase.initializeApp(
      options: env == Environment.prod
          ? prod.DefaultFirebaseOptions.currentPlatform
          : dev.DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado');
  } catch (e, s) {
    print('❌ Error al inicializar Firebase: $e');
    print('📌 StackTrace:\n$s');
  }

  try {
    runApp(MyApp());
  } catch (e, s) {
    print('❌ Error al iniciar la app: $e');
    print('📌 StackTrace:\n$s');
  }
}
