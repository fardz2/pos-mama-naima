import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:poin_of_sale_mama_naima/app/modules/home/controllers/home_controller.dart';
import 'package:poin_of_sale_mama_naima/app/modules/home/views/home_view.dart';
import 'package:poin_of_sale_mama_naima/app/modules/info/views/info_view.dart';

class LandingController extends GetxController {
  final selectedIndex = 0.obs;
  List<Widget> widgetOptions = <Widget>[
    HomeView(),
    const InfoView(),
  ];
  @override
  void onInit() {
    super.onInit();
    Get.put(HomeController());
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
