// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:checkofficer/utility/app_constant.dart';
import 'package:checkofficer/widgets/widget_image.dart';
import 'package:checkofficer/widgets/widget_image_network.dart';
import 'package:checkofficer/widgets/widget_text.dart';
import 'package:flutter/material.dart';

import 'package:checkofficer/models/guest_model.dart';

class Detail extends StatelessWidget {
  const Detail({
    Key? key,
    required this.guestModel,
  }) : super(key: key);

  final GuestModel guestModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          data: 'D-FREND Solution',
          textStyle: AppConstant().h2Style(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Column(
              children: [
                WidgetImage(
                  pathImage: 'images/dfend.png',
                  width: 250,
                ),
                WidgetText(data: 'รายละเอียดข้อมูลการติดต่อ'),
                WidgetText(data: 'ทะเบียนรถ : ${guestModel.carId}'),
                WidgetText(data: 'จังหวัด : ${guestModel.province}'),
                WidgetText(data: 'ข้อมูลการติดต่อ : ${guestModel.objective}'),
                WidgetText(data: 'เวลาเข้า : ${guestModel.checkIn}'),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all()),
                  width: 250,
                  height: 200,
                  child: WidgetText(data: 'ตราประทับ'),
                ),
                WidgetImageNetwork(
                    urlImage:
                        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${guestModel.id}'),
                Container(margin: const EdgeInsets.only(top: 16, bottom: 64),
                  child: WidgetText(data: 'Title : ข้อมูลปิดท้ายสลิป'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
