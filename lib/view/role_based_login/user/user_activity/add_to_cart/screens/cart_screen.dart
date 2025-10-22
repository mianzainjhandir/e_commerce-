
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
            ),
            ),
            ),
        ),
          if(carts.isNotEmpty) _buildSummarySection(context, cp)
      ],
      ),
    );
  }
  Widget _buildSummarySection(BuildContext context, CartProvider cp){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: Column(
        children: [
          Row(
            children: [
              Text("Delivery",style: TextStyle(
                fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,

              ),),
              SizedBox(width: 10,),
              Expanded(child: Divider()),
              SizedBox(width: 10,),
              Text(
                "\$4.99",style: TextStyle(
                fontSize: 20,color: Colors.red,
                fontWeight: FontWeight.bold,letterSpacing: -1,

              ),),

            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text("Total Order",style: TextStyle(
                fontWeight: FontWeight.w600,fontSize: 20,color: Colors.black
              ),),
              SizedBox(width: 10,),
              Expanded(child: Divider()),
              SizedBox(width: 10,),
              Text("\$${(cp.totalCart()).toStringAsFixed(2)}", style: TextStyle(
                color: Colors.redAccent,fontSize: 22,fontWeight: FontWeight.w600,letterSpacing: -1,
              ),)

            ],
          ),
          SizedBox(height: 40,),
          MaterialButton(
            color: Colors.black,
            height: 70,
            minWidth: MediaQuery.of(context).size.width-50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: (){},
            child: Text("Pay \$${(cp.totalCart() +4.99).toStringAsFixed(2)}",
            style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold
                ,color: Colors.white
            ),),
          ),
        ],
      ),
    );
  }
}
