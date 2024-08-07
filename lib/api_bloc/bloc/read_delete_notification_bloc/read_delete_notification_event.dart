part of 'read_delete_notification_bloc.dart';

sealed class ReadDeleteNotificationEvent extends Equatable {
  const ReadDeleteNotificationEvent();
  @override
  List<Object> get props => [];
}
class SubmitReadDeleteNotificationData extends ReadDeleteNotificationEvent {
  final String ReadDeleteData;
  SubmitReadDeleteNotificationData(this.ReadDeleteData);
}
