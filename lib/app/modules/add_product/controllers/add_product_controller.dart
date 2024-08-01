import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';
import 'package:poin_of_sale_mama_naima/app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final price = TextEditingController();
  final imageProduct = XFile("").obs;
  final barcode = ''.obs;
  final isLoading = false.obs;
  final supabaseService = Get.put(SupabaseService());

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      imageProduct.value = pickedFile;
    }
  }

  // untuk mengupload gambar ke firebase storage
  Future<String> uploadImage(XFile image) async {
    final storage = supabaseService.supabaseClient.storage.from('mama_naima');
    final fileExt = image.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final imageBytes = await image.readAsBytes();

    await storage.uploadBinary(filePath, imageBytes,
        fileOptions: FileOptions(contentType: image.mimeType));
    final imageUrl = storage.getPublicUrl(filePath);
    return imageUrl;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      if (imageProduct.value.path == "") {
        Get.snackbar(
          "Peringatan",
          "Gambar produk belum dipilih",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        isLoading.value = true;
        try {
          String url = await uploadImage(imageProduct.value);
          print(url);
          supabaseService.addProduct(
              name.text, url, int.parse(price.text), barcode.value);
          Get.snackbar(
            "Sukses",
            "Data produk ${name.text} berhasil ditambahkan",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          name.clear();
          price.clear();
          imageProduct.value = XFile("");
          isLoading.value = false;
          Get.offAllNamed(Routes.LANDING);
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  void onClose() {
    name.dispose();
    price.dispose();
    super.onClose();
  }
}
