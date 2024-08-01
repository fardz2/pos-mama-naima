import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/models/Product.dart';
import 'package:poin_of_sale_mama_naima/app/modules/cart_product/controllers/cart_product_controller.dart';
import 'package:poin_of_sale_mama_naima/app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final supabaseService = Get.put(SupabaseService());
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final CartProductController controllerCart =
      Get.put(CartProductController(), permanent: true);

  var products = <Product>[].obs;
  var isLoadingMore = false.obs;
  var isLoading = false.obs;
  var page = 0;
  final search = "".obs;

  @override
  void onInit() {
    super.onInit();
    _subscribeToProductChanges();
    loadInitialProducts(search.value);
  }

  @override
  void onClose() async {
    super.onClose();
    await supabaseService.supabaseClient.removeChannel(
        supabaseService.supabaseClient.channel('public:products'));
  }

  void _subscribeToProductChanges() {
    supabaseService.supabaseClient
        .channel('public:products')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'products',
            callback: (payload) {
              loadInitialProducts(search.value);
            })
        .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'products',
            callback: (payload) {
              products.removeWhere(
                  (product) => product.id == payload.oldRecord["id"]);
            })
        .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'products',
            callback: (payload) {
              loadInitialProducts(search.value);
            })
        .subscribe();
  }

  void loadInitialProducts(String search) async {
    isLoading.value = true;
    page = 0;
    var newProducts = await supabaseService.getProducts(page, search);

    products.assignAll(newProducts);
    isLoading.value = false;
  }

  void loadMoreProducts() async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;
    page++;
    var newProducts = await supabaseService.getProducts(page, search.value);
    products.addAll(newProducts);
    isLoadingMore.value = false;
  }

  void deleteProduct(int id) async {
    await supabaseService.deleteProduct(id);
    Get.snackbar(
      "Sukses",
      "Data produk berhasil dihapus",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    products.removeWhere((product) => product.id == id);
  }
}
