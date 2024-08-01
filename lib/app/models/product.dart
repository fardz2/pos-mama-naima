class Product {
  int id;
  String name;
  String image;
  int price;
  String barcode;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.barcode,
    required this.createdAt,
  });

  // Factory method to create a Product from a Supabase row
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      barcode: map['barcode'],
      createdAt: DateTime.parse(map['created_at']),
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}
