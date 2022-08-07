import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
//import 'package:url_launcher/url_launcher.dart';

class EmployeeTiles extends StatefulWidget {
  String? Perkdesc;
  DateTime? Expirydate;

  EmployeeTiles(this.Perkdesc, this.Expirydate);

  @override
  State<EmployeeTiles> createState() =>
      _EmployeeTilesState(Perkdesc, Expirydate);
}

class _EmployeeTilesState extends State<EmployeeTiles> {
  String? Perkdesc;
  DateTime? Expirydate;

  _EmployeeTilesState(this.Perkdesc, this.Expirydate);
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 155, 197, 232),
      ),
      width: screenwidth / 3,
      margin: const EdgeInsets.fromLTRB(35, 20, 20, 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(Perkdesc!,
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 91, 161),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  fontSize: 22,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
                'Perk Expiry Date: ' +
                    DateFormat('dd-MM-yyyy').format(Expirydate!),
                style: TextStyle(
                  color: Color.fromARGB(255, 5, 91, 161),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  fontSize: 22,
                )),
          ),
          // Image.network(
          //   imageurls[itemNo],
          //   height: 170,
          //   width: 170,
          // ),
          Expanded(
            child: ListTile(
              tileColor: Color.fromARGB(255, 123, 186, 238),
              hoverColor: Color.fromARGB(255, 254, 236, 210),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: screenheight / 10),
                Row(
                  children: [
                    Expirydate!.isAfter(DateTime.now())
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: MaterialButton(
                              color: Colors.red,
                              onPressed: () {
                                // _launchURL(urls[itemNo]);
                              },
                              child: const Text(
                                'Redeem',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Perk Expired',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 91, 161),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 2.0,
                                  fontSize: 22,
                                )),
                          )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
