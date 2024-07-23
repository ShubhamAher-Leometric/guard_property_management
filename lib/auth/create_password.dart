import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_bloc/bloc/chnage_password_bloc/change_password_bloc.dart';
import 'change_password.dart';

class create_password extends StatefulWidget {
  const create_password({Key? key}) : super(key: key);

  @override
  State<create_password> createState() => _create_passwordState();
}

class _create_passwordState extends State<create_password> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();
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
    // Get the screen size
    Size screenSize = MediaQuery
        .of(context)
        .size;

    // Define responsive sizes based on screen width
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double buttonWidth = screenWidth * 0.8; // Adjust as needed

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/login.png',
                  // Replace 'image_name.png' with your image asset path
                  height: screenHeight * 0.2, // Adjust the height of the image
                ),
                SizedBox(height: screenHeight * 0.04),
                const Text(
                  'Please Enter Your New Password',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                // New Password TextField
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(6.0), // Set border radius
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Adjust spacing
                // Confirm Password TextField
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(6.0), // Set border radius
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                BlocProvider(
                  create: (context) => _changePasswordBloc,
                  child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
                    listener: (context, state) {
                      if (state is ChangePasswordLoaded) {
                        final data = state.changePasswordModel.status!;
                        if (data == 'success') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => change_password(),
                            ),
                                (Route<dynamic> route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.changePasswordModel.message!),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        // else {
                        //   Fluttertoast.showToast(
                        //     msg: state.changePasswordModel.message!,
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.BOTTOM,
                        //     timeInSecForIosWeb: 1,
                        //     backgroundColor: Colors.blueAccent,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0,
                        //   );
                        // }
                      } else if (state is ChangePasswordError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message!),
                            backgroundColor: Colors.red,
                          ),
                        );
                        // Fluttertoast.showToast(
                        //   msg: state.message!,
                        //   toastLength: Toast.LENGTH_SHORT,
                        //   gravity: ToastGravity.BOTTOM,
                        //   timeInSecForIosWeb: 1,
                        //   backgroundColor: Colors.blueAccent,
                        //   textColor: Colors.white,
                        //   fontSize: 16.0,
                        // );
                      }
                    },
                    child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                      builder: (context, state) {
                        if(state is ChangePasswordLoading){
                          return ElevatedButton(
                            onPressed: () {
                              print('Waiting for response in loading state');
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFF3629B7)),
                              elevation: MaterialStateProperty.all(0),
                              // Remove elevation
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(buttonWidth * 2, screenHeight * 0.08)),
                              // Set text color to white
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                            ),
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        }
                        else{
                          return ElevatedButton(
                            onPressed: () {
                              var passwordData = {
                                "new_password": newPasswordController.text,
                                "confirm_password": confirmPasswordController.text,
                                "user_id": prefs.get('Otp_User_ID')
                              };
                              print('-------------------------');
                              print(passwordData);
                              var PasswordData = jsonEncode(passwordData);
                              _changePasswordBloc.add(ChangePasswordData(PasswordData));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFF3629B7)),
                              elevation: MaterialStateProperty.all(0),
                              // Remove elevation
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(buttonWidth * 2, screenHeight * 0.08)),
                              // Set text color to white
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text('Change Password',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015), // 1.5% of screen height
              ],
            ),
          ),
        ),
      ),
    );
  }
}
