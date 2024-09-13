import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/models/transaction.dart';
import 'package:poin_of_sale_mama_naima/app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfoController extends GetxController {
  //TODO: Implement InfoController
  final supabaseService = Get.put(SupabaseService());
  final count = 0.obs;
  final transaction = <Transaction>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getTransaction();
  }

  Future<void> getTransaction() async {
    try {
      isLoading.value = true;
      final response = await supabaseService.getTransactionItems();
      transaction.assignAll(response);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
