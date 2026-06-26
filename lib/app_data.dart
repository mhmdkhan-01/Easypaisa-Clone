import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static int? balance;
  static String? myTitle;
  static String? myNumber;
  static String? recTitle;
  static String? recNumber;
  static int? amount;

  AppData() {
    initializeMemories();
  }

  void initializeMemories() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    balance = sp.getInt('balance');
    myTitle = sp.getString('myTitle');
    myNumber = sp.getString('myNumber');
  }

  static bool checkAmountValidity() {
    return (amount! <= balance!);
  }

  static Future<void> setBalance(int bal) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('balance', bal);
    balance = bal;
  }

  static Future<void> setMyInfo(String title, String num) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('myTitle', title);
    sp.setString('myNumber', num);
    myTitle = title;
    myNumber = num;
  }

  static Future<void> setAmount(int amo) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('amount', amo);
    amount = amo;
  }

  static Future<void> setReceiverInfo(String num) async {
    recTitle = await getReceiverAccountTitle(num);
    recNumber = num;
  }

  static Future<void> addContact(String title, String number) async {
    SharedPreferences ps = await SharedPreferences.getInstance();
    String? data = ps.getString('accounts');

    Map<String, String> accounts = {};

    if (data != null) {
      accounts = Map<String, String>.from(jsonDecode(data));
    }
    accounts[number] = title;
    await ps.setString('accounts', jsonEncode(accounts));
  }

  static Future<String?> getReceiverAccountTitle(String number) async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString('accounts');
    String? title = "Not Available";
    if (data != null) {
      Map<String, dynamic> accounts = jsonDecode(data);

      title = accounts[number];
      print(title);
    }

    return title!;
  }

  static Future<void> removeAccount(String number) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('accounts');

    if (data == null) return;

    Map<String, String> accounts = Map<String, String>.from(jsonDecode(data));

    accounts.remove(number);

    await prefs.setString('accounts', jsonEncode(accounts));
  }

  static Future<void> deduct() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    int newBalance = balance! - amount!;
    balance = newBalance;
    await sp.setInt('balance', newBalance);
  }
}
