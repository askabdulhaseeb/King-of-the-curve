import 'package:flutter/material.dart';

class RoundedEdgeButton extends StatelessWidget {
  final double height;
  final color;
  final String text;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textFontSize;
  final Function onPressed;
  final double buttonRadius;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final BuildContext context;
  final double buttonElevation;
  final Color borderColor;

  RoundedEdgeButton(
      {this.height = 60,
      @required this.color,
      @required this.text,
      this.textColor,
      this.textFontWeight = FontWeight.bold,
      this.textFontSize = 18,
      @required this.onPressed,
      this.buttonRadius = 13,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.topMargin = 0,
      this.borderColor = Colors.transparent,
      this.bottomMargin = 0,
      this.buttonElevation = 3,
      @required this.context})
      : assert(
          text != null,
          'A non-null String must be provided to a Text widget.',
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          top: topMargin,
          bottom: bottomMargin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: buttonElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          primary: color,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: textFontSize,
          ),
        ),
        onPressed: () {
          onPressed(context);
        },
      ),
    );
  }
}
