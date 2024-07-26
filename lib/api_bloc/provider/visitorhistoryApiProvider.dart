import 'package:dio/dio.dart';
import 'package:guard_property_management/model/visitor_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../network_checker.dart';


class VisitorHistoryApiProvider {
  final Dio _dio = Dio();

  Future<VisitorHistoryModel> visitorListData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var user_id = await prefs.getString('Login_user_id');
      var property_id =await prefs.getString('Guard_property_id');
      var selected_tab =await prefs.getString('selected_tab');
      var visitor_filtor =await prefs.getString('visitor_filter');

      print("Visitor History Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-property-visitors-history-by-guard?request_type=$selected_tab&property_id=$property_id&date_filter=$visitor_filtor&guard_id=$user_id';

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
      print("Visitor History Response");
      print(response);
      if (response.data['status'] == 'success') {
        return VisitorHistoryModel.fromJson(response.data);
      } else {
        return VisitorHistoryModel.withError(response.data['message'].toString());
      }
    } else {
      return VisitorHistoryModel.withError("No Internet Connection");
    }

  }
}
