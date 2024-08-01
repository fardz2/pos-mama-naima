import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:poin_of_sale_mama_naima/app/helper/format_harga.dart';
import 'package:poin_of_sale_mama_naima/app/helper/product_validation.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/custom_appbar.dart';

import 'package:poin_of_sale_mama_naima/app/widgets/textfield_custom.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Pembayaran',
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Obx(() {
                      return Text(
                        "Total Pembayaran: ${FormatHarga.formatRupiah(controller.total.value)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }),
                    TextFieldCustom(
                      label: "Bayar*",
                      fontWeight: FontWeight.bold,
                      controller: controller.bayar,
                      hintText: FormatHarga.formatRupiah(2000),
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      onChanged: (String value) {
                        // Gunakan int.tryParse untuk menangani kasus input yang tidak valid
                        final parsedValue = int.tryParse(value);
                        if (parsedValue != null) {
                          controller.pembayaran.value = parsedValue;
                        } else {
                          // Jika parsing gagal, Anda bisa mengatur nilai ke 0 atau menangani kasus ini sesuai kebutuhan
                          controller.pembayaran.value = 0;
                        }
                      },
                      validator: ProductValidation.price,
                    ),
                    Obx(() {
                      return Text(
                        "Kembalian: ${FormatHarga.formatRupiah(controller.calculateKembalian())}",
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 44,
                      child: Obx(() {
                        return ElevatedButton(
                          onPressed: () async {
                            if (!controller.isLoading.value) {
                              controller.submit();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  "Bayar",
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
            ],
          ),
        ),
      ),
    );
  }
}
