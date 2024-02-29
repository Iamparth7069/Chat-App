import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:module6/1/screens/home.dart';
import 'package:module6/1/screens/registration.dart';
import '../firebase/firebase.dart';
import '../preference/prefutils.dart';
import '../utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? errorEmail,errorPassword;


  FirebaseService service = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0),),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.mail,color: Colors.purple.shade900),
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
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
                    onPressed: () async {
                      String email = _emailController.text.toString().trim();
                      String password = _passwordController.text.toString().trim();

                      // reset focus
                      errorEmail = null;
                      errorPassword = null;

                      if (email.isEmpty || !Utils.isValidEmail(email)) {
                        // show error on email
                        setState(() {
                          errorEmail = 'Enter valid email';
                        });
                      } else if (!Utils.isValidPassword(password)) {
                        // show error on password
                        setState(() {
                          errorPassword = 'Enter valid password';
                        });
                      } else {
                        PrefUtils.updateLoginStatus(true);
                        var check =await login(email, password, context);
                        print(check);
                        if(check is UserCredential){
                          //print("call");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        }
                        else {
                          print("error");
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                ),
                TextButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Registration()));

                            },
                            child: Text('or create an account'),
                        ),
                    ],
                  ),
                ),
            ),
    );
  }
  Future<dynamic> login(String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print("User id ${credential.user!.uid}");
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user";
      }
    }
  }
}
