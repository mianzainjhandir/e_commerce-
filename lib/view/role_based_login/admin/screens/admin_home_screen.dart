
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/services/auth_sevices.dart';
import 'package:explorer/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'add_items.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  // for storing all the items in this collection
  final CollectionReference items =
  FirebaseFirestore.instance.collection('items');
  String? selectedCategory;
  List<String> categories = [];
  @override
  void initState() {
    fatchCategories();

    super.initState();
  }
  Future<void> fatchCategories() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('category').get();
    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });

  }

  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Your uploaded items",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.receipt_long)),
                      Positioned(
                        top: 6,
                        right: 8,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: Colors.red,
                          child: Center(
                            child: Text(
                              "0",style: TextStyle(
                              color: Colors.white,fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      authServices.signOut();
                      Get.to(LoginScreen());
                    },
                    child: Icon(Icons.exit_to_app),
                  ),
                  DropdownButton<String>(
                      items: categories.map((String category){
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),);
                      }).toList(),
                      icon: Icon(Icons.tune),
                      underline: const SizedBox(),
                      onChanged: (String? newValue){
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: items.where("uploadedBy", isEqualTo: uid).where('category', isEqualTo: selectedCategory).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error loading items"),
                      );
                    }
                    final documents = snapshot.data?.docs ?? [];
                    if (documents.isEmpty) {
                      return Center(
                        child: Text("No item uploaded"),
                      );
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final items = documents[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 2,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: items['image'],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                items['name'] ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        items['price'] != null ? "\$${items['price']}.00" : "N/A",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Gap(10),
                                      Text(
                                        "${items['category'] ?? "N/A"}",
                                      ),
                                      // Gap(5),
                                      // Text("${items['category'] ?? "N/A"}")
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Get.to(AddItems());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
//
// Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text("Welcome to the Admin! page"),
// ElevatedButton(onPressed: (){
// authServices.signOut();
// Get.to(LoginScreen));
// }, child: Text("LogOut"))
// ],
// ),
// ),

