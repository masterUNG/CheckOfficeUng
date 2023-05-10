// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:checkofficer/widgets/widget_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  final BuildContext context;
  AppDialog({
    required this.context,
  });

  void normalDialog({required String title, Widget? contentWidget}) {
    Get.dialog(
      AlertDialog(
        title: WidgetText(data: title),
        content: contentWidget,
        actions: [
          WidgetTextButton(
            label: 'Cancel',
            pressFunc: () => Get.back(),
          )
        ],
      ),
    );
  }
}
