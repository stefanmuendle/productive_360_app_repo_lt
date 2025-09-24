import 'package:flutter/material.dart';

import 'data/notifiers.dart';
import 'views/widget_tree.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

///import 'package:productive_360_app/data/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // navigatorKey: navigatorKey,
          //     navigatorKey, // Navigator for aad oauth (ms mobile auth)
          title: 'Flutter Demo - main screen???',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: value ? Brightness.dark : Brightness.light,
            ),
          ),

          home: WidgetTree(),
        );
      },
    );
  }
}
