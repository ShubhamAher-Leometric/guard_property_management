import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../model/resendotpmodel.dart';
import '../network_checker.dart';

class RegResendOtpApiProvider {
  final Dio _dio = Dio();

  Future<RegResendOtpModel>OtpData(String sendRegOtpData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      print("Resend Otp Request");
      print(sendRegOtpData);
      final String _url = AppConstants.BASE_URL + '/api/guard-resend-otp';
      Response response = await _dio.post(
        _url,
        options: Options(
            headers: {'Content-type': 'application/json', "Accept": "application/json",
            },
            validateStatus: (statusCode) {
              return true;
            }),
        data: sendRegOtpData,
      );
      print("Resend OTP Response");
      print(response);
      if (response.data['status'] == 'success') {
        return RegResendOtpModel.fromJson(response.data);
      } else {
        return RegResendOtpModel.withError(response.data['message'].toString());
      }
    } else {
      return RegResendOtpModel.withError("No Internet Connection");
    }
  }
}
