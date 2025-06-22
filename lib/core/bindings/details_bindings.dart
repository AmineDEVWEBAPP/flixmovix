import 'package:get/get.dart';

import '../../controller/details_controller.dart';

class DetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailsController());
  }
}
