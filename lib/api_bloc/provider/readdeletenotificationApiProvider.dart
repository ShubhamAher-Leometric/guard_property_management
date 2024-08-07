import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/readnotificationmodel.dart';
import '../network_checker.dart';

class ReadDeleteNotificationApiProvider {
  final Dio _dio = Dio();

  Future<ReadDeleteNotificationModel>readData(String sendreadData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');

      print("Submit Read or delete Request");
      print(sendreadData);
      final String _url = AppConstants.BASE_URL + '/api/update-notification-status';
      Response response = await _dio.post(
        _url,
        options: Options(
            headers: {'Content-type': 'application/json',
              "Authorization": "Bearer " + token!
            },
            validateStatus: (statusCode) {
              return true;
            }),
        data: sendreadData,
      );
      print("Read delete notification Response");
      print(response);
      if (response.data['status'] == 'success') {
        return ReadDeleteNotificationModel.fromJson(response.data);
      } else {
        return ReadDeleteNotificationModel.withError(response.data['message'].toString());
      }
    } else {
      return ReadDeleteNotificationModel.withError("No Internet Connection");
    }
  }
}
