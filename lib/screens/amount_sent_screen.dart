import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payx/app_data.dart';
import 'package:video_player/video_player.dart';

class AmountSent extends StatefulWidget {
  const AmountSent({super.key});

  @override
  State<AmountSent> createState() => _AmountSentState();
}

class _AmountSentState extends State<AmountSent> {
  late VideoPlayerController _controller;
  @override
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/tickAnimation.mp4");

    _controller.initialize().then((_) {
      _controller
        ..setLooping(true)
        ..setVolume(1)
        ..play();
      Future.delayed(_controller.value.duration, () {
        _controller.setVolume(0);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 5, backgroundColor: Colors.black),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 32),
              child: Row(
                mainAxisAlignment: .end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 25,
                    color: Colors.grey,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            _controller.value.isInitialized
                ? SizedBox(
                    width: 450,
                    height: 143,
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // top-aligned
                        child: Transform.translate(
                          offset: const Offset(0, -90),
                          child: Transform.scale(
                            scale: 1.2,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text("Rs.", style: TextStyle(fontWeight: .w500)),
                  Row(
                    crossAxisAlignment: .end,

                    children: [
                      Text(
                        "${AppData.amount}",
                        style: TextStyle(fontSize: 45, fontWeight: .w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: Text(".00", style: TextStyle(fontWeight: .w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text("Successfully Sent to", style: TextStyle(fontWeight: .w500)),
            SizedBox(height: 9),
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
                        style: TextStyle(color: Colors.black, fontSize: 23),
                      ),
                    );
                  }

                  // 2. Construct the path to your custom file
                  final String path =
                      "${snapshot.data!.path}/${AppData.recNumber}.jpg";
                  final File imageFile = File(path);
                  print("Snapshot got data");
                  // 3. Check if the file actually exists on the device
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
                            style: TextStyle(color: Colors.black, fontSize: 23),
                          ),
                        );
                },
              ),
            ),
            SizedBox(height: 9),
            Text(AppData.recTitle!, style: TextStyle(fontWeight: .w500)),
            Row(
              mainAxisAlignment: .center,
              children: [
                Image.asset("assets/elogo.png", height: 15),
                Text(AppData.recNumber!),
              ],
            ),
            SizedBox(height: 40),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                onTap: () async {
                  showReceipt(context);
                },
                highlightColor: Colors.white,
                child: Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long_rounded, color: Colors.grey),
                        SizedBox(width: 10),
                        Text(
                          "View Receipt",
                          style: TextStyle(fontWeight: .w600),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.share, color: Colors.grey),
                      SizedBox(width: 10),
                      Text("Share", style: TextStyle(fontWeight: .w600)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showReceipt(BuildContext context) async {
    var date = DateTime.now();
    String d = (date.day < 10) ? "0${date.day}" : "${date.day}";
    int hh = date.hour;
    String ampm = (date.hour < 13) ? "AM" : "PM";
    if (hh != 12) {
      hh = hh % 12;
    }
    String hour = (hh < 10) ? "0$hh" : "$hh";
    String minute = (date.minute < 10) ? "0${date.minute}" : "${date.minute}";

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
                      "$d ${months[date.month]} ${date.year}   $hour:$minute $ampm",
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
                      "${AppData.recTitle}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      "${AppData.recNumber}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Account Details",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      "${AppData.recTitle}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Sent by",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      "${AppData.myTitle}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      "${AppData.myNumber}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "Amount",
                      style: TextStyle(fontWeight: .bold, fontSize: 16),
                    ),
                    Text(
                      "${AppData.amount}.00",
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
                      "Rs. ${AppData.amount}.00",
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
