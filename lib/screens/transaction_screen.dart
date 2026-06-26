import 'package:flutter/material.dart';
import 'package:payx/app_data.dart';
import 'package:payx/data/db_helper.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<String> months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  DBHelper helper = DBHelper.getInstance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text("My Account", style: TextStyle(fontSize: 19)),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              mainAxisAlignment: .spaceAround,
              children: [
                Text("Summary", style: TextStyle(color: Colors.grey.shade500)),
                Text(
                  "Transaction History",
                  style: TextStyle(fontWeight: .w500),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: .end,
            children: [
              Container(
                color: Color.fromARGB(255, 0, 189, 94),
                height: 3,
                width: 190,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 18, left: 18),
            child: Container(
              color: Colors.white,
              height: 65,
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Icon(Icons.file_download_outlined, color: Colors.redAccent),
                  SizedBox(width: 6),
                  Text("Download e-statement"),
                ],
              ),
            ),
          ),

          //Paste Here
          Expanded(child: getTransactionBoxes()),
        ],
      ),
    );
  }

  Widget getTransactionBoxes() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: helper.getAllTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> transactions = snapshot.data!;

        // If no transactions
        if (transactions.isEmpty) {
          return Center(
            child: Text(
              "No records Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        // Group transactions by date
        Map<String, List<Map<String, dynamic>>> grouped = {};

        for (var trx in transactions) {
          String date = trx['trx_date'];

          if (!grouped.containsKey(date)) {
            grouped[date] = [];
          }

          grouped[date]!.add(trx);
        }

        // Sort dates descending
        var sortedDates = grouped.keys.toList()
          ..sort((a, b) {
            List<String> partsA = a.split('-');
            List<String> partsB = b.split('-');

            DateTime dateA = DateTime(
              int.parse(partsA[2]),
              int.parse(partsA[1]),
              int.parse(partsA[0]),
            );

            DateTime dateB = DateTime(
              int.parse(partsB[2]),
              int.parse(partsB[1]),
              int.parse(partsB[0]),
            );

            return dateB.compareTo(dateA);
          });

        return SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sortedDates.map((dateStr) {
              List<Map<String, dynamic>> trxList = grouped[dateStr]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Text(
                    '${dateStr.split('-')[0]} ${months[int.parse(dateStr.split('-')[1])]} ${dateStr.split('-')[2]} ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),

                  // Transactions
                  ...trxList.map((trx) {
                    return InkWell(
                      onTap: () async {
                        showReceipt(context, trx);
                      },
                      splashColor: Colors.grey.shade100,
                      highlightColor: Colors.grey.shade100,
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Image.asset(
                            "assets/elogo.png",
                            height: 35,
                            width: 35,
                          ),
                          title: Text(
                            'Money Transfer-${trx['receiver'].toString().split('#')[0]}',
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            trx['trx_time'],
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            "Rs. ${trx['amount']}.00",
                            style: TextStyle(
                              color:
                                  (trx['receiver'].toString().split('#')[0] ==
                                      "Umar")
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> showReceipt(
    BuildContext context,
    Map<String, dynamic> trx,
  ) async {
    var months = [
      "None",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    int month = int.parse(trx["trx_date"].toString().split('-')[1]);
    String date =
        "${trx["trx_date"].toString().split('-')[0]} ${months[month]} ${trx["trx_date"].toString().split('-')[2]} ";
    String ampm = (int.parse(trx["trx_time"].toString().split(":")[0]) < 13)
        ? "AM"
        : "PM";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.zero),
          ),
          insetPadding: EdgeInsets.fromLTRB(10, 35, 10, 35),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(0),
          content: Column(
            crossAxisAlignment: .start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 142,
                  width: 310,
                  color: Color.fromARGB(255, 248, 248, 248),
                  child: Column(
                    children: [
                      Image.asset("assets/receiptTop.png", width: 310),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "$date   ${trx["trx_time"]} $ampm",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      "ID#45530648691",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Funding Source",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Image.asset("assets/walleticon.png", height: 19),
                        Text(
                          " easypaisa Account",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sent to",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      ("${trx["receiver"].toString().split('#')[0]}" == "Umar")
                          ? "${AppData.myTitle}"
                          : "${trx["receiver"].toString().split('#')[0]}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      ("${trx["receiver"].toString().split('#')[0]}" == "Umar")
                          ? "${AppData.myNumber}"
                          : "${trx["receiver"].toString().split('#')[1]}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Account Details",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      ("${trx["receiver"].toString().split('#')[0]}" == "Umar")
                          ? "${AppData.myTitle}"
                          : "${trx["receiver"].toString().split('#')[0]}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Sent by",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      ("${trx["receiver"].toString().split('#')[0]}" == "Umar")
                          ? "${trx["receiver"].toString().split('#')[0]}"
                          : "${AppData.myTitle}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      ("${trx["receiver"].toString().split('#')[0]}" == "Umar")
                          ? "${trx["receiver"].toString().split('#')[1]}"
                          : "${AppData.myNumber}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Amount",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      "${trx["amount"]}.00",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Fee / Charge",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      "No Charge",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Total Amount",
                      style: TextStyle(
                        fontWeight: .bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 194, 82),
                      ),
                    ),
                    Text(
                      "Rs. ${trx["amount"]}.00",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        Column(
                          mainAxisAlignment: .end,
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.grey.shade700,
                              size: 16,
                            ),
                            Text("Share", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: .end,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.grey.shade700,
                              size: 16,
                            ),
                            Text(
                              "Save to Gallery",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: .end,
                          children: [
                            Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.grey.shade700,
                              size: 16,
                            ),
                            Text("Save as PDF", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
