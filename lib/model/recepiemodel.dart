import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String? image;
  String? name;
  String? procedure;
  List<String>? ingredients;
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
      ingredients: (data['ingredients'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      time: data['time'] as String?,
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';

// class Recipe {
//   String? image;
//   String? name;
//   String? procedure;
//   List<DocumentReference>? ingredients;
//   String? time;

//   Recipe({
//     this.image,
//     this.name,
//     this.procedure,
//     this.ingredients,
//     this.time,
//   });

//   factory Recipe.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Recipe(
//       image: data['image'] as String?,
//       name: data['name'] as String?,
//       procedure: data['procedure'] as String?,
//       ingredients: (data['ingredients'] as List<dynamic>?)
//           ?.map((item) => item as DocumentReference)
//           .toList(),
//       time: data['time'] as String?,
//     );
//   }
// }
