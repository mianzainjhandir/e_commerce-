

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../services/auth_sevices.dart';
import '../../../../login_screen.dart';

class UserProfile extends StatelessWidget {

  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthServices authServices = AuthServices();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId).snapshots(),
                    builder: (context ,snapshot){
                      if(!snapshot.hasData || !snapshot.data!.exists){
                        return Center(child: CircularProgressIndicator(),);
                      }
                      final user = snapshot.data;
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: CachedNetworkImageProvider("https://randomuser.me/api/portraits/men/32.jpg"),
                          ),
                          Text(user!['name'],style: TextStyle(
                            fontSize: 20,
                            height: 2,
                            fontWeight: FontWeight.bold
                          ),),
                          Text(user['email'],style: TextStyle(height: 2),),
                        ],
                      );
                    }
                ),
              ),
              SizedBox(height: 20,),
              Divider(),
              Column(
                children: [
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.change_circle_rounded,size: 30,),
                      title: Text("Order",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                  ),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.payments,size: 30,),
                      title: Text("Payment Method",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),),
                    ),
                  ),
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.info,size: 30,),
                      title: Text("About Us",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      authServices.signOut();
                      Get.to(LoginScreen());
                    },
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app,size: 30,),
                      title: Text("Log Out",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
