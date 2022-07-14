import 'package:flutter/material.dart';

import 'api/log_status.dart';
import 'screen/authentication/login.dart';
import 'screen/home.dart';

void main() {
  WidgetsFlutterBinding();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            details.exception.toString(),
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  };

  LogStatus().getToken().then(
    (value) {
      if (value.isNotEmpty) {
        LogStatus.token = value;

        runApp(const ExpenseTracker(initialPage: Home()));
      } else {
        runApp(const ExpenseTracker(initialPage: Login()));
      }
    },
  );
}

class ExpenseTracker extends StatefulWidget {
  final Widget? initialPage;
  const ExpenseTracker({
    Key? key,
    @required this.initialPage,
  }) : super(key: key);

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Expense Income Tracker',
      home: widget.initialPage,
    );
  }
}
