import 'package:get/get.dart';
import 'package:phuonghai/app/controllers/ble_controller.dart';

class BleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BleController>(() => BleController());
  }
}
