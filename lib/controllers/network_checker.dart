import 'package:get/get.dart';
import 'package:online_telecom/controllers/check_internet_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
