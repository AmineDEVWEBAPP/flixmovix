import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../core/config/theme.dart';
import '../../core/service/scrapping_service.dart';
import '../../core/service/sqflite_service.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final AppTheme _appTheme = AppTheme().instance;

  final TextEditingController _editingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final HomeController _homeController = Get.find();

  List<Map<String, Object?>> suggestions = [];

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
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await _submitting(_editingController.text);
              }),
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
          id: 'suggestions',
          initState: (state) async {
            // _focusNode.requestFocus();
            suggestions = await SQFliteService.read(
                columns: [DbColumns.searchSuggestion]);
            _homeController.update(['suggestions']);
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
          onSubmitted: (value) async {
            await _submitting(value);
          },
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
            labelStyle: const TextStyle(color: Color.fromARGB(95, 80, 80, 80)),
            fillColor: _appTheme.theme.iconButtonTheme.style?.backgroundColor
                ?.resolve(RxSet()),
            filled: true,
          ),
        ),
      );

  Widget _buildSuggestions() => SingleChildScrollView(
        child: Column(children: [
          ...List.generate(
              suggestions.length,
              (i) => Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await _submitting(
                              suggestions[i]['searchSuggestion'].toString());
                        },
                        child: SizedBox(
                          width: Get.width * 0.8,
                          child: Row(
                            children: [
                              SizedBox(width: Get.width * 0.08),
                              Text(
                                  suggestions[i]['searchSuggestion'].toString(),
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () async {
                            await SQFliteService.delete(
                                DbColumns.searchSuggestion,
                                suggestions[i]['searchSuggestion'].toString());
                            suggestions = await SQFliteService.read(
                                columns: [DbColumns.searchSuggestion]);
                            _homeController.update(['suggestions']);
                          },
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

  Future<void> _submitting(String value) async {
    Get.back();
    _homeController.isLoading = true;
    _homeController.title = value;
    _homeController.update(['homeBody', 'homeSearchBar']);
    _homeController.itemsData = await ScrappingService.getItems(word: value);
    _homeController.isLoading = false;
    _homeController.update(['homeBody', 'homeSearchBar']);
    value.isNotEmpty
        ? await SQFliteService.write(value, DbColumns.searchSuggestion)
        : null;
  }
}
