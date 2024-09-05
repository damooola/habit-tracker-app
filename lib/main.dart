import 'package:flutter/material.dart';
import 'package:habit_trackerapp/database/habit_database.dart';
import 'package:habit_trackerapp/pages/home_page.dart';
import 'package:habit_trackerapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  //ensures that necessary setup tasks are completed before app runs.
  WidgetsFlutterBinding.ensureInitialized();
  // setup and database initialize 
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
