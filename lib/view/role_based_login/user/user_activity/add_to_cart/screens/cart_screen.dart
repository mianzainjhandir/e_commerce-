
import 'package:explorer/core/common/provider/cart_provider.dart';
import 'package:explorer/view/role_based_login/user/user_activity/add_to_cart/widgets/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cp = ref.watch(cartService);
    final carts = cp.carts.reversed.toList();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        elevation: 0,
        title: Text("My Cart",style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
        Expanded(
            child: carts.isNotEmpty ?
            ListView.builder(
                itemCount: carts.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){
              return Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: (){},
                child: CartItems(cart: carts[index]),
              ),
              );
            }
            ):Center(child: Text("Your Cart list is empty",style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),),)
        ),
      ],
      ),
    );
  }
}
