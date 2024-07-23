import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'login_screen.dart';


class change_password extends StatefulWidget {
  const change_password({super.key});

  @override
  State<change_password> createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double buttonWidth = screenWidth * 0.8; // Adjust as needed

    return Scaffold(
      appBar: AppBar(
        //title: const Text('Reset Password'),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/change_pass.png', // Replace 'image_name.png' with your image asset path
                  height: screenHeight * 0.2, // Adjust the height of the image
                ),
                SizedBox(height: screenHeight * 0.04),
                const Text(
                  'Change password successfully',
                  style: TextStyle(fontSize: 18, color:Color(0xFF3629B7)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.01),
                const Text(
                  'You have successfully change password please use the new passwprd when sign in',
                  style: TextStyle(fontSize: 14,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.07),

                ElevatedButton(
                  onPressed: () {
                   Get.to(login_page());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF3629B7)),
                    elevation: MaterialStateProperty.all(0), // Remove elevation
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(buttonWidth * 2, screenHeight * 0.07)),
                    // Set text color to white
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Ok', style: TextStyle(fontSize: 20)),
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
