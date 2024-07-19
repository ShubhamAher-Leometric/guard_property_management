import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../model/LoginModel.dart';
import '../network_checker.dart';

class LoginApiProvider {
  final Dio _dio = Dio();

  Future<LoginModel> LoginData(String sendLoginOtpData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      print("Send Login Request");
      print(sendLoginOtpData);
      final String _url = AppConstants.BASE_URL + '/api/guard-login';
      Response response = await _dio.post(
        _url,
        options: Options(
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          },
          validateStatus: (statusCode) {
            return true;
          },
        ),
        data: sendLoginOtpData,
      );
      print("Login Response");
      print(response);
      if (response.data['status'] == 'success') {
        return LoginModel.fromJson(response.data);
      } else {
        return LoginModel.withError(response.data['message'].toString());
      }
    } else {
      return LoginModel.withError("No Internet Connection");
    }
  }
}
