import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guard_property_management/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api_bloc/bloc/get_profile_bloc/get_profile_bloc.dart';
import '../constant.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? errorMessage;
  bool isUploading = false;
  String? _errorText;

  GetProfileBloc _getProfileBloc = GetProfileBloc();
  late SharedPreferences prefs;



  @override
  void initState() {
    super.initState();
    _initPrefs();
    _getProfileBloc.add(GetProfileDataEvent());
  }


  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          imageQuality: 70,
        );
        if (pickedFile != null) {
          setState(() {
            _images = [File(pickedFile.path)];
          });
        }
      } else {
        // Pick a single image using the camera
        final pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 800,
          imageQuality: 70,
        );
        if (pickedFile != null) {
          setState(() {
            _images = [File(pickedFile.path)];
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
  void _validatePhoneNumber() {
    final text = _phoneController.text;
    if (text.length < 10 || text.length > 11) {
      setState(() {
        _errorText = 'Phone number must be between 11 digits';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  Future<void> _submitData() async {
    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse('${AppConstants.BASE_URL}/api/edit-guard-profile');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = "Bearer ${prefs.getString('TOKEN')}";
    request.fields['guard_id'] = prefs.getString('Login_user_id')!;
    request.fields['name'] = _nameController.text;
    request.fields['mobile_number'] = _phoneController.text;
    request.fields['email'] = _emailController.text;

    for (var i = 0; i < _images.length; i++) {
      var image = _images[i];
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          image.path,
        ),
      );
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Uploaded successfully: $responseData');
        setState(() {
          isUploading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
          errorMessage = null; // Clear error message
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
              (Route<dynamic> route) => false,
        );
        // Navigate back to previous page with result
        // Get.back(result: true);
      } else {
        setState(() {
          Map<String, dynamic> parsedResponse = json.decode(responseData);
          String extractedMessage = parsedResponse['message']['mobile_number'][0];
          errorMessage = "$extractedMessage";
          isUploading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        });
        print(errorMessage);
      }
    } catch (e) {
      print('Error uploading files: $e');
      setState(() {
        errorMessage = "Error uploading files: $e";
        isUploading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocProvider(
            create: (context) => _getProfileBloc,
            child: BlocBuilder<GetProfileBloc, GetProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoading){
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF3629B7),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align to the start of the row
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                    onPressed: () {
                                      Get.back(); // Handle back arrow button press
                                    },
                                  ),
                                  SizedBox(width: 20,),
                                  Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(height: 40,),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.15,
                        left: screenWidth * 0.5 - 50,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: screenHeight * 0.06,
                              backgroundColor: Colors.red,
                              backgroundImage: AssetImage('assets/images/dummy_user.jpeg'),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: screenWidth * 0.39,
                        top: screenHeight * 0.23,
                        child: GestureDetector(
                          onTap: () {
                            // Add your edit functionality here
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3629B7),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.27,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: SingleChildScrollView( // Wrap the content with SingleChildScrollView
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.black,

                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black), // Border color
                                  borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      border: InputBorder.none, // Hide the default border of the text field
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,

                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black), // Border color
                                  borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: InputBorder.none, // Hide the default border of the text field
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: Colors.black,

                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black), // Border color
                                  borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: InputBorder.none, // Hide the default border of the text field
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.1),

                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Add functionality for the button
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xFF3629B7)),
                                    elevation: MaterialStateProperty.all(0), // Remove elevation
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),

                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(buttonWidth * 3, screenHeight * 0.06)),
                                    // Set text color to white
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: Text('Update', style: TextStyle(fontSize: 18),),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                else if(state is GetProfileLoaded){
                  if (_nameController.text.isEmpty) {
                    _nameController.text = state.getProfileModel.data!.name!;
                  }
                  if (_emailController.text.isEmpty) {
                    _emailController.text = state.getProfileModel.data!.email!;
                  }
                  if (_phoneController.text.isEmpty) {
                    _phoneController.text = state.getProfileModel.data!.mobileNumber!;
                  }
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFF3629B7),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align to the start of the row
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                    onPressed: () {
                                      Get.back(); // Handle back arrow button press
                                    },
                                  ),
                                  SizedBox(width: 20,),
                                  Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            SizedBox(height: 40,),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.15,
                        left: screenWidth * 0.5 - 50,
                        child: Stack(
                          children: [
                            if (_images.isNotEmpty)
                              CircleAvatar(
                                radius: screenHeight * 0.06,
                                backgroundColor: Colors.red,
                                backgroundImage: FileImage(File(_images.first.path)), // Display the first image from the list
                              )
                            else
                              CircleAvatar(
                                radius: screenHeight * 0.06,
                                backgroundColor: Colors.red,
                                backgroundImage: NetworkImage(state.getProfileModel.data!.profileImage.toString()),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: screenWidth * 0.39,
                        top: screenHeight * 0.23,
                        child: GestureDetector(
                          onTap: () {
                            _pickImage(ImageSource.gallery);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3629B7),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.27,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.06,),
                              Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0), // Add some padding for the text field
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: state.getProfileModel.data!.name,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0), // Add some padding for the text field
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: state.getProfileModel.data!.email,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  child: TextField(
                                    controller: _phoneController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: state.getProfileModel.data!.mobileNumber,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      errorText: errorMessage,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    onChanged: (text) {
                                      // _validatePhoneNumber();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: ElevatedButton(
                                  onPressed: isUploading ? null : _submitData,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xFF3629B7)),
                                    elevation: MaterialStateProperty.all(0), // Remove elevation
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(buttonWidth * 3, screenHeight * 0.06)),
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: isUploading
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                      : Text('Update', style: TextStyle(fontSize: 18),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF3629B7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align to the start of the row
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                  onPressed: () {
                                    Get.back(); // Handle back arrow button press
                                  },
                                ),
                                SizedBox(width: 20,),
                                Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.15,
                      left: screenWidth * 0.5 - 50,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: screenHeight * 0.06,
                            backgroundColor: Colors.red,
                            backgroundImage: AssetImage('assets/images/dummy_user.jpeg'),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: screenWidth * 0.39,
                      top: screenHeight * 0.23,
                      child: GestureDetector(
                        onTap: () {
                          // Add your edit functionality here
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF3629B7),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.27,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      child: SingleChildScrollView( // Wrap the content with SingleChildScrollView
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  'User Name',
                                  style: TextStyle(
                                    color: Color(0xFF3629B7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.06,),
                            Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.black,

                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black), // Border color
                                borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Name',
                                    border: InputBorder.none, // Hide the default border of the text field
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black,

                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black), // Border color
                                borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'example@gmail.com',
                                    border: InputBorder.none, // Hide the default border of the text field
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                color: Colors.black,

                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black), // Border color
                                borderRadius: BorderRadius.circular(20), // Border radius to make it circular
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16), // Add some padding for the text field
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: '9214 77710 51',
                                    border: InputBorder.none, // Hide the default border of the text field
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.1),

                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add functionality for the button
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xFF3629B7)),
                                  elevation: MaterialStateProperty.all(0), // Remove elevation
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),

                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(Size(buttonWidth * 3, screenHeight * 0.06)),
                                  // Set text color to white
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                child:  isUploading
                                    ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    :Text('Update', style: TextStyle(fontSize: 18),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
