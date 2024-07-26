import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart' show FormData;
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:property_management/Models/defectlist.dart';
// import 'package:property_management/Models/property_list.dart';
// import 'package:property_management/Models/propertydetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:property_management/Models/defectlist.dart' as defectlist;




  class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = "https://prop-management.medks-sz.com";
  late final String userId;
  late final String accessToken;
  late final Future<void> _initialization;

  AuthService() {
    _initialization = _loadCredentials();
  }





  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('Login_user_id');
    String? storedAccessToken = prefs.getString('TOKEN');

    if (storedUserId == null || storedAccessToken == null) {
      throw Exception('Credentials not found in SharedPreferences');
    }

    userId = storedUserId;
    accessToken = storedAccessToken;
  }

  Future<void> ensureCredentialsLoaded() async {
    await _initialization;
  }

  // Future<DefectList> fetchDefects(int propertyId, int blockId, int floorId, int unitId) async {
  //   await ensureCredentialsLoaded(); // Ensure credentials are loaded
  //
  //
  //
  //
  //
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/get-defect-list?property_id=$propertyId&block_id=$blockId&floor_id=$floorId&unit_id=$unitId'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );
  //
  //
  //
  //   print(response);
  //   print(propertyId);
  //   print(blockId);
  //   print(floorId);
  //
  //
  //
  //   if (response.statusCode == 200) {
  //     return DefectList.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load defects');
  //   }
  // }

  Future<void> createDefett(
      int property_id,
      int block_id,
      int floor_id,
      int unit_id,
      String title,
      String description,
      // File imageFile,
      ) async {
    final url = Uri.parse('$baseUrl/api/add-defect');

    final request = http.MultipartRequest('POST', url);
    request.fields['property_id'] = property_id.toString();
    request.fields['block_id'] = block_id.toString();
    request.fields['floor_id'] = floor_id.toString();
    request.fields['unit_id'] = unit_id.toString();
    request.fields['title'] = title;
    request.fields['description'] = description;
    // final imageStream = http.ByteStream(imageFile.openRead());
    // final imageLength = await imageFile.length();
    // final multipartFile = http.MultipartFile('defect_file[]', imageStream, imageLength, filename: 'property_image.jpg');

    // request.files.add(multipartFile);

    print(request);
    print(request.toString());
    print("property $property_id");
    print("block $block_id");
    print("floor $floor_id");
    print("unit $unit_id");


    print("request $request");

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Property-Defect created successfully');
        print(response.toString());

        print(response.statusCode);
        print(response.request);


        print('Property-Defect fetched successfully');
        print(response.toString());
        print('Status Code: ${response.statusCode}');


      } else {
        print('Failed to create property - defect. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> addFeedback({
    required String imagePath,
    required String feedbackText,
    required BuildContext context, // Add BuildContext parameter
  }) async {
    await _initialization;


    FormData data = FormData.fromMap({
      'files': [
        await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      ],
      'user_id': userId,
      'feedback_text': feedbackText,
    });

    try {
      var response = await _dio.post(
        '$baseUrl/api/add-feedback',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feedback submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print(response.statusMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  //
  // Future<List<defectlist.DefectData>> fetchDefectList({
  //   required int propertyId,
  //   required int blockId,
  //   required int floorId,
  //   required int unitId,
  // }) async {
  //   await _initialization;
  //
  //   final response = await _dio.get(
  //     '$baseUrl/api/get-defect-list',
  //     queryParameters: {
  //       'property_id': propertyId,
  //       'block_id': blockId,
  //       'floor_id': floorId,
  //       'unit_id': unitId,
  //     },
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return defectlist.DefectList.fromJson(response.data).data;
  //   } else {
  //     throw Exception('Failed to load defect list: ${response.statusCode}');
  //   }
  // }


  //Future<List<defectlist.DefectData>> fetchDefectList({
  //   required int propertyId,
  //   required int blockId,
  //   required int floorId,
  //   required int unitId,
  // }) async {
  //   await _initialization;
  //
  //   final response = await _dio.get(
  //     '$baseUrl/api/get-defect-list',
  //     queryParameters: {
  //       'property_id': propertyId,
  //       'block_id': blockId,
  //       'floor_id': floorId,
  //       'unit_id': unitId,
  //     },
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // Print IDs
  //     print('Property ID: $propertyId');
  //     print('Block ID: $blockId');
  //     print('Floor ID: $floorId');
  //     print('Unit ID: $unitId');
  //
  //     // Store IDs locally
  //     await _storeIDsLocally(propertyId, blockId, floorId, unitId);
  //
  //     return defectlist.DefectList.fromJson(response.data).data;
  //   } else {
  //     throw Exception('Failed to load defect list: ${response.statusCode}');
  //   }
  // }
  //
  // Future<void> _storeIDsLocally(int propertyId, int blockId, int floorId, int unitId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('property_id', propertyId);
  //   prefs.setInt('block_id', blockId);
  //   prefs.setInt('floor_id', floorId);
  //   prefs.setInt('unit_id', unitId);
  // }






  // Future<PropertyData> fetchPropertyDetails(int propertyId) async {
  //   await _initialization;
  //   final response = await _dio.get(
  //     '$baseUrl/api/get-property-details',
  //     queryParameters: {
  //       'property_id': propertyId,
  //       'user_id': userId,
  //     },
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return Propertydetails.fromJson(response.data).data;
  //   } else {
  //     throw Exception('Failed to load property details: ${response.statusCode}');
  //   }
  // }





  Future<void> createProperties(
      int property_id,
      int block_id,
      int floor_id,
      int unit_id,
      String title,
      String description,
      File imageFile,
      ) async {
    final url = Uri.parse('https://your-api.com/properties');

    final request = http.MultipartRequest('POST', url);
    request.fields['property_id'] = property_id.toString();
    request.fields['block_id'] = block_id.toString();
    request.fields['floor_id'] = floor_id.toString();
    request.fields['unit_id'] = unit_id.toString();
    request.fields['title'] = title;
    request.fields['description'] = description;
    final imageStream = http.ByteStream(imageFile.openRead());
    final imageLength = await imageFile.length();
    final multipartFile = http.MultipartFile('image', imageStream, imageLength, filename: 'property_image.jpg');

    request.files.add(multipartFile);

    try {
      final response = await request.send();

      print(request);
      print(request.toString());



      if (response.statusCode == 200) {
        // Request was successful
        print('Property created successfully');
        print(response.statusCode);

      } else {
        // Request failed

        print('Failed to create property. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred during the request
      print('Error: $e');
    }
  }





  // Future<List<Data>> fetchUserProperties() async {
  //   await _initialization;
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/get-user-property-list?user_id=$userId'),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     return PropertyList.fromJson(jsonData).data;
  //   } else {
  //     throw Exception('Failed to load properties: ${response.statusCode}');
  //   }
  // }




  Future<Map<String, dynamic>> addDefect({
    required List<String> filePaths,
    required String propertyId,
    required String blockId,
    required String floorId,
    required String unitId,
    required String title,
    required String description,
    required String defectFilePath,
  }) async {
    await _initialization;

    try {
      FormData formData = FormData();


      for (var filePath in filePaths) {
        if (FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
          String fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              'defect_file',
              await MultipartFile.fromFile(
                filePath,
                filename: fileName,
              ),
            ),
          );
        } else {
          print("File at path $filePath does not exist. Skipping...");
          continue;
        }
      }

      formData.fields.addAll([
        MapEntry('property_id', propertyId),
        MapEntry('block_id', blockId),
        MapEntry('floor_id', floorId),
        MapEntry('unit_id', unitId),
        MapEntry('title', title),
        MapEntry('description', description),
      ]);

      final response = await _dio.post(
        '$baseUrl/api/add-defect',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {'status': 'success'};
    }
  }














  Future<void> assignPropertyToOwner(
      int propertyId,
      int blockId,
      int floorId,
      int unitId,
      String propertyAddress,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedAccessToken = prefs.getString('api_access_token');

        // due to this i am getting error its throwing execption

      final response = await http.post(
        Uri.parse('https://prop-management.medks-sz.com/api/assign-property-to-owner'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$storedAccessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'property_id': propertyId,
          'block_id': blockId,
          'floor_id': floorId,
          'unit_id': unitId,
          'property_address': propertyAddress,
        }),
      );

      print(jsonEncode);
      print(jsonEncode);
      print(jsonEncode);
      print(jsonEncode);

      if (response.statusCode == 200) {
        print(response.body);
        print("Property assigned successfully");
      } else {
        print(response.statusCode);
        print("Failed to assign property to owner. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error assigning property to owner: $e");
      throw Exception('Failed to assign property to owner');
    }
  }



  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String mobileNumber,
  }) async {
    var formData = FormData.fromMap({
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'name': name,
      'mobile_number': mobileNumber,
    });
    try {
      var response = await _dio.post(
        'https://prop-management.medks-sz.com/api/registration',
        data: formData,
      );
      print('formData***  $formData');
      print('response***  $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check the type of response data
        if (response.data is String) {

          return json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          print('response here');
          return response.data;
        } else {

          return {'error': 'Unexpected response data type'};
        }
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      developer.log('Exception*** $e', name: 'my.app.error');

      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }




  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required int user_id,
    required String type,

  }) async {
    var formData = FormData.fromMap({
      'otp': otp,
      'user_id': user_id,
      'type': type,

    });

    try {
      var response = await _dio.post(

        'https://prop-management.medks-sz.com/api/verify-otp',
        data: formData,
      );
      print('formData***  $formData');
      print('response***  $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check the type of response data
        if (response.data is String) {


          return json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          // If it's already a Map, return it directly
          print('response here');
          return response.data;
        } else {

          return {'error': 'Unexpected response data type'};
        }
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      developer.log('Exception*** $e', name: 'my.app.error');

      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }




  Future<Map<String, dynamic>> resendCode({

    required int user_id,
    required String type,

  }) async {
    var formData = FormData.fromMap({
      'user_id': user_id,
      'type': type,

    });

    try {
      var response = await _dio.post(

        'https://prop-management.medks-sz.com/api/resend-otp',
        data: formData,
      );
      print('formData***  $formData');
      print('response***  $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {

          return json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {

          print('response here');
          return response.data;
        } else {

          return {'error': 'Unexpected response data type'};
        }
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      developer.log('Exception*** $e', name: 'my.app.error');

      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }





  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    var formData = FormData.fromMap({
      'email': email,
      'password': password,
    });

    try {
      var response = await _dio.post(
        'https://prop-management.medks-sz.com/api/login',
        data: formData,
      );
      print('formData***  $formData');
      print('response***  $response');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData;


        if (response.data is String) {

          responseData = json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          responseData = response.data;
        } else {
          return {'error': 'Unexpected response data type'};
        }

        if (responseData['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('api_access_token', responseData['api_access_token']);
          await prefs.setString('user_id', responseData['data']['id'].toString());
          await prefs.setString('user_name', responseData['data']['name']);
          await prefs.setString('user_email', responseData['data']['email']);
          await prefs.setString('user_mobile_number', responseData['data']['mobile_number']);

          print('user_id: ${responseData['data']['id']}');
          print('user_id: ${responseData['data']['name']}');
        }

        return responseData;
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      developer.log('Exception*** $e', name: 'my.app.error');
      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }





  Future<Map<String, dynamic>> forget({
    required String email,
  }) async {
    try {
      var formData = FormData.fromMap({
        'email': email,
      });

      var response = await _dio.post(
        'https://prop-management.medks-sz.com/api/forgot-password-otp',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {
          return json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          return {'error': 'Unexpected response data type'};
        }
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }







  Future<Map<String, dynamic>> verifyForgetOtp({
    required String otp,
    required int userId,
    required String type,
  }) async {
    final dio.Dio dioInstance = dio.Dio(); // Create a Dio instance
    final dio.FormData formData = dio.FormData.fromMap(
        {
          'otp': otp,
          'user_id': userId,
          'type': type,
        });
    print('otp***,$otp');
    try {
      final response = await dioInstance.post(
        'https://prop-management.medks-sz.com/api/verify-otp',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is String) {
          return json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          return {'error': 'Unexpected response data type'};
        }
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      print('Error connecting to server: $e');
      return {'error': 'Failed to connect to the server.'};
    }
  }







  Future<Map<String, dynamic>> changePassword({
    required String newPassword,
    required String confirmPassword,
    required String userId,
  }) async {
    try {
      final String apiUrl = 'https://prop-management.medks-sz.com/api/reset-password';

      Response response = await _dio.post(
        apiUrl,
        data: {
          'new_password': newPassword,
          'confirm_password': confirmPassword,
          'user_id': userId,
        },
      );


      return response.data;
    } catch (e) {

      if (e is DioError) {

        if (e.response?.statusCode == 429) {

          print('Too many requests error: ${e.message}');
          return {'error': 'Too many requests. Please try again later.'};
        } else {

          print('Error connecting to server: $e');
          return {'error': 'Failed to connect to the server.'};
        }
      } else {

        print('Error: $e');
        return {'error': 'An unexpected error occurred.'};
      }
    }
  }
}







//
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'dart:developer' as developer;
// import 'package:dio/dio.dart' show FormData;
// import 'package:dio/dio.dart' as dio;
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:property_management/Models/property_list.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   final Dio _dio = Dio();
//   final String baseUrl = "https://prop-management.medks-sz.com";
//   late final String userId;
//   late final String accessToken;
//   late final Future<void> _initialization;
//
//   AuthService() {
//     _initialization = _loadCredentials();
//   }
//
//   Future<void> _loadCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedUserId = prefs.getString('user_id');
//     String? storedAccessToken = prefs.getString('api_access_token');
//
//     if (storedUserId == null || storedAccessToken == null) {
//       throw Exception('Credentials not found in SharedPreferences');
//     }
//
//     userId = storedUserId;
//     accessToken = storedAccessToken;
//   }
//
//   Future<void> clearCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user_id');
//     await prefs.remove('api_access_token');
//   }
//
//   Future<void> assignPropertyToOwner(int propertyId,
//       int blockId,
//       int floorId,
//       int unitId,
//       String propertyAddress,) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? storedAccessToken = prefs.getString('api_access_token');
//
//       final response = await http.post(
//         Uri.parse(
//             'https://prop-management.medks-sz.com/api/assign-property-to-owner'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization': '$storedAccessToken',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'user_id': userId,
//           'property_id': propertyId,
//           'block_id': blockId,
//           'floor_id': floorId,
//           'unit_id': unitId,
//           'property_address': propertyAddress,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         print(response.body);
//         print("Property assigned successfully");
//       } else {
//         print(response.statusCode);
//         print("Failed to assign property to owner. Status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (e) {
//       print("Error assigning property to owner: $e");
//       throw Exception('Failed to assign property to owner');
//     }
//   }
//
//
//   Future<List<Data>> fetchUserProperties() async {
//     await _initialization;
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/get-user-property-list?user_id=$userId'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       return PropertyList.fromJson(jsonData).data;
//     } else {
//       throw Exception('Failed to load properties: ${response.statusCode}');
//     }
//   }
//
//
//
//
//   Future<void> logout() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('api_access_token');
//       await prefs.remove('user_id');
//       // Remove other user details as needed
//     } catch (e) {
//       print('Error during logout: $e');
//       throw Exception('Failed to logout');
//     }
//   }
//
//
//   Future<Map<String, dynamic>> sendFeedback({
//     required String filePath,
//     required String propertyId,
//     required String blockId,
//     required String floorId,
//     required String unitId,
//     required String feedbackText,
//   }) async {
//     await _initialization;
//
//     try {
//       var headers = {
//         'Authorization': 'Bearer $accessToken',
//       };
//
//       var data = FormData.fromMap({
//         'files': [
//           await MultipartFile.fromFile(filePath, filename: filePath
//               .split('/')
//               .last),
//         ],
//         'user_id': userId,
//         'property_id': propertyId,
//         'block_id': blockId,
//         'floor_id': floorId,
//         'unit_id': unitId,
//         'feedback_text': feedbackText,
//       });
//
//       var response = await _dio.request(
//         '$baseUrl/api/add-feedback',
//         options: Options(
//           method: 'POST',
//           headers: headers,
//         ),
//         data: data,
//       );
//
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         return {
//           'status': 'error',
//           'message': response.statusMessage,
//         };
//       }
//     } catch (e) {
//       return {
//         'status': 'error',
//         'message': e.toString(),
//       };
//     }
//   }
//
//
//   void main() async {
//     AuthService authService = AuthService();
//
//     try {
//       await authService.assignPropertyToOwner(
//         21,
//         64,
//         100,
//         131,
//         '123 Main Street',
//       );
//     } catch (e) {
//       print(e);
//     }
//
//     var response = await authService.sendFeedback(
//       filePath: '/C:/Users/Compumatrix/Pictures/Screenshots/Screenshot (8).png',
//       propertyId: '21',
//       blockId: '64',
//       floorId: '100',
//       unitId: '131',
//       feedbackText: 'wrtyhtrredabhh',
//     );
//     if (response['status'] == 'success') {
//       print(json.encode(response));
//     } else {
//       print(response['message']);
//     }
//   }
//
//
//   Future<Map<String, dynamic>> register({
//     required String email,
//     required String password,
//     required String confirmPassword,
//     required String name,
//     required String mobileNumber,
//   }) async {
//     var formData = FormData.fromMap({
//       'email': email,
//       'password': password,
//       'confirm_password': confirmPassword,
//       'name': name,
//       'mobile_number': mobileNumber,
//     });
//     try {
//       var response = await _dio.post(
//         'https://prop-management.medks-sz.com/api/registration',
//         data: formData,
//       );
//       print('formData***  $formData');
//       print('response***  $response');
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Check the type of response data
//         if (response.data is String) {
//           return json.decode(response.data);
//         } else if (response.data is Map<String, dynamic>) {
//           print('response here');
//           return response.data;
//         } else {
//           return {'error': 'Unexpected response data type'};
//         }
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       developer.log('Exception*** $e', name: 'my.app.error');
//
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> verifyOtp({
//     required String otp,
//     required int user_id,
//     required String type,
//
//   }) async {
//     var formData = FormData.fromMap({
//       'otp': otp,
//       'user_id': user_id,
//       'type': type,
//
//     });
//
//     try {
//       var response = await _dio.post(
//
//         'https://prop-management.medks-sz.com/api/verify-otp',
//         data: formData,
//       );
//       print('formData***  $formData');
//       print('response***  $response');
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Check the type of response data
//         if (response.data is String) {
//           // If it's a String, decode it
//
//           return json.decode(response.data);
//         } else if (response.data is Map<String, dynamic>) {
//           // If it's already a Map, return it directly
//           print('response here');
//           return response.data;
//         } else {
//           // Handle other data types if necessary
//           return {'error': 'Unexpected response data type'};
//         }
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       developer.log('Exception*** $e', name: 'my.app.error');
//
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> resendCode({
//
//     required int user_id,
//     required String type,
//
//   }) async {
//     var formData = FormData.fromMap({
//       'user_id': user_id,
//       'type': type,
//
//     });
//
//     try {
//       var response = await _dio.post(
//
//         'https://prop-management.medks-sz.com/api/resend-otp',
//         data: formData,
//       );
//       print('formData***  $formData');
//       print('response***  $response');
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Check the type of response data
//         if (response.data is String) {
//           // If it's a String, decode it
//
//           return json.decode(response.data);
//         } else if (response.data is Map<String, dynamic>) {
//           // If it's already a Map, return it directly
//           print('response here');
//           return response.data;
//         } else {
//           // Handle other data types if necessary
//           return {'error': 'Unexpected response data type'};
//         }
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       developer.log('Exception*** $e', name: 'my.app.error');
//
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       var response = await _dio.post(
//         'https://prop-management.medks-sz.com/api/login',
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Map<String, dynamic> responseData = response.data;
//         if (responseData['status'] == 'success') {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString(
//               'api_access_token', responseData['api_access_token']);
//           await prefs.setString(
//               'user_id', responseData['data']['id'].toString());
//           // Save other user details as needed
//         }
//         return responseData;
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> forget({
//     required String email,
//   }) async {
//     try {
//       var formData = FormData.fromMap({
//         'email': email,
//       });
//
//       var response = await _dio.post(
//         'https://prop-management.medks-sz.com/api/forgot-password-otp',
//         data: formData,
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (response.data is String) {
//           return json.decode(response.data);
//         } else if (response.data is Map<String, dynamic>) {
//           return response.data;
//         } else {
//           return {'error': 'Unexpected response data type'};
//         }
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> verifyForgetOtp({
//     required String otp,
//     required int userId,
//     required String type,
//   }) async {
//     final dio.Dio dioInstance = dio.Dio(); // Create a Dio instance
//     final dio.FormData formData = dio.FormData.fromMap(
//         { // Specify FormData class from dio package
//
//           'otp': otp,
//           'user_id': userId,
//           'type': type,
//         });
//     print('otp***,$otp');
//     try {
//       final response = await dioInstance.post(
//         'https://prop-management.medks-sz.com/api/verify-otp',
//         data: formData,
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (response.data is String) {
//           return json.decode(response.data);
//         } else if (response.data is Map<String, dynamic>) {
//           return response.data;
//         } else {
//           return {'error': 'Unexpected response data type'};
//         }
//       } else {
//         return {'error': response.statusMessage};
//       }
//     } catch (e) {
//       print('Error connecting to server: $e');
//       return {'error': 'Failed to connect to the server.'};
//     }
//   }
//
//
//   Future<Map<String, dynamic>> changePassword({
//     required String newPassword,
//     required String confirmPassword,
//     required String userId,
//   }) async {
//     try {
//       // Define your API endpoint URL
//       final String apiUrl = 'https://prop-management.medks-sz.com/api/reset-password'; // Replace with your actual API endpoint URL
//
//       // Make the API request to change the password
//       Response response = await _dio.post(
//         apiUrl,
//         data: {
//           'new_password': newPassword,
//           'confirm_password': confirmPassword,
//           'user_id': userId,
//         },
//       );
//
//       return response.data;
//     } catch (e) {
//      if (e is DioError) {
//         if (e.response?.statusCode == 429) {
//           print('Too many requests error: ${e.message}');
//           return {'error': 'Too many requests. Please try again later.'};
//         } else {
//           // Handle other DioError exceptions
//           print('Error connecting to server: $e');
//           return {'error': 'Failed to connect to the server.'};
//         }
//       } else {
//         print('Error: $e');
//         return {'error': 'An unexpected error occurred.'};
//       }
//     }
//   }
// }
//















