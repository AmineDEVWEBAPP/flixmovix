import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';

class GridViewLoading {
  static builder({
    int? itemCount,
    required Widget Function(int index) itemBuilder,
    required Future<void> Function() onEnd,
  }) =>
      GridViewBuilder(
          itemCount: itemCount, itemBuilder: itemBuilder, onEnd: onEnd);
}

class GridViewBuilder extends StatefulWidget {
  const GridViewBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onEnd,
  });
  final int? itemCount;
  final Widget Function(int index) itemBuilder;
  final Future<void> Function() onEnd;

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  ScrollController controller = ScrollController();
  RxBool showLoading = RxBool(false);

  @override
  void initState() {
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset) {
        await _loadingMore();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: controller,
        children: [
          SizedBox(height: Get.height * 0.015),
          Container(
            alignment: Alignment.center,
            child: Wrap(
              spacing: Get.width * 0.025,
              runSpacing: Get.height * 0.015,
              children: List.generate(
                widget.itemCount ?? 10,
                widget.itemBuilder.call,
              ),
            ),
          ),
          Obx(
            () => showLoading.value
                ? Column(children: [
                    SizedBox(height: Get.height * 0.025),
                    Container(
                        alignment: Alignment.center,
                        child: SpinKitDualRing(
                          color:
                              AppTheme().instance.theme.colorScheme.secondary,
                          size: ((Get.width + Get.height) / 2) * 0.06,
                        )),
                    SizedBox(height: Get.height * 0.015),
                  ])
                : const SizedBox(),
          )
        ]);
  }

  Future<void> _loadingMore() async {
    showLoading.value = true;
    await widget.onEnd.call();
    showLoading.value = false;
  }
}
