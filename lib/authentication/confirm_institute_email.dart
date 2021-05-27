import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kings_of_the_curve/models/institutes_model.dart';
import 'package:kings_of_the_curve/providers/institute_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:kings_of_the_curve/widgets/edit_text_with_hint.dart';
import 'package:kings_of_the_curve/widgets/rounded_edge_button.dart';
import 'package:provider/provider.dart';

class ConfirmInstituteEmailPage extends StatefulWidget {
  final bool isRegister;

  ConfirmInstituteEmailPage({
    this.isRegister = false,
  });

  @override
  _ConfirmInstituteEmailPageState createState() =>
      _ConfirmInstituteEmailPageState();
}

class _ConfirmInstituteEmailPageState extends State<ConfirmInstituteEmailPage>
    with BaseClass {
  @override
  void initState() {
    var instituteProvider =
        Provider.of<InstituteProvider>(context, listen: false);
    instituteProvider.setInstituteList();
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  InstituteModel selectedModel;

  @override
  Widget build(BuildContext context) {
    var instituteProvider = Provider.of<InstituteProvider>(context);
    var sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: instituteProvider.getInstituteList().length > 0
          ? LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCustomAppBar(context, topMargin: appBarTopMargin),
                        Container(
                          margin: EdgeInsets.only(top: 15, left: appLeftMargin),
                          child: Text(
                            "Confirm Your\nInstitute Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: Dimensions.pixels_33,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.pixels_30,
                              right: Dimensions.pixels_30,
                              top: Dimensions.pixels_60),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.circular(Dimensions.pixels_5)),
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                onChanged: (value) {
                                  print(value);
                                },
                                autofocus: false,
                                controller: this._typeAheadController,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Select your institution",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.pixels_5),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                )),
                            suggestionsCallback: (pattern) async {
                              return instituteProvider.getInstituteList();
                            },
                            itemBuilder: (context, suggestion) {
                              InstituteModel model =
                                  suggestion as InstituteModel;
                              return ListTile(
                                /*leading: Icon(Icons.shopping_cart),*/
                                title: Text(model.institutionName),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              selectedModel = suggestion as InstituteModel;
                              this._typeAheadController.text =
                                  selectedModel.institutionName;
                            },
                          ), /*RoundedBorderEditText(
                      hintText: "Select your institution",
                      context: context,
                      leftMargin: Dimensions.pixels_30,
                      isObscure: false,
                      rightMargin: Dimensions.pixels_30,
                      topMargin: Dimensions.pixels_60,
                    ),*/
                        ),
                        SizedBox(
                          height: appBarTopMargin,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimensions.pixels_60),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                EditTextWithHint(
                                  hintText: "Enter your institute email",
                                  context: context,
                                  leftMargin: Dimensions.pixels_30,
                                  isObscure: false,
                                  rightMargin: Dimensions.pixels_30,
                                  textEditingController: _emailController,
                                  topMargin: Dimensions.pixels_60,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: RoundedEdgeButton(
                                        color: primaryColor,
                                        text: "Confirm!",
                                        leftMargin: Dimensions.pixels_30,
                                        textFontSize: Dimensions.pixels_18,
                                        height: Dimensions.pixels_60,
                                        rightMargin: Dimensions.pixels_30,
                                        topMargin: Dimensions.pixels_30,
                                        bottomMargin: Dimensions.pixels_60,
                                        textColor: Colors.white,
                                        onPressed: (value) {
                                          if (_typeAheadController.text
                                              .trim()
                                              .isEmpty) {
                                            showError(context,
                                                "Please select institute name");
                                          } else if (_emailController.text
                                              .trim()
                                              .isEmpty) {
                                            showError(context,
                                                "Email cannot be empty");
                                          } else {
                                            if (widget.isRegister) {
                                              Map<String, String> params = {
                                                'institute':
                                                    _typeAheadController.text
                                                        .trim(),
                                                'email': _emailController.text
                                                    .trim(),
                                                'id': selectedModel.id,
                                              };
                                              Navigator.pop(context, params);
                                            } else {
                                              instituteProvider
                                                  .updateInstituteName(
                                                      sharedPrefProvider
                                                          .userDataModel.userId,
                                                      selectedModel
                                                          .institutionName,
                                                      selectedModel.id,
                                                      context,
                                                      _emailController.text
                                                          .trim());
                                            }
                                          }
                                        },
                                        context: context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          : Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}
