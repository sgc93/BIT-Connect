import 'dart:math';

import 'package:bit_connect/presentation/auth/components/error_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(context) {
  return MediaQuery.of(context).size.height;
}

// getting user location
// 1. to locate and mark devices's location
// 2. to locate and mark nearest desired places from the device's current location

Future<List?> getUserLoc(context) async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // request for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission still denied
        final snackBar = ErrorSnackBar(
            content:
                "User denied to grant permission of sharing device's location, Sorry!");
        ScaffoldMessenger.of(context).showSnackBar(snackBar.getSnackBar());
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return [position.latitude, position.longitude];
  } catch (error) {
    final snackBar =
        ErrorSnackBar(content: "Unable to locate user, Please try again?");
    ScaffoldMessenger.of(context).showSnackBar(snackBar.getSnackBar());
    return null;
  }
}

// Finding nearest specified type position
// considering that earth is spherical : using Haversine Formula

double getDistance(lat1, lng1, lat2, lng2) {
  const r = 6371; // radius of earth
  final l1 = inRadian(lat1);
  final l2 = inRadian(lat2);
  final dLat = inRadian(lat2 - lat1);
  final dLng = inRadian(lng2 - lng1);

  // calculate haversine term a
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(l1) * cos(l2) * sin(dLng / 2) * sin(dLng / 2);

  // calculate central angle c
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // calculate distance d = R * c
  final d = r * c;

  return d;
}

List getNearest(List<Map<String, dynamic>> positions, userPos) {
  double? smallestD;
  Map<String, dynamic> nearestPlace = {};

  for (var pos in positions) {
    double d = getDistance(
        pos['position'][0], pos['position'][1], userPos[0], userPos[1]);
    if (smallestD == null) {
      smallestD = d;
      nearestPlace = pos;
    } else {
      if (d < smallestD) {
        smallestD = d;
        nearestPlace = pos;
      }
    }
  }

  return [nearestPlace, convertDistance(smallestD!)];
}

// convert angle to radian
double inRadian(angle) {
  return angle * (3.14 / 180);
}

// convert km into m if d < 1km  : and rounding
String convertDistance(double d) {
  if (d < 1) {
    return "${(d * 1000).round()} Meters";
  } else {
    return "${d.round()} Kms";
  }
}

// export function getNearestPlace(positions) {
// 	return new Promise((resolve, reject) => {
// 		if ("geolocation" in navigator) {
// 			navigator.geolocation.getCurrentPosition(
// 				(userPos) => {
// 					const { latitude, longitude } = userPos.coords;
// 					const nearest = getNearest(positions, [latitude, longitude]);

// 					resolve([
// 						[
// 							{
// 								name: "user",
// 								position: [latitude, longitude],
// 							},
// 							nearest[0],
// 						],
// 						nearest[1],
// 					]);
// 				},
// 				(error) => {
// 					reject("Something went wrong while locating user : " + error);
// 				}
// 			);
// 		} else {
// 			throw new Error("geolocation is not supported in this browser!");
// 		}
// 	});
// }
