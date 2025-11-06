
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPaymentMethods extends StatefulWidget {
  const AddPaymentMethods({super.key});

  @override
  State<AddPaymentMethods> createState() => _AddPaymentMethodsState();

}
//.......lllll

class _AddPaymentMethodsState extends State<AddPaymentMethods> {
  String? selectedPaymentSystem;
  final _formKey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>> fetchPaymentSystem () async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("payment_methods").get();
    return snapshot.docs.map((doc) => {
      'name' : doc['name'],
      'image': doc['image'],
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Payment Method"),

      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
      
      child: Form(
          key: _formKey,
          child: Column(
        children: [
          FutureBuilder(
              future: fetchPaymentSystem(),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Text("No Payment system available");
                }
                return DropdownButton<String>(
                  elevation: 2,
                    value: selectedPaymentSystem,
                    hint: Text("Select Payment System"),
                    items: snapshot.data!.map((system){
                      return DropdownMenuItem<String>(
                          value: system['name'],
                          child: Row(
                            children: [
                              CachedNetworkImage(imageUrl: system['image'],
                                width: 30,height: 30,errorWidget: (context, stackTrace, error) => Icon(
                                    Icons.error),
                              ),
                              SizedBox(width: 10,),
                              Text(system['name'])
                            ],
                          ));}).toList(),
                    onChanged: (value){
                    selectedPaymentSystem = value;
                    // selectedPaymentSystem = snapshot.data!.firstWhere(test)
                    });
              })
        ],
      )),)),
    );
  }
}
//,,,,,,