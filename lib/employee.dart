import 'package:chad_hr/model/Badge.dart';
import 'package:flutter/material.dart';
import 'package:chad_hr/model/GiveBadgeContract.dart';

class Empl extends StatefulWidget {
  Empl({Key? key}) : super(key: key);

  String? name;
  GiveBadgeContract? giveBadgeContract;
  Empl.withName({this.name, this.giveBadgeContract});

  @override
  State<Empl> createState() =>
      _EmplState(name: name, giveBadgeContract: giveBadgeContract);
}

class _EmplState extends State<Empl> {
  String? name;
  // final int id;
  List<String>? userBadges = [];
  String? badgeListString = "";

  GiveBadgeContract? giveBadgeContract;

  _EmplState({this.name, this.giveBadgeContract});

  @override
  void initState() {
    // TODO: implement initState
    GetBadgeDetails();
    super.initState();
  }

  void GetBadgeDetails() async {
    await giveBadgeContract!.GetBadges();

    List<Badge>? badgesList = giveBadgeContract!.badgesList ?? List.empty();

    for (int i = 0; i < badgesList.length; i++) {
      for (int j = 0;
          j < (badgesList[i].badgeOwners ?? List.empty()).length;
          j++) {
        if (name == badgesList[i].badgeOwners![j]) {
          if(!userBadges!.contains(badgesList[i].badgeName))
          {
            userBadges!.add(badgesList[i].badgeName ?? "");
          }
        }
      }
    }

    String s = "";
    for (int i = 0; i < (userBadges ?? List.empty()).length; i++) {
      s += "${i + 1}. ${userBadges![i]}\n";
    }

    setState(() {
      badgeListString = s;
    });

    // print(badges);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 170, 206, 235),
            border: Border.all(color: Colors.black)),
        // ignore: sort_child_properties_last
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'NAME : ',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 55, 64, 69)),
                  ),
                  Text(
                    name ?? "Lowde",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 20, 96, 132)),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Has Badge : \n' + (badgeListString == "" ? "No Badges :(" : badgeListString!),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 55, 64, 69)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          OpenBadgeGiver(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Give Badge",
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
        height: 15,
      ),
    );
  }

  OpenBadgeGiver(BuildContext context) async {
    await giveBadgeContract!.GetBadges();

    String? currentBadge = 'chad';

    List<String?>? items = giveBadgeContract!.badgesList!
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
                      items:
                          items.map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value ?? "Lowde"),
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
                      await giveBadgeContract!.GiveBadge(currentBadge!, name!);

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
