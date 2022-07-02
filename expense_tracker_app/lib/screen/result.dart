import 'package:flutter/material.dart';

import '../widget/navigator.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            right: sWidth * 0.03,
            bottom: 10,
            left: sWidth * 0.03,
          ),
          child: Column(
            children: const [
              Text("Result"),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 3),
    );
  }
}
