import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_property_management/auth/reset_password.dart';
import 'package:guard_property_management/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_bloc/bloc/login_bloc/login_apiblock_bloc.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginApiblockBloc _loginApiBloc = LoginApiblockBloc();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double titleFontSize = screenWidth * 0.08;
    double buttonWidth = screenWidth * 0.8;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3629B7),
                  ),
                ),
                const Text(
                  'Hello there, sign in to continue ',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: screenHeight * 0.011),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Image.asset(
                    'assets/login.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.022),
                Container(
                  height: screenHeight * 0.1,
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
                SizedBox(height: screenHeight * 0.015),
                Container(
                  height: screenHeight * 0.1,
                  child: TextField(
                    controller: passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocProvider(
                  create: (context) => _loginApiBloc,
                  child: BlocListener<LoginApiblockBloc, LoginApiblockState>(
                    listener: (context, state) {
                      if (state is LoginApiblockLoaded) {
                        if (state.loginModel.data != null) {
                          SetLogin(state.loginModel.apiAccessToken!);
                          SetUserId(state.loginModel.data!.id.toString());
                          SetProfilePic(state.loginModel.data!.profileImage.toString());
                          SetPropertyId(state.loginModel.data!.propertyId.toString());
                          Setdatefilter('this_month');
                          setSelectedTab('owner');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                                (Route<dynamic> route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.loginModel.message!),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else if (state is LoginApiblockError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<LoginApiblockBloc, LoginApiblockState>(
                      builder: (context, state) {
                        if (state is LoginApiblockLoading) {
                          return ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFF3629B7)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(buttonWidth * 2.3, screenHeight * 0.08)),
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                            ),
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              var sendLoginData = {
                                "email": emailController.text,
                                "password": passwordController.text
                              };
                              var loginData = jsonEncode(sendLoginData);
                              _loginApiBloc.add(LoginApiData(loginData));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xFF3629B7)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(
                                  Size(buttonWidth * 2.3, screenHeight * 0.08)),
                              foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("Not an account yet?"),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => registration_page(),
                //           ),
                //         );                      },
                //       child: Text(
                //         'Register now',
                //         style: TextStyle(color: Color(0xFF3629B7)),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> SetLogin(String token) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool("IS_LOGIN", true);
      prefs.setString('TOKEN', token);
      print('User Auth Token :' + token);
    });
  }
  Future<void> SetPropertyId(String property_id) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Guard_property_id', property_id);
      print('Guard_property_id :' + property_id);
    });
  }
  Future<void> SetUserId(String user_id) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('Login_user_id', user_id);
      print('Login_user_id :' + user_id);
    });
  }
  Future<void> SetProfilePic(String profile_pic) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('user_pic', profile_pic);
      print('user_pic :' + profile_pic);
    });
  }

  Future<void> Setdatefilter(String date_filter) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString('visitor_filter', date_filter);
      print('visitor_filter :' + date_filter);
    });
  }
  Future<void> setSelectedTab(String tabName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('selected_tab', tabName);
    print('Selected Tab: $tabName');
  }
}
