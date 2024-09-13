class Product {
  int id;
  String name;
  String? image;
  int? price;
  String? barcode;
  DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    this.image,
    this.price,
    this.barcode,
    this.createdAt,
  });

  // Factory method to create a Product from a Supabase row
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '', // Default empty string if null
      image: map['image'] ?? '', // Default empty string if null
      price: map['price'] ?? 0, // Default 0 if null
      barcode: map['barcode'] ?? '', // Default empty string if null
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null, // Handle potential null value
    );
  }

  // Method to convert a Product to a Supabase row
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'barcode': barcode,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
