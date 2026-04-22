// import 'package:adhan/adhan.dart';
// import 'package:azkar/src/core/widgets/app_loader.dart';
// import 'package:azkar/src/features/home/widgets/qiblah_compass.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_qiblah/flutter_qiblah.dart';

// class Qiblaa extends StatefulWidget {
//   final Qibla? qibla;
//   const Qiblaa({Key? key, this.qibla}) : super(key: key);

//   @override
//   State<Qiblaa> createState() => _QiblaaState();
// }

// class _QiblaaState extends State<Qiblaa> {
//   @override
//   Widget build(BuildContext context) {
//     // final deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
//     return FutureBuilder(
//       future: deviceSupport,
//       builder: (_, AsyncSnapshot<bool?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const AppIndicator();
//         } else if (snapshot.data!) {
//           return const QiblahCompass();
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text("Error: ${snapshot.error.toString()}"),
//           );
//         } else {
//           return const Text("فى انتظار الموقع !");
//         }
//       },
//     );
//   }
// }
