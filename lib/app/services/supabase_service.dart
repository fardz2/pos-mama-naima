import 'package:get/get.dart';

import 'package:poin_of_sale_mama_naima/app/models/Product.dart';
import 'package:poin_of_sale_mama_naima/app/models/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxController {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  // Product Collection CRUD

  Future<List<Product>> getProducts(int page, String search,
      {int pageSize = 10}) async {
    final response = await supabaseClient
        .from('products')
        .select()
        .ilike('name', '%$search%')
        .order('created_at', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    final data = response;
    return data.map((item) => Product.fromMap(item)).toList();
  }
  //crud product

  Future<void> addProduct(
      String name, String image, int price, String barcode) async {
    try {
      await supabaseClient.from('products').insert(
          {'name': name, 'image': image, 'price': price, 'barcode': barcode});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editProduct(
      int id, String name, String image, int price, String barcode) async {
    try {
      await supabaseClient.from('products').update({
        'name': name,
        'image': image,
        'price': price,
        'barcode': barcode
      }).eq('id', id);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    await supabaseClient.from('products').delete().eq('id', id);
  }

  Future<Product> findProductWithBarCode(String barcode) async {
    try {
      final response = await supabaseClient
          .from('products')
          .select()
          .eq('barcode', barcode)
          .single();
      return Product.fromMap(response);
    } catch (e) {
      throw "qr code tidak ditemukan";
    }
  }

  // Transaction Collection CRUD
  Future<void> addTransaction(
    List<Map<String, dynamic>> products,
    int totalAmount,
    String transactionCode,
    int totalPayment,
    int returnOfPayment,
  ) async {
    try {
      await supabaseClient.from('transactions').insert({
        "transaction_code": transactionCode,
        "total_amount": totalAmount,
        "total_payment": totalPayment,
        "return_of_payment": returnOfPayment
      });
      await supabaseClient.from('transaction_items').insert(products);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Transaction>> getTransactionItems() async {
    try {
      final response = await Supabase.instance.client
          .from('transactions')
          .select('*, transaction_items(qty,unit_price, products(id,name))')
          .order('created_at', ascending: false);

      return response.map((item) => Transaction.fromMap(item)).toList();
    } catch (e) {
      throw e;
    }
  }
}
