import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InfoView'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Menampilkan CircularProgressIndicator jika isLoading bernilai true
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika tidak loading, tampilkan daftar transaksi
        return ListView.builder(
          itemCount: controller.transaction.length,
          itemBuilder: (context, index) {
            final transaction = controller.transaction[index];
            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail transaksi
                Get.toNamed('/detail-transaction', arguments: transaction);
              },
              child: ListTile(
                title: Text('Transaction ${transaction.transactionCode}'),
                subtitle: Text('Total: ${transaction.totalAmount}'),
              ),
            );
          },
        );
      }),
    );
  }
}
