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

class GiveBadgeContract extends ChangeNotifier {
  List<Badge>? badgesList = [];
  final String _rpcUrl =
      "https://ropsten.infura.io/v3/1f48dd8246df4a6e84642b0d71c59758";
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
  String contractAddress = "0x39f7fb8c85dd808769Ac3445E4076617218A304b";

  Chadhr? chadhr;

  // ContractFunction? _notesCount;
  // ContractFunction? _notes;
  // ContractFunction? _addNote;
  // ContractFunction? _deleteeNote;
  // ContractFunction? _editNote;
  // ContractEvent? _noteAddedEvent;
  // ContractEvent? _noteDeletedEvent;

  GiveBadgeContract() {
    WidgetsFlutterBinding.ensureInitialized();
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client());
    credentials = EthPrivateKey.fromHex(_privateKey);

    // await getAbi();
    // await getCreadentials();
    // await getDeployedContract();

    chadhr = Chadhr(
        address: EthereumAddress.fromHex(contractAddress),
        client: _client!,
        chainId: 3);
  }

  Future<List<dynamic>> GetBadges() async {
    badgesList = [];

    List<dynamic> badgeList = await chadhr!.GetBadges();

    for (var l in badgeList) {
      List<String> badgeOwners = [];
      for (var s in l[1]) {
        badgeOwners.add(s.toString());
      }
      Badge b = Badge(badgeName: l[0].toString(), badgeOwners: badgeOwners);

      badgesList!.add(b);
    }

    return badgeList;
  }

  Future AddBadge(String badgeName) async {
    String hash = await chadhr!.AddBadge(badgeName, credentials: credentials!);
    print(hash);

    // TransactionReceipt? tr;
    // await Future.delayed(Duration(seconds: 2), () async {
    //   while (tr == null) {
    //     tr = await _client!.getTransactionReceipt(hash);
    //   }
    // });

    // print(tr?.status);

    // print("Badge Add Status = " + (status == true ? "Success" : "Failure"));
  }

  Future GiveBadge(String badgeName, String userName) async {
    String hash =
        await chadhr!.GiveBadge(badgeName, userName, credentials: credentials!);
    print(hash);
  }
}
