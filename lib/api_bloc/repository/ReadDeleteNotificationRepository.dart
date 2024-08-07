import '../../model/readnotificationmodel.dart';
import '../provider/readdeletenotificationApiProvider.dart';

class ReadDeleteNotificationRepository {
  final _provider = ReadDeleteNotificationApiProvider();

  Future<ReadDeleteNotificationModel> sendreadNotification(String sendReadDeleteData) {
    return _provider.readData(sendReadDeleteData);
  }
}

class NetworkError extends Error {}