// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:checkofficer/models/guest_model.dart';
import 'package:checkofficer/models/objective_model.dart';
import 'package:checkofficer/models/province_model.dart';
import 'package:checkofficer/utility/app_controller.dart';
import 'package:checkofficer/utility/app_snackbar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> processPrint(
      {required String name, required String phone}) async {
    await BluetoothThermalPrinter.writeText('Test Print\n$name\n$phone\n\n\n');
  }

  Future<void> processPrintImage() async {
    CapabilityProfile profile = await CapabilityProfile.load();
    var generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = <int>[];
    bytes += generator.text('Doramon');
    bytes += generator.qrcode('I love doramon');

    await BluetoothThermalPrinter.writeBytes(bytes);
  }

  Future<void> processChoosePrinter({required String printerName}) async {
    print('printName ---> $printerName');
    var macs = printerName.split('#');
    print('mas.last----> ${macs.last}');
    await BluetoothThermalPrinter.connect(macs.last).then((value) {
      print('value at processChoosePrinter ---> $value');
      if (value.toString() == 'true') {
        appController.connectedPrinter.value = true;
      }
    }).catchError((onError) {
      print('onError ----> $onError');
    });
  }

  Future<void> proccessGetBluetooth() async {
    await BluetoothThermalPrinter.getBluetooths.then((value) {
      if (value != null) {
        appController.availableBluetoothDevices.addAll(value);
      }
    });
  }

  Future<void> readAllGuest() async {
    String urlApi =
        'https://www.androidthai.in.th/fluttertraining/checeOffocerUng/getAllGuest.php';

    if (appController.guestModels.isNotEmpty) {
      appController.guestModels.clear();
    }

    await dio.Dio().get(urlApi).then((value) {
      for (var element in json.decode(value.data)) {
        GuestModel model = GuestModel.fromMap(element);
        appController.guestModels.add(model);
      }
    });
  }

  Future<void> processAddGuest(
      {required String nameAndSurname,
      required String phone,
      required String carId,
      required String province,
      required String objective}) async {
    String urlApiUpload =
        'https://www.androidthai.in.th/fluttertraining/checeOffocerUng/saveFile.php';

    var files = <File>[];
    files.add(appController.avatarFiles.last);
    files.add(appController.carFiles.last);
    files.add(appController.carFiles.last);

    var urlImages = <String>[];
    int index = 0;

    for (var element in files) {
      String nameFile = 'image${Random().nextInt(1000000)}.jpg';
      Map<String, dynamic> map = {};
      map['file'] =
          await dio.MultipartFile.fromFile(element.path, filename: nameFile);
      dio.FormData formData = dio.FormData.fromMap(map);
      await dio.Dio().post(urlApiUpload, data: formData).then((value) {
        print('upload $nameFile success');
        urlImages.add(
            'https://www.androidthai.in.th/fluttertraining/checeOffocerUng/image/$nameFile');
      });
      index++;
    }

    if (urlImages.isNotEmpty) {
      String urlApiInsertGuest =
          'https://www.androidthai.in.th/fluttertraining/checeOffocerUng/insertGuest.php?isAdd=true&nameAndSur=$nameAndSurname&phone=$phone&carId=$carId&province=$province&objective=$objective&urlImage1=${urlImages[0]}&urlImage2=${urlImages[1]}&urlImage3=${urlImages[2]}&checkIn=${DateTime.now().toString()}';
      await dio.Dio().get(urlApiInsertGuest).then((value) {
        Get.back();
        AppSnackBar(
                title: 'Add Guest Success', message: 'Thankyou for Add Guest')
            .normalSnackBar();
      });
    }
  }

  Future<File> processTakePhoto() async {
    var result = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 800);
    File file = File(result!.path);
    return file;
  }

  Future<void> readAllObjective() async {
    String urlApi =
        'https://www.androidthai.in.th/fluttertraining/checeOffocerUng/getAllObjectiveUng.php';
    await dio.Dio().get(urlApi).then((value) {
      for (var element in json.decode(value.data)) {
        ObjectiveModel model = ObjectiveModel.fromMap(element);
        appController.objectiveModels.add(model);
      }
    });
  }

  Future<void> readAllProvince() async {
    String urlApi = 'https://www.androidthai.in.th/flutter/getAllprovinces.php';
    await dio.Dio().get(urlApi).then((value) {
      for (var element in json.decode(value.data)) {
        ProvinceModel model = ProvinceModel.fromMap(element);
        appController.provinceModels.add(model);
      }
    });
  }
}
