import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:module6/chat-app-with-firebase/components/my_button.dart';
import 'package:module6/chat-app-with-firebase/components/my_textfield.dart';

import '../service/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  //Email and pass texteditingcontroller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  //tap to go to register page
  final void Function()? onTap;

    LoginPage({super.key,required this.onTap});

    void login(BuildContext context) async {
      print("Call");
      final authService = AuthService();
      String email = _emailController.text.toString();
      String password = _passController.text.toString();
      try {
        await authService.signInWithEmailPassword(email,password);
      }
      catch(e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            Icon(
                Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 50,),

            //welcome back message
            Text(
              "Welcome back,you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25,),

            //email text-field
            MyTextField(
                hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 10,),
            MyTextField(
                hintText: 'Password',
              obscureText: true,
              controller: _passController,
            ),
            SizedBox(height: 25,),

            //Login button
            MyButton(
                text: 'Login',
                onTap: ()=>login(context),
            ),
            SizedBox(height: 25,),

            //Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                      'Register Now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
