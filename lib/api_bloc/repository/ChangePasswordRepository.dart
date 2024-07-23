import '../../model/changepassword_model.dart';
import '../provider/ChangePasswordApiProvider.dart';

class ChangePassWordApiRepository {
  final _provider = ChangePasswordapiProvider();

  Future<ChangePasswordModel> sendNewPassword(String sendNewPassword) {
    return _provider.PasswordData(sendNewPassword);
  }
}

class NetworkError extends Error {}
