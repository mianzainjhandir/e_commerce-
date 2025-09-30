
import 'package:explorer/view/role_based_login/user/screens/user_app_home_screen.dart';
import 'package:explorer/view/role_based_login/user/screens/user_profile/profile_screen.dart';
import 'package:flutter/material.dart';

class UserAppMainScreen extends StatefulWidget {
  const UserAppMainScreen({super.key});

  @override
  State<UserAppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<UserAppMainScreen> {

  int selectedIndex = 0;
 final List pages = [
   UserAppHomeScreen(),
    Scaffold(),
    Scaffold(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (value){
          setState(() {

          });
          selectedIndex = value;
          },
          elevation: 0,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: "Profile"),
          ]
      ),
      body: pages[selectedIndex],
    );
  }
}























//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../services/auth_sevices.dart';
// import '../../login_screen.dart';
// AuthServices authServices = AuthServices();
// class UserAppFirstScreen extends StatefulWidget {
//    UserAppFirstScreen({super.key});
//
//
//
//   @override
//   State<UserAppFirstScreen> createState() => _UserAppFirstScreenState();
// }
//
// class _UserAppFirstScreenState extends State<UserAppFirstScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User App"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Welcome User"),
//             ElevatedButton(onPressed: (){
//               authServices.signOut();
//               Get.to(LoginScreen());
//             }, child: Text("LogOut"))
//           ],
//         ),
//       ),
//     );
//   }
// }
