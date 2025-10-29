import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> initTestEnvironment() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SizedBox()));
}
