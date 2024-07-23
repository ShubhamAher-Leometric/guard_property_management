import '../../model/submitotpmodel.dart';
import '../provider/SubmitForgetOtpApiProvider.dart';

class SubmitForgetOtpApiRepository {
  final _provider = SubmitForgetOtpApiProvider();

  Future<SubmitOtpModel> sendForgetOtp(String sendForgetOtpData) {
    return _provider.OtpData(sendForgetOtpData);
  }
}

class NetworkError extends Error {}
