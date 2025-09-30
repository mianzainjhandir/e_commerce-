
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/view/role_based_login/admin/model/add_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';

final addItemProvider = StateNotifierProvider<AddItemNotifier, AddItemState>((ref){
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemState>{
  AddItemNotifier(): super(AddItemState()){
    fetchCategory();
  }
  // for storing all the items in this collection
  final CollectionReference items =
  FirebaseFirestore.instance.collection('items');

  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('category');

  void pickImage() async {
    try{
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        state = state.copyWith(imagePath : pickedFile.path);
      }
    }catch(e){
      throw Exception("Error saving item: $e");
    }
  }
  void setSelectedCategory(String? category){
    state = state.copyWith(selectedCategory: category);
  }
  void addSize(String size){
    state = state.copyWith(sizes : [...state.sizes, size]);
  }
  void removeSize(String size){
    state = state.copyWith(sizes: state.sizes.where((s) => s != size).toList());
  }
  void addColor(String color){
    state = state.copyWith(colors: [...state.colors, color]);
  }
  void removeColor(String color){
    state = state.copyWith(colors: state.colors.where((c) => c != color).toList());
  }
  void toggleDiscount(bool? isDiscounted){
    state = state.copyWith(isDiscounted:isDiscounted);
  }
  void setDiscountPercentage(String percentage){
    state = state.copyWith(discountPercentage:percentage);
  }
  void setLoading(bool isLoading){
    state = state.copyWith(isLoading:isLoading);
  }
  Future<void> fetchCategory()async{
    try{
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categories =
      snapshot.docs.map((doc)=> doc['name'] as String).toList();
      state = state.copyWith(categories:categories);
    }catch(e){
      throw Exception("Error saving item: $e");
    }
  }
  Future<void> uploadAndSaveItem(String name, String price)async{
    if(name.isEmpty || price.isEmpty || state.imagePath == null || state.selectedCategory == null || state.sizes.isEmpty || state.colors.isEmpty|| (state.isDiscounted && state.discountPercentage==null)){
      throw Exception("Please fill all the fields and upload an image");
    }
    state = state.copyWith(isLoading: true);
    try{
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference = FirebaseStorage.instance.ref().child('image/$fileName');
      await reference.putFile(File(state.imagePath!));
      final imageUrl = await reference.getDownloadURL();


      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await items.add({
        'name': name,
        'price': int.tryParse(price),
        'image':imageUrl,
        'uploadedBy':uid,
        'category': state.selectedCategory,
        'sizes': state.sizes,
        'fcolor': state.colors,
        'isDiscounted': state.isDiscounted,
        'discountPercentage': state.isDiscounted? int.tryParse(state.discountPercentage!):0,
      });

      state = AddItemState();
    }catch(e){
      throw Exception("Error saving item: $e");
    }finally{
      state =state.copyWith(isLoading: false);
    }

  }
}