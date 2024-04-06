import 'package:bit_connect/utils/constants/colorAssets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePageOptions extends StatelessWidget {
  final String name;
  final String iconPath;

  const HomePageOptions(
      {super.key, required this.name, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      
      child: Container(
        
       decoration: BoxDecoration(color:Colors.blue[50],borderRadius: BorderRadius.circular(10)),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //icon
            Image.asset(iconPath,height: 50,color: ColorAssets.bduColor,),
            //name
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(name,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16, color: Colors.blue[700]),),
            )
          ],
        ),
      ),
    );
  }
}
