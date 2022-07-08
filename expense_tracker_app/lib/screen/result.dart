import 'package:expense_tracker/api/http/progress_http.dart';
import 'package:flutter/material.dart';

import '../api/res/progress_res.dart';
import '../api/urls.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final routeUrl = ApiUrls.routeUrl;

  late Future<ProgressData> userProgress;

  void loadProgress() {
    userProgress = ProgressHttp().getUserProgress();
  }

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            right: sWidth * 0.03,
            bottom: 10,
            left: sWidth * 0.03,
          ),
          child: FutureBuilder<ProgressData>(
            future: userProgress,
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
                if (snapshot.hasData) {
                  children = <Widget>[
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            routeUrl +
                                snapshot.data!.progress!.user!.profilePicture!,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Your Progress",
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Progress: ",
                        style: TextStyle(
                          color: AppColors.text,
                        ),
                        children: [
                          TextSpan(
                            text: snapshot.data!.progress!.progress!.toString(),
                          ),
                        ],
                      ),
                    ),
                  ];
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
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 3),
    );
  }
}
