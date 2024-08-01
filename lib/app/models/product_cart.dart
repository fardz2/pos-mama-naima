class ProductCart {
  int? id;
  String name;
  String image;
  int price;
  int quantity;
  String barcode;

  ProductCart({
    this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.barcode,
  });

  // Factory method to create a ProductCart from a Supabase row
  factory ProductCart.fromMap(Map<String, dynamic> map) {
    return ProductCart(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      quantity: map['quantity'],
      barcode: map['barcode'],
    );
  }

  // Method to convert a Product to a Supabase row
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'barcode': barcode,
    };
  }
}
