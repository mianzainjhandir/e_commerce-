
import 'package:explorer/services/auth_sevices.dart';
import 'package:explorer/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String selectedRole = "User"; //default selected role for dropdown
  bool isLoading = false;
  bool isPasswordHidden = true;
  // instance for authServices for authentication logic
  final AuthServices _authServices = AuthServices();
  //Sighup function to handle user registration
  void _signUp()async{
    setState(() {
      isLoading = true;
    });
    // Call signup methed from authservices with user input
    String? result = await _authServices.signup(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: selectedRole,
    );
    setState(() {
      isLoading = false;
    });
    if(result == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SignUp Successfully! now turned to login"))
      );
      Get.to(LoginScreen());
    }else{
      //Signup failed
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("SignUp failed$result"))
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                      children: [
                        Image.asset('assets/images/signin.png'),
                        Gap(15),

                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            label: Text("Name"),border: OutlineInputBorder(),
                          ),
                        ),
                        Gap(20),
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
                        Gap(15),
                        //  Dropdown for selecting the role
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: "Role",
                            border: OutlineInputBorder(),
                          ),
                          items: ["Admin", "User"].map((role) {
                            return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // yahan tum apna role store kar sakte ho
                            setState(() {
                              selectedRole = newValue!; //update rolls selection in text field
                            });
                          },
                        ),

                        Gap(20),

                        // Button for SignUp
                        isLoading ?  Center(child: CircularProgressIndicator(),) :
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: (){
                            _signUp();
                          }, child: Text("Signup")),
                        ),
                        Gap(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Already have an account? ",style: TextStyle(fontSize: 16),),
                            InkWell(
                onTap: (){
                  Get.to(LoginScreen());
                },
                child: Text("LogIn here",style: TextStyle(
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
              ),),
    );
  }
}
