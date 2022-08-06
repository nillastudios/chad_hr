// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:chad_hr/SecureStorage.dart';
import 'package:chad_hr/model/GiveBadgeContract.dart' as badgeContract;
//import 'package:flutter_application_1/employee.dart';
import 'dart:math';
import 'package:chad_hr/model/UserCredentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chad_hr/sidebar.dart';

import 'model/chadhr.g.dart' as chadhr;

import 'employee.dart';
import 'dart:convert';

class employee_m extends StatefulWidget {
  employee_m({Key? key}) : super(key: key);

  @override
  State<employee_m> createState() => _employee_mState();
}

class _employee_mState extends State<employee_m> {
  final storage = SecureStorage(FlutterSecureStorage());
  List<String> userCred_string = [];
  List<UserCredentials> userCreds = [];
  UserCredentials? currentuser;

  final badgeInterface = badgeContract.GiveBadgeContract();

  TextEditingController badgeAddCont = TextEditingController();

  @override
  void initState() {
    // print("object");
    GetUserCreds();
    // TODO: implement initState
    super.initState();
  }

  void GetUserCreds() async {
    String? jsonString = await storage.read(key: 'userCredentials');
    userCred_string =
        (jsonDecode(jsonString ?? "") as List<dynamic>).cast<String>();

    setState(() {
      for (String uCS in userCred_string) {
        Map<String, dynamic> data = jsonDecode(uCS);

        UserCredentials creds = UserCredentials.fromJson(data);

        userCreds.add(creds);
      }
    });

    String? usercredsStr = await storage.read(key: 'currentUser');

    setState(() {
      currentuser = UserCredentials.fromJson(jsonDecode(usercredsStr ?? ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(249, 243, 229, 202),
      appBar: AppBar(
        title: Text(
          'CHAD HR',
          style: TextStyle(
            fontFamily: 'ArchitectsDaughter-Regular',
            fontSize: 23.0,

            //fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 7, 68, 133),
        centerTitle: true,
      ),
      body: Row(
        children: [
          SideBar(),
          SizedBox(
            height: 1.1,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.13,
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                    child: Text(
                  'EMPLOYEE MANAGEMENT SYSTEM',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(185, 0, 0, 0),
                    decoration: TextDecoration.underline,
                  ),
                )),
                SizedBox(height: 20),
                Flexible(
                  child: GridView.builder(
                    itemBuilder: ((context, index) => Empl.withName(
                          name: userCreds[index].userName ?? "Lowde",
                          giveBadgeContract: badgeInterface,
                        )),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemCount: userCreds.length,
                  ),
                ),
              ],
            ),
          ),
          if (currentuser?.userRole == 'HR' || currentuser?.userRole == 'Boss')
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FloatingActionButton(
                  onPressed: () {
                    // Open FOrm dialog
                    OpenBadgeAdder(context);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            )
        ],
      ),
    );
  }

  OpenBadgeAdder(BuildContext buildContext) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Add Badge"),
              content: Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ), // BoxDecoration
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: badgeAddCont,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Badge Name',
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await badgeInterface.AddBadge(badgeAddCont.text);

                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Add Badge"),
                    ))
              ],
            );
          });
        });
  }

  OpenBadgeGiver(BuildContext context) {
    String? currentBadge = 'chad';

    List<String?>? items = badgeInterface.badgesList!
        .map(
          (e) => e.badgeName,
        )
        .toList();

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Add Badge"),
              content: Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ), // BoxDecoration
                  child: DropdownButton(
                      value: currentBadge,
                      items: items.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value??"Lowde"),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          currentBadge = val.toString();
                        });
                      }),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await badgeInterface.AddBadge(badgeAddCont.text);

                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Add Badge"),
                    ))
              ],
            );
          });
        });
  }
}
