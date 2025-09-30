import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/view/login_screen.dart';
import 'package:explorer/view/role_based_login/admin/screens/admin_home_screen.dart';
import 'package:explorer/view/role_based_login/user/screens/user_app_main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Make sure this is imported
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Correct way to initialize Riverpod with Get
  runApp(
    ProviderScope( // ProviderScope must be the root widget
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "data",
      home: AuthStateHandler(),
    );
  }
}
class AuthStateHandler extends StatefulWidget {
  const AuthStateHandler({super.key});

  @override
  State<AuthStateHandler> createState() => _AuthStateHandlerState();
}

class _AuthStateHandlerState extends State<AuthStateHandler> {
  User? _currentUser;
  String? _userRole;

  @override
  void initState(){
    super.initState();
    _initializeAuthState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;

      setState(() {
        _currentUser = user;
        _userRole = null;
      });

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (!mounted) return;

        if (userDoc.exists) {
          setState(() {
            _userRole = userDoc['role'];
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_currentUser==null){
      return LoginScreen();
    }
    if(_userRole == null){
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }
    return _userRole == 'Admin' ? AdminHomeScreen(): UserAppMainScreen();
  }
}