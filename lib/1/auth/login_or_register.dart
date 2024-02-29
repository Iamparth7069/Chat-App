import 'package:flutter/material.dart';
import 'package:module6/1/screens/login.dart';
import 'package:module6/1/screens/registration.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially, show login page
  bool showLoginPage = true;

  //Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return Login();
    }
    else {
      return Registration();
    }
  }
}
