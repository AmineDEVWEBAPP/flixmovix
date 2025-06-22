import 'package:get/get.dart';

import '../core/service/scrapping_service.dart';

class DetailsController extends GetxController {
  late String href;
  late String title;
  bool isLoading = false;

  Future<Map<String, dynamic>> getData({String? authorHref}) async {
    Map<String, dynamic> data =
        await ScrappingService.getItemDetails(authorHref ?? href);
    return data;
  }

  Future retry() async {
    isLoading = true;
    update();
    await getData();
    isLoading = false;
    update();
  }

  @override
  void onInit() {
    href = Get.arguments['href'];
    title = Get.arguments['title'];
    super.onInit();
  }
}
