class SubCategory {
  final String name, image;

  SubCategory({required this.name, required this.image});
}

List<SubCategory> subcategory = [
  SubCategory(
    name: "Bags",
    image: "assets/subcategory/footwear.jpg",
  ),
  SubCategory(
    name: "Wallets",
    image: "assets/subcategory/clothes.jpg",
  ),
  SubCategory(
    name: "Footwear",
    image: "assets/subcategory/footwear.jpg",
  ),
  SubCategory(
    name: "Clothes",
    image: "assets/subcategory/clothes.jpg",
  ),
  SubCategory(
    name: "Watch",
    image: "assets/subcategory/watch.jpg",
  ),
  SubCategory(
    name: "Makeup",
    image: "assets/subcategory/makeup.jpg",
  ),
];


List<String> filterCategory = [
  "Filter",
  "Ratings",
  "Size",
  "Color",
  "Price",
  "Brand",
];
