import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../../model/getprofilemodel.dart';
import '../network_checker.dart';


class GetProfileApiProvider {
  final Dio _dio = Dio();

  Future<GetProfileModel> profileData() async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      final prefs = await SharedPreferences.getInstance();
      var token = await prefs.getString('TOKEN');
      var user_id =await prefs.getString('Login_user_id');
      print("Profile Details Request");
      final String _url = '${AppConstants.BASE_URL}/api/get-guard-profile-details?guard_id=$user_id';

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
      print("Profile Details Response");
      print(response);
      if (response.data['status'] == 'success') {
        return GetProfileModel.fromJson(response.data);
      } else {
        return GetProfileModel.withError(response.data['message'].toString());
      }
    } else {
      return GetProfileModel.withError("No Internet Connection");
    }

  }
}
