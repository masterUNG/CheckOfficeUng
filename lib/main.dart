import 'dart:io';

import 'package:checkofficer/states/authen.dart';
import 'package:checkofficer/states/list_guest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  HttpOverrides.global = MyHttpOverride();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Authen(),
     
      theme: ThemeData(
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
