import '../../model/notificationlistmodel.dart';
import '../provider/notificationlistApiProvider.dart';

class NotificationListRepository {
  final _provider = NotificationListapiProvider();
  Future<NotificationListModel> notificationData() {
    return _provider.notificationListData();
  }
}

class NetworkError extends Error {}
