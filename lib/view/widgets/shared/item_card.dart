import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/assets.dart';
import '../../../core/config/constants.dart';
import '../../../core/config/theme.dart';
import '../../../data/models/item_model.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    this.onTap,
    required this.model,
  });
  final void Function()? onTap;
  final ItemModel? model;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: Get.width * 0.3,
        height: Get.height * 0.2,
        decoration: itemCardDecoration,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    _valueNotifier.addListener(() {
      if (_valueNotifier.value == 100) {}
    });
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        fit: BoxFit.fill,
        widget.model?.imageUrl ?? '',
        loadingBuilder: (context, child, loadingProgress) {
          return Stack(fit: StackFit.expand, children: [
            child,
            _buildDetails(),
            _buildLoadingProgress(loadingProgress?.cumulativeBytesLoaded,
                loadingProgress?.expectedTotalBytes)
          ]);
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppAsset().images.errorImage,
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [_buildYear(widget.model?.year)]),
            SizedBox(height: Get.height * 0.1),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
              ),
              child: Text(
                '${widget.model?.title}',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 249, 249),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildYear(String? year) => year != null
      ? Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
          margin:
              EdgeInsets.only(top: Get.height * 0.005, left: Get.width * 0.015),
          decoration: BoxDecoration(
              color: AppTheme().instance.theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(3)),
          child: Text(year.replaceAll(RegExp(r'[()]'), ''),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              )),
        )
      : const SizedBox();

  Widget _buildLoadingProgress(
      int? cumulativeBytesLoaded, int? expectedTotalBytes) {
    return Opacity(
      opacity: _valueNotifier.value > 95 ? 0 : 1,
      child: Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(30),
          child: DashedCircularProgressBar.aspectRatio(
            aspectRatio: 1, // width ÷ height
            valueNotifier: _valueNotifier,
            progress: cumulativeBytesLoaded?.toDouble() ?? 100,
            maxProgress: expectedTotalBytes?.toDouble() ?? 100,
            foregroundColor: AppTheme().instance.theme.colorScheme.secondary,
            backgroundColor: const Color(0xffeeeeee),
            foregroundStrokeWidth: 5,
            animation: true,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (_, double value, __) => Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
          )),
    );
  }
}
