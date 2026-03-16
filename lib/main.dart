import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/data/services/size_conversion_service.dart';
import 'package:smart_size_converter/src/features/Home/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userSharedPreferences = SharedPreferencesService();
  await userSharedPreferences.initialize();

  final sizeConversionService = SizeConversionService();
  await sizeConversionService.loadDefinitionData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SharedPreferencesService>.value(
          value: userSharedPreferences,
        ),
        ChangeNotifierProvider<SizeConversionService>.value(
          value: sizeConversionService,
        ),
      ],
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
      home: const HomeScreen(),
    );
  }
}
