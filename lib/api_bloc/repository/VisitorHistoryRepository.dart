import 'package:guard_property_management/model/visitor_history_model.dart';
import '../provider/visitorhistoryApiProvider.dart';

class VisitorHistoryRepository {
  final _provider = VisitorHistoryApiProvider();
  Future<VisitorHistoryModel> visitorListingData() {
    return _provider.visitorListData();
  }
}

class NetworkError extends Error {}