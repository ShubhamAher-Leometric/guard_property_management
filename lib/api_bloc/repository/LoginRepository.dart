import '../../model/LoginModel.dart';
import '../provider/LoginApiProvider.dart';

class LoginApiRepository {
  final _provider = LoginApiProvider();

  Future<LoginModel> sendLoginOtp(String sendLoginOtpData) {
    return _provider.LoginData(sendLoginOtpData);
  }
}

class NetworkError extends Error {}
