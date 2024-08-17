import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/termsandconditionsmodel.dart';
import '../network_checker.dart';


class TermsAndConditionsApiProvider {
  final Dio _dio = Dio();

  Future<TermsAndConditionsModel> termsandConditions() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');

      print("Terms And Conditions Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-terms-and-condtions';

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
      print("Terms And Conditions Response");
      print(response);
      if (response.data['status'] == 'success') {
        return TermsAndConditionsModel.fromJson(response.data);
      } else {
        return TermsAndConditionsModel.withError(response.data['message'].toString());
      }
    } else {
      return TermsAndConditionsModel.withError("No Internet Connection");
    }

  }
}
