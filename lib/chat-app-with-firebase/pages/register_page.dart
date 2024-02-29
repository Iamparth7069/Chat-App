import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../service/auth/auth_service.dart';
class RegisterPage extends StatelessWidget {

  //Email and pass texteditingcontroller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  //tap to go to login page
  final void Function()? onTap;

  RegisterPage({super.key,required this.onTap});

   Future<void> register(BuildContext context) async {
     final _auth = AuthService();
      if(_passController.text== _confirmController.text) {
       try{
         String email = _emailController.text.toString();
         String password = _passController.text.toString();
         await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,password: password);
       }catch(e) {
         showDialog(
             context: context,
             builder: (context) =>AlertDialog(
               title: Text(e.toString()),
             ),
         );
       }
     }
     else{
       showDialog(
         context: context,
         builder: (context) =>AlertDialog(
           title: Text('Password dont match'),
         ),
       );
     }
   }
 /*    if (_passController.text == _confirmController.text) {
       try {
         _auth.signUpWithEmailPassword(
             _emailController.text,
             _passController.text
         );
       } catch (e) {
         showDialog(
           context: context,
           builder: (context) =>
               AlertDialog(
                 title: Text(e.toString()),
               ),
         );
       }
     }
     else {
       showDialog(
         context: context,
         builder: (context) =>
             AlertDialog(
               title: Text('Password dont match'),
             ),
       );
     }
   }*/
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
              "Let's create an account for you",
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
            SizedBox(height: 10,),
            MyTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmController,
            ),
            SizedBox(height: 25,),

            //Login button
            MyButton(
              text: 'Register',
              onTap: ()=>register(context),
            ),
            SizedBox(height: 25,),

            //Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login Now',
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
