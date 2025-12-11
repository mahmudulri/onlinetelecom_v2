import 'package:get/get.dart';
import 'package:online_telecom/models/province_model.dart';
import 'package:online_telecom/services/province_service.dart';

import '../models/country_list_model.dart';

class ProvinceController extends GetxController {
  @override
  void onInit() {
    fetchProvince();
    super.onInit();
  }

  var isLoading = false.obs;

  var allprovincelist = ProvincesModel().obs;

  void fetchProvince() async {
    try {
      isLoading(true);
      await ProvinceApi().fetchProvince().then((value) {
        allprovincelist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
