import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/details_controller.dart';
import '../../../core/config/theme.dart';
import '../../../core/service/ads_service.dart';
import '../../../data/models/item_details_model.dart';
import '../../widgets/details_widgets/iframe_card.dart';
import '../../widgets/shared/custom_circular_progress.dart';
import '../../widgets/shared/error_widget.dart';
import '../../widgets/shared/no_wifi_widget.dart';

class SerieBody extends StatefulWidget {
  const SerieBody({super.key, required this.model});
  final ItemDetailsModel model;

  @override
  State<SerieBody> createState() => _SerieBodyState();
}

class _SerieBodyState extends State<SerieBody> {
  late ItemDetailsModel _model;

  final DetailsController _detailsController = Get.find<DetailsController>();

  final ThemeData _appTheme = AppTheme().instance.theme;

  bool isLoading = false;

  bool isError = false;

  bool isConnectionState = true;

  int secondeIndex = 0;

  @override
  void initState() {
    _model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailsController>(
        id: 'seriePage',
        builder: (controller) {
          if (isLoading) {
            return Transform.translate(
                offset: const Offset(0, -60), child: CustomCircularProgress());
          }
          if (isError) {
            return ErrorBodyWidget(
                onTapRetry: () async {
                  _getEpisodeData(secondeIndex);
                },
                statusCode: 0000000);
          }
          if (isConnectionState == false) {
            return NoWifiWidget(
              onTapRetry: () async {
                _getEpisodeData(secondeIndex);
              },
            );
          }
          return Stack(
            children: [
              ListView(
                children: [
                  SizedBox(height: Get.height * 0.03),
                  IframeCard(
                    iframe: _model.iframe ?? 'www.google.com',
                  ),
                  SizedBox(height: Get.height * 0.03),
                  Wrap(
                    spacing: Get.width * 0.015,
                    runSpacing: Get.height * 0.015,
                    alignment: WrapAlignment.center,
                    children: List.generate(
                        _model.episodes?.length ?? 0,
                        (i) => InkWell(
                            onTap: () async {
                              secondeIndex = i;
                              await _getEpisodeData(i);
                            },
                            child: _buildEpisode(
                                _model.episodes?.elementAt(i)['name'],
                                _model.episodes?.elementAt(i)['selected']))),
                  ),
                  SizedBox(height: Get.height * 0.5),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: AdsService.showBannerAd())
            ],
          );
        });
  }

  Widget _buildEpisode(String name, bool selected) {
    return Container(
        width: Get.width * 0.23,
        height: Get.height * 0.045,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? _appTheme.primaryColor
              : _appTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(name,
            style: const TextStyle(
              fontSize: 17,
            )));
  }

  Future<dynamic> _getEpisodeData(int i) async {
    isLoading = true;
    _detailsController.update(['seriePage']);
    Map<String, dynamic> data = await _detailsController.getData(
        authorHref: _model.episodes?.elementAt(i)['href']);
    if (data['connectionStatus'] == false) {
      isConnectionState = false;
      _detailsController.update(['seriePage']);
      return null;
    }
    if (data['error']['status'] == true) {
      isError = true;
      _detailsController.update(['seriePage']);
      return null;
    }
    _model = ItemDetailsModel.fromJson(data['body']);
    isLoading = false;
    _detailsController.update(['seriePage']);
  }
}
