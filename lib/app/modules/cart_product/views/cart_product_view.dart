import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/helper/format_harga.dart';
import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';
import '../controllers/cart_product_controller.dart';

class CartProductView extends StatelessWidget {
  const CartProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProductController controller = Get.find<CartProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CartProductView'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cart.isEmpty) {
          return const Center(child: Text('Keranjang Kosong'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.cart.length,
                    itemBuilder: (context, index) {
                      final product = controller.cart[index];
                      return Card(
                        child: ListTile(
                          title: Text(product.name),
                          leading: Image.network(product.image,
                              width: 50, height: 50, fit: BoxFit.cover),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    controller.decrementQuantity(product),
                                icon: const Icon(Icons.remove),
                              ),
                              Text(product.quantity.toString()),
                              IconButton(
                                onPressed: () =>
                                    controller.incrementQuantity(product),
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          subtitle:
                              Text(FormatHarga.formatRupiah(product.price)),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.PAYMENT,
                        arguments: controller.totalPrice());
                  },
                  child: Text(
                    'Total Harga: ${FormatHarga.formatRupiah(controller.totalPrice())}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
