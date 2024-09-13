import 'dart:ffi';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_transaction_controller.dart';

class DetailTransactionView extends GetView<DetailTransactionController> {
  const DetailTransactionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuldii Printer"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Device:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        return DropdownButton<BluetoothDevice>(
                          items: controller.getDeviceItems(),
                          onChanged: (value) {
                            controller.device = value;
                          },
                          value: controller.device,
                        );
                      }),
                      Obx(() {
                        return ElevatedButton(
                          onPressed: controller.pressed.value
                              ? null
                              : controller.connected.value
                                  ? controller.disconnect
                                  : controller.connect,
                          child: Text(controller.connected.value
                              ? 'Disconnect'
                              : 'Connect'),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: controller.initPlatformState,
                    child: Text('Refresh'),
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                    child: ElevatedButton(
                      onPressed: controller.connected.value
                          ? controller.tesPrint
                          : null,
                      child: Text('TesPrint'),
                    ),
                  );
                }),
              ],
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.transaction.transactionItems.length,
                itemBuilder: (context, index) {
                  final product =
                      controller.transaction.transactionItems[index];
                  return ListTile(
                    title: Text(product.product.name),
                  );
                })
          ],
        ),
      ),
    );
  }
}
