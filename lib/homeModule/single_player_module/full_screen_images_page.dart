import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class FullScreenImagesPage extends StatelessWidget {
  final List<NetworkImage> imagesList;
  final int selectedIndex;

  FullScreenImagesPage({
    @required this.imagesList,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 20,top: 20),
        height: Dimensions.pixels_450,
        child: Carousel(
          images: imagesList,
          autoplay: false,
          dotSize: Dimensions.pixels_7,
          dotVerticalPadding: Dimensions.pixels_5,
          dotBgColor: Colors.transparent,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          //boxFit: BoxFit.cover,
          dotSpacing: Dimensions.pixels_20,
          indicatorBgPadding: Dimensions.pixels_5,
          dotColor: Colors.white,
          dotIncreasedColor: Colors.white,
          borderRadius: false,
          defaultImage: selectedIndex,
        ),
      ),
    );
  }
}
