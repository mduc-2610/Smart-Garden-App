// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:smart_garden_app/utils/constants/colors.dart';
// // import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class TMapFunction {
//   TMapFunction._();
//
//   static Future<BitmapDescriptor> createCustomMarkerBitmap(String imageUrl, {
//     double size = 150,
//     Color borderColor = Colors.white,
//     double borderWidth = 10,
//     Color backgroundColor = Colors.transparent,
//   }) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint()..color = backgroundColor;
//     final double radius = size / 2;
//
//     canvas.drawCircle(Offset(radius, radius), radius, paint);
//
//     if (borderWidth > 0) {
//       final borderPaint = Paint()
//         ..color = borderColor
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = borderWidth;
//       canvas.drawCircle(Offset(radius, radius), radius - (borderWidth / 2), borderPaint);
//     }
//
//     final clipPath = Path()
//       ..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius - borderWidth));
//     canvas.clipPath(clipPath);
//
//     final Completer<ui.Image> completer = Completer<ui.Image>();
//     final ImageStream imageStream = NetworkImage(imageUrl).resolve(const ImageConfiguration());
//     late final ImageStreamListener listener;
//     listener = ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
//       imageStream.removeListener(listener);
//       completer.complete(imageInfo.image);
//     }, onError: (dynamic exception, StackTrace? stackTrace) {
//       imageStream.removeListener(listener);
//       completer.completeError(exception, stackTrace);
//     });
//     imageStream.addListener(listener);
//
//     final ui.Image image = await completer.future;
//     paintImage(
//       canvas: canvas,
//       rect: Rect.fromCircle(center: Offset(radius, radius), radius: radius - borderWidth),
//       image: image,
//       fit: BoxFit.cover,
//     );
//
//     final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
//       size.toInt(),
//       size.toInt(),
//     );
//
//     final  byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
//     final uint8List = byteData!.buffer.asUint8List();
//
//     return BitmapDescriptor.fromBytes(uint8List);
//   }
//
//   static Future<List<LatLng>> getPolyCoordinates(List<LatLng> coordinates) async {
//     String osrmBaseUrl = "https://router.project-osrm.org/route/v1/driving/";
//     String routeUrl = osrmBaseUrl;
//
//     for (var coord in coordinates) {
//       routeUrl += "${coord.longitude},${coord.latitude};";
//     }
//
//     routeUrl = "${routeUrl.substring(0, routeUrl.length - 1)}?geometries=geojson";
//
//     try {
//       final response = await http.get(Uri.parse(routeUrl));
//
//       if (response.statusCode == 200) {
//         final decodedData = json.decode(response.body);
//
//         if (decodedData['routes'].isNotEmpty) {
//           final route = decodedData['routes'][0];
//           final routeCoordinates = route['geometry']['coordinates'];
//           List<LatLng> polyCoordinates = [];
//
//           for (var coord in routeCoordinates) {
//             double lon = coord[0];
//             double lat = coord[1];
//             polyCoordinates.add(LatLng(lat, lon));
//           }
//
//           return polyCoordinates;
//         }
//       } else {
//         print('Error fetching route from OSRM: ${response.body}');
//       }
//     } catch (e) {
//       print('Exception caught while fetching route: $e');
//     }
//
//     return [];
//   }
//
//   static void animateCamera(GoogleMapController controller, LatLng from, LatLng to) {
//     final CameraUpdate cameraUpdate = CameraUpdate.newLatLng(to);
//     controller.animateCamera(cameraUpdate);
//   }
// }