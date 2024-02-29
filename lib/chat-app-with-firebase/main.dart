import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:module6/chat-app-with-firebase/Themes/theme_provider.dart';
import 'package:module6/chat-app-with-firebase/service/auth/auth_gate.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
