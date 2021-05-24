import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class RoundedBorderEditText extends StatelessWidget {
  final String hintText;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final TextEditingController textEditingController;
  final BuildContext context;
  final bool isObscure;
  final bool isPassword;
  final IconData trailingIcon;
  final TextInputType keyboardType;
  final Color hintColor;
  final IconData leadingIcon;
  final Color iconColor;
  final Function toggleObscure;
  final FocusNode focusNode ;

  RoundedBorderEditText(
      {@required this.hintText,
      this.leftMargin = 10,
      this.rightMargin = 10,
      @required this.context,
      this.hintColor = hintTextColor,
      this.topMargin = 0,
      this.isPassword = false,
      this.bottomMargin = 0,
      this.toggleObscure,
      this.textEditingController,
        this.focusNode,
      this.isObscure = false,
      this.trailingIcon,
      this.keyboardType = TextInputType.text,
      this.leadingIcon,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          top: topMargin,
          bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.circular(Dimensions.pixels_5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /*  Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15, right: 8, top: 12),
            child: Text(
              hintText,
              style: TextStyle(color: hintGrey, fontSize: 16),
            ),
          ),*/
          Container(
            /*margin: EdgeInsets.only(
              left: 10,
            ),*/
            child: Padding(
              padding:  EdgeInsets.only(left: Dimensions.pixels_5),
              child: TextField(
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
                keyboardType: keyboardType,
                focusNode: focusNode,
                controller: textEditingController,
                cursorColor: Colors.black.withOpacity(0.1),
                obscureText: isObscure,
                decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: Dimensions.pixels_15, bottom: Dimensions.pixels_15),
                    /*border: InputBorder.none,*/
                    /* labelText: hintText,
                  labelStyle: TextStyle(color: hintColor, fontSize: Dimensions.pixels_14),*/
                    suffixIcon: Icon(
                      Icons.search,
                      color: hintColor,
                    )
                    /* hintText: hintText,
                  hintStyle: TextStyle(
                    color: hintColor,
                  ),*/
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
