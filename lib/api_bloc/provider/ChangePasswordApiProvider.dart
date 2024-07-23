import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../model/changepassword_model.dart';
import '../network_checker.dart';

class ChangePasswordapiProvider {
  final Dio _dio = Dio();

  Future<ChangePasswordModel>PasswordData(String sendNewPasswordData) async {
    bool isInternet = await NetworkHelper.isInternetIsOn();
    if (isInternet) {
      print("Submit Password Request");
      print(sendNewPasswordData);
      final String _url = AppConstants.BASE_URL + '/api/guard-reset-password';
      Response response = await _dio.post(
        _url,
        options: Options(
            headers: {'Content-type': 'application/json', "Accept": "application/json",
            },
            validateStatus: (statusCode) {
                return true;
            }),
        data: sendNewPasswordData,
      );
      print("change password Response");
      print(response);
      if (response.data['status'] == 'success') {
        return ChangePasswordModel.fromJson(response.data);
      } else {
        return ChangePasswordModel.withError(response.data['message'].toString());
      }
    } else {
      return ChangePasswordModel.withError("No Internet Connection");
    }
  }
}
