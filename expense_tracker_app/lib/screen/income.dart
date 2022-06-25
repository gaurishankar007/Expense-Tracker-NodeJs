import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/api/urls.dart';
import 'package:expense_tracker/resource/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/http/income_http.dart';
import '../api/model/expense_income_model.dart';
import '../api/res/income_res.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';

class Income extends StatefulWidget {
  const Income({Key? key}) : super(key: key);

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  final routeUrl = ApiUrls.routeUrl;
  final _formKey = GlobalKey<FormState>();
  String name = "",
      amount = "",
      category = "Other",
      startDate = "",
      endDate = "";

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black87,
  );

  late Future<IncomeDWM> userIncomeDetails;
  late List<IncomeData> incomeList;
  late int incomeAmount;
  late List<IncomeCategorized> incomeCategoryList;
  int incomeIndex = 0;
  int touchedIndex = 0;

  void getUserIncomeDetails() async {
    userIncomeDetails = IncomeHttp().getIncomeDWM();
    userIncomeDetails.then((value) {
      incomeList = value.todayIncomes!;
      incomeAmount = value.todayIncomeAmount!;
      incomeCategoryList = value.todayIncomeCategories!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserIncomeDetails();
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
              left: sWidth * 0.03,
            ),
            child: FutureBuilder<IncomeDWM>(
              future: userIncomeDetails,
              builder: (context, snapshot) {
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
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  routeUrl + snapshot.data!.profilePicture!,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Incomes",
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return addIncome(context);
                                  });
                            },
                            icon: Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 35,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (incomeIndex == 0) {
                                return;
                              }

                              userIncomeDetails.then((value) {
                                setState(() {
                                  incomeList = value.todayIncomes!;
                                  incomeAmount = value.todayIncomeAmount!;
                                  incomeCategoryList =
                                      value.todayIncomeCategories!;
                                  incomeIndex = 0;
                                  touchedIndex = 0;
                                });
                              });
                            },
                            child: Text(
                              "Today",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: incomeIndex == 0
                                  ? AppColors.primary
                                  : AppColors.button,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (incomeIndex == 1) {
                                return;
                              }

                              userIncomeDetails.then((value) {
                                setState(() {
                                  incomeList = value.thisWeekIncomes!;
                                  incomeAmount = value.thisWeekIncomeAmount!;
                                  incomeCategoryList =
                                      value.thisWeekIncomeCategories!;
                                  incomeIndex = 1;
                                  touchedIndex = 0;
                                });
                              });
                            },
                            child: Text(
                              "This Week",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: incomeIndex == 1
                                  ? AppColors.primary
                                  : AppColors.button,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (incomeIndex == 2) {
                                return;
                              }

                              userIncomeDetails.then((value) {
                                setState(() {
                                  incomeList = value.thisMonthIncomes!;
                                  incomeAmount = value.thisMonthIncomeAmount!;
                                  incomeCategoryList =
                                      value.thisMonthIncomeCategories!;
                                  incomeIndex = 2;
                                  touchedIndex = 0;
                                });
                              });
                            },
                            child: Text(
                              "This Month",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: incomeIndex == 2
                                  ? AppColors.primary
                                  : AppColors.button,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (incomeIndex == 3) {
                                return;
                              }

                              setState(() {
                                incomeList = [];
                                incomeAmount = 0;
                                incomeCategoryList = [];
                                incomeIndex = 3;
                                touchedIndex = 0;
                              });
                            },
                            child: Text(
                              "Select",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: incomeIndex == 3
                                  ? AppColors.primary
                                  : AppColors.button,
                              minimumSize: Size.zero,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        ],
                      ),
                      incomeIndex == 3
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: sWidth * .45,
                                        height: 60,
                                        child: DateTimeField(
                                          onChanged: (value) {
                                            startDate =
                                                value.toString().split(" ")[0];
                                          },
                                          format: DateFormat("yyyy-MM-dd"),
                                          onShowPicker:
                                              (context, currentValue) {
                                            return showDatePicker(
                                              context: context,
                                              firstDate: DateTime(
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[0]),
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[1]),
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[2]),
                                              ),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime.now(),
                                            );
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.form,
                                            hintText: "Start Date",
                                            enabledBorder: formBorder,
                                            focusedBorder: formBorder,
                                            errorBorder: formBorder,
                                            focusedErrorBorder: formBorder,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: sWidth * .45,
                                        height: 60,
                                        child: DateTimeField(
                                          onChanged: (value) {
                                            endDate =
                                                value.toString().split(" ")[0];
                                          },
                                          format: DateFormat("yyyy-MM-dd"),
                                          onShowPicker:
                                              (context, currentValue) {
                                            return showDatePicker(
                                              context: context,
                                              firstDate: DateTime(
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[0]),
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[1]),
                                                int.parse(snapshot
                                                    .data!.firstIncomeDate!
                                                    .split("-")[2]),
                                              ),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime.now(),
                                            );
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.form,
                                            hintText: "End Date",
                                            enabledBorder: formBorder,
                                            focusedBorder: formBorder,
                                            errorBorder: formBorder,
                                            focusedErrorBorder: formBorder,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (startDate == "" ||
                                          startDate == "null" ||
                                          endDate == "" ||
                                          endDate == "null") {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Both start and end date is required.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        IncomeSpecific resData =
                                            await IncomeHttp()
                                                .getIncomeSpecific(
                                                    startDate, endDate);

                                        setState(() {
                                          incomeList = resData.incomes!;
                                          incomeAmount = resData.incomeAmount!;
                                          incomeCategoryList =
                                              resData.incomeCategories!;
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Search",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: incomeIndex == 3
                                          ? AppColors.primary
                                          : AppColors.button,
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      viewIncome(
                        context,
                        incomeList,
                        incomeAmount,
                        incomeCategoryList,
                      ),
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
              },
            )),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 2),
    );
  }

  void refreshPage(BuildContext context) {
    userIncomeDetails = IncomeHttp().getIncomeDWM();
    if (incomeIndex == 0) {
      userIncomeDetails.then((value) {
        setState(() {
          incomeList = value.todayIncomes!;
          incomeAmount = value.todayIncomeAmount!;
          incomeCategoryList = value.todayIncomeCategories!;
        });
      });
    } else if (incomeIndex == 1) {
      userIncomeDetails.then((value) {
        setState(() {
          incomeList = value.thisWeekIncomes!;
          incomeAmount = value.thisWeekIncomeAmount!;
          incomeCategoryList = value.thisWeekIncomeCategories!;
        });
      });
    } else if (incomeIndex == 2) {
      userIncomeDetails.then((value) {
        setState(() {
          incomeList = value.thisMonthIncomes!;
          incomeAmount = value.thisWeekIncomeAmount!;
          incomeCategoryList = value.thisMonthIncomeCategories!;
        });
      });
    }
  }

  Widget addIncome(
    BuildContext context,
  ) {
    return StatefulBuilder(builder: (context, setState1) {
      return AlertDialog(
        title: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: ((value) {
                  name = value!;
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Enter name",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                onSaved: ((value) {
                  amount = value!;
                }),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Enter amount",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.form,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  value: category,
                  elevation: 20,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.form,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (String? newValue) {
                    setState1(() {
                      category = newValue!;
                    });
                  },
                  items: Category.incomeCategory.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(8),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final resData = await IncomeHttp().addIncome(
                  AddExpenseIncome(
                    name: name,
                    amount: amount,
                    category: category,
                  ),
                );

                if (resData["statusCode"] == 201) {
                  refreshPage(context);
                  category = "Other";
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Provide all information.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: Text("Add"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(8),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              category = "Other";
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    });
  }

  Widget viewIncome(
    BuildContext context,
    List<IncomeData> incomes,
    int amount,
    List<IncomeCategorized> category,
  ) {
    final sWidth = MediaQuery.of(context).size.width;

    if (incomes.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              children: [
                Text(
                  "Income Categories:",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: category.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: IncomeCategoryColors.colorList[Category
                          .incomeCategory
                          .indexOf(category[index].category!)],
                      radius: 8,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      category[index].category! +
                          " (Rs. ${category[index].amount})",
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 8,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Total (Rs. ${amount.toString()})",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            width: sWidth * .5,
            height: sWidth * .5,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }

                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 30,
                sections: category
                    .asMap()
                    .map((index, data) {
                      final isTouched = index == touchedIndex;
                      final double fontSize = isTouched ? 20 : 15;
                      final double radius =
                          isTouched ? sWidth * .20 : sWidth * .16;

                      final pieData = PieChartSectionData(
                        value: double.parse(
                            ((data.amount! / amount) * 100).toStringAsFixed(1)),
                        title:
                            "${((data.amount! / amount) * 100).toStringAsFixed(1)}%",
                        color: IncomeCategoryColors.colorList[
                            Category.incomeCategory.indexOf(data.category!)],
                        radius: radius,
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                      return MapEntry(index, pieData);
                    })
                    .values
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                "Income Items:",
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: incomes.length,
            itemBuilder: ((context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                minVerticalPadding: 5,
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (builder) {
                      return operationIncome(
                        context,
                        IncomeData(
                          id: incomes[index].id,
                          name: incomes[index].name,
                          amount: incomes[index].amount,
                          category: incomes[index].category,
                        ),
                      );
                    },
                  );
                },
                leading: Text(
                  (index + 1).toString() + ".",
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  incomes[index].name!,
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  incomes[index].category!,
                  style: TextStyle(
                    color: AppColors.text,
                  ),
                ),
                trailing: Text(
                  "Rs. " + incomes[index].amount!.toString(),
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
        ],
      );
    } else if (incomeIndex != 3) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No income yet",
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                minimumSize: Size.zero,
                padding: EdgeInsets.all(8),
                elevation: 10,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return addIncome(context);
                  },
                );
              },
              child: Text("Add Income"),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget operationIncome(BuildContext context, IncomeData incomeData) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: MediaQuery.of(context).size.width * .20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.button,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(0),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (builder) {
                  return editIncome(
                    context,
                    incomeData,
                  );
                },
              );
            },
            child: SizedBox(
              height: 45,
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(0),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final resData = await IncomeHttp().removeIncome(incomeData.id!);
              refreshPage(context);
              Fluttertoast.showToast(
                msg: resData["resM"],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0,
              );
            },
            child: SizedBox(
              height: 45,
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Remove",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editIncome(BuildContext context, IncomeData incomeData) {
    TextEditingController nameTEC = TextEditingController(),
        amountTEC = TextEditingController();
    nameTEC.text = incomeData.name!;
    amountTEC.text = incomeData.amount!.toString();
    String categoryTEC = incomeData.category!;

    return StatefulBuilder(builder: (context, setState1) {
      return AlertDialog(
        title: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameTEC,
                onSaved: ((value) {
                  nameTEC.text = value!;
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Enter name",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: amountTEC,
                onSaved: ((value) {
                  amountTEC.text = value!;
                }),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.form,
                  hintText: "Enter amount",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.form,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton(
                  value: categoryTEC,
                  elevation: 20,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.form,
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (String? newValue) {
                    setState1(() {
                      categoryTEC = newValue!;
                    });
                  },
                  items: Category.incomeCategory.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(8),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final resData = await IncomeHttp().editIncome(
                  IncomeData(
                    id: incomeData.id,
                    name: nameTEC.text,
                    amount: int.parse(amountTEC.text),
                    category: categoryTEC,
                  ),
                );

                if (resData["statusCode"] == 200) {
                  refreshPage(context);

                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Provide all information.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: Text("Edit"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(8),
              elevation: 10,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    });
  }
}
