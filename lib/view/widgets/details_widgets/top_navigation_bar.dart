import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/theme.dart';

// ignore: must_be_immutable
class TopNavigationBar extends StatefulWidget {
  TopNavigationBar(
      {super.key,
      required this.getItem,
      required this.isFilm,
      this.selectedIndex = 0});
  final Function(int index) getItem;
  final bool isFilm;
  int selectedIndex = 0;

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  final ThemeData _appTheme = AppTheme().instance.theme;

  late final List titles;

  @override
  void initState() {
    titles =
        widget.isFilm ? ['التفاصيل', 'مشاهدة الفلم'] : ['التفاصيل', 'الحلقات'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: Get.height * 0.05,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          _appTheme.colorScheme.secondary,
          _appTheme.colorScheme.tertiaryContainer
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ...List.generate(
            titles.length,
            (i) => _buildItems(i),
          )
        ]));
  }

  Widget _buildItems(int i) => InkWell(
      onTap: () async {
        widget.selectedIndex = i;
        setState(() {});
        widget.getItem.call(i);
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.005),
          child: Column(
            children: [
              Text(
                titles[i],
                style: widget.selectedIndex == i
                    ? TextStyle(
                        color: _appTheme.primaryColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      )
                    : const TextStyle(fontWeight: FontWeight.w600),
              ),
              widget.selectedIndex == i
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      height: Get.height * 0.003,
                      decoration: BoxDecoration(
                          color: _appTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(2000)),
                      child: Text(titles[i],
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          )),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ));
}
