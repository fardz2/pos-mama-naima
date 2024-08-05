import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:poin_of_sale_mama_naima/app/helper/product_validation.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/custom_appbar.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/textfield_custom.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../controllers/edit_product_controller.dart';

class EditProductView extends GetView<EditProductController> {
  const EditProductView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const CustomAppBar(title: 'Edit Produk'),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Foto Produk *",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                                        File(
                                            controller.imageProduct.value.path),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await controller.getImage(true);
                                    },
                                    child: CachedNetworkImage(
                                        imageUrl: controller.imageUrl.value),
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
                        Obx(
                          () => TextFieldCustom(
                            label: "Barcode ",
                            fontWeight: FontWeight.bold,
                            keyboardType: TextInputType.number,
                            hintText: controller.barcode.value,
                            obscureText: false,
                            enabled: true,
                            suffixIcon: GestureDetector(
                                onTap: () async {
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
                                child:
                                    const Icon(IconsaxPlusLinear.scan_barcode)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 44,
                          child: Obx(() {
                            return ElevatedButton(
                              onPressed: () async {
                                if (!controller.isLoadingEdit.value) {
                                  controller.submit("edit");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black, // background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: controller.isLoadingEdit.value
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 44,
                          child: Obx(() {
                            return ElevatedButton(
                              onPressed: () async {
                                if (!controller.isLoadingDelete.value) {
                                  bool confirmed = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Konfirmasi"),
                                        content: Text(
                                            "Apakah Anda yakin ingin menghapus produk ${controller.argument.name} ini?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed) {
                                    controller.submit("hapus");
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: controller.isLoadingDelete.value
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Hapus",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
