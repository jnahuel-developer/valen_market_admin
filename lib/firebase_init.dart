import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options_dev.dart';

Future<void> initializeFirebaseForIntegrationTest() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
