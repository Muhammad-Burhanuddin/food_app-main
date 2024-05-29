import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String? name;
  String? price;
  String? image;

  Ingredient({
    this.name,
    this.price,
    this.image,
  });

  factory Ingredient.fromMap(Map<String, dynamic> data) {
    return Ingredient(
      name: data['name'] as String?,
      price: data['price'] as String?,
      image: data['image'] as String?,
    );
  }
}

class Recipe {
  String? image;
  String? name;
  String? procedure;
  List<Ingredient>? ingredients;
  String? time;

  Recipe({
    this.image,
    this.name,
    this.procedure,
    this.ingredients,
    this.time,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      image: data['image'] as String?,
      name: data['name'] as String?,
      procedure: data['procedure'] as String?,
      ingredients: (data['ringredient'] as List<dynamic>?)
          ?.map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
          .toList(),
      time: data['time'] as String?,
    );
  }
}
