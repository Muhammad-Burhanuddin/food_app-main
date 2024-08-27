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

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'image': image,
      };

  static Ingredient fromJson(Map<String, dynamic> json) => Ingredient(
        name: json['name'],
        price: json['price'],
        image: json['image'],
      );
}

class Recipe {
  String? image;
  String? name;
  String? procedure;
  List<Ingredient>? ingredients;
  String? time;
  double? rating; // Added rating field

  Recipe({
    this.image,
    this.name,
    this.procedure,
    this.ingredients,
    this.time,
    this.rating,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      image: data['image'] as String?,
      name: data['name'] as String?,
      procedure: data['procedure'] as String?,
      ingredients: (data['ingredients'] as List<dynamic>?)
          ?.map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
          .toList(),
      time: data['time'] as String?,
      rating: (data['rating'] as num?)?.toDouble(), // Map rating field
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'procedure': procedure,
        'ingredients': ingredients?.map((i) => i.toJson()).toList(),
        'image': image,
        'time': time,
        'rating': rating, // Include rating in JSON
      };

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
        name: json['name'],
        procedure: json['procedure'],
        ingredients: (json['ingredients'] as List)
            .map((i) => Ingredient.fromJson(i))
            .toList(),
        image: json['image'],
        time: json['time'],
        rating: (json['rating'] as num?)?.toDouble(), // Parse rating from JSON
      );
}
