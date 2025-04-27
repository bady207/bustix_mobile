import 'package:get/get.dart';

import '../controllers/result_tiket_controller.dart';

class ResultTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultTiketController>(
      () => ResultTiketController(),
    );
  }
}
