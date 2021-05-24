import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/providers/leaderboard_provider.dart';
import 'package:kings_of_the_curve/providers/shared_preference_provider.dart';
import 'package:kings_of_the_curve/utils/appColors.dart';
import 'package:kings_of_the_curve/utils/appImages.dart';
import 'package:kings_of_the_curve/utils/constantWidgets.dart';
import 'package:kings_of_the_curve/utils/constantsValues.dart';
import 'package:kings_of_the_curve/utils/widget_dimensions.dart';
import 'package:provider/provider.dart';

class TimedGlobalLeaderBoardHighScorePage extends StatefulWidget {
  @override
  _TimedGlobalLeaderBoardHighScorePageState createState() =>
      _TimedGlobalLeaderBoardHighScorePageState();
}

class _TimedGlobalLeaderBoardHighScorePageState
    extends State<TimedGlobalLeaderBoardHighScorePage> {
  @override
  void initState() {
    var leaderBoardProvider =
        Provider.of<LeaderBoardProvider>(context, listen: false);
    leaderBoardProvider.getAllUsersTimedMode(leaderBoardProvider);
    // TODO: implement initState
    super.initState();
  }

  static int myRankIndex = -1;
int getRank(){
  return myRankIndex ;
}
  @override
  Widget build(BuildContext context) {
    var leaderBoardProvider = Provider.of<LeaderBoardProvider>(context);
    var sharedPrefProvider = Provider.of<SharedPreferenceProvider>(context);

    return Scaffold(
      backgroundColor: editButtonColor,
      body: leaderBoardProvider.timedModeUsersList.length == 0
          ? Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraint) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getCustomAppBarWithText(
                          context,
                          "Global High Score",
                          topMargin: appbarTopMargin,
                        ),
                        SizedBox(
                          height: Dimensions.pixels_45,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.pixels_30,
                              right: Dimensions.pixels_30),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        "Rank",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.pixels_10,
                                    ),
                                    Container(
                                      width: Dimensions.pixels_45,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: _getTabBarItem("Score"),
                              ),
                              Flexible(
                                flex: 2,
                                child: _getTabBarItem("User Name"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.pixels_18,
                                right: Dimensions.pixels_18,
                                top: Dimensions.pixels_30,
                                bottom: Dimensions.pixels_51),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.pixels_15),
                              color: Colors.white,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.pixels_60),
                                  child: ListView.builder(
                                      itemCount:
                                          leaderBoardProvider.timedModeUsersList.length,
                                      itemBuilder: (_, int index) {
                                        return Column(
                                          children: [
                                            _getScoreWidgets(
                                                userName: leaderBoardProvider.timedModeUsersList
                                                    .elementAt(index)
                                                    .userName!=null?leaderBoardProvider.timedModeUsersList
                                                    .elementAt(index)
                                                    .userName:"",
                                                score: leaderBoardProvider.timedModeUsersList
                                                    .elementAt(index)
                                                    .timedModeHighScore,
                                                universityImage: index == 0
                                                    ? first_place
                                                    : index == 1
                                                        ? second_place
                                                        : third_place,
                                                position: index),
                                            getDivider(dividerColor: Colors.grey.shade200),
                                          ],
                                        );
                                      }),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    height: Dimensions.pixels_45,
                                    width: Dimensions.pixels_140,
                                    margin: EdgeInsets.only(
                                        left: Dimensions.pixels_12,
                                        bottom: Dimensions.pixels_12),
                                    decoration: BoxDecoration(
                                      color: successLightColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.pixels_5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "You: ${leaderBoardProvider.getTimedRank()} ${getTrailingString(leaderBoardProvider.getTimedRank())}",
                                        style: TextStyle(
                                            color: successColor,
                                            fontSize: Dimensions.pixels_16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
  String getTrailingString(int rank){
    if(rank ==0){
      return "";
    }
    else if(rank ==1){
      return "st";
    }
    else if(rank ==2){
      return "nd";
    }
    else if(rank ==3){
      return "rd";
    }
    else {
      return "th";
    }

  }
  Widget _getTabBarItem(String title) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.topRight,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(
          height: Dimensions.pixels_10,
        ),
      ],
    );
  }

  Widget _getScoreWidgets(
      {String score, String universityImage, String userName, int position}) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.pixels_15, right: Dimensions.pixels_15),
      height: Dimensions.pixels_60,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Container(
                height: Dimensions.pixels_30,
                width: Dimensions.pixels_30,
                child: Stack(
                  children: [
                    Image(
                      image: AssetImage(universityImage),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2),
                        child: Text(
                          (position + 1).toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: Dimensions.pixels_12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: Dimensions.pixels_5),
              width: double.infinity,
              child: Text(
                score,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: Dimensions.pixels_5),
              child: Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.pixels_14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
