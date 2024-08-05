import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';
import 'package:poin_of_sale_mama_naima/app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProductController extends GetxController {
  final argument = Get.arguments;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final price = TextEditingController();
  final imageProduct = XFile("").obs;
  final barcode = ''.obs;
  final imageUrl = ''.obs;
  final idProduct = 0.obs;
  final isLoadingEdit = false.obs;
  final isLoadingDelete = false.obs;
  final supabaseService = Get.put(SupabaseService());

  @override
  void onInit() {
    name.text = argument.name;
    price.text = argument.price.toString();
    barcode.value = argument.barcode;
    imageUrl.value = argument.image;
    idProduct.value = argument.id;
    super.onInit();
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);

    if (pickedFile != null) {
      imageProduct.value = pickedFile;
    }
  }

  Future<String> uploadImage(XFile image) async {
    final storage = supabaseService.supabaseClient.storage.from('mama_naima');
    final fileExt = image.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final imageBytes = await image.readAsBytes();

    await storage.uploadBinary(filePath, imageBytes,
        fileOptions: FileOptions(contentType: image.mimeType));
    final imageUrl = storage.getPublicUrl(
      filePath,
    );
    return imageUrl;
  }

  Future<void> editProduct(
      int idProduct, String name, String url, int price, String barcode) async {
    await supabaseService.editProduct(idProduct, name, url, price, barcode);
  }

  Future<void> deleteProduct(int idProduct) async {
    await supabaseService.deleteProduct(idProduct);
  }

  void submit(String information) async {
    if (information == "edit") {
      if (formKey.currentState!.validate()) {
        try {
          isLoadingEdit.value =
              true; // Pindahkan ini ke awal untuk memastikan loading selalu diset
          if (imageProduct.value.path == "") {
            await editProduct(idProduct.value, name.text, imageUrl.value,
                int.parse(price.text), barcode.value);
            Get.snackbar(
              "Sukses",
              "Data produk ${name.text} berhasil diedit",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            String url = await uploadImage(imageProduct.value);
            await editProduct(idProduct.value, name.text, url,
                int.parse(price.text), barcode.value);
            Get.snackbar(
              "Sukses",
              "Data produk ${name.text} berhasil diedit",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          Get.snackbar(
            "Error",
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } finally {
          name.clear();
          price.clear();
          imageProduct.value = XFile("");
          isLoadingEdit.value = false;
          Get.offAllNamed(Routes.LANDING);
        }
      }
    } else {
      isLoadingDelete.value = true;
      await deleteProduct(idProduct.value);
      isLoadingDelete.value = false;
      Get.offAllNamed(Routes.LANDING);
    }
  }

  @override
  void onClose() {
    name.dispose();
    price.dispose();
    super.onClose();
  }
}
