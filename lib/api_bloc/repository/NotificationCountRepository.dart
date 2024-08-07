import '../../model/notification_count.dart';
import '../provider/notificationcountApiProvider.dart';

class GetNotificationCountRepository {
  final _provider = NotificationCountApiProvider();
  Future<NotificationCountModel> notificationcountData() {
    return _provider.countData();
  }
}

class NetworkError extends Error {}
