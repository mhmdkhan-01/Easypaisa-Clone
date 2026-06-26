import 'package:flutter/material.dart';
import 'package:payx/app_data.dart';
import 'package:payx/screens/amount_screen.dart';

class SearchContact extends StatefulWidget {
  const SearchContact({super.key});

  @override
  State<SearchContact> createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  List<List<String>> contacts = [
    ['Aisha', '03011234567'],
    ['Ali', '03022345678'],
    ['Amina', '03033456789'],
    ['Bilal', '03044567890'],
    ['Fatima', '03055678901'],
    ['Hassan', '03066789012'],
    ['Khadija', '03077890123'],
    ['Maryam', '03088901234'],
    ['Muhammad', '03099012345'],
    ['Noor', '03110123456'],
    ['Omar', '03121234567'],
    ['Saad', '03132345678'],
    ['Sara', '03143456789'],
    ['Usman', '03154567890'],
    ['Zainab', '03165678901'],
  ];
  TextEditingController numberController = TextEditingController();
  bool showNumber = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("easypaisa Transfer"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: .start,
        spacing: 10,
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
              child: Text(
                "Enter Mobile Number or Contact Name",
                style: TextStyle(
                  fontWeight: .w500,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 20),
              child: TextField(
                controller: numberController,
                onChanged: (value) {
                  setState(() {
                    showNumber = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter Number or Search Contacts",
                  hintStyle: TextStyle(fontSize: 12),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 14,
                    color: (numberController.text.length != 11)
                        ? Colors.grey.shade400
                        : Color.fromARGB(255, 0, 194, 82),
                  ),
                ),
              ),
            ),
          ),
          if (showNumber)
            InkWell(
              onTap: () async {
                if (numberController.text.length != 11) {
                  return;
                }
                await AppData.setReceiverInfo(numberController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AmountScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (numberController.text.length != 11)
                      ? Colors.white
                      : Color.fromARGB(255, 0, 194, 82),
                  border: (numberController.text.length != 11)
                      ? Border.all(color: Colors.grey.shade400)
                      : Border.all(color: Color.fromARGB(255, 0, 194, 82)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Send To: ${numberController.text}",
                  style: TextStyle(
                    color: (numberController.text.length != 11)
                        ? Colors.grey.shade400
                        : Colors.white,
                    fontWeight: .w800,
                  ),
                ),
              ),
            ),
          Container(
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 6, left: 20, bottom: 6),
              child: Text("Your contacts", style: TextStyle(fontWeight: .w700)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  contacts[index][0],
                  style: TextStyle(fontWeight: .w700),
                ),
                subtitle: Text(
                  contacts[index][1],
                  style: TextStyle(color: Colors.grey),
                ),

                leading: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 0, 194, 82),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      contacts[index][0][0],
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                trailing: Image.asset("assets/elogo.png", height: 25),
                shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
