import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payx/app_data.dart';
import 'package:payx/screens/send_money_screen.dart';

class AmountScreen extends StatefulWidget {
  const AmountScreen({super.key});

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  _AmountScreenState();
  bool nextBtnOn = false;
  var amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("easypaisa Transfer"),
        backgroundColor: Color.fromARGB(255, 243, 254, 248),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              color: Color.fromARGB(255, 243, 254, 248),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 0, 0),
                    child: Text(
                      "Sending to easypaisa account",
                      style: TextStyle(fontWeight: .w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 0, 194, 82),
                              width: 1,
                            ),
                          ),
                          child: FutureBuilder<Directory>(
                            future: getApplicationDocumentsDirectory(),
                            builder: (context, snapshot) {
                              // 1. While waiting for the directory path
                              if (!snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    AppData.recTitle![0],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 23,
                                    ),
                                  ),
                                );
                              }

                              // 2. Construct the path to your custom file
                              final String path =
                                  "${snapshot.data!.path}/${AppData.recNumber}.jpg";
                              final File imageFile = File(path);
                              print("Snapshot got data");
                              return (imageFile.existsSync())
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          FileImage(imageFile) as ImageProvider,
                                    )
                                  : CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        AppData.recTitle![0],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 23,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppData.recTitle!,
                                    style: TextStyle(fontWeight: .w500),
                                  ),
                                  Image.asset("assets/elogo.png", height: 15),
                                ],
                              ),
                              Text(AppData.recNumber!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 15, 0, 0),
                      child: Text(
                        "Enter Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(140, 35, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rs."),
                          SizedBox(
                            width: 199,
                            child: TextField(
                              showCursor: false,
                              controller: amountController,
                              onTap: () => amountController.text = "",
                              onChanged: (value) {
                                if (value.contains('-') ||
                                    value.contains(' ') ||
                                    value.contains('.') ||
                                    value.contains(',')) {
                                  return;
                                }
                                if (value.isNotEmpty &&
                                    (int.parse(value) > 0)) {
                                  nextBtnOn = true;
                                } else if (value.isEmpty ||
                                    (int.parse(value) < 0)) {
                                  nextBtnOn = false;
                                }
                                setState(() {});
                              },
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 40),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 40),
                                hintText: "0",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 45, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline),
                          SizedBox(width: 7),
                          Text("Add a Message Here (Optional)"),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            await AppData.setAmount(
                              int.parse(amountController.text),
                            );
                            if (AppData.checkAmountValidity()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendMoney(),
                                ),
                              );
                            } else {
                              showError(context);
                            }
                          },
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: (nextBtnOn)
                                  ? Color.fromARGB(255, 0, 194, 82)
                                  : Colors.grey.shade500,
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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
            ),
          ],
        ),
      ),
    );
  }
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
