import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../model/forgetotpmodel.dart';
import '../network_checker.dart';

class ForgetOtpApiProvider {
  final Dio _dio = Dio();

  Future<ForgotOtpModel>OtpData(String sendForgetOtpData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      print("Send Otp Request");
      print(sendForgetOtpData);
      final String _url = AppConstants.BASE_URL + '/api/guard-forgot-password-otp';
      Response response = await _dio.post(
        _url,
        options: Options(
            headers: {'Content-type': 'application/json', "Accept": "application/json",
            },
            validateStatus: (statusCode) {
                return true;
            }),
        data: sendForgetOtpData,
      );
      print("Forgot OTP Response");
      print(response);
      if (response.data['status'] == 'success') {
        return ForgotOtpModel.fromJson(response.data);
      } else {
        return ForgotOtpModel.withError(response.data['message'].toString());
      }
    } else {
      return ForgotOtpModel.withError("No Internet Connection");
    }
  }
}
