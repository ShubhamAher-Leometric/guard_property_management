import '../../model/termsandconditionsmodel.dart';
import '../provider/termsandconditionsApiProvider.dart';

class TermsAndConditionsRepository {
  final _provider = TermsAndConditionsApiProvider();
  Future<TermsAndConditionsModel> termsAndConditionData() {
    return _provider.termsandConditions();
  }
}

class NetworkError extends Error {}