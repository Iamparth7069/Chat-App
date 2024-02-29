import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user.dart';


class FirebaseService{
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  final DatabaseReference _mRef = FirebaseDatabase.instance.ref();
  final Reference _storageRef = FirebaseStorage.instance.ref();

  //Signup
  Future<dynamic> signup(String email,String password) async {
    try{
      UserCredential credential = await _mAuth.createUserWithEmailAndPassword(email: email!, password: password!);
      return credential;
    } on FirebaseAuthException catch(e) {
      if(e.code == 'Weak password') {
        return 'The password provided is too weak.';
      } else if(e.code == 'Email-already-in-use') {
        return 'The account already exists for that email.';
      }
    }catch(e){
      return e.toString();
    }
  }
  Future<dynamic> login(String email, String password) async {
    try {
      final credential = await _mAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  // Add User
  Future<void> addUser(AppUser user) async {
    return await _mRef.child('user-node').child(user.id!).set(user.toMap());
  }

  //Logout
  Future<void> signOut() async {
    return await _mAuth.signOut();
  }
}