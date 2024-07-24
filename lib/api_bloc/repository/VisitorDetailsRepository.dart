import '../../model/visitordetailsmodel.dart';
import '../provider/visitordetailsApiProvider.dart';

class VisitorDetailsRepository {
  final _provider = VisitorDetailsApiProvider();
  Future<VisitorDetailsModel> visitorData() {
    return _provider.visitorData();
  }
}

class NetworkError extends Error {}