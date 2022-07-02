import 'package:expense_tracker/api/http/home_http.dart';
import 'package:expense_tracker/api/res/expense_res.dart';
import 'package:expense_tracker/api/res/home_res.dart';
import 'package:expense_tracker/resource/category.dart';
import 'package:expense_tracker/screen/categorized_expense.dart';
import 'package:expense_tracker/screen/categorized_income.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../api/res/income_res.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';
import 'setting.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  int curTime = DateTime.now().hour;
  String greeting = "Expense Tracker";

  late Future<HomeData> userHomeData;
  bool moreExpense = false;
  bool moreIncome = false;
  List<String> expenseCategories = [];
  List<String> incomeCategories = [];

  ButtonStyle elevated = ElevatedButton.styleFrom(
    primary: AppColors.primary,
    minimumSize: Size.zero,
    padding: EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 5,
    ),
    elevation: 10,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );

  void getUserHomeData() {
    userHomeData = HomeHttp().viewHome();
    userHomeData.then((value) {
      List<ExpenseCategorized> e = value.thisMonthExpenseCategories!;
      List<IncomeCategorized> i = value.thisMonthIncomeCategories!;

      if (e.isEmpty) {
        expenseCategories = Category.expenseCategory;
      } else {
        expenseCategories = e
            .asMap()
            .map((key, value) {
              return MapEntry(key, e[key].category!);
            })
            .values
            .toList();
      }

      if (i.isEmpty) {
        incomeCategories = Category.incomeCategory;
      } else {
        incomeCategories = i
            .asMap()
            .map((key, value) {
              return MapEntry(key, i[key].category!);
            })
            .values
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (5 <= curTime && 12 >= curTime) {
      greeting = "Good Morning";
    } else if (12 <= curTime && 18 >= curTime) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    getUserHomeData();
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
            bottom: 10,
          ),
          child: Column(
            children: [
              FutureBuilder<HomeData>(
                future: userHomeData,
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
                  } else {
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: sWidth * 0.03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                greeting,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.settings,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => Setting(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        snapshot.data!.expenseDays!.length > 1
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: sWidth * 0.03,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          snapshot.data!.thisMonthView!
                                              ? "This"
                                              : "Previous" " Month Expenses",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expenseLineChart(
                                    context,
                                    snapshot.data!.maxExpenseAmount!,
                                    snapshot.data!.expenseDays!,
                                    snapshot.data!.expenseAmounts!,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        feedback(context, snapshot.data!),
                        expenseDetail(context,
                            snapshot.data!.thisMonthExpenseCategories!),
                        SizedBox(
                          height: 10,
                        ),
                        incomeDetail(
                          context,
                          snapshot.data!.thisMonthIncomeCategories!,
                        )
                      ];
                    } else if (snapshot.hasError) {
                      if ("${snapshot.error}".split("Exception: ")[0] ==
                          "Socket") {
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 0),
    );
  }

  Widget expenseLineChart(
    BuildContext context,
    int maxExpenseAmount,
    List<int> expenseDays,
    List<int> expenseAmounts,
  ) {
    final sWidth = MediaQuery.of(context).size.width;
    List<FlSpot> expenseLineData = [];

    for (int i = 0; i < expenseDays.length; i++) {
      expenseLineData.add(FlSpot(expenseDays[i].toDouble(),
          (expenseAmounts[i] / maxExpenseAmount) * 5));
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: SizedBox(
        height: 200,
        width: sWidth * .94,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: AppColors.primary,
                  tooltipRoundedRadius: 5,
                  getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                    return touchedBarSpots.map((barSpot) {
                      final flSpot = barSpot;
                      if (flSpot.x == 0 || flSpot.x == 6) {
                        return null;
                      }

                      return LineTooltipItem(
                        "Rs. ${((flSpot.y / 5) * maxExpenseAmount).round()}",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  }),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Color(0xFFAAAEB1),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Color(0xFFAAAEB1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 25,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    TextStyle style = TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    );
                    String text = "";
                    String amount1 = (maxExpenseAmount / 5000) > 0.1
                        ? (maxExpenseAmount / 5000).toStringAsFixed(1) + "k"
                        : (maxExpenseAmount / 5000).toStringAsFixed(2) + "k";
                    String amount2 = ((maxExpenseAmount / 5000) * 2) > 0.1
                        ? ((maxExpenseAmount / 5000) * 2).toStringAsFixed(1) +
                            "k"
                        : ((maxExpenseAmount / 5000) * 2).toStringAsFixed(2) +
                            "k";
                    String amount3 = ((maxExpenseAmount / 5000) * 3) > 0.1
                        ? ((maxExpenseAmount / 5000) * 3).toStringAsFixed(1) +
                            "k"
                        : ((maxExpenseAmount / 5000) * 3).toStringAsFixed(2) +
                            "k";
                    String amount4 = ((maxExpenseAmount / 5000) * 4) > 0.1
                        ? ((maxExpenseAmount / 5000) * 4).toStringAsFixed(1) +
                            "k"
                        : ((maxExpenseAmount / 5000) * 4).toStringAsFixed(2) +
                            "k";
                    String amount5 = (maxExpenseAmount / 1000) > 0.1
                        ? (maxExpenseAmount / 1000).toStringAsFixed(1) + "k"
                        : (maxExpenseAmount / 1000).toStringAsFixed(2) + "k";

                    if (value.toInt() == 1) {
                      text = amount1;
                    } else if (value.toInt() == 2) {
                      text = amount2;
                    } else if (value.toInt() == 3) {
                      text = amount3;
                    } else if (value.toInt() == 4) {
                      text = amount4;
                    } else if (value.toInt() == 5) {
                      text = amount5;
                    }

                    return Text(text,
                        style: style, textAlign: TextAlign.center);
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 15,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    TextStyle style = TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 7,
                    );
                    Widget text = Text("");

                    for (int i = 1; i < 32; i++) {
                      if (value.toInt() == i) {
                        text = Text(i.toString(), style: style);
                      }
                    }

                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 5,
                      child: text,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary,
                  width: 3,
                ),
                left: BorderSide(
                  color: AppColors.primary,
                  width: 3,
                ),
                right: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Colors.red,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Color(0xFFF08F88),
                ),
                spots: expenseLineData,
              ),
            ],
            minX: 0,
            maxX: 32,
            maxY: 5,
            minY: 0,
          ),
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  Widget shortNote(BuildContext context) {
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    "Expense:",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.money_off_csred_rounded,
                    color: Colors.red,
                    size: 25,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Income:",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.attach_money_rounded,
                    color: Colors.green,
                    size: 25,
                  ),
                ],
              )
            ],
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: RichText(
            text: TextSpan(
              text: "ExD: ",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "Expense amount spend per day in a month.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: RichText(
            text: TextSpan(
              text: "InD: ",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "Income amount earned per day in a month.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: RichText(
            text: TextSpan(
              text: "MxEC: ",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text:
                      "The expense category which contains maximum expenses this month.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: RichText(
            text: TextSpan(
              text: "MxIC: ",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text:
                      "The income category which contains maximum incomes this month.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget feedback(BuildContext context, HomeData homeData) {
    final sWidth = MediaQuery.of(context).size.width;

    if (homeData.thisMonthExpenseAmount! == 0 &&
        homeData.thisMonthIncomeAmount! == 0) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(
        right: sWidth * 0.03,
        left: sWidth * 0.03,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range_rounded,
                color: AppColors.primary,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${months[(int.parse(DateTime.now().month.toString())) - 1]} ${DateTime.now().year.toString()}",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: homeData.thisMonthExpenseAmount == 0 &&
                    homeData.thisMonthIncomeAmount == 0
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              homeData.thisMonthExpenseAmount == 0
                  ? SizedBox()
                  : SizedBox(
                      width: sWidth * .45,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.money_off_csred_rounded,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                Text(
                                  "Rs. ${homeData.thisMonthExpenseAmount!}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.money_off_csred_rounded,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                Text(
                                  "Rs. ${homeData.thisMonthExpenseRate!} ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => shortNote(context),
                                    );
                                  },
                                  child: Text(
                                    "ExD",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.money_off_csred_rounded,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rs. ${homeData.maxExpenseCategory!.amount}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${homeData.maxExpenseCategory!.category} ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  shortNote(context),
                                            );
                                          },
                                          child: Text(
                                            "MxEC",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              homeData.thisMonthIncomeAmount == 0
                  ? SizedBox()
                  : SizedBox(
                      width: sWidth * .45,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                Text(
                                  "Rs. ${homeData.thisMonthIncomeAmount!}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                Text(
                                  "Rs. ${homeData.thisMonthIncomeRate!} ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => shortNote(context),
                                    );
                                  },
                                  child: Text(
                                    "InD",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rs. ${homeData.maxIncomeCategory!.amount}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${homeData.maxIncomeCategory!.category} ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  shortNote(context),
                                            );
                                          },
                                          child: Text(
                                            "MxIC",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          homeData.thisMonthExpenseAmount! < homeData.thisMonthIncomeAmount! &&
                  homeData.thisMonthExpenseAmount != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "Expense is less than income.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.previousMonthExpenseAmount! != 0 &&
                  homeData.thisMonthExpenseRate! <
                      homeData.previousMonthExpenseRate! &&
                  homeData.thisMonthExpenseAmount != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "Expense amount per day (ExD) is less than previous month (Rs. ${homeData.previousMonthExpenseRate} ExD).",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.previousMonthIncomeAmount! != 0 &&
                  homeData.thisMonthIncomeAmount! >
                      homeData.previousMonthIncomeAmount!
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "Income is greater than previous month (Rs. ${homeData.previousMonthIncomeAmount}).",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.previousMonthIncomeAmount! != 0 &&
                  homeData.thisMonthIncomeRate! >
                      homeData.previousMonthIncomeRate!
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "InD is greater than previous month (Rs. ${homeData.previousMonthIncomeRate} InD).",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.thisMonthExpenseAmount! > homeData.thisMonthIncomeAmount! &&
                  homeData.thisMonthIncomeAmount != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "Expense is greater than income this month",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.previousMonthExpenseAmount! != 0 &&
                  homeData.thisMonthExpenseAmount! >
                      homeData.previousMonthExpenseAmount!
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "Expense is greater than previous month (Rs. ${homeData.previousMonthExpenseAmount})",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          homeData.previousMonthExpenseAmount! != 0 &&
                  homeData.thisMonthExpenseAmount! >
                      homeData.previousMonthExpenseAmount!
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: sWidth * .8,
                        child: Text(
                          "ExD is greater than previous month (Rs. ${homeData.previousMonthExpenseRate} ExD)",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget expenseDetail(
      BuildContext context, List<ExpenseCategorized> category) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Expense Categories",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .55)) / (sHeight * .25),
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(
              expenseCategories.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CategorizedExpense(
                          category: expenseCategories[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            height: sHeight * 0.2,
                            width: sWidth * 0.46,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "image/category/${expenseCategories[index]}.jpg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        expenseCategories[index],
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          category.isNotEmpty
              ? moreExpense
                  ? ElevatedButton(
                      onPressed: () {
                        List<String> tempCategory = category
                            .asMap()
                            .map((key, value) {
                              return MapEntry(key, category[key].category!);
                            })
                            .values
                            .toList();

                        setState(() {
                          expenseCategories = tempCategory;
                          moreExpense = !moreExpense;
                        });
                      },
                      child: Text(
                        "View less",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: elevated,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        List<String> tempCategory = expenseCategories;
                        for (int i = 0;
                            i < Category.expenseCategory.length;
                            i++) {
                          if (!tempCategory
                              .contains(Category.expenseCategory[i])) {
                            tempCategory.add(Category.expenseCategory[i]);
                          }
                        }
                        setState(() {
                          expenseCategories = tempCategory;
                          moreExpense = !moreExpense;
                        });
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: elevated,
                    )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget incomeDetail(BuildContext context, List<IncomeCategorized> category) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Income Categories",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .55)) / (sHeight * .25),
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(
              incomeCategories.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CategorizedIncome(
                          category: incomeCategories[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            height: sHeight * 0.2,
                            width: sWidth * 0.46,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "image/category/${incomeCategories[index]}.jpg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        incomeCategories[index],
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          category.isNotEmpty
              ? moreIncome
                  ? ElevatedButton(
                      onPressed: () {
                        List<String> tempCategory = category
                            .asMap()
                            .map((key, value) {
                              return MapEntry(key, category[key].category!);
                            })
                            .values
                            .toList();

                        setState(() {
                          incomeCategories = tempCategory;
                          moreIncome = !moreIncome;
                        });
                      },
                      child: Text(
                        "View Less",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: elevated,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        List<String> tempCategory = incomeCategories;
                        for (int i = 0;
                            i < Category.incomeCategory.length;
                            i++) {
                          if (!tempCategory
                              .contains(Category.incomeCategory[i])) {
                            tempCategory.add(Category.incomeCategory[i]);
                          }
                        }
                        setState(() {
                          incomeCategories = tempCategory;
                          moreIncome = !moreIncome;
                        });
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      style: elevated,
                    )
              : SizedBox(),
        ],
      ),
    );
  }
}
