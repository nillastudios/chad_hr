// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'model/Perks.dart';
import 'sidebar.dart';
import 'SecureStorage.dart';
import 'employee_tile.dart';
import 'employee_tile.dart';

import 'model/UserCredentials.dart';

class EmployeePerks extends StatefulWidget {
  EmployeePerks({Key? key}) : super(key: key);

  @override
  State<EmployeePerks> createState() => _EmployeePerksState();
}

class _EmployeePerksState extends State<EmployeePerks> {
  final storage = SecureStorage(FlutterSecureStorage());

  UserCredentials? currentuser;
  List<UserCredentials> userCreds = [];
  DateTime? dateTime = DateTime.now();
  DateTime? newDate;
  List<Perks>? perks = [];
  List<Perks>? avaialableperks = [];
  List<String>? perks_string = [];
  List<String?>? perkedemployees = [];

  void initState() {
    DoStuff();
    // TODO: implement initState
    super.initState();
  }

  Future DoStuff() async {
    //await CurrentUser();
    await GetUserCreds();
    await GetPerks();
    await CheckPerks();
  }

  Future GetUserCreds() async {
    String? jsonString = await storage.read(key: 'userCredentials');
    List<String>? userCred_string =
        (jsonDecode(jsonString ?? "") as List<dynamic>).cast<String>();

    for (String uCS in userCred_string) {
      Map<String, dynamic> data = jsonDecode(uCS);

      UserCredentials creds = UserCredentials.fromJson(data);

      userCreds.add(creds);

      String? usercreds = await storage.read(key: 'currentUser');

      currentuser = UserCredentials.fromJson(jsonDecode(usercreds ?? ""));
    }
  }

  Future GetPerks() async {
    setState(() {
      perks = [];
    });

    String? perStr = await storage.read(key: 'perks');
    perks_string = (jsonDecode(perStr!) as List<dynamic>).cast<String>();

    for (String s in perks_string!) {
      Map<String, dynamic> data = jsonDecode(s);

      setState(() {
        perks!.add(Perks.fromJson(data));
      });
    }

    // for (int i = 0; i < perks!.length; i++) {
    //   if (perks![i].redeemer!.contains(currentuser)) {
    //     avaialableperks!.add(perks![i]);
    //   }
    // }
  }

  Future CheckPerks() async {
    setState(() {
      avaialableperks = [];
    });
    for (int i = 0; i < perks!.length; i++) {
      print(perks![i].redeemer);
      if (perks![i].redeemer!.contains(currentuser!.userName)) {
        print("Lowde");
        setState(() {
          avaialableperks!.add(perks![i]);
        });
      }

      //print(perks![i].redeemer);
    }

    //print(avaialableperks);
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'Chad HR';
    var screenwidth = MediaQuery.of(context).size.width;
    String emojiCode = '\u2639';
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 213, 161),
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
          automaticallyImplyLeading: true,
        ),
        body: Row(
          children: [
            SideBar(index: 5),
            SizedBox(height: 2),
            avaialableperks!.length != 0
                ? Container(
                    width: screenwidth / 1.1,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(children: [
                          SizedBox(
                            width: screenwidth / 2.4,
                          ),
                          Text(
                            'PERKS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(185, 0, 0, 0),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GridView.builder(
                            itemCount: avaialableperks!.length,
                            itemBuilder: (context, index) => EmployeeTiles(
                                avaialableperks![index].perk,
                                avaialableperks![index].expireDate),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 50,
                              crossAxisSpacing: 20,
                            ),
                          ),
                        )
                      ],
                    ))
                : Container(
                    width: screenwidth / 1.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emojiCode,
                              style: TextStyle(fontSize: 40),
                            ),
                            Text(
                              'Nothing to Show Here',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 91, 161),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 2.0,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
            // if (currentuser?.userRole == 'HR' ||
            //     currentuser?.userRole! == 'Boss')

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      perks_issue(context, this);
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  perks_issue(BuildContext context, _EmployeePerksState state) {
    TextEditingController perksCont = new TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Dialog(
            child: Container(
              width: 1000,
              height: 700,
              color: Color.fromARGB(255, 228, 213, 161),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Padding(
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
                            // controller: titleCont,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the Perk details',
                            ),
                            controller: perksCont,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Row(children: [
                          Text('Enter Expiry date: '),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              newDate = await showDatePicker(
                                  context: context,
                                  initialDate: dateTime!,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2200));

                              if (newDate == null)
                                return;
                              else {
                                setState(() => dateTime = newDate);
                              }
                            },
                            child: Text('${dateTime!.day}/' +
                                '${dateTime!.month}/' +
                                '${dateTime!.year}'),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Perk Redeemers',
                      ),
                      Container(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MultiSelectDialogField<UserCredentials>(
                              searchable: true,
                              searchHint: 'Search for Employees',
                              title: Text('Select Redeemers'),
                              items: userCreds
                                  .map((e) =>
                                      MultiSelectItem(e, e.userName ?? ""))
                                  .toList(),
                              listType: MultiSelectListType.LIST,
                              onConfirm: (values) {
                                for (int i = 0; i < values.length; i++) {
                                  perkedemployees!.add(values[i].userName);
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () async {
                      // Save it into a json
                      Perks pe = Perks();
                      pe.perk = perksCont.text;
                      if (dateTime != null) pe.expireDate = newDate;

                      pe.redeemer = List.from(perkedemployees!);

                      perks_string!.add(jsonEncode(pe.toJson()));

                      await storage.write(
                          key: 'perks', value: jsonEncode(perks_string));

                      await state.DoStuff();

                      Navigator.pop(context);
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
