import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/notification_count.dart';
import '../network_checker.dart';


class NotificationCountApiProvider {
  final Dio _dio = Dio();

  Future<NotificationCountModel> countData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var user_id =await prefs.getString('Login_user_id');
      print("Product Details Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-guard-notification-count?guard_id=$user_id';

      Response response = await _dio.get(
        _url,
        options: Options(
          headers: {'Content-type': 'application/json',
            "Authorization": "Bearer " + token!

          },
          validateStatus: (status) {
            return true;
          },
        ),
      );
      print("Product Details Response");
      print(response);
      if (response.data['status'] == 'success') {
        return NotificationCountModel.fromJson(response.data);
      } else {
        return NotificationCountModel.withError(response.data['message'].toString());
      }
    } else {
      return NotificationCountModel.withError("No Internet Connection");
    }

  }
}
