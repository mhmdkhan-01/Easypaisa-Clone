import 'dart:convert';
import 'dart:io'; // Added for File
import 'package:flutter/material.dart';
import 'package:payx/app_data.dart';
import 'package:payx/data/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Added
import 'package:path_provider/path_provider.dart'; // Added

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController balancecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController numbercontroller = TextEditingController();
  TextEditingController mynamecontroller = TextEditingController();
  TextEditingController mynumbercontroller = TextEditingController();

  File? _selectedImage; // To store the selected file
  File? _userImage;
  @override
  void initState() {
    super.initState();
  }

  // Added: Function to pick and save image locally
  Future<void> _pickAndSaveImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      bool d = await File('${directory.path}/userDP.jpg').exists();
      if (d) {
        await File('${directory.path}/userDP.jpg').delete(recursive: true);
        print("Found and deleted");
      }
      final File savedImage = await File(
        image.path,
      ).copy('${directory.path}/userDP.jpg');

      // You can save this path to SharedPreferences here if needed
      //await AppData.setProfileImagePath(savedImage.path);
      print("image saved");
      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  Future<void> saveUserImage(String num) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      bool d = await File('${directory.path}/${num}.jpg').exists();
      if (d) {
        await File('${directory.path}/${num}.jpg').delete(recursive: true);
        print("Found and deleted");
      }
      final File savedImage = await File(
        image.path,
      ).copy('${directory.path}/${num}.jpg');

      // You can save this path to SharedPreferences here if needed
      //await AppData.setProfileImagePath(savedImage.path);
      print("image saved");
      setState(() {
        _userImage = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit"), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter New Balance",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: balancecontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "000000",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  if (balancecontroller.text == "") {
                    return;
                  }
                  int prevbalance = await AppData.balance ?? 0;
                  int newbalance =
                      prevbalance + int.parse(balancecontroller.text);
                  await AppData.setBalance(newbalance);
                  DBHelper helper = DBHelper.getInstance;
                  DateTime dt = DateTime.now();
                  await helper.addTransaction(
                    date: "${dt.day}-${dt.month}-${dt.year}",
                    time:
                        "${(dt.hour < 10) ? '0${dt.hour}' : '${dt.hour}'}:${(dt.minute < 10) ? '0${dt.minute}' : '${dt.minute}'}",
                    to: "Umar#03046382341",
                    amount: int.parse(balancecontroller.text),
                  );
                  balancecontroller.text = "";
                  setState(() {});
                },
                highlightColor: Colors.white,
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 0, 194, 82),
                  ),
                  child: Center(
                    child: Text(
                      "Update Balance",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Enter Your Number",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: mynumbercontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "03XXXXXXXXX",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Enter Your Name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: mynamecontroller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "ABC XYZ",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  if (mynamecontroller.text == '' ||
                      mynumbercontroller.text.length < 11) {
                    return;
                  }
                  await AppData.setMyInfo(
                    mynamecontroller.text.toString(),
                    mynumbercontroller.text.toString(),
                  );

                  mynamecontroller.text = "";
                  mynumbercontroller.text = "";
                  setState(() {});
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
                      "Update Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Enter Reciever Number",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: numbercontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "03XXXXXXXXX",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Enter Reciever Name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: namecontroller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "ABC XYZ",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  if (namecontroller.text == '' ||
                      numbercontroller.text.length < 11) {
                    return;
                  }
                  await AppData.addContact(
                    namecontroller.text.toString(),
                    numbercontroller.text.toString(),
                  );
                  namecontroller.text = "";
                  numbercontroller.text = "";
                  setState(() {});
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
                      "Add Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45),
              InkWell(
                onTap: () async {
                  await AppData.removeAccount(numbercontroller.text);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 255, 82, 63),
                  ),
                  child: Center(
                    child: Text(
                      "Delete Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // --- NEW CODE STARTING HERE ---
              SizedBox(height: 40),
              Text(
                "Profile Image",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: _pickAndSaveImage,
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 194, 82),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 194, 82),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // --- NEW CODE END ---
              SizedBox(height: 40),
              Text(
                "Enter Reciever Number",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: numbercontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: "03XXXXXXXXX",
                  hintStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                ),
              ),
              // --- NEW CODE STARTING HERE FOR USER ---
              SizedBox(height: 40),
              Text(
                "Receiver Image",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 194, 82),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _userImage != null
                          ? FileImage(_userImage!)
                          : null,
                      child: _userImage == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        await saveUserImage(numbercontroller.text);
                        numbercontroller.text = "";
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 194, 82),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 194, 82),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // --- NEW CODE END ---
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> updateBalance(int balance) async {
  AppData.setBalance(balance);
}

Future<void> addAccount(String number, String title) async {
  final prefs = await SharedPreferences.getInstance();

  // get old data first
  String? data = prefs.getString('accounts');

  Map<String, String> accounts = {};

  if (data != null) {
    accounts = Map<String, String>.from(jsonDecode(data));
  }

  // add new account
  accounts[number] = title;

  // save again
  await prefs.setString('accounts', jsonEncode(accounts));
}
