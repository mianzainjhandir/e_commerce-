

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartService = ChangeNotifierProvider<CartProvider>((ref)=> CartProvider());

class CartProvider with ChangeNotifier{

}