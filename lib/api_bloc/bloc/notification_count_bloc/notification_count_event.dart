part of 'notification_count_bloc.dart';

sealed class NotificationCountEvent extends Equatable {
  const NotificationCountEvent();
  @override
  List<Object> get props => [];
}

class GetNotificationCountEvent extends NotificationCountEvent {
  GetNotificationCountEvent();
}
