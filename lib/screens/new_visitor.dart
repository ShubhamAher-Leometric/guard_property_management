
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class AddNewVisitor extends StatefulWidget {
  const AddNewVisitor({super.key});

  @override
  _AddNewVisitorState createState() => _AddNewVisitorState();
}

class _AddNewVisitorState extends State< AddNewVisitor> {
  List<String> options = ['Visitor', 'Delivery', 'Contractor', 'Homestay'];
  List<String> visitorType = ['Walk in', 'Owner invite'];
  List<String> entry = ['Single', 'Multiple'];

  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _visitorTypeController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _expirydateController = TextEditingController();
  final TextEditingController _expirytimeController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  bool isSecondContainerVisible = false;
  bool isThirdContainerVisible = false;
  bool isFourthContainerVisible = false;
  bool isFifthContainerVisible = false;
  bool isSixthContainerVisible = false;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  late SharedPreferences prefs;
  String? errorMessage;
  bool isUploading = false;
  String? _errorText;


  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  void _validatePhoneNumber() {
    final text = _phoneNumberController.text;
    if (text.length < 10 || text.length > 12) {
      setState(() {
        _errorText = 'Phone number must be between 10 and 12 digits';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }
  Future<void> _submitData() async {
    if (_purposeController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Purpose Of Entry"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_fullAddressController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Enter Visitor Full Name"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Enter Visitors Phone Number"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_dateController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Visit Date"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_timeController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Visitors Entry Time"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_expirydateController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Visitors Expiry Date"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_expirytimeController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Visitors Expiry Time"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    if (_entryController.text.isEmpty) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select Visitors Entry Type"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }
    setState(() {
      isUploading = true;
    });

    final uri = Uri.parse('${AppConstants.BASE_URL}/api/add-property-visitor');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] =
    "Bearer ${prefs.getString('TOKEN')}";

    request.fields['property_id'] = prefs.getString('Facility_Property_Id')!;
    request.fields['block_id'] = prefs.getString('Facility_Block_Id')!;
    request.fields['floor_id'] = prefs.getString('Facility_Floor_Id')!;
    request.fields['unit_id'] =prefs.getString('Facility_Unit_Id')!;
    request.fields['purpose_of_visit'] = _purposeController.text;
    request.fields['name'] = _fullAddressController.text;
    request.fields['mob_number'] = _phoneNumberController.text;
    request.fields['date'] = _dateController.text;
    request.fields['visit_time'] = _timeController.text;
    request.fields['visit_type'] = _visitorTypeController.text;
    request.fields['expired_date'] = _expirydateController.text;
    request.fields['entry_type'] = _entryController.text;
    request.fields['nric_passport_no'] = _idController.text;
    request.fields['vehicle_number'] = _vehicleController.text;
    request.fields['remark'] = _remarkController.text;
    request.fields['expired_time'] = _expirytimeController.text;
    request.fields['added_by'] = 'owner';


    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'id_image',
          _image!.path,
        ),
      );
    }
    print('Submitting data:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });
    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData); // Decode the JSON response

      if (response.statusCode == 200 && jsonResponse['status'] == 'success') {
        print('Uploaded successfully: $responseData');
        setState(() {
          isUploading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Visitor added successfully"),
              backgroundColor: Colors.green,
            ),
          );
          errorMessage = null; // Clear error message
        });
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = "${jsonResponse['message']}";
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
      print('Error uploading file: $e');
      setState(() {
        errorMessage = "Error uploading file: $e";
        isUploading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error uploading file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }


  Future<void> _selectDate(BuildContext context, TextEditingController controller, {DateTime? firstDate}) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = firstDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final time = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        controller.text = formattedTime; // Save time in 24-hour format
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Visitor',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const SizedBox(height: 20.0),
             const Text(
                'Purpose of Entry',
               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  //color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // Set border color here
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSecondContainerVisible = !isSecondContainerVisible;
                          });
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextField(
                            controller: _purposeController,
                            decoration: const InputDecoration(
                              hintText: 'Select Purpose of entry',
                              contentPadding: EdgeInsets.all(12.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSecondContainerVisible = !isSecondContainerVisible;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down), // Change the icon as needed
                    ),
                  ],
                ),
              ),
             const SizedBox(height: 5.0),
              Visibility(
                visible: isSecondContainerVisible,
                child: SizedBox(
                  width: 347.0, // Specify width here
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: options.length, // Adjust the count as needed
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0), // Adjust the spacing as needed
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _purposeController.text = options[index];
                                      isSecondContainerVisible = false;
                                    });
                                  },
                                  child: Text(
                                   options[index],
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 10.0),
           const   Text(
                'Full Name',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
             const  SizedBox(height: 6),
              TextField(
                controller: _fullAddressController,
                decoration: InputDecoration(
                  hintText: 'Enter Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
             const SizedBox(height: 16),
            const  Text(
                'Phone Number',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            const  SizedBox(height: 6),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  errorText: _errorText,
                ),
                onChanged: (text) {
                  _validatePhoneNumber();
                },
              ),
             const SizedBox(height: 16),
             const Text(
                'Visit Date',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
           const   SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  _selectDate(context,_dateController); // Open calendar when the icon is tapped
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Select Visit Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    readOnly: true, // Make the TextField read-only
                  ),
                ),
              ),
            const  SizedBox(height: 16),
              const Text(
                'Visit Time',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const   SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  _selectTime(context,_timeController); // Open calendar when the icon is tapped
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      hintText: 'Select Visit Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: const Icon(Icons.watch_later_rounded),
                    ),
                    readOnly: true, // Make the TextField read-only
                  ),
                ),
              ),
              const  SizedBox(height: 16),
              const Text(
                'Expiry Date',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const   SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  _selectDate(context,_expirydateController); // Open calendar when the icon is tapped
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _expirydateController,
                    decoration: InputDecoration(
                      hintText: 'Select Expiry Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    readOnly: true, // Make the TextField read-only
                  ),
                ),
              ),
              const  SizedBox(height: 16),
              const Text(
                'Expiry Time',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const   SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  _selectTime(context,_expirytimeController); // Open calendar when the icon is tapped
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _expirytimeController,
                    decoration: InputDecoration(
                      hintText: 'Select Expiry Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      suffixIcon: const Icon(Icons.watch_later_rounded),
                    ),
                    readOnly: true, // Make the TextField read-only
                  ),
                ),
              ),




              const  SizedBox(height: 16),
              const Text(
                'Visitor Type',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  //color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // Set border color here
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFifthContainerVisible = !isFifthContainerVisible;
                          });
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextField(
                            controller: _visitorTypeController,
                            decoration: const InputDecoration(
                              hintText: 'Select Visitor Type',
                              contentPadding: EdgeInsets.all(12.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFifthContainerVisible = !isFifthContainerVisible;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down), // Change the icon as needed
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Visibility(
                visible: isFifthContainerVisible,
                child: SizedBox(
                  width: 347.0, // Specify width here
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: visitorType.length, // Adjust the count as needed
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0), // Adjust the spacing as needed
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _visitorTypeController.text = visitorType[index];
                                      isFifthContainerVisible = false;
                                    });
                                  },
                                  child: Text(
                                    visitorType[index],
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              const  SizedBox(height: 16),

              const Text(
                'Entry',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  //color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // Set border color here
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSixthContainerVisible = !isSixthContainerVisible;
                          });
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextField(
                            controller: _entryController,
                            decoration: const InputDecoration(
                              hintText: 'Select Entry Type',
                              contentPadding: EdgeInsets.all(12.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSixthContainerVisible = !isSixthContainerVisible;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down), // Change the icon as needed
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Visibility(
                visible: isSixthContainerVisible,
                child: SizedBox(
                  width: 347.0, // Specify width here
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: entry.length, // Adjust the count as needed
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0), // Adjust the spacing as needed
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _entryController.text = entry[index];
                                      isSixthContainerVisible = false;
                                    });
                                  },
                                  child: Text(
                                    entry[index],
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const   Text(
                'NRIC/Passport No',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const  SizedBox(height: 6),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: 'Enter NRIC/Passport No',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Attach Image of ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                        border: Border.all(color:Color(0xFF3629B7)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_rounded, color: Color(0xFF3629B7)),
                            SizedBox(width: 8),
                            Text('Gallery', style: TextStyle()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.camera),
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF3629B7)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, color: Color(0xFF3629B7)),
                            SizedBox(width: 8),
                            Text('Camera', style: TextStyle()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_image != null)
                Container(
                  height: 100,
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.file(_image!),
                  ),
                ),
             const SizedBox(height: 16),
              const Text(
                'Vehicle Number',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _vehicleController,
                decoration: InputDecoration(
                  hintText: 'Enter Vehicle Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Remark',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _remarkController,
                decoration: InputDecoration(
                  hintText: 'Enter Remark',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isUploading ? null : _submitData,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF3629B7)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    const Size(double.infinity, 60), // Adjust the height here (e.g., from 50 to 60)
                  ),
                ),
                child: isUploading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ): Text('Submit', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}