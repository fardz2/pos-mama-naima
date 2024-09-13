import 'package:poin_of_sale_mama_naima/app/models/Product.dart';

class Transaction {
  final int id;
  final String transactionCode;
  final int totalAmount;
  final DateTime createdAt;
  final int totalPayment;
  final int returnOfPayment;
  final List<TransactionItem> transactionItems;

  Transaction({
    required this.id,
    required this.transactionCode,
    required this.totalAmount,
    required this.createdAt,
    required this.totalPayment,
    required this.returnOfPayment,
    required this.transactionItems,
  });

  // Membuat objek Transaction dari Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      transactionCode: map['transaction_code'],
      totalAmount: map['total_amount'],
      createdAt: DateTime.parse(map['created_at']),
      totalPayment: map['total_payment'],
      returnOfPayment: map['return_of_payment'],
      transactionItems: (map['transaction_items'] as List)
          .map((item) => TransactionItem.fromMap(item))
          .toList(),
    );
  }

  // Mengonversi objek Transaction menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_code': transactionCode,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'total_payment': totalPayment,
      'return_of_payment': returnOfPayment,
      'transaction_items':
          transactionItems.map((item) => item.toMap()).toList(),
    };
  }
}

class TransactionItem {
  final int qty;
  final Product product;
  final int unitPrice;

  TransactionItem({
    required this.qty,
    required this.product,
    required this.unitPrice,
  });

  // Membuat objek TransactionItem dari Map
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      qty: map['qty'],
      product: Product.fromMap(map['products']),
      unitPrice: map['unit_price'],
    );
  }

  // Mengonversi objek TransactionItem menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'products': product.toMap(),
      'unit_price': unitPrice,
    };
  }
}
