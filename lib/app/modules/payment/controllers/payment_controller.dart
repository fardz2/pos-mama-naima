import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/modules/cart_product/controllers/cart_product_controller.dart';
import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CartProductController controllerCart = Get.find();
  final int argument =
      Get.arguments ?? 0; // Pastikan argument memiliki nilai default
  final total = 0.obs;
  final isLoading = false.obs;
  final pembayaran = 0.obs;
  final bayar = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    total.value = argument;
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Get.snackbar(
        "Sukses",
        "Pembayaran berhasil",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Simulasi waktu loading

      isLoading.value = false;
      controllerCart.clearCart();
      Get.offAllNamed(Routes.LANDING);
    }
  }

  @override
  void onClose() {
    bayar.dispose();
    super.onClose();
  }

  int calculateKembalian() {
    return pembayaran.value == 0
        ? pembayaran.value
        : pembayaran.value - total.value;
  }
}
