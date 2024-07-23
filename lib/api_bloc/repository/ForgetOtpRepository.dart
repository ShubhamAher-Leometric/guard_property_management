

import '../../model/forgetotpmodel.dart';
import '../provider/ForgetOtpApiProvider.dart';

class ForgetOtpApiRepository {
  final _provider = ForgetOtpApiProvider();

  Future<ForgotOtpModel> sendForgetOtp(String sendForgetOtpData) {
    return _provider.OtpData(sendForgetOtpData);
  }
}

class NetworkError extends Error {}
