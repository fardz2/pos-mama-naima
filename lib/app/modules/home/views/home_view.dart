import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:poin_of_sale_mama_naima/app/models/product_cart.dart';

import 'package:poin_of_sale_mama_naima/app/routes/app_pages.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/product_card.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:badges/badges.dart' as badges;
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        controller.loadMoreProducts();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Naima"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ),
                          );
                          if (res is String) {
                            if (res == '-1') {
                              Get.snackbar(
                                "Batal",
                                "Tidak jadi",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else {
                              try {
                                await controller.controllerCart
                                    .findProductWithBarCode(res);
                              } catch (e) {
                                Get.snackbar(
                                  "Peringatan",
                                  "Produk tidak ditemukan",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(IconsaxPlusLinear.scan_barcode),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.CART_PRODUCT);
                        },
                        icon: Obx(() => controller.controllerCart.cart.isEmpty
                            ? const Icon(IconsaxPlusLinear.shopping_cart)
                            : badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -14),
                                badgeContent: Text(
                                  controller.controllerCart.cart.length
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                child:
                                    const Icon(IconsaxPlusLinear.shopping_cart),
                              )),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  controller.search.value = value;
                  controller.loadInitialProducts(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Cari barang",
                  contentPadding: const EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.black));
                  }

                  if (controller.products.isEmpty) {
                    return const Center(child: Text("Data tidak ditemukan"));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.products.clear();
                      controller.loadInitialProducts(controller.search.value);
                    },
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: controller.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            Routes.EDIT_PRODUCT,
                            arguments: product,
                          ),
                          child: ProductCard(
                              product: product,
                              onAddToCart: (product) {
                                controller.controllerCart
                                    .addProduct(ProductCart(
                                  id: product.id,
                                  name: product.name,
                                  image: product.image,
                                  price: product.price,
                                  quantity: 1,
                                  barcode: product.barcode,
                                ));
                              }),
                        );
                      },
                    ),
                  );
                }),
              ),
              Obx(() {
                return controller.isLoadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.toNamed(Routes.ADD_PRODUCT);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
