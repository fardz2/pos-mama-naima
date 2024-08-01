import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poin_of_sale_mama_naima/app/models/Product.dart';
import 'package:poin_of_sale_mama_naima/app/helper/format_harga.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: product.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 30, // Atur lebar sesuai kebutuhan
                  height: 30, // Atur tinggi sesuai kebutuhan
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(FormatHarga.formatRupiah(product.price)),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => onAddToCart(product),
                    icon: const Icon(IconsaxPlusLinear.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
