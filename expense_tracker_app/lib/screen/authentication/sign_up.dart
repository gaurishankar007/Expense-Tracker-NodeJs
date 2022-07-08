import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/authentication/sign_up_http.dart';
import '../../api/model/user_model.dart';
import '../../resource/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "", confirmPassword = "", profileName = "";
  String? gender = "";

  bool hidePass = true;
  bool hideCPass = true;

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
    final _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("SmoothPlayer"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: _screenWidth * 0.05,
            right: _screenWidth * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Welcome to Expense Tracker',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {
                    email = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Email is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.form,
                    hintText: "Enter your email.....",
                    enabledBorder: formBorder,
                    focusedBorder: formBorder,
                    errorBorder: formBorder,
                    focusedErrorBorder: formBorder,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {
                    profileName = value!;
                  },
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Profile name is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.form,
                    hintText: "Enter your profile name.....",
                    enabledBorder: formBorder,
                    focusedBorder: formBorder,
                    errorBorder: formBorder,
                    focusedErrorBorder: formBorder,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: (value) {
                        MultiValidator([
                          RequiredValidator(errorText: "Password is required!"),
                        ]);
                        return null;
                      },
                      obscureText: hidePass,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.form,
                        hintText: "Enter a password.....",
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          hidePass = !hidePass;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        confirmPassword = value!;
                      },
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        MultiValidator([
                          RequiredValidator(
                              errorText: "Password confirmation is required!"),
                        ]);
                        return null;
                      },
                      obscureText: hideCPass,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.form,
                        hintText: "Enter the password again.....",
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          hideCPass = !hideCPass;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final resData = await SignUpHttp().signUp(
                        UploadUser(
                          email: email,
                          profileName: profileName,
                          password: password,
                          confirmPassword: confirmPassword,
                        ),
                      );
                      if (resData["statusCode"] == 201) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.green,
                          textColor: AppColors.primary,
                          msg: resData["body"]["resM"],
                        );
                      } else {
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: AppColors.primary,
                          msg: resData["body"]["resM"],
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: AppColors.primary,
                        msg: "Please fill the required form",
                      );
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    elevation: 10,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
