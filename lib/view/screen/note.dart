import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';
import '../../core/config/theme.dart';
import '../../core/service/firebase_service.dart';
import '../widgets/shared/custom_circular_progress.dart';

// ignore: must_be_immutable
class Note extends StatelessWidget {
  Note({super.key});
  final ThemeData _appTheme = AppTheme().instance.theme;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _txtCont = TextEditingController();
  bool activeButton = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('تدوين ملاحضة')),
        body: Container(
          color: _appTheme.scaffoldBackgroundColor,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: Get.height * 0.02),
              _buildTextField(),
              GetBuilder<NoteController>(
                  id: 'submitButton',
                  builder: (controller) => _buildButton(
                      onTap: () async {
                        isLoading = true;
                        controller.update(['submitButton']);
                        Map<String, dynamic> response =
                            await FirebaseService.writeNote(_txtCont.text);
                        context.mounted
                            ? AwesomeDialog(
                                context: context,
                                dialogType: _getDialogType(response),
                                title: _getDialogText(response),
                                dialogBackgroundColor:
                                    _appTheme.scaffoldBackgroundColor,
                                btnOk: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.2),
                                    child: _buildButton(
                                        text: _getDialogBtnText(response),
                                        onTap: () {
                                          if (response['status']) {
                                            Get.back();
                                            Get.back();
                                          } else {
                                            Get.back();
                                          }
                                        })),
                              ).show()
                            : null;
                        isLoading = false;
                        controller.update(['submitButton']);
                      },
                      text: 'Submit',
                      isLoading: isLoading,
                      active: activeButton)),
              SizedBox(height: Get.height * 0.1),
              _buildHelperText(),
            ]),
          ),
        ));
  }

  DialogType _getDialogType(Map<String, dynamic> response) =>
      !response['connectionStatus']
          ? DialogType.warning
          : response['error']['errorStatus']
              ? DialogType.error
              : DialogType.success;

  String _getDialogText(Map<String, dynamic> response) =>
      !response['connectionStatus']
          ? 'لا يوجد الاتصال بالانترنت'
          : response['error']['errorStatus']
              ? 'حدث خطأ'
              : 'تمت اضافة الملاحضة';

  String _getDialogBtnText(Map<String, dynamic> response) =>
      response['status'] ? 'تم' : 'اعادة المحاولة';

  Widget _buildTextField() => GetBuilder<NoteController>(
      id: 'TextField',
      builder: (controller) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _txtCont,
              focusNode: _focusNode,
              onTapOutside: (event) {
                _focusNode.unfocus();
                controller.update(['TextField']);
              },
              onChanged: (value) {
                value.isEmpty ? activeButton = false : activeButton = true;
                controller.update(['submitButton']);
              },
              onTap: () {
                controller.update(['TextField']);
              },
              cursorColor: _appTheme.primaryColor,
              decoration: InputDecoration(
                fillColor: _focusNode.hasFocus
                    ? const Color.fromARGB(255, 147, 147, 147)
                    : _appTheme.shadowColor,
                filled: true,
                hintText: 'دون ملاحضتك...',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: _appTheme.primaryColor, width: 2)),
              ),
              minLines: 10,
              maxLines: 11,
              maxLength: 500,
            ),
          ));

  Widget _buildButton(
          {String text = '',
          void Function()? onTap,
          bool isLoading = false,
          bool active = true}) =>
      InkWell(
        // onTap: isLoading? || !active ? null : onTap,
        onTap: isLoading || !active ? null : onTap,
        child: Container(
            width: Get.width * 0.25,
            height: Get.height * 0.045,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  active ? AppTheme().instance.theme.primaryColor : Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: AppTheme().instance.theme.shadowColor,
                  blurRadius: 2,
                  spreadRadius: 2.5,
                )
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme().instance.theme.colorScheme.tertiary,
              ),
            ),
            child: isLoading
                ? CustomCircularProgress(
                    lineWidth: 3.5, size: ((Get.height + Get.width) / 2) * 0.03)
                : Text(text,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
      );

  Widget _buildHelperText() => Align(
        alignment: Alignment.centerRight,
        child: Container(
            width: Get.width * 0.6,
            padding: EdgeInsets.only(right: Get.width * 0.02),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'المرجو تدوين الملاحضة حول التطبيق بأدق التفاصيل ومشاركة رايك معنا لانه يهمنا لمساعدتنا على تحسين  تجربة المستخدم وشكرا.',
                textAlign: TextAlign.justify,
              ),
            ])),
      );
}
