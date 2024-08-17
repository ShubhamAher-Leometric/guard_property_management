import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/privacypolicymodel.dart';
import '../network_checker.dart';


class PrivacyPolicyApiProvider {
  final Dio _dio = Dio();

  Future<PrivacyPolicyModel> privacypolicydata() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');

      print("Privacy Policy Details Request");
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
      print("Privacy Policy Details Response");
      print(response);
      if (response.data['status'] == 'success') {
        return PrivacyPolicyModel.fromJson(response.data);
      } else {
        return PrivacyPolicyModel.withError(response.data['message'].toString());
      }
    } else {
      return PrivacyPolicyModel.withError("No Internet Connection");
    }

  }
}
