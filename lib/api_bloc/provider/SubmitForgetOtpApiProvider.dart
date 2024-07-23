import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../model/submitotpmodel.dart';
import '../network_checker.dart';

class SubmitForgetOtpApiProvider {
  final Dio _dio = Dio();

  Future<SubmitOtpModel>OtpData(String sendForgetOtpData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      print("Submit Otp Request");
      print(sendForgetOtpData);
      final String _url = AppConstants.BASE_URL + '/api/guard-verify-otp';
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
        return SubmitOtpModel.fromJson(response.data);
      } else {
        return SubmitOtpModel.withError(response.data['message'].toString());
      }
    } else {
      return SubmitOtpModel.withError("No Internet Connection");
    }
  }
}
