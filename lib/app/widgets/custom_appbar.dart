import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:poin_of_sale_mama_naima/app/widgets/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            CustomIconButton(
              onPressed: () => Get.back(),
              borderRadius: 30,
              size: 40,
              child: Transform.rotate(
                angle: 90 *
                    3.1415927 /
                    180, // Rotasi 90 derajat ke kiri (dalam radian)
                child: const Icon(
                  IconsaxPlusLinear.arrow_down,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
