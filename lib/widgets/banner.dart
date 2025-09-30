
import 'package:flutter/material.dart';

import '../core/common/utils/colors.dart';

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.23,
      width: size.width,
      color: bannerColor,
      child: Padding(padding: EdgeInsets.only(left: 27),
      child: Stack(
        children: [
          Column(
            children: [
              Text(
                "NEW COLLECTIONS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: -2,

                ),
              )
            ],
          )
        ],),),
    );
  }
}
