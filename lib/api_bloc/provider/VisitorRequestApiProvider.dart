import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../../model/VisitorPequestModel.dart';
import '../network_checker.dart';


class VisitorRequestApiProvider {
  final Dio _dio = Dio();

  Future<VistorListingModel> visitorListData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var property_id =await prefs.getString('Guard_property_id');
      var selected_tab =await prefs.getString('selected_tab');
      var visitor_filtor =await prefs.getString('visitor_filter');

      print("Visitor list Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-property-visitors-listing-by-guard?request_type=$selected_tab&property_id=$property_id&date_filter=$visitor_filtor';

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
      print("Visitor List Response");
      print(response);
      if (response.data['status'] == 'success') {
        return VistorListingModel.fromJson(response.data);
      } else {
        return VistorListingModel.withError(response.data['message'].toString());
      }
    } else {
      return VistorListingModel.withError("No Internet Connection");
    }

  }
}
