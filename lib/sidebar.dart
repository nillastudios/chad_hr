import 'package:chad_hr/sign_in.dart';
import 'package:flutter/material.dart';
import 'announcement.dart';
import 'employee_perks.dart';
import 'employee_managment.dart';
import 'employee.dart';
import 'form.dart';
import 'main.dart';
import 'approval.dart';
import 'approval_main.dart';
import 'reject_main.dart';
import 'SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'model/UserCredentials.dart';

class SideBar extends StatefulWidget {
  int index;
  SideBar({Key? key, required this.index}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final storage = SecureStorage(FlutterSecureStorage());
  UserCredentials? currentuser;

  @override
  void initState() {
    // TODO: implement initState
    CurrentUser();
    super.initState();
  }

  Future CurrentUser() async {
    String? usercreds = await storage.read(key: 'currentUser');

    setState(() {
      currentuser = UserCredentials.fromJson(jsonDecode(usercreds ?? ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.blue[600],
      width: (screenwidth / 25) + 4,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (route) => false);
                },
                child: Icon(
                  Icons.home,
                  color: widget.index == 0 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => announcement()),
                      (route) => false);
                },
                child: Icon(
                  Icons.campaign,
                  color: widget.index == 1 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => reject_m()),
                  //     (route) => false);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Forms()),
                      (route) => false);
                },
                child: Icon(
                  Icons.assignment,
                  color: widget.index == 2 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => approval_m()),
                      (route) => false);
                },
                child: Icon(
                  Icons.account_circle,
                  color: widget.index == 3 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600]),
          ),
          if(currentuser != null)
          if (currentuser!.userRole == 'HR' || currentuser!.userRole == 'Boss')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => employee_m()),
                      (route) => false);
                },
                child: Icon(
                  Icons.supervised_user_circle,
                  color: widget.index == 4 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => EmployeePerks()),
                    (route) => false);
              },
              child: Icon(
                Icons.discount,
                color: widget.index == 5 ? Colors.amber : Colors.white,
                size: 35.0,
              ),
              color: Colors.blue[600],
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async {
                  // await storage.delete(key: 'currentUser');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                },
                child: Icon(
                  Icons.logout,
                  color: widget.index == 6 ? Colors.amber : Colors.white,
                  size: 35.0,
                ),
                color: Colors.blue[600],
              ),
            ),
        ],
      ),
    );
  }
}
