import 'package:checkofficer/states/add_guest.dart';
import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_service.dart';
import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_image_network.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGuest extends StatefulWidget {
  const ListGuest({super.key});

  @override
  State<ListGuest> createState() => _ListGuestState();
}

class _ListGuestState extends State<ListGuest> {
  @override
  void initState() {
    super.initState();
    AppService().readAllGuest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const WidgetText(data: 'List Guest'),
        centerTitle: true,
      ),
      floatingActionButton: WidgetButton(
        label: 'Add Guest',
        pressFunc: () {
          Get.to(const AddGuest())!.then((value) {
            AppService().readAllGuest();
          });
        },
      ),
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('gurestModels ---> ${appController.guestModels.length}');
            return appController.guestModels.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    itemCount: appController.guestModels.length,
                    itemBuilder: (context, index) => Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: AppConstant().borderBox(),
                          margin: const EdgeInsets.all(8.0),
                          child: WidgetImageNetwork(
                            urlImage:
                                appController.guestModels[index].urlImage1,
                            width: 180,
                            height: 150,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                                data: appController
                                    .guestModels[index].nameAndSur),
                            WidgetText(
                                data: appController.guestModels[index].carId),
                            WidgetText(
                                data:
                                    appController.guestModels[index].province),
                            WidgetText(
                                data:
                                    appController.guestModels[index].objective),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
