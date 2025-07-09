import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/theme.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final AppTheme _appTheme = AppTheme().instance;

  final TextEditingController _editingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(children: [
        SizedBox(
          height: Get.height * 0.05,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          _buildTextFieldSearch(),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ]),
        Divider(),
        Align(
            alignment: Alignment.centerRight,
            child: Text(' مؤخرًا',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600))),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Expanded(
            child: GetBuilder<HomeController>(
          initState: (state) {
            _focusNode.requestFocus();
          },
          dispose: (state) {
            _focusNode.dispose();
            _editingController.dispose();
          },
          builder: (controller) => _buildSuggestions(),
        )),
      ]));

  Widget _buildTextFieldSearch() => SizedBox(
        height: Get.height * 0.05,
        width: Get.width * 0.7,
        child: TextField(
          focusNode: _focusNode,
          controller: _editingController,
          textInputAction: TextInputAction.search,
          cursorColor: _appTheme.theme.primaryColor,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: _appTheme.theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _appTheme.theme.colorScheme.outline.withAlpha(100)),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _appTheme.theme.colorScheme.outline.withAlpha(200)),
                borderRadius: BorderRadius.circular(10)),
            labelText: 'بحث...',
            labelStyle: const TextStyle(color: Colors.black38),
            fillColor: _appTheme.theme.iconButtonTheme.style?.backgroundColor
                ?.resolve(RxSet()),
            filled: true,
          ),
        ),
      );

  Widget _buildSuggestions() => SingleChildScrollView(
        child: Column(children: [
          ...List.generate(
              100,
              (i) => Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                          width: Get.width * 0.8,
                          child: Row(
                            children: [
                              SizedBox(width: Get.width * 0.08),
                              Text('فيلم الاكشن',
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close),
                          style: ButtonStyle(
                              shadowColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.transparent))),
                    ],
                  ))
        ]),
      );
}
