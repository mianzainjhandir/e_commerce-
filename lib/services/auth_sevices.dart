
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // Firebase Authentication intense
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FireStore Instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Function to handel user signup

  Future<String?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
}) async{
    try{
      // Create User in firebase authentication with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim()
      );
      //Save additional user data in firestore (name,email,role)
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'name':name.trim(),
        'email':email.trim(),
        'role': role,  //role determines if user is admin or user
      });
      return null; //Success no error
    }catch(e){
      return e.toString(); //error return the exeption message
    }
  }


  /// Function to handle user login


  Future<String?> login({
    required String email,
    required String password,
  }) async{
    try{
      // SignIn User in firebase authentication with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim()
      );
      // fetching the user role from firestore to determined access level

      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userCredential.user!.uid).get();

      return userDoc['role']; // return the user role (admin/user)
    }catch(e){
      return e.toString(); //error return the exception message
    }
  }

  // for logout

  signOut()async{
    _auth.signOut();
  }

}