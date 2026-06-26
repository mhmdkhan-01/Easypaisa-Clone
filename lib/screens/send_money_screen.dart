import 'package:flutter/material.dart';
import 'package:payx/app_data.dart';
import 'package:payx/data/db_helper.dart';
import 'package:payx/screens/amount_sent_screen.dart';
import 'package:payx/screens/sending_animation_screen.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  DBHelper helper = DBHelper.getInstance;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("easypaisa Transfer"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Pay From",
                style: TextStyle(fontWeight: .w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset("assets/walleticon.png", height: 50),
                      SizedBox(width: 7),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text("easypaisa Account"),
                          Text(
                            (AppData.balance != null)
                                ? "Rs. ${AppData.balance} "
                                : "Rs. 0.01",
                            style: TextStyle(fontWeight: .w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 5),
              child: Text(
                "Pay To",
                style: TextStyle(fontWeight: .w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 5,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text("Account Title"),
                            Text(AppData.recTitle!),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text("Account Number"),
                            Text(AppData.recNumber ?? "2301"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 5),
              child: Text(
                "Payment Summary",
                style: TextStyle(fontWeight: .w600, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 7,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text("Transfer amount"),
                            Text("Rs. ${AppData.amount}"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [Text("Fee (including tax)"), Text("Free")],
                        ),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(fontWeight: .w700, fontSize: 18),
                            ),
                            Text(
                              "Rs. ${AppData.amount}",
                              style: TextStyle(fontWeight: .w700, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.square_outlined,
                        color: Color.fromARGB(255, 0, 194, 82),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Favorite Contact",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Add this recipient as a favorite for easy payments in the future.",
                              softWrap: true,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    DateTime dt = DateTime.now();
                    await AppData.deduct();
                    await helper.addTransaction(
                      date: "${dt.day}-${dt.month}-${dt.year}",
                      time:
                          "${(dt.hour < 10) ? '0${dt.hour}' : '${dt.hour}'}:${(dt.minute < 10) ? '0${dt.minute}' : '${dt.minute}'}",
                      to: "${AppData.recTitle}#${AppData.recNumber}",
                      amount: AppData.amount!,
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SendingAnimation(nextScreen: AmountSent()),
                      ),
                      (route) => route.isFirst,
                    );
                  },

                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 0, 194, 82),
                    ),
                    child: Center(
                      child: Text(
                        "Send Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
