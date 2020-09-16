import 'package:flutter/material.dart';
import 'package:messenger/authenticate/authenticate.dart';
import 'package:messenger/modals/user.dart';
import 'package:messenger/screens/chat.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Chat();
    }
  }
}
