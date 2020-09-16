import 'package:flutter/material.dart';
import 'package:messenger/modals/user.dart';
import 'package:messenger/services/auth.dart';
import 'package:messenger/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthMethods().user,
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff1f1f),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
