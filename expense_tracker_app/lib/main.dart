import 'package:flutter/material.dart';

import 'api/log_status.dart';
import 'screen/authentication/login.dart';
import 'screen/home.dart';

void main() {
  WidgetsFlutterBinding();

  LogStatus().getToken().then(
    (value) {
      if (value.isNotEmpty) {
        LogStatus.token = value;

        runApp(const SmoothPlayer(initialPage: Home()));
      } else {
        runApp(const SmoothPlayer(initialPage: Login()));
      }
    },
  );
}

class SmoothPlayer extends StatefulWidget {
  final Widget? initialPage;
  const SmoothPlayer({
    Key? key,
    @required this.initialPage,
  }) : super(key: key);

  @override
  State<SmoothPlayer> createState() => _SmoothPlayerState();
}

class _SmoothPlayerState extends State<SmoothPlayer> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      title: 'Smooth Player Music App',
      home: widget.initialPage,
    );
  }
}
