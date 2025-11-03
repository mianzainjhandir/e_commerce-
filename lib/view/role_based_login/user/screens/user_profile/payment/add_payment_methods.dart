
import 'package:flutter/material.dart';

class AddPaymentMethods extends StatefulWidget {
  const AddPaymentMethods({super.key});

  @override
  State<AddPaymentMethods> createState() => _AddPaymentMethodsState();

}
//.......lllll

class _AddPaymentMethodsState extends State<AddPaymentMethods> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Payment Method"),

      ),
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
      
      child: Form(child: Column(
        children: [

        ],
      )),)),
    );
  }
}
//,,,,,,