import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/features/Home/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userSharedPreferences = SharedPreferencesService();
  await userSharedPreferences.initialize();

  runApp(
    ChangeNotifierProvider<SharedPreferencesService>.value(
      value: userSharedPreferences,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfect Fit',
      home: const HomeScreen(), // Dein Startbildschirm
    );
  }
}
