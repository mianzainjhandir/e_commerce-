import 'dart:io';

import 'package:explorer/widgets/my_button.dart';
import 'package:explorer/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Add this import
import 'package:gap/gap.dart';

// Import your controller and model
import 'package:explorer/view/role_based_login/admin/controller/add_items_controller.dart';

// Change StatelessWidget to ConsumerWidget
class AddItems extends ConsumerWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _discountpercentageController = TextEditingController();

  AddItems({super.key});

  @override
  // Add WidgetRef ref here
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);


    // Now you can read the state from your provider
    // final addItemState = ref.watch(addItemProvider);
    // You can also access the notifier to call methods like:
    // final notifier = ref.read(addItemProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add New Items"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.imagePath != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(state.imagePath!),
                      fit: BoxFit.cover,
                    ),


                  ):state.isLoading ? CircularProgressIndicator():GestureDetector(
                    onTap: notifier.pickImage,
                    child: Icon(Icons.camera_alt,size: 30,),
                  ),
                ),
              ),
              Gap(10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              Gap(10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
              Gap(10),
              DropdownButtonFormField<String>(
                value: state.selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: notifier.setSelectedCategory,
              items: state.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),);
              }).toList(),),
               Gap(10),
              TextField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: "sizes (comma separated)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value){
                  notifier.addSize(value);
                  _sizeController.clear();
                },
              ),
              Wrap(
                spacing: 8,
                children:
                  state.sizes.map(
                      (size) => Chip(
                          onDeleted: () => notifier.removeSize(size),
                          label: Text(size))
                  ).toList(),
              ),
              Gap(10),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: "Color (Comma Separated)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value){
                  notifier.addColor(value);
                  _colorController.clear();
                },
              ),Wrap(
                spacing: 8,
                children:
                state.colors.map(
                        (color) => Chip(
                        onDeleted: () => notifier.removeColor(color),
                        label: Text(color))
                ).toList(),
              ),
              Row(
                children: [
                  Checkbox(value: state.isDiscounted, onChanged: notifier.toggleDiscount,
                  ),
                  Text("Apply Discount"),
                ],
              ),
              if(state.isDiscounted)
                Column(
                  children: [
                    TextField(
                      controller: _discountpercentageController,
                      decoration: InputDecoration(
                        labelText: "Discount Percentage (%)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value){
                        notifier.setDiscountPercentage(value);
                      },
                    ),

                  ],
                ),
              Gap(10),
              Gap(10),
              state.isLoading ? Center(
                child: CircularProgressIndicator(),
              ):Center(child: MyButton(onTab: ()async{
                try{
                  await notifier.uploadAndSaveItem(_nameController.text, _priceController.text);
                  showSnackBar(context, "Item added successfully!");
                  Navigator.of(context).pop();
                }catch(e){
                  showSnackBar(context, "Error: $e");
                }
              }, buttonText: "Save item"),),

              // You can now add a button to submit the form using your controller's logic
              // ElevatedButton(
              //   onPressed: () {
              //     ref.read(addItemProvider.notifier).uploadAndSaveItem(
              //       _nameController.text,
              //       _priceController.text,
              //     );
              //   },
              //   child: Text("Save Item"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}