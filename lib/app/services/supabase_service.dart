import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/models/Product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxController {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  // User Collection CRUD

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
}
