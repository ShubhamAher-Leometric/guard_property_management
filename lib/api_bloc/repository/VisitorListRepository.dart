import 'package:guard_property_management/api_bloc/provider/VisitorRequestApiProvider.dart';
import '../../model/VisitorPequestModel.dart';

class VisitorListRepository {
  final _provider = VisitorRequestApiProvider();
  Future<VistorListingModel> visitorListingData() {
    return _provider.visitorListData();
  }
}

class NetworkError extends Error {}