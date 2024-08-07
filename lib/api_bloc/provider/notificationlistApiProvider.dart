import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/notificationlistmodel.dart';
import '../network_checker.dart';


class NotificationListapiProvider {
  final Dio _dio = Dio();

  Future<NotificationListModel> notificationListData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var user_id =await prefs.getString('Login_user_id');
      var datefilter =await prefs.getString('notification_filter');
      print(user_id);
      print(datefilter);

      print("Notification List Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-guard-notifications?guard_id=$user_id&date_filter=$datefilter';

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
      print("Notification List Response");
      print(response);
      if (response.data['status'] == 'success') {
        return NotificationListModel.fromJson(response.data);
      } else {
        return NotificationListModel.withError(response.data['message'].toString());
      }
    } else {
      return NotificationListModel.withError("No Internet Connection");
    }

  }
}
