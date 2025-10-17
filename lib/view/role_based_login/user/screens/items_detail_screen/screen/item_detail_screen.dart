import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/core/common/cart_order_count.dart';
import 'package:explorer/core/common/provider/cart_provider.dart';
import 'package:explorer/view/role_based_login/user/models/app_model.dart';
import 'package:explorer/view/role_based_login/user/screens/items_detail_screen/widget/size_and_color.dart';
import 'package:explorer/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/common/provider/favourite_provider.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final DocumentSnapshot<Object?> productItems;
  const ItemDetailScreen({super.key, required this.productItems});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 1;
  int selectedSizeIndex = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cp = ref.watch(cartService);
    FavoriteProvider provider = ref.watch(favoriteProvider);

    final finalprice = num.parse(
      (widget.productItems['price'] *
          (1 - widget.productItems['discountPercentage'] / 100))
          .toStringAsFixed(2),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Items Detail Screen"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          CartOrderCount(),
          SizedBox(width: 20,)
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: size.height * 0.46,
            width: size.width,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Hero(
                      tag: widget.productItems.id,
                      child: CachedNetworkImage(
                        imageUrl: widget.productItems['image'],
                        height: size.height * 0.4,
                        width: size.width * 0.85,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                            (index) => AnimatedContainer(
                          duration: Duration(microseconds: 300),
                          margin: EdgeInsets.only(right: 4),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: index == currentIndex
                                ? Colors.blue
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "H&M",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black26,
                      ),
                    ),
                    Gap(5),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 17,
                    ),
                    Text("${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}"),
                    Text("(${Random().nextInt(300) + 55})"),
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          provider.toggleFavorite(widget.productItems);
                        },
                        child : Icon(provider.isExist(widget.productItems)?
                        Icons.favorite
                            : Icons.favorite_border,
                        color: provider.isExist(widget.productItems)? Colors.red: Colors.black,

                        )

                    ),
                  ],
                ),
                Text(
                  widget.productItems['name'],
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$$finalprice",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 5),
                    if (widget.productItems['isDiscounted'] == true)
                      Text(
                        "\$${widget.productItems['price']}.00",
                        style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black26,
                        ),
                      )
                  ],
                ),
                Gap(15),
                Text(
                  "$myDescription1 ${widget.productItems['name']}$myDiscription",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
                Gap(20),

                // 🔧 FIXED SECTION
                SizeAndColor(
                  colors: widget.productItems.data().toString().contains('fcolor')
                      ? List<String>.from(widget.productItems['fcolor'])
                      : [],
                  sizes: widget.productItems.data().toString().contains('sizes')
                      ? List<String>.from(widget.productItems['sizes'])
                      : [],
                  onColorSelected: (index) {
                    setState(() {
                      selectedColorIndex = index;
                    });
                  },
                  onSizeSelected: (index) {
                    setState(() {
                      selectedSizeIndex = index;
                    });
                  },
                  selectedColorIndex: selectedColorIndex,
                  selectedSizeIndex: selectedSizeIndex,
                ),
              ],
            ),

          ),
          SizedBox(height: 10,)
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Colors.white,
        label: SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: GestureDetector(

                    onTap: (){
                      final productId = widget.productItems.id;
                      final productData = widget.productItems.data() as Map<String,dynamic>;

                      final selectedColor = widget.productItems['fcolor'][selectedColorIndex];
                      final selectedSize = widget.productItems['sizes'][selectedSizeIndex];

                      cp.addCart(
                          productId,
                          productData,
                          selectedColor,
                          selectedSize
                      );
                      showSnackBar(context, "${productData['name']} added to cart");
                    },
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.shopping_bag,
                          color: Colors.black,
                        ),
                        Gap(5),
                        Text(
                          "ADD TO CART",
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: -1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "BUY NOW",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
