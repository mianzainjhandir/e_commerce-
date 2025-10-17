
import 'package:explorer/core/common/provider/cart_provider.dart';
import 'package:explorer/view/role_based_login/user/user_activity/add_to_cart/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CartOrderCount extends ConsumerWidget {
  const CartOrderCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CartProvider cp = ref.watch(cartService);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Iconsax.shopping_bag,
          size: 28,
        ),
        cp.carts.isNotEmpty ?
        Positioned(
          right: -1,
          top: -5,
          child: GestureDetector(
            onTap: (){
              Get.to(CartScreen());
            },
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  cp.carts.length.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ) : SizedBox(),
      ],
    );
  }
}
