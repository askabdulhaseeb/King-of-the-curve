import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/statsModel.dart';
import '../providers/intitute_provider.dart';
import '../providers/shared_preference_provider.dart';
import '../utils/appColors.dart';
import '../utils/baseClass.dart';
import '../utils/constantsValues.dart';
import '../utils/widget_dimensions.dart';

class MyStatsPage extends StatefulWidget {
  @override
  createState() => _MyStatsPageState();
}

class _MyStatsPageState extends State<MyStatsPage> with BaseClass {
  @override
  Widget build(BuildContext context) {
    final instituteProvider = Provider.of<InstituteProvider>(
      context,
      listen: false,
    );
    final sharedPref = Provider.of<SharedPreferenceProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingAccountDetailBackgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: settingAccountDetailBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.pixels_15,
                left: appLeftMargin,
              ),
              child: Text(
                'My Stats',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Dimensions.pixels_33,
                ),
              ),
            ),
            FutureBuilder<List<StatsModel>>(
              future: instituteProvider.checkStats(
                sharedPref.userDataModel.userId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  print("ERROR");
                  return null;
                }

                if (snapshot.data.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(30.0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _buildListItemWidget(
                          snapshot.data[index],
                        );
                      },
                    ),
                  );
                }

                return Container(
                  margin: EdgeInsets.only(
                    top: getScreenHeight(context) * 0.3,
                    left: Dimensions.pixels_20,
                    right: Dimensions.pixels_20,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'No stats found\nPlay Endless or timed mode to see your stats.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: Dimensions.pixels_16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemWidget(StatsModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Dimensions.pixels_15,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.categoryName,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: Dimensions.pixels_24,
                    ),
                  ),
                  Text(
                    '${item.categoryPercentage}%',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: Dimensions.pixels_14,
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                ...item.statsSubCategory.map(
                  (subCatData) {
                    return _getStatsDataWidget(
                      title: subCatData.subCategoryName,
                      textColor: singlePlayerTextColor,
                      percentage: '${subCatData.percentage}%',
                      percentageBackgroundColor: singlePlayerBackgroundColor,
                      tileBackgroundColor: Colors.white,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStatsDataWidget({
    @required title,
    String percentage,
    Color textColor,
    Color tileBackgroundColor,
    Color percentageBackgroundColor,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: Dimensions.pixels_51,
        padding: EdgeInsets.only(
          left: Dimensions.pixels_23,
          right: Dimensions.pixels_23,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.pixels_16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: Dimensions.pixels_40,
              width: Dimensions.pixels_50,
              decoration: BoxDecoration(
                color: singlePlayerBackgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.pixels_4),
              ),
              child: Center(
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: textColor,
                    fontSize: Dimensions.pixels_14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
