import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:poin_of_sale_mama_naima/app/helper/format_harga.dart';
import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/custom_appbar.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/custom_cart_card.dart';

import '../controllers/cart_product_controller.dart';

class CartProductView extends StatelessWidget {
  const CartProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProductController controller = Get.find<CartProductController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Keranjang',
              ),
              Obx(() {
                if (controller.cart.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text('Keranjang Kosong')),
                  );
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 40,
                                width: MediaQuery.sizeOf(context).width / 3,
                                child: ElevatedButton(
                                    onPressed: () {
                                      controller.clearCart();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          IconsaxPlusLinear.trash,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Reset',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.cart.length,
                            itemBuilder: (context, index) {
                              final product = controller.cart[index];
                              return CustomCartCard(
                                  product: product,
                                  onDecrement: () =>
                                      controller.decrementQuantity(product),
                                  onIncrement: () =>
                                      controller.incrementQuantity(product));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.PAYMENT, arguments: controller.totalPrice());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Total Harga: ${FormatHarga.formatRupiah(controller.totalPrice())}',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        );
      }),
    );
  }
}
