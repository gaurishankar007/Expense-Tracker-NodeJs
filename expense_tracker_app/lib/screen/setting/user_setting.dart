import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/user_http.dart';
import '../../api/res/user_res.dart';
import '../../resource/colors.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  String profileName = "",
      userName = "",
      birthDate = "",
      biography = "",
      email = "";
  String? gender;

  final pKey = GlobalKey<FormState>(),
      uKey = GlobalKey<FormState>(),
      bKey = GlobalKey<FormState>(),
      eKey = GlobalKey<FormState>();

  bool pChange = false,
      uChange = false,
      bdChange = false,
      bChange = false,
      eChange = false,
      gChange = false;

  late Future<User> getUser;

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  @override
  void initState() {
    super.initState();

    getUser = UserHttp().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Personal Info",
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.onPrimary,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            right: sWidth * .01,
            bottom: 25,
            left: sWidth * .05,
          ),
          child: FutureBuilder<User>(
            future: getUser,
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
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 0, right: 0, bottom: 20),
                      minLeadingWidth: 0,
                      title: pChange
                          ? Form(
                              key: pKey,
                              child: TextFormField(
                                key: Key("profileName"),
                                onChanged: (value) {
                                  profileName = value.trim();
                                },
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "New profile ame is required"),
                                ]),
                                style: TextStyle(
                                  color: AppColors.text,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.form,
                                  hintText: "Enter new Profile Name",
                                  enabledBorder: formBorder,
                                  focusedBorder: formBorder,
                                  errorBorder: formBorder,
                                  focusedErrorBorder: formBorder,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Profile Name:",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  snapshot.data!.profileName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                      subtitle: pChange
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  pChange = false;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.deepOrange,
                                size: 25,
                              ),
                            )
                          : SizedBox(),
                      trailing: pChange
                          ? ElevatedButton(
                              onPressed: () async {
                                if (pKey.currentState!.validate()) {
                                  final resData = await UserHttp()
                                      .changeProfileName(profileName);
                                  Fluttertoast.showToast(
                                    msg: resData["body"]["resM"],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    getUser = UserHttp().getUser();
                                    pChange = false;
                                  });
                                }
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pChange = true;
                                });
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 0, right: 0, bottom: 20),
                      minLeadingWidth: 0,
                      title: eChange
                          ? Form(
                              key: eKey,
                              child: TextFormField(
                                key: Key("email"),
                                onChanged: (value) {
                                  email = value.trim();
                                },
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "New email is required"),
                                ]),
                                style: TextStyle(
                                  color: AppColors.text,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.form,
                                  hintText: "Enter new Email",
                                  enabledBorder: formBorder,
                                  focusedBorder: formBorder,
                                  errorBorder: formBorder,
                                  focusedErrorBorder: formBorder,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  snapshot.data!.email!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                      subtitle: eChange
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  eChange = false;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.deepOrange,
                                size: 25,
                              ),
                            )
                          : SizedBox(),
                      trailing: eChange
                          ? ElevatedButton(
                              onPressed: () async {
                                if (eKey.currentState!.validate()) {
                                  final resData =
                                      await UserHttp().changeEmail(email);
                                  Fluttertoast.showToast(
                                    msg: resData["body"]["resM"],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    getUser = UserHttp().getUser();
                                    eChange = false;
                                  });
                                }
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  eChange = true;
                                });
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 0, right: 0, bottom: 20),
                      minLeadingWidth: 0,
                      title: gChange
                          ? Row(
                              children: [
                                Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.primary),
                                  value: "Male",
                                  groupValue: gender,
                                  onChanged: (String? value) => setState(() {
                                    gender = value;
                                  }),
                                ),
                                Text(
                                  "Male",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 15,
                                  ),
                                ),
                                Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.primary),
                                  value: "Female",
                                  groupValue: gender,
                                  onChanged: (String? value) => setState(() {
                                    gender = value;
                                  }),
                                ),
                                Text(
                                  "Female",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 15,
                                  ),
                                ),
                                Radio(
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.primary),
                                  value: "Other",
                                  groupValue: gender,
                                  onChanged: (String? value) => setState(() {
                                    gender = value;
                                  }),
                                ),
                                Text(
                                  "Other",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender:",
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  snapshot.data!.gender!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                      subtitle: gChange
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  gChange = false;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.deepOrange,
                                size: 25,
                              ),
                            )
                          : SizedBox(),
                      trailing: gChange
                          ? ElevatedButton(
                              onPressed: () async {
                                if (gender != null) {
                                  final resData =
                                      await UserHttp().changeGender(gender!);
                                  Fluttertoast.showToast(
                                    msg: resData["body"]["resM"],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  setState(() {
                                    getUser = UserHttp().getUser();
                                    gChange = false;
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Gender not selected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  gChange = true;
                                });
                              },
                              child: Icon(Icons.edit),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                minimumSize: Size.zero,
                                primary: AppColors.primary,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                    ),
                  ];
                } else if (snapshot.hasError) {
                  if ("${snapshot.error}".split("Exception: ")[0] == "Socket") {
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
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
            },
          ),
        ),
      ),
    );
  }
}
