import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'appColors.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: Dimensions.pixels_5,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(Dimensions.pixels_10),
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
