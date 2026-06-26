import 'package:flutter/material.dart';
import 'package:payx/app_data.dart';
import 'package:payx/screens/my_account_screen.dart';
import 'package:payx/screens/search_contact_screen.dart';
import 'package:payx/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? balance;
  bool showBalance = false;
  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    AppData appData = AppData();
    showBalance = false;
    getBalance();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF7FE3B3),
                    Color(0xFFF5F0B5),
                    Color(0xFF7FE3B3),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAccount(),
                              ),
                            ).then(
                              (value) => setState(() {
                                getBalance();
                              }),
                            );
                          },
                          icon: Icon(Icons.person_2),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                              child: Image.asset("assets/logo.png", height: 30),
                            ),
                            Row(
                              children: [
                                Icon(Icons.search_rounded, color: Colors.green),
                                Icon(Icons.notifications, color: Colors.green),
                                Icon(Icons.logout, color: Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionScreen(),
                        ),
                      ),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 109, 91),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 22, 15, 0),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Text(
                                    " easypaisa Account ",
                                    style: TextStyle(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        1,
                                        139,
                                        116,
                                      ),
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "My Rewards ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      Icon(
                                        Icons.star_border_rounded,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                crossAxisAlignment: .end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      0,
                                      10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      mainAxisAlignment: .end,
                                      children: [
                                        Text(
                                          "Available Balance",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        InkWell(
                                          onTap: () {
                                            showBalance = !showBalance;
                                            getBalance();
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                (showBalance)
                                                    ? (balance != null)
                                                          ? "Rs. $balance.91 "
                                                          : "Rs. 0.01"
                                                    : "****** ",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Icon(
                                                (showBalance)
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showBalance = !showBalance;
                                            setState(() {});
                                          },
                                          child: Text(
                                            (showBalance)
                                                ? "Tap to hide balance"
                                                : "Tap to show balance",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      10,
                                      0,
                                      0,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              255,
                                              0,
                                              109,
                                              91,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Color.fromARGB(
                                                255,
                                                0,
                                                189,
                                                94,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Upgrade Account",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 35,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                              255,
                                              0,
                                              189,
                                              94,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Color.fromARGB(
                                                255,
                                                0,
                                                189,
                                                94,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Add Amount",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: .spaceAround,
            //   children: [
            //     Container(
            //       height: 80,
            //       width: 90,

            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.white,
            //       ),
            //       child: Column(
            //         mainAxisAlignment: .center,
            //         children: [
            //           Icon(Icons.send_rounded),
            //           SizedBox(height: 5),
            //           Text("Send Money", style: TextStyle(fontSize: 12)),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 80,
            //       width: 90,

            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.white,
            //       ),
            //       child: Column(
            //         mainAxisAlignment: .center,
            //         children: [
            //           Icon(Icons.send_rounded),
            //           SizedBox(height: 5),
            //           Text("Bill Payment ", style: TextStyle(fontSize: 12)),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 80,
            //       width: 90,

            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.white,
            //       ),
            //       child: Column(
            //         mainAxisAlignment: .center,
            //         children: [
            //           Icon(Icons.send_rounded),
            //           SizedBox(height: 5),
            //           Text(
            //             "Mobile Packages",
            //             style: TextStyle(fontSize: 12),
            //             textAlign: .center,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),

            // SizedBox(height: 20),
            // Text("More with easypaisa"),
            InkWell(
              onTap: () async {
                showSendMoneyTo(context);
              },
              child: Image.asset("assets/upp.png"),
            ),
            InkWell(
              onTap: () async {
                setState(() {});
                showError(context);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset("assets/image.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getBalance() async {
    balance = AppData.balance;
    setState(() {});
  }
}

Future<void> showSendMoneyTo(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        title: Center(
          child: Text(
            "Send Money To",
            style: TextStyle(fontSize: 14, fontWeight: .w600),
          ),
        ),
        content: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => SearchContact()),
            );
          },
          child: SizedBox(
            height: 320,
            width: 400,
            child: Image.asset("assets/sendmoneyto.jpeg", width: 200),
          ),
        ),
      );
    },
  );
}

Future<void> showError(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.fromLTRB(30, 5, 30, 5),
        backgroundColor: Colors.white,
        content: InkWell(
          onTap: () => Navigator.pop(context),
          focusColor: Colors.white,
          highlightColor: Colors.white,
          child: Image.asset("assets/error.jpeg", width: 400, height: 300),
        ),
      );
    },
  );
}
