import 'package:cached_network_image/cached_network_image.dart';
import 'package:explorer/core/common/provider/cart_provider.dart';
import 'package:explorer/core/common/utils/color_conversation.dart';
import 'package:explorer/view/role_based_login/user/user_activity/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CartItems extends ConsumerWidget {
  final CartModel cart;
  const CartItems({super.key, required this.cart});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);
    Size size = MediaQuery.of(context).size;
    final finalPrice = num.parse((cart.productData['price']*(1-cart.productData['discountPercentage']/100)).toStringAsFixed(2));
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
                        CircleAvatar(radius: 10, backgroundColor: getColorFromName(cart.selectedColor),
                        ),
                        SizedBox(width: 10,),
                        Text("Size :"),
                        Text(cart.selectedSize,style: TextStyle(fontWeight: FontWeight.bold),),

                      ],
                    ),
                    SizedBox(height: 18,),
                    Row(
                      children: [
                        Text("\$$finalPrice",style: TextStyle(
                          color: Colors.pink,fontWeight: FontWeight.bold,letterSpacing: -1,fontSize: 22
                        ),),
                        SizedBox(width: 45,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap : (){
                                if(cart.quantity>1){
                                  cp.decreaseQuantity(cart.productId);

                                }
                              },
                              child: Container(
                                height: 30,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                  //jjjjj
                                ),
                                child: Icon(
                                  Icons.remove,size: 20,color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              cart.quantity.toString(),style: TextStyle(
                                color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                cp.addCart(
                                    cart.productId,
                                    cart.productData,
                                    cart.selectedColor,
                                    cart.selectedSize
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 25,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,size: 20,color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
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
