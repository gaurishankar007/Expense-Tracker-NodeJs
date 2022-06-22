import 'package:expense_tracker/screen/expense.dart';
import 'package:expense_tracker/screen/income.dart';
import 'package:expense_tracker/screen/result.dart';
import 'package:flutter/material.dart';
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
            Icons.money_off_csred_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.money_off_csred_rounded,
            color: Color(0XFF5B86E5),
          ),
          label: "Expense",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.attach_money_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.attach_money_rounded,
            color: Color(0XFF5B86E5),
          ),
          label: "Income",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.bar_chart_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.bar_chart_rounded,
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
