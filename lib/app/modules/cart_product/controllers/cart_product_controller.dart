import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/models/product_cart.dart';
import 'package:poin_of_sale_mama_naima/app/services/supabase_service.dart';

class CartProductController extends GetxController {
  final supabaseService = Get.put(SupabaseService());
  final cart = <ProductCart>[].obs;

  Future<void> findProductWithBarCode(String barcode) async {
    // Mencari produk di keranjang berdasarkan barcode
    final index = cart.indexWhere((product) => product.barcode == barcode);

    if (index != -1) {
      // Jika produk ditemukan di keranjang, tambahkan quantity-nya
      cart[index].quantity++;
      Get.snackbar(
        "Sukses",
        "Jumlah Produk ${cart[index].name} berhasil ditambahkan ke keranjang",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // Jika produk tidak ditemukan di keranjang, cari di database
      final product = await supabaseService.findProductWithBarCode(barcode);
      cart.add(ProductCart(
        id: product.id,
        name: product.name,
        image: product.image.toString(),
        price: int.parse(product.price.toString()),
        quantity: 1,
        barcode: product.barcode.toString(),
      ));
      Get.snackbar(
        "Sukses",
        "Produk ${product.name} berhasil ditambahkan ke keranjang",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void addProduct(ProductCart product) {
    final index = cart.indexWhere((value) => product.id == value.id);

    if (index != -1) {
      cart[index].quantity++;
      Get.snackbar(
        "Sukses",
        "Jumlah Produk ${product.name} berhasil ditambahkan ke keranjang",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      cart.add(product);
      Get.snackbar(
        "Sukses",
        "Produk ${product.name} berhasil ditambahkan ke keranjang",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void incrementQuantity(ProductCart product) {
    product.quantity++;
    cart.refresh();
  }

  void decrementQuantity(ProductCart product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      cart.remove(product);
    }
    cart.refresh();
  }

  int totalPrice() {
    return cart.fold(
        0, (sum, product) => sum + (product.price * product.quantity).toInt());
  }

  void clearCart() {
    cart.clear();
  }
}
