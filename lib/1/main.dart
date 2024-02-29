import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:module6/1/preference/prefutils.dart';
import 'package:module6/1/screens/login.dart';


//void main() => runApp(MyApp());
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefUtils.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Registration using sqlite',
      home: Login(),
    );
  }
}
