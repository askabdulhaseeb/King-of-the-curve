import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';

class EditTextWithHint extends StatelessWidget {
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
  final String errorText;
  final IconData leadingIcon;
  final Color iconColor;
  final Function toggleObscure;
  final Function onChanged;
  final FocusNode focusNode;
  final Key key;
final bool isEnabled ;
  EditTextWithHint(
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
        this.isEnabled=true,
      this.isObscure = false,
      this.trailingIcon,
      this.errorText,
      this.onChanged,
      this.key,
      this.focusNode,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TextField(
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 1,
              enabled: isEnabled,
              focusNode: focusNode,
              keyboardType: keyboardType,
              controller: textEditingController,
              cursorColor: Colors.black.withOpacity(0.1),
              onChanged: onChanged,
              key: key,
              obscureText: isObscure,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    top: Dimensions.pixels_15, bottom: Dimensions.pixels_15),
                labelText: hintText,
                labelStyle:
                    TextStyle(color: hintColor, fontSize: Dimensions.pixels_18),
                errorText: errorText,
                errorStyle: TextStyle(
                    color: Colors.red, fontSize: Dimensions.pixels_12),
                errorMaxLines: 3,
                suffixIcon: isPassword
                    ? GestureDetector(
                        onTap: () {
                          toggleObscure(isObscure);
                        },
                        child: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: hintColor,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
