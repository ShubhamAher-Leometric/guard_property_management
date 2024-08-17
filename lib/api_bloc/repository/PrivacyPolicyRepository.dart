import '../../model/privacypolicymodel.dart';
import '../provider/privacypolicyApiProvider.dart';

class PrivacyPolicyrepository {
  final _provider = PrivacyPolicyApiProvider();
  Future<PrivacyPolicyModel> privacyPolicyData() {
    return _provider.privacypolicydata();
  }
}

class NetworkError extends Error {}
