

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/view/role_based_login/user/models/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import 'items_detail_screen/screen/item_detail_screen.dart';

class CategoryItems extends StatefulWidget {
  final String selectedCategory;
  final String category;
  CategoryItems({
    super.key,
    required this.category,
    required this.selectedCategory});

  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {

  Map<String, Map<String,dynamic>> randomValueCache = {};
  TextEditingController searchController = TextEditingController();

  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filteredItems = [];

  @override initState (){
    searchController.addListener(onSearchChanged);
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged (){
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems.where((item){
        final data = item.data() as Map<String ,dynamic>;
        final itemName = data['name'].toString().toLowerCase();
        return itemName.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final CollectionReference itemsCollection =
    FirebaseFirestore.instance.collection('items');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_outlined),
              ),
              SizedBox(width: 10,),
              Expanded(child: SizedBox(
                height: 45,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: "${widget.category}'s Fashion",hintStyle: TextStyle(color: Colors.black38),
                    filled: true,
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: Icon(Iconsax.search_normal,color : Colors.black38),
                    border: OutlineInputBorder(borderSide: BorderSide.none)
                  ),
                ),
              ))
            ],
          ),),
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filterCategory.length, (index) => Padding(padding: EdgeInsets.only(right: 5),
                child: Container(
                    padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)
                  ),
                  child:  Row(
                    children: [
                      Text(filterCategory[index]),
                      SizedBox(width: 5,),
                      index == 0? Icon(Icons.filter_list,size: 15,) : Icon(Icons.keyboard_arrow_down,size: 15,)

                    ],
                  )
                ),
                ))
              ),
            ),
          ),
          SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                  subcategory.length, (index)=> InkWell(
                  onTap: (){},
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),child:
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(subcategory[index].image),
                          ),
                        ),
                      ),
                      ),
                      SizedBox(height: 10,),
                      Text(subcategory[index].name),
                    ],
                  ),
                ),)
            ),
          ),
          Gap(20),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: itemsCollection.where('category',isEqualTo: widget.selectedCategory).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!.docs;
                    if (allItems.isEmpty) {
                      allItems = items;
                      filteredItems = items;
                    }
                    if (filteredItems.isEmpty) {
                      return Center(child: Text("No items found."),);
                    }

                    return GridView.builder(

                        itemCount: filteredItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final doc = filteredItems[index];
                      final item = doc.data() as Map<String, dynamic>;
                       final itemId = doc.id;
                       
                       if(!randomValueCache.containsKey(itemId)){
                         randomValueCache[itemId] = {
                           "rating" : "${Random().nextInt(2)+3}.${Random().nextInt(5)+4}",
                           "reviews": Random().nextInt(300)+100,
                         };
                       }
                       final cachedRating = randomValueCache[itemId]!['rating'];
                          final cachedReviews = randomValueCache[itemId]!['reviews'];
                      return GestureDetector(
                        onTap: () {
                          Get.to(ItemDetailScreen(
                              productItems: doc));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: doc.id,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image:
                                    CachedNetworkImageProvider(item['image']),
                                      fit: BoxFit.cover,
                                    ),
                                ),
                                height: size.height * 0.25,
                                width: size.width * 0.5,
                                child: Padding(padding: EdgeInsets.all(12),
                                  child: Align(alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.black26,
                                      child: Icon(Icons.favorite_border,
                                        color: Colors.white,),
                                    ),),
                                ),
                              ),
                            ),
                            Gap(7),
                            Row(
                              children: [
                                Text("H&M",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black26),),
                                Gap(5),
                                Icon(Icons.star,
                                  color: Colors.amber,
                                  size: 17,
                                ),
                                Text("$cachedRating"),
                                Text("$cachedReviews", style: TextStyle(
                                  color: Colors.black38,
                                ),),

                              ],
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                              child: Text(
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                item['name'],
                                style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                              ),),
                            ),
                            Row(
                              children: [
                                Text("\$${(item['price']*(1-item['discountPercentage']/100)).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),),
                                SizedBox(width: 5,),
                                if(item['isDiscounted'] == true)
                                  Text("\$${item['price']}.00",
                                    style: TextStyle(
                                        color: Colors.black26,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black26
                                    ),),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  }if(snapshot.hasError){
                    return Center(child: Text("Error: ${snapshot.error}"),);
                  }
                  return Center(child: CircularProgressIndicator(),);
                },
              ),
          )
        ],
      )),
    );
  }
}
