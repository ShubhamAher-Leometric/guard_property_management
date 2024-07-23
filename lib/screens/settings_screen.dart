import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:property_management/privacy.dart';
// import 'package:property_management/profile.dart';
// import 'package:property_management/term_condition.dart';
// import 'package:property_management/users_screen/Login_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        // final SharedPreferences prefs = await _prefs;
        // Handle the back navigation as per your requirement
        // For example, navigate back to the previous screen
        Get.back();
        // Return false to prevent the default system back button behavior
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Profile()),
                  // );
                },
                title: const Text('Edit Profile', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_right),
              ),
              ListTile(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const TermCondition()),
                  // );
                },
                title: const Text('Terms & Conditions', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_right), // Use appropriate icon
              ),
              ListTile(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                  // );
                },
                title: const Text('Privacy Policy', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.arrow_right),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              prefs.setBool("IS_LOGIN", false);
                              prefs.setString('TOKEN',"");
                              Navigator.of(
                                  context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => login_page()),
                                    (route) => false,
                              ); // Return false when "No" is pressed
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: const Text('Logout', style: TextStyle(fontSize: 17)),
                trailing: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
