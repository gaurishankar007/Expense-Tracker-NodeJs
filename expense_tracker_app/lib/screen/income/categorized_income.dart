import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../api/http/income_http.dart';
import '../../api/res/income_res.dart';
import '../../resource/colors.dart';

class CategorizedIncome extends StatefulWidget {
  final String? category;
  const CategorizedIncome({Key? key, @required this.category})
      : super(key: key);

  @override
  State<CategorizedIncome> createState() => _CategorizedIncomeState();
}

class _CategorizedIncomeState extends State<CategorizedIncome> {
  late Future<List<IncomeData>> incomeCategories;
  late List<IncomeData> incomeList;
  String firstDate = "";
  int incomeAmount = 0;
  int incomeIndex = 0;

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  void getCategorizedIncomes() async {
    int tempIncomeAmount = 0;
    incomeCategories = IncomeHttp().getCategorizedIncome(widget.category!);
    incomeCategories.then((value) {
      for (int i = 0; i < value.length; i++) {
        tempIncomeAmount = tempIncomeAmount + value[i].amount!;
      }
      setState(() {
        incomeList = value;
        incomeAmount = tempIncomeAmount;
      });
    });

    firstDate = await IncomeHttp().getCategoryStartDate(widget.category!);
  }

  @override
  void initState() {
    super.initState();
    getCategorizedIncomes();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<IncomeData>>(
              future: incomeCategories,
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
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    child: Image(
                                      width: sWidth,
                                      height: sHeight * .3,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "image/category/${widget.category}.jpg",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: sWidth,
                                    height: sHeight * .3,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black38,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sWidth * 0.015,
                                  vertical: 5,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        "${widget.category} (Rs. $incomeAmount)",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IconButton(
                            padding: EdgeInsets.all(5.0),
                            constraints: BoxConstraints(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.onPrimary,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      getButtons(context),
                      viewIncomes(context),
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
        ),
      ),
    );
  }

  Widget getButtons(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: sWidth * 0.03,
            top: 10,
            left: sWidth * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (incomeIndex == 0) {
                    return;
                  }

                  List<IncomeData> tempIncomeList =
                      await IncomeHttp().getCategorizedIncome(widget.category!);
                  int tempIncomeAmount = 0;
                  for (int i = 0; i < tempIncomeList.length; i++) {
                    tempIncomeAmount =
                        tempIncomeAmount + tempIncomeList[i].amount!;
                  }

                  setState(() {
                    incomeList = tempIncomeList;
                    incomeAmount = tempIncomeAmount;
                    incomeIndex = 0;
                  });
                },
                child: Text(
                  "This Month",
                ),
                style: ElevatedButton.styleFrom(
                  primary:
                      incomeIndex == 0 ? AppColors.primary : AppColors.button,
                  onPrimary:
                      incomeIndex == 0 ? AppColors.onPrimary : AppColors.text,
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
                  setState(() {
                    incomeList = [];
                    incomeAmount = 0;
                    incomeIndex = 1;
                  });

                  showDialog(
                    context: context,
                    builder: (builder) => selectDate(context, firstDate),
                  );
                },
                child: Text(
                  "Select",
                ),
                style: ElevatedButton.styleFrom(
                  primary:
                      incomeIndex == 1 ? AppColors.primary : AppColors.button,
                  onPrimary:
                      incomeIndex == 1 ? AppColors.onPrimary : AppColors.text,
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
          ),
        ),
      ],
    );
  }

  Widget selectDate(BuildContext context, String firstDate) {
    String startDate = "", endDate = "";

    return SimpleDialog(
      children: [
        SimpleDialogOption(
          padding: EdgeInsets.only(
            top: 5,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              DateTimeField(
                onChanged: (value) {
                  startDate = value.toString().split(" ")[0];
                },
                format: DateFormat("yyyy-MM-dd"),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(
                      int.parse(firstDate.split("-")[0]),
                      int.parse(firstDate.split("-")[1]),
                      int.parse(firstDate.split("-")[2]),
                    ),
                    initialDate: currentValue ?? DateTime.now(),
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
              SizedBox(
                height: 10,
              ),
              DateTimeField(
                onChanged: (value) {
                  endDate = value.toString().split(" ")[0];
                },
                format: DateFormat("yyyy-MM-dd"),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(
                      int.parse(firstDate.split("-")[0]),
                      int.parse(firstDate.split("-")[1]),
                      int.parse(firstDate.split("-")[2]),
                    ),
                    initialDate: currentValue ?? DateTime.now(),
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
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (startDate == "" ||
                      startDate == "null" ||
                      endDate == "" ||
                      endDate == "null") {
                    Fluttertoast.showToast(
                      msg: "Both start and end date is required.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: AppColors.primary,
                      fontSize: 16.0,
                    );
                  } else {
                    List<IncomeData> tempIncomeList = await IncomeHttp()
                        .getCategorizedSpecificIncome(
                            widget.category!, startDate, endDate);

                    int tempIncomeAmount = 0;
                    for (int i = 0; i < tempIncomeList.length; i++) {
                      tempIncomeAmount =
                          tempIncomeAmount + tempIncomeList[i].amount!;
                    }

                    setState(() {
                      incomeList = tempIncomeList;
                      incomeAmount = tempIncomeAmount;
                    });

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Search",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primary,
                  onPrimary: AppColors.onPrimary,
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
          ),
        ),
      ],
    );
  }

  Widget viewIncomes(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return incomeList.isEmpty
        ? SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "No incomes",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              right: sWidth * 0.03,
              bottom: 10,
              left: sWidth * 0.03,
            ),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: incomeList.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  minVerticalPadding: 5,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text(
                    (index + 1).toString() + ".",
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    incomeList[index].name!,
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    incomeList[index].createdAt!.split("T")[0],
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                  trailing: Text(
                    "Rs. " + incomeList[index].amount!.toString(),
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          );
  }
}
