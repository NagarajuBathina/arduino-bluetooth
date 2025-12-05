import 'package:bluetooth_arduino/screens/home.dart';
import 'package:bluetooth_arduino/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => BlueProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothScreen(),
    );
  }
}
