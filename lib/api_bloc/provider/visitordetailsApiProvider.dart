import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../../model/visitordetailsmodel.dart';
import '../network_checker.dart';


class VisitorDetailsApiProvider {
  final Dio _dio = Dio();

  Future<VisitorDetailsModel> visitorData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var visitor_id =await prefs.getString('visitor_id');


      print("Getting Visitor Data Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-visit-details?visit_id=$visitor_id';

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
      print("Visitor Data Response");
      print(response);
      if (response.data['status'] == 'success') {
        return VisitorDetailsModel.fromJson(response.data);
      } else {
        return VisitorDetailsModel.withError(response.data['message'].toString());
      }
    } else {
      return VisitorDetailsModel.withError("No Internet Connection");
    }

  }
}
