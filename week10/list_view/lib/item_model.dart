// item_model.dart
class ItemModel {
  final int id;
  final String name;
  final String description;
  final String category;
  bool isFavorite;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.isFavorite = false, // Default false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}