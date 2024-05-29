import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String? name;
  String? price;

  Ingredient({this.name, this.price});

  factory Ingredient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ingredient(
      name: data['name'] as String,
      price: data['price'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
    };
  }
}
