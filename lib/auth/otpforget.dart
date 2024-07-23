import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_bloc/bloc/reg_resend_otp_bloc/reg_resend_otp_bloc.dart';
import '../api_bloc/bloc/submit_foreget_otp_bloc/submit_forgot_otp_bloc.dart';
import 'create_password.dart';


class OtpPage extends StatefulWidget {
  final String email;


  const OtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final SubmitForgotOtpBloc _SubmitforgetOtpBloc = SubmitForgotOtpBloc();
  final RegResendOtpBloc _RegResendOtpBloc = RegResendOtpBloc();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _start = 59;
  String? _resentOtp;
  Timer? _timer;
  bool _resendCodeTapped = false; // Track if "Resend code" is tapped

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 0) {
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  Future<void> _resendCode() async {}

  // var otpResponse = await _apiService.resendCode(
  //   // user_id: widget.userId,
  //   type: '1',
  // );
  //
  //   if (otpResponse.containsKey('status') && otpResponse['status'] == 'success') {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(otpResponse['message']),
  //       backgroundColor: Colors.green,
  //     ));
  //     setState(() {
  //       _start = 59;
  //       _resentOtp = otpResponse['data']['otp'].toString();
  //       _startTimer();
  //       _resendCodeTapped = true; // Set to true when "Resend code" is tapped
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Error: ${otpResponse['message']}'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final double buttonWidth = screenWidth * 0.3;

    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.12,
      height: screenWidth * 0.13,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Enter OTP', style: const TextStyle(fontWeight: FontWeight.bold)),
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
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/login.png',
                width: screenWidth * 0.6,),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Code has been sent to your email  ${widget.email}. Enter the code here",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme.copyWith(
                  width: screenWidth * 0.13,
                  height: screenWidth * 0.14,
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.grey),
                  ),
                  textStyle: TextStyle(
                    color: Color(0xFF3629B7),
                    fontSize: 22,
                  ),
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.13,
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Color(0xFF3629B7)),
                  ),
                  textStyle: TextStyle(
                    color: Color(0xFF3629B7),
                    fontSize: 22,
                  ),
                ),
                controller: otpController,
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't Receive Code? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    child: BlocProvider(
                      create: (context) => _RegResendOtpBloc,
                      child: BlocListener<RegResendOtpBloc, RegResendOtpState>(
                        listener: (context, state) {
                          if(state is RegResendOtpLoading){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Resending new OTP"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          if (state is RegResendOtpLoaded) {
                            final data = state.regResendOtpModel.status!;
                            if (data == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.regResendOtpModel.message!),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                            // else {
                            //   Fluttertoast.showToast(
                            //     msg: state.submitforgotOtpModel.message!,
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.BOTTOM,
                            //     timeInSecForIosWeb: 1,
                            //     backgroundColor: Colors.blueAccent,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0,
                            //   );
                            // }
                          } else if (state is RegResendOtpError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: InkWell(
                          onTap:(){
                            _resendCode;
                            var sendOtpData = {
                              "type": 0,
                              "user_id": prefs.get('Otp_User_ID')
                            };
                            print('-------------------------');
                            print(sendOtpData);
                            var otpData = jsonEncode(sendOtpData);
                            _RegResendOtpBloc.add(RegResendOtpData(otpData));
                          },
                          child: Text(
                            "Resend code",
                            style: TextStyle(
                              color: Color(0xFF3629B7),
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF3629B7),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_resendCodeTapped)
                Text(
                  "Resend code in 00:${_start.toString().padLeft(2, '0')} ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              BlocProvider(
                create: (context) => _SubmitforgetOtpBloc,
                child: BlocListener<SubmitForgotOtpBloc, SubmitForgotOtpState>(
                  listener: (context, state) {
                    if (state is SubmitForgotOtpLoaded) {
                      final data = state.submitforgotOtpModel.status!;
                      if (data == 'success') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => create_password(),
                          ),
                              (Route<dynamic> route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.submitforgotOtpModel.message!),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      // else {
                      //   Fluttertoast.showToast(
                      //     msg: state.submitforgotOtpModel.message!,
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.blueAccent,
                      //     textColor: Colors.white,
                      //     fontSize: 16.0,
                      //   );
                      // }
                    } else if (state is SubmitForgotOtpError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<SubmitForgotOtpBloc, SubmitForgotOtpState>(
                    builder: (context, state) {
                      if (state is SubmitForgotOtpLoading){
                        return ElevatedButton(
                          onPressed: () {
                            print('Waiting for response in loading state');
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
                                Size(buttonWidth * 5, screenHeight * 0.07)),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.white),
                          ),
                          child:  CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      }
                      else {
                        return ElevatedButton(
                          onPressed: () {
                            var sendOtpData = {
                              "otp": otpController.text,
                              "type": 0,
                              "user_id": prefs.get('Otp_User_ID')
                            };
                            print('-------------------------');
                            print(sendOtpData);
                            var otpData = jsonEncode(sendOtpData);
                            _SubmitforgetOtpBloc.add(SubmitForgetOtpData(otpData));
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
                                Size(buttonWidth * 5, screenHeight * 0.07)),
                            foregroundColor: MaterialStateProperty.all(
                                Colors.white),
                          ),
                          child: Text('Verify Code', style: TextStyle(
                              fontSize: 20)),
                        );
                      }

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
