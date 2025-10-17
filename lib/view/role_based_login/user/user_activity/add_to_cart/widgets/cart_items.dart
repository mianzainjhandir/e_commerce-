import 'package:cached_network_image/cached_network_image.dart';
import 'package:explorer/core/common/utils/color_conversation.dart';
import 'package:explorer/view/role_based_login/user/user_activity/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartItems extends StatelessWidget {
  final CartModel cart;
  const CartItems({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 120,
      width: size.width/1.1,
      child: Column(children: [
        Row(
          children: [
          SizedBox(width: 20,),
            CachedNetworkImage(
              imageUrl: cart.productData['image'],
              height: 120,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(cart.productData['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text("Color:"),
                        Gap(5),
                        CircleAvatar(radius: 10, backgroundColor: getColorFromName(cart.selectedColor),)
                      ],
                    )
                  ],
                ),
            ),
        ],
        ),
      ],
      ),
    );
  }
}
