import 'package:checkofficer/states/add_guest.dart';
import 'package:checkofficer/states/detail.dart';
import 'package:checkofficer/states/scan_qr.dart';
import 'package:checkofficer/states/setting.dart';
import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_dialog.dart';
import 'package:checkofficer/utility/app_service.dart';
import 'package:checkofficer/widgets/widget_button.dart';
import 'package:checkofficer/widgets/widget_icon_button.dart';
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
    AppService().proccessGetBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(
              '###  availableBluetooth ----> ${appController.availableBluetoothDevices.length}');
          print('connectedPrinter ---> ${appController.connectedPrinter}');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const WidgetText(data: 'List Guest'),
              centerTitle: true,
              actions: [
                WidgetIconButton(
                  iconData: Icons.qr_code,
                  pressFunc: () async {
                    Get.to(const ScanQr());
                  },
                ),
                WidgetIconButton(
                  iconData: Icons.print,
                  color: appController.connectedPrinter.value
                      ? Colors.green
                      : Colors.red,
                  pressFunc: () {
                    AppDialog(context: context).normalDialog(
                      title: 'Connected Printer',
                      contentWidget: appController
                              .availableBluetoothDevices.isEmpty
                          ? const WidgetText(data: 'ไม่มี Printer')
                          : ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appController
                                  .availableBluetoothDevices.length,
                              itemBuilder: (context, index) => WidgetButton(
                                label: appController
                                    .availableBluetoothDevices[index]
                                    .toString(),
                                pressFunc: () {
                                  AppService()
                                      .processChoosePrinter(
                                          printerName: appController
                                              .availableBluetoothDevices[index])
                                      .then((value) => Get.back());
                                },
                              ),
                            ),
                    );
                  },
                ),
                WidgetIconButton(
                  iconData: Icons.settings,
                  pressFunc: () {
                    Get.to(const Setting());
                  },
                )
              ],
            ),
            floatingActionButton: WidgetButton(
              label: 'Add Guest',
              pressFunc: () {
                Get.to(const AddGuest())!.then((value) {
                  AppService().readAllGuest();
                });
              },
            ),
            body: appController.guestModels.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    itemCount: appController.guestModels.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Get.to(Detail(
                            guestModel: appController.guestModels[index]));
                      },
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    data:
                                        appController.guestModels[index].carId),
                                WidgetText(
                                    data: appController
                                        .guestModels[index].province),
                                WidgetText(
                                    data: appController
                                        .guestModels[index].objective),
                                appController.connectedPrinter.value
                                    ? WidgetButton(
                                        label: 'Print',
                                        pressFunc: () {
                                          print('print');
                                          // AppService().processPrint(
                                          //     name: appController
                                          //         .guestModels[index]
                                          //         .nameAndSur,
                                          //     phone: appController
                                          //         .guestModels[index].phone);
                                          AppService().processPrintImage();
                                        },
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
