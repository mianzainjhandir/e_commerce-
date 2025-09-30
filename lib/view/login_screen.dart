

import 'package:explorer/view/role_based_login/admin/screens/admin_home_screen.dart';
import 'package:explorer/view/role_based_login/user/screens/user_app_main_screen.dart';
import 'package:explorer/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../services/auth_sevices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;
  final AuthServices _authServices = AuthServices();
  void login()async{
    setState(() {
      isLoading = true;
    });
    String? result = await _authServices.login(
        email: emailController.text,
        password: passwordController.text);

    setState(() {
      isLoading = false;
    });
    if(result ==  "Admin"){
      Get.to(AdminHomeScreen());
    }else if(result == "User"){
      Get.to(UserAppMainScreen());
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed $result"))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(child: Padding(
          padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/login.png'),
            Gap(15),
            // Input for email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                label: Text("Email"),border: OutlineInputBorder(),
              ),
            ),
            Gap(15),
            // Input for Password
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  label: Text("Password"),border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(isPasswordHidden ? Icons.visibility_off:Icons.visibility))

              ),
              obscureText: isPasswordHidden,
            ),
            Gap(20),
            // Button for login
            isLoading ? Center(child: CircularProgressIndicator(),) :
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                login();
              }, child: Text("Login")),
            ),
            Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Don't have an account? ",style: TextStyle(fontSize: 16),),
                InkWell(
                  onTap: (){
                    Get.to(SignupScreen());
                  },
                  child: Text("SignUp here",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: -1,
                  ),),
                )
              ],
            )
          ],
        
        ),
      ),)),
    );
  }
}
