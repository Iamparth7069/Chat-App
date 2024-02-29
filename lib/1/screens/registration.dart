import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:module6/1/screens/login.dart';

import '../firebase/firebase.dart';
import '../model/user.dart';
import '../utils.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String? _name, _email, _password;
  final _passController = TextEditingController();

  FirebaseService service = FirebaseService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createAccount(AppUser user, BuildContext context) async {
    var credential = await service.signup(user.email!, user.password!);
    if (credential is UserCredential) {
      // success
      if (credential.user != null) {
        print('uid : ${credential.user!.uid}');
        user.id = credential.user!.uid;
        service.addUser(user).then((value) {
          //Navigator.pushNamedAndRemoveUntil(context, AppRoute.home, (route) => false);
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginByPhoneNumber()));*/
        }).catchError((error) {
          print(error.toString());
        });
      }
    } else if (credential is String) {
      //failed
      print(credential);
    }
  }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration page'),
        backgroundColor: Colors.purple.shade900,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  //Text('Login',style: TextStyle(fontWeight:FontWeight.bold,color: Colors.black,fontSize: 30.0),),
                  //SizedBox(height: 10.0),
                  Icon(Icons.sms,
                    color: Colors.purple.shade900,
                    size: 60,
                  ),
                  SizedBox(height: 10.0,),
                  Text('Chatter',
                    style: TextStyle(
                      fontSize:22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _name = newValue;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0),),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person,color: Colors.purple.shade900,),
                        hintText: 'User Name',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !Utils.isValidEmail(value)) {
                          return 'Enter valid Email address';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _email = newValue;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0),),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.mail,color: Colors.purple.shade900,),
                        hintText: 'Email address',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _passController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !Utils.isValidPassword(value)) {
                          return 'Enter valid Password';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _password = newValue;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0),),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.lock,color: Colors.purple.shade900,),
                        hintText: 'Password',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!. validate()) {
                          formkey.currentState!.save();
                          print('''
                             name : $_name
                             email: $_email
                             password: $_password
                             ''');
                          var user = AppUser(
                              name: _name,
                              email: _email,
                              password: _password
                          );
                          createAccount(user, context);
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                        }
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.purple.shade900,
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Do have an account?'
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ) ;
  }
}