import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:poin_of_sale_mama_naima/app/helper/format_harga.dart';
import 'package:poin_of_sale_mama_naima/app/models/transaction.dart';

class DetailTransactionController extends GetxController {
  //TODO: Implement DetailTransactionController

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  BluetoothDevice? device;
  String? pathImage;
  final transaction = Get.arguments as Transaction;

  // List<BluetoothDevice> _devices;
  var listBlueDevices = List.empty().obs;

  var connected = false.obs;
  var pressed = false.obs;

  List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (listBlueDevices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('Tidak ada device'),
      ));
    } else {
      for (var dev in listBlueDevices) {
        items.add(DropdownMenuItem(
          value: dev,
          child: Text(dev.name),
        ));
      }
    }
    return items;
  }

  void connect() {
    if (device == null) {
      _show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(device!).catchError((error) {
            pressed.value = false;
            print("error");
          });
          pressed.value = true;
          print("berhasi");
        }
      });
    }
  }

  Future _show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Get.snackbar("Warning!", message, duration: duration);
  }

  void disconnect() {
    bluetooth.disconnect();
    pressed.value = true;
  }

  void tesPrint() async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        // Header Tabel
        bluetooth.printCustom("TokoNaima", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("==============================", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "Item                Qty    Price", 1, 1); // Header kolom
        bluetooth.printCustom("==============================", 1, 1);
        bluetooth.printNewLine();

        // Baris Tabel

        for (var element in transaction.transactionItems) {
          String itemName = element.product.name;
          String qty = element.qty.toString();
          String price = FormatHarga.formatRupiah(element.unitPrice);

          // Menghitung total harga

          // Pastikan panjang itemName, qty, dan price sesuai agar tidak melebihi batas lebar kertas.
          if (itemName.length > 16) {
            itemName = itemName.substring(0, 16); // Batasi panjang nama item
          }

          String line =
              "$itemName${" " * (20 - itemName.length - qty.length)}$qty${" " * (10 - qty.length - price.length)}$price";
          bluetooth.printCustom(line, 1, 1);
        }

        bluetooth.printNewLine();
        bluetooth.printCustom("==============================", 1, 1);
        bluetooth.printNewLine();

        // Cetak Total Harga
        String total = FormatHarga.formatRupiah(transaction.totalAmount);
        bluetooth.printLeftRight("Total", total, 1);
        bluetooth.printNewLine();
        String totalPayment =
            FormatHarga.formatRupiah(transaction.totalPayment);
        bluetooth.printLeftRight("Tunai", totalPayment, 1);
        bluetooth.printNewLine();
        String Kembali = FormatHarga.formatRupiah(transaction.returnOfPayment);
        bluetooth.printLeftRight("Kembali", Kembali, 1);
        bluetooth.printNewLine();

        // Footer Tabel
        bluetooth.printCustom("==============================", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("Terimakasih", 2, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Future<void> initPlatformState() async {
    try {
      listBlueDevices.value = await bluetooth.getBondedDevices();
    } on PlatformException {
      Get.defaultDialog(
        title: "Terjadi Error",
        middleText: "Platform Exception",
      );
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected.value = true;
          pressed.value = false;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected.value = false;
          pressed.value = false;
          break;
        default:
          print(state);
          break;
      }
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
  }

  @override
  void onClose() {
    disconnect();
  }
}
