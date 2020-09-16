import 'package:flutter/material.dart';
import 'package:messenger/screens/sign_in.dart';
import 'package:messenger/services/auth.dart';
import 'package:messenger/widgets/appbar.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String message = '';
  TextEditingController emailController = TextEditingController();
  bool isloading = false;
  final _formkey = GlobalKey<FormState>();
  AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return isloading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: appBarMain(context),
            body: Container(
              padding: EdgeInsets.fromLTRB(15, 150, 15, 0),
              child: Column(
                children: <Widget>[
                  Form(
                      key: _formkey,
                      child: Container(
                        height: 70,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?_^`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : 'Enter valid Email Id';
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter the  email',
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        _authMethods
                            .resetPassword(emailController.text)
                            .then((value) {
                          if (value == null) {
                            setState(() {
                              isloading = false;
                              message =
                                  'The change password link is sent to your email !!';
                            });
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ));
                          }
                        });
                      }
                    },
                    color: Colors.blue,
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
  }
}
