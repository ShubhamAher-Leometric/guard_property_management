part of 'notification_list_bloc.dart';

sealed class NotificationListEvent extends Equatable {
  const NotificationListEvent();
  @override
  List<Object> get props => [];
}

class GetNotificationListEvent extends NotificationListEvent {
  GetNotificationListEvent();
}