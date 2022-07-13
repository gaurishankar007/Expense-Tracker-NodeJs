import 'package:expense_tracker/api/http/progress_http.dart';
import 'package:expense_tracker/api/res/progress_res.dart';
import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class RankingSystem extends StatefulWidget {
  const RankingSystem({Key? key}) : super(key: key);

  @override
  State<RankingSystem> createState() => _RankingSystemState();
}

class _RankingSystemState extends State<RankingSystem> {
  late Future<TopProgress> usersProgress;
  List<Progress> progressList = [];
  int progressIndex = 0;

  void topUsersProgress() {
    usersProgress = ProgressHttp().topUsersProgress();
    usersProgress.then((value) {
      progressList = value.progress!;
    });
  }

  @override
  void initState() {
    super.initState();

    topUsersProgress();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.onPrimary,
          ),
        ),
        title: Text(
          "Progress Point Ranking",
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: sWidth * 0.03,
          left: sWidth * 0.03,
          bottom: 10,
        ),
        child: FutureBuilder<TopProgress>(
          future: usersProgress,
          builder: ((context, snapshot) {
            List<Widget> children = [];

            if (snapshot.connectionState == ConnectionState.waiting) {
              children = <Widget>[
                Container(
                  width: sWidth,
                  height: sHeight,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  ),
                )
              ];
            } else if (snapshot.connectionState == ConnectionState.done) {
              children = <Widget>[
                getButtons(context),
              ];
              if (snapshot.hasData) {
              } else if (snapshot.hasError) {
                if ("${snapshot.error}".split("Exception: ")[0] == "Socket") {
                  children = <Widget>[
                    Container(
                      width: sWidth,
                      height: sHeight,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.warning_rounded,
                            size: 25,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Connection Problem",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ];
                } else {
                  children = <Widget>[
                    Container(
                      width: sWidth,
                      height: sHeight,
                      alignment: Alignment.center,
                      child: Text(
                        "${snapshot.error}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  ];
                }
              }
            }

            return Column(
              children: children,
            );
          }),
        ),
      ),
    );
  }

  Widget getButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (progressIndex == 0) {
              return;
            }

            usersProgress.then((value) {
              setState(() {
                progressList = value.progress!;
                progressIndex = 0;
              });
            });
          },
          child: Text(
            "Total",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: progressIndex == 0 ? AppColors.primary : AppColors.button,
            onPrimary:
                progressIndex == 0 ? AppColors.onPrimary : AppColors.text,
            minimumSize: Size.zero,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            if (progressIndex == 1) {
              return;
            }

            usersProgress.then((value) {
              setState(() {
                progressList = value.tmp!;
                progressIndex = 1;
              });
            });
          },
          child: Text(
            "This Month",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: progressIndex == 1 ? AppColors.primary : AppColors.button,
            onPrimary:
                progressIndex == 1 ? AppColors.onPrimary : AppColors.text,
            minimumSize: Size.zero,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            if (progressIndex == 2) {
              return;
            }

            usersProgress.then((value) {
              setState(() {
                progressList = value.pmp!;
                progressIndex = 2;
              });
            });
          },
          child: Text(
            "Previous Month",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: progressIndex == 2 ? AppColors.primary : AppColors.button,
            onPrimary:
                progressIndex == 2 ? AppColors.onPrimary : AppColors.text,
            minimumSize: Size.zero,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        )
      ],
    );
  }
}
