

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/view/role_based_login/user/user_activity/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartService = ChangeNotifierProvider<CartProvider>((ref)=> CartProvider());

class CartProvider with ChangeNotifier{
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void reset(){
    _carts = [];
    notifyListeners();
  }
  final userId = FirebaseAuth.instance.currentUser!.uid;

  set carts(List<CartModel> carts){
    _carts = carts;
    notifyListeners();
  }
  Future<void> addCart(String productId,Map<String, dynamic> productData, String selectedColor, String selectedSize)async{
    int index = _carts.indexWhere((elements) => elements.productId == productId);

    if(index != -1){
      var existingItem = _carts[index];

      _carts[index] = CartModel(
          productId: productId,
          productData: productData,
          quantity: existingItem.quantity +1,
          selectedColor: selectedColor,
          selectedSize: selectedSize
      );
      await _updateCartInFirebase(productId, _carts[index].quantity);
    } else {
      _carts.add(
        CartModel(
            productId: productId,
            productData: productData,
            quantity: 1,
            selectedColor: selectedColor,
            selectedSize: selectedSize
        )
      );
      await _firestore.collection("userCart").doc(productId).set({
        'productData': productData,
        'Quantity':1,
        'selectedColor': selectedColor,
        'selectedSize': selectedSize,
        'uid': userId,
      });
    }
    notifyListeners();
  }
  Future<void>_updateCartInFirebase(String productId, int quantity)async{
    try{
      await _firestore.collection("userCart").doc(productId).update("quantity":quantity);
    } catch(e){
      print(e.toString());
    }
  }
}



