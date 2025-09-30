
import 'package:flutter/material.dart';

class AppModel{
  final String name, image, description, category;
  final double reting;
  final int review, price;
  List<Color> fcolor;
  List<String> size;
  bool isCheck;


  AppModel({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.reting,
    required this.review,
    required this.price,
    required this.fcolor,
    required this.size,
    required this.isCheck,
});
}

List<AppModel> fashionEcommerceApp = [
  
  AppModel(
      name: "Oversize Fit Printed Mash T shirt",
      image: 'assets/images/dress.png',
      description: "",
      category: "Women",
      reting: 4.9,
      review: 136,
      price: 295,
      fcolor: [
        Colors.black,
        Colors.blue,
        Colors.pink
      ],
      size: [
        "XS",
        "S",
        "M",
      ],
      isCheck: true,
  ),

  AppModel(
    name: "DrMove Track Jacket",
    image: 'assets/images/jacket.png',
    description: "",
    category: "Men",
    reting: 4.1,
    review: 29,
    price: 290,
    fcolor: [
      Colors.black,
      Colors.blueAccent,
      Colors.orange,
    ],
    size: [
      "S",
      "X",
      "XX",
    ],
    isCheck: false,
  ),

  // Teenagers
  AppModel(
    name: "Classic Denim Jacket",
    image: 'assets/images/demin_jecket.png',
    description: "",
    category: "Teens",
    reting: 4.6,
    review: 85,
    price: 320,
    fcolor: [
      Colors.blue,
      Colors.black,
      Colors.lightBlue,
    ],
    size: [
      "XS",
      "S",
      "M",
      "L"
    ],
    isCheck: false,
  ),

// Kids
  AppModel(
    name: "Dino Adventure T-Shirt",
    image: 'assets/images/dino_tshirt.png',
    description: "",
    category: "Kids",
    reting: 4.8,
    review: 112,
    price: 150,
    fcolor: [
      Colors.green,
      Colors.yellow,
      Colors.red,
    ],
    size: [
      "2T",
      "4T",
      "6",
    ],
    isCheck: false,
  ),

// Women
  AppModel(
    name: "Floral Summer Dress",
    image: 'assets/images/floral_dress.png',
    description: "",
    category: "Women",
    reting: 5.0,
    review: 210,
    price: 350,
    fcolor: [
      Colors.white,
      Colors.yellow,
      Colors.pink,
    ],
    size: [
      "S",
      "M",
      "L",
    ],
    isCheck: false,
  ),

// Baby
  AppModel(
    name: "Cozy Bear Jumpsuit",
    image: 'assets/images/jumpsuit.png',
    description: "",
    category: "Baby",
    reting: 4.9,
    review: 65,
    price: 210,
    fcolor: [
      Colors.brown,
      Colors.grey,
      Colors.blue,
    ],
    size: [
      "3-6M",
      "6-9M",
      "9-12M"
    ],
    isCheck: false,
  ),

// Men
  AppModel(
    name: "Casual Slim Fit Polo",
    image: 'assets/images/polo.jpg',
    description: "",
    category: "Men",
    reting: 4.5,
    review: 78,
    price: 250,
    fcolor: [
      Colors.blue,
      Colors.red,
      Colors.white,
    ],
    size: [
      "M",
      "L",
      "XL"
    ],
    isCheck: false,
  ),

// Women
  AppModel(
    name: "Elegant Maxi Skirt",
    image: 'assets/images/skirt.png',
    description: "",
    category: "Women",
    reting: 4.7,
    review: 91,
    price: 280,
    fcolor: [
      Colors.black,
      Colors.purple,
      Colors.green,
    ],
    size: [
      "S",
      "M",
      "L",
    ],
    isCheck: false,
  ),

  AppModel(
    name: "Loose fit Sweet Shirt",
    image: 'assets/images/miami.png',
    description: "",
    category: "Men",
    reting: 4.7,
    review: 59,
    price: 187,
    fcolor: [
      Colors.red,
      Colors.blue,
      Colors.purple,
    ],
    size: [
      "X",
      "XX",
      "XL"
    ],
    isCheck: false,
  ),

  AppModel(
    name: "Loose fit Hoodies",
    image: 'assets/images/hoodie.png',
    description: "",
    category: "Men",
    reting: 5.0,
    review: 29,
    price: 400,
    fcolor: [
      Colors.brown,
      Colors.blueGrey,
      Colors.orange,
    ],
    size: [
      "X",
      "S",
    ],
    isCheck: false,
  ),



];

const myDescription1 = "Evaluate your Casual wardrobe with our";
const myDiscription =
    "Crafted from premium cotton for maximum comfort, this relexed-fit feature";