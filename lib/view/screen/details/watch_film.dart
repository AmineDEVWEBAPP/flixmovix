import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/routes.dart';
import '../../../core/service/ads_service.dart';
import '../../../data/models/item_details_model.dart';
import '../../../data/models/item_model.dart';
import '../../widgets/details_widgets/iframe_card.dart';
import '../../widgets/shared/item_card.dart';

class WatchFilm extends StatelessWidget {
  const WatchFilm({super.key, required this.model});

  final ItemDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(height: Get.height * 0.03),
            IframeCard(
              iframe: model.iframe ?? 'www.google.com',
            ),
            SizedBox(height: Get.height * 0.03),
            const Text('  عروض مشابهة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: Get.height * 0.02),
            Wrap(
              spacing: Get.width * 0.025,
              runSpacing: Get.height * 0.015,
              alignment: WrapAlignment.center,
              children: List.generate(
                model.similarOffers?.length ?? 0,
                (i) => ItemCard(
                    onTap: () async {
                      await AdsService.showAd(AdsService.rewardedAdPlacementId);
                      context.mounted
                          ? Navigator.of(context).pushReplacementNamed(
                              AppRoutes.details,
                              arguments: {
                                  'href':
                                      model.similarOffers?.elementAt(i)['href'],
                                  'title': model.similarOffers
                                      ?.elementAt(i)['title'],
                                })
                          : null;
                    },
                    model:
                        ItemModel.fromJson(model.similarOffers?.elementAt(i))),
              ),
            ),
            SizedBox(height: Get.height * 0.5),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: AdsService.showBannerAd()),
      ],
    );
  }
}
