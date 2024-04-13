import 'package:bit_connect/presentation/location/components/loc_overview.dart';
import 'package:bit_connect/searvices/helpers.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: getWidth(context),
        height: getHeight(context),
        color: Colors.blue[200],
        child: Column(
          children: [
            const LocOverview(),
            Expanded(
              child: Container(
                width: getWidth(context),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Facilities"),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
