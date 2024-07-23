import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_bloc/bloc/forget_otp_bloc/forget_otp_bloc.dart';
import 'otpforget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final ForgetOtpBloc _forgetOtpBloc = ForgetOtpBloc();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double buttonWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
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
                  'assets/reset_pass.png',
                  height: screenHeight * 0.2,
                ),
                SizedBox(height: screenHeight * 0.04),
                const Text(
                  'Please enter your email address to receive the verification link',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                Container(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Your Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                BlocProvider(
                  create: (context) => _forgetOtpBloc,
                  child: BlocListener<ForgetOtpBloc, ForgetOtpState>(
                    listener: (context, state) {
                      if (state is ForgetOtpLoaded) {
                        final data = state.forgotOtpModel.data;
                        if (data != null && data.userId != null) {
                          _recivedOtpUserID(data.userId!.toString());
                          _recivedOtpEmailId(data.email!.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpPage(email: emailController.text),
                              ),
                            );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.forgotOtpModel.message!),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        // else {
                        //   Fluttertoast.showToast(
                        //     msg: state.forgotOtpModel.message ?? 'Error occurred',
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.BOTTOM,
                        //     timeInSecForIosWeb: 1,
                        //     backgroundColor: Colors.blueAccent,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0,
                        //   );
                        // }
                      } else if (state is ForgetOtpError) {
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
                    child: BlocBuilder<ForgetOtpBloc, ForgetOtpState>(
                      builder: (context, state) {
                        if(state is ForgetOtpLoading){
                          return ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color(0xFF3629B7)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(buttonWidth * 2, screenHeight * 0.08)),
                              foregroundColor: MaterialStateProperty.all(
                                  Colors.white),
                            ),
                            child:  CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        }
                        else {return ElevatedButton(
                          onPressed: () {
                            var sendOtpData = {
                              "email": emailController.text,
                            };
                            var otpData = jsonEncode(sendOtpData);
                            _forgetOtpBloc.add(ForgetOtpData(otpData));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color(0xFF3629B7)),
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all(
                                Size(buttonWidth * 2, screenHeight * 0.08)),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.white),
                          ),
                          child: const Text(
                              'Send', style: TextStyle(fontSize: 20)),
                        );}
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _recivedOtpUserID(String otpUserId) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('Otp_User_ID', otpUserId);
    print('User ID Forget user: $otpUserId');
  }
  Future<void> _recivedOtpEmailId(String emailUserId) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('Forget_Email_User_ID', emailUserId);
    print('User Email For Forget user: $emailUserId');
  }
}
