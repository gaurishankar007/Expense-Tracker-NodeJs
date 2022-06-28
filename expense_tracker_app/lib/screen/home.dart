import 'package:expense_tracker/api/http/home_http.dart';
import 'package:expense_tracker/api/res/expense_res.dart';
import 'package:expense_tracker/api/res/home_res.dart';
import 'package:expense_tracker/resource/category.dart';
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
            right: sWidth * 0.03,
            bottom: 10,
            left: sWidth * 0.03,
          ),
          child: Column(
            children: [
              Row(
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
              SizedBox(
                height: 20,
              ),
              FutureBuilder<HomeData>(
                future: userHomeData,
                builder: ((context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    children = <Widget>[
                      Container(
                        width: sWidth * 0.97,
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
                        expenseIncomeLineChart(
                          context,
                          snapshot.data!.thisMonthExpenses!,
                          snapshot.data!.thisMonthIncomes!,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        feedback(context, snapshot.data!),
                        SizedBox(
                          height: 20,
                        ),
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
                      children = <Widget>[
                        Container(
                          width: sWidth * 0.97,
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

  Widget expenseIncomeLineChart(BuildContext context,
      List<ExpenseData> expenses, List<IncomeData> incomes) {
    final sWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 200,
      width: sWidth * .94,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipRoundedRadius: 2,
            ),
          ),
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                "Day",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 25,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  TextStyle style = TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 0:
                      text = Text('1', style: style);
                      break;
                    case 1:
                      text = Text('2', style: style);
                      break;
                    case 2:
                      text = Text('3', style: style);
                      break;
                    case 3:
                      text = Text('4', style: style);
                      break;
                    case 4:
                      text = Text('5', style: style);
                      break;
                    case 5:
                      text = Text('6', style: style);
                      break;
                    case 6:
                      text = Text('7', style: style);
                      break;
                    default:
                      text = const Text('');
                      break;
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 5,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  TextStyle style = TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 1:
                      text = '1m';
                      break;
                    case 2:
                      text = '2m';
                      break;
                    case 3:
                      text = '3m';
                      break;
                    case 4:
                      text = '5m';
                      break;
                    case 5:
                      text = '6m';
                      break;
                    default:
                      return Container();
                  }

                  return Text(text, style: style, textAlign: TextAlign.center);
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: AppColors.text,
                width: 4,
              ),
              left: BorderSide(
                color: AppColors.text,
                width: 3,
              ),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Color(0xFF88F1BE),
              ),
              spots: const [
                FlSpot(0, 1),
                FlSpot(3, 1.5),
                FlSpot(5, 1.4),
                FlSpot(7, 3.4),
                FlSpot(10, 2),
                FlSpot(12, 2.2),
                FlSpot(13, 1.8),
              ],
            ),
            LineChartBarData(
              isCurved: true,
              color: Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: false,
              ),
              spots: const [
                FlSpot(1, 1),
                FlSpot(3, 2.8),
                FlSpot(7, 1.2),
                FlSpot(10, 2.8),
                FlSpot(12, 2.6),
                FlSpot(13, 3.9),
              ],
            ),
          ],
          minX: 0,
          maxX: 14,
          maxY: 4,
          minY: 0,
        ),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  Widget feedback(BuildContext context, HomeData homeData) {
    final sWidth = MediaQuery.of(context).size.width;

    if (homeData.thisMonthExpenses!.isEmpty) {
      return SizedBox();
    }

    return Column(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
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
                          "Rs. ${homeData.thisMonthExpenseRate!} ExD",
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
                            Text(
                              "${homeData.maxExpenseCategory!.category} MxEC",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
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
                          "Rs. ${homeData.thisMonthIncomeRate!} InD",
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
                            Text(
                              "${homeData.maxIncomeCategory!.category} MxIC",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
        homeData.thisMonthExpenseAmount! < homeData.thisMonthIncomeAmount!
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
                    homeData.previousMonthExpenseRate!
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
                        "Income amount per day (InD) is greater than previous month (Rs. ${homeData.previousMonthIncomeRate} InD).",
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
        homeData.thisMonthExpenseAmount! > homeData.thisMonthIncomeAmount!
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_box_rounded,
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
                      Icons.check_box_rounded,
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
                      Icons.check_box_rounded,
                      color: Colors.orange,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: sWidth * .8,
                      child: Text(
                        "Expense amount per day is greater than previous month (Rs. ${homeData.previousMonthExpenseRate} ExD)",
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
    );
  }

  Widget expenseDetail(
      BuildContext context, List<ExpenseCategorized> category) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Column(
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
    );
  }

  Widget incomeDetail(BuildContext context, List<IncomeCategorized> category) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Column(
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
                      for (int i = 0; i < Category.incomeCategory.length; i++) {
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
    );
  }
}
