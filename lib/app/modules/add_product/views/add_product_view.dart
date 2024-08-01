import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/helper/product_validation.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/textfield_custom.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  const AddProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Foto Produk *",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: const Color(0xff828282),
                          borderRadius: BorderRadius.circular(10)),
                      child: controller.imageProduct.value.path != ""
                          ? GestureDetector(
                              onTap: () async {
                                await controller.getImage(true);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(controller.imageProduct.value.path),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await controller.getImage(true);
                              },
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldCustom(
                    label: "Nama Produk *",
                    fontWeight: FontWeight.bold,
                    controller: controller.name,
                    hintText: "Contoh : Taro",
                    obscureText: false,
                    validator: ProductValidation.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldCustom(
                    label: "Harga *",
                    fontWeight: FontWeight.bold,
                    controller: controller.price,
                    keyboardType: TextInputType.number,
                    hintText: "Contoh : 2000",
                    obscureText: false,
                    validator: ProductValidation.price,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text(controller.barcode.value)),
                  ElevatedButton(
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(),
                          ));
                      if (res is String) {
                        controller.barcode.value = res;
                      }
                    },
                    child: const Text('Open Scanner'),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 44,
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: () async {
                          if (!controller.isLoading.value) controller.submit();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff54B175), // background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text(
                                "Tambah",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                      );
                    }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
