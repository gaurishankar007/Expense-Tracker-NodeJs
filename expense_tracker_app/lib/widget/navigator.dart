import 'package:expense_tracker/screen/expense/expense.dart';
import 'package:expense_tracker/screen/income/income.dart';
import 'package:expense_tracker/screen/progress/result.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screen/home.dart';

class PageNavigator extends StatelessWidget {
  final int? pageIndex;
  const PageNavigator({Key? key, @required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_filled,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.home_filled,
            color: Color(0XFF5B86E5),
          ),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(
            FontAwesomeIcons.circleDollarToSlot,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            FontAwesomeIcons.circleDollarToSlot,
            color: Color(0XFF5B86E5),
          ),
          label: "Expense",
        ),
        NavigationDestination(
          icon: Icon(
            FontAwesomeIcons.sackDollar,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            FontAwesomeIcons.sackDollar,
            color: Color(0XFF5B86E5),
          ),
          label: "Income",
        ),
        NavigationDestination(
          icon: Icon(
            FontAwesomeIcons.chartLine,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            FontAwesomeIcons.chartLine,
            color: Color(0XFF5B86E5),
          ),
          label: "Progress",
        ),
      ],
      height: 60,
      selectedIndex: pageIndex!,
      backgroundColor: Colors.transparent,
      onDestinationSelected: (int index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Home(),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Expense(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Income(),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Result(),
            ),
          );
        }
      },
    );
  }
}
