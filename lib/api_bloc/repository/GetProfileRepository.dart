import '../../model/getprofilemodel.dart';
import '../provider/getprofileApiProvider.dart';

class GetProfileRepository {
  final _provider = GetProfileApiProvider();
  Future<GetProfileModel> profileData() {
    return _provider.profileData();
  }
}

class NetworkError extends Error {}
