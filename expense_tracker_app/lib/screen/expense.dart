import 'package:expense_tracker/api/http/expense_http.dart';
import 'package:expense_tracker/api/model/expense_income_model.dart';
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Expense"),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return StatefulBuilder(
                                builder: (context, setState) {
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              category = newValue!;
                                            });
                                          },
                                          items: Category.expenseCategory
                                              .map((String value) {
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

                                        final resData =
                                            await ExpenseHttp().addExpense(
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
                      color: AppColors.text,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 1),
    );
  }
}
