import '../../model/resendotpmodel.dart';
import '../provider/RegResendOtpApiProvider.dart';

class RegResendOtpApiRepository {
  final _provider = RegResendOtpApiProvider();

  Future<RegResendOtpModel> sendRegOtp(String sendRegOtpData) {
    return _provider.OtpData(sendRegOtpData);
  }
}

class NetworkError extends Error {}
