import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:chad_hr/model/Badge.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'Badge.dart';

import 'chadhr.g.dart';
import 'package:collection/collection.dart';

class GiveBadgeContract extends ChangeNotifier {
  List<Badge>? badgesList = [];
  final String _rpcUrl = "https://rpc.ankr.com/polygon_mumbai";
  final String _wsUrl = "ws://127.0.0.1:7545/";

  final String _privateKey =
      "0xd87de68ddc182eb57b81c0636624b912009ed96a737110099b9a2b080b2b7429";

  Web3Client? _client;
  String? _abiCode;

  Credentials? credentials;
  EthereumAddress? _contractAddress;
  EthereumAddress? _ownAddress;
  DeployedContract? _contract;

  ContractFunction? getBadgesFunc;
  ContractFunction? badgesFunc;
  ContractFunction? giveBadgeFunc;
  String contractAddress = "0xB517aB924B022cc6dc62e704815E4F121aCC1220";

  Chadhr? chadhr;

  GiveBadgeContract() {
    WidgetsFlutterBinding.ensureInitialized();
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client());
    credentials = EthPrivateKey.fromHex(_privateKey);

    chadhr = Chadhr(
        address: EthereumAddress.fromHex(contractAddress),
        client: _client!,
        chainId: 80001);
  }

  Future<List<dynamic>> GetBadges() async {
    badgesList = [];
    // print(badgesList);

    List<dynamic> badgeList = await chadhr!.GetBadges();

    List<Badge>? badges = List.empty(growable: true);

    for (var l in badgeList) {
      List<String> badgeOwners = [];
      for (var s in l[1]) {
        badgeOwners.add(s.toString());
      }

      badges.add(Badge(badgeName: l[0].toString(), badgeOwners: badgeOwners));
    }

    badgesList = badges;
    print("Badges Loaded!");
    return badgeList;
  }

  Future AddBadge(String badgeName) async {
    String hash = await chadhr!.AddBadge(badgeName, credentials: credentials!);
    print(hash);
  }

  Future GiveBadge(String badgeName, String userName) async {
    String hash =
        await chadhr!.GiveBadge(badgeName, userName, credentials: credentials!);
    print(hash);
  }
}
