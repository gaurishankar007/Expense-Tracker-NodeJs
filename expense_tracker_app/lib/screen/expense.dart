import 'package:expense_tracker/api/http/expense_http.dart';
import 'package:expense_tracker/api/model/expense_income_model.dart';
import 'package:expense_tracker/api/res/expense_res.dart';
import 'package:expense_tracker/api/urls.dart';
import 'package:expense_tracker/resource/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../resource/colors.dart';
import '../widget/navigator.dart';

class Expense extends StatefulWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final routeUrl = ApiUrls.routeUrl;
  final _formKey = GlobalKey<FormState>();
  String name = "", amount = "", category = "Other";

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

  late Future<ExpenseDWM> userExpenseDetails;
  late List<ExpenseData> expenseList;
  late int expenseAmount;
  late List<ExpenseCategorized> expenseCategoryList;
  int expenseIndex = 0;

  void getUserExpenseDetails() {
    userExpenseDetails = ExpenseHttp().getExpenseDWM();
    userExpenseDetails.then((value) {
      expenseList = value.todayExpenses!;
      expenseAmount = value.todayExpenseAmount!;
      expenseCategoryList = value.todayExpenseCategories!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserExpenseDetails();
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
            child: FutureBuilder<ExpenseDWM>(
              future: userExpenseDetails,
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
                                "Your Expenses",
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          addExpense(),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              userExpenseDetails.then((value) {
                                setState(() {
                                  expenseList = value.todayExpenses!;
                                  expenseAmount = value.todayExpenseAmount!;
                                  expenseCategoryList =
                                      value.todayExpenseCategories!;
                                  expenseIndex = 0;
                                });
                              });
                            },
                            child: Text(
                              "Today",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: expenseIndex == 0
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
                              userExpenseDetails.then((value) {
                                setState(() {
                                  expenseList = value.thisWeekExpenses!;
                                  expenseAmount = value.thisWeekExpenseAmount!;
                                  expenseCategoryList =
                                      value.thisWeekExpenseCategories!;
                                  expenseIndex = 1;
                                });
                              });
                            },
                            child: Text(
                              "This Week",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: expenseIndex == 1
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
                              userExpenseDetails.then((value) {
                                setState(() {
                                  expenseList = value.thisMonthExpenses!;
                                  expenseAmount = value.thisMonthExpenseAmount!;
                                  expenseCategoryList =
                                      value.thisMonthExpenseCategories!;
                                  expenseIndex = 2;
                                });
                              });
                            },
                            child: Text(
                              "This Month",
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: expenseIndex == 2
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
                      viewExpense(
                        expenseList,
                        expenseAmount,
                        expenseCategoryList,
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
      bottomNavigationBar: PageNavigator(pageIndex: 1),
    );
  }

  Widget addExpense() {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return StatefulBuilder(builder: (context, setState) {
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
                              setState(() {
                                category = newValue!;
                              });
                            },
                            items: Category.expenseCategory.map((String value) {
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

                          final resData = await ExpenseHttp().addExpense(
                            AddExpenseIncome(
                              name: name,
                              amount: amount,
                              category: category,
                            ),
                          );

                          if (resData["statusCode"] == 201) {
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
            });
      },
      icon: Icon(
        Icons.add,
        color: AppColors.primary,
        size: 35,
      ),
    );
  }

  Widget viewExpense(
    List<ExpenseData> expenses,
    int amount,
    List<ExpenseCategorized> category,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              'Total Expense: ',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Rs. " + amount.toString(),
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: expenses.length,
          itemBuilder: ((context, index) {
            return SizedBox(
              height: 55,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                minVerticalPadding: 5,
                leading: Text(
                  (index + 1).toString() + ".",
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  expenses[index].name!,
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  expenses[index].category!,
                  style: TextStyle(
                    color: AppColors.text,
                  ),
                ),
                trailing: Text(
                  "Rs. " + expenses[index].amount!.toString(),
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
