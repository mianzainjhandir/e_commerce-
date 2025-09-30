

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/view/role_based_login/user/models/app_model.dart';
import 'package:explorer/view/role_based_login/user/models/category_model.dart';
import 'package:explorer/view/role_based_login/user/screens/category_item.dart';
import 'package:explorer/view/role_based_login/user/screens/items_detail_screen/screen/item_detail_screen.dart';
import 'package:explorer/widgets/curated_items.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserAppHomeScreen extends StatefulWidget {
  const UserAppHomeScreen({super.key});

  @override
  State<UserAppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<UserAppHomeScreen> {
  final CollectionReference categiriesItems =
      FirebaseFirestore.instance.collection('category');
  
  final CollectionReference items =
  FirebaseFirestore.instance.collection('items');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(50),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Image.asset('assets/images/logo.jpg',height: 40,),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.shopping_bag,size: 28,),
                    Positioned(
                        right: -1,top: -5,
                        child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text("3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ))

                  ],
                ),
                ],
              ),
            ),
            Gap(20),
            SizedBox(child: Image.asset('assets/images/salebanner.png')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shop By Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  color: Colors.black87,
                ),
                ),
                Text("See All",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
                )
              ],
            ),
            ),
            StreamBuilder(
              stream: categiriesItems.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if(streamSnapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                          streamSnapshot.data!.docs.length,
                              (index)=> InkWell(
                          onTap: (){
                            //
                            // final filterItems = fashionEcommerceApp
                            //     .where((item)=> item.category.toLowerCase()
                            //     == category[index].name.toLowerCase()
                            // ).toList();

                            Get.to(CategoryItems(
                              selectedCategory: streamSnapshot.data!.docs[index]['name'],
                              category: streamSnapshot.data!.docs[index]
                              ['name'],
                            ));
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),child:
                              CircleAvatar(
                                radius: 30,backgroundColor: Colors.white,
                                backgroundImage: AssetImage(category[index].image),
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text(category[index].name),
                            ],
                          ),
                        ),)
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },

            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Curated For You",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                      color: Colors.black87,
                    ),
                  ),
                  Text("See All",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            StreamBuilder(
              stream: items.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData){
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          snapshot.data!.docs.length,
                              (index){
                            final eCommerceItems = snapshot.data!.docs[index];
                            return Padding(padding: index == 0 ?
                            EdgeInsets.symmetric(horizontal: 20):
                            EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () {
                                   Get.to(ItemDetailScreen(
                                       productItems: eCommerceItems));
                                },
                                child: CuratedItems(eCommerceItems: eCommerceItems, size: size),

                              ),
                            );
                          }
                      ),

                    ),
                  );

                }
                return Center(child: CircularProgressIndicator(),);
              }
            ),

          ],
        ),
      ),
    );
  }
}
