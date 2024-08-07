part of 'notification_list_bloc.dart';

sealed class NotificationListState extends Equatable {
  const NotificationListState();
}

final class NotificationListInitial extends NotificationListState {
  @override
  List<Object> get props => [];
}

class NotificationListLoading extends NotificationListState {
  @override

  List<Object> get props => [];
}

class NotificationListLoaded extends NotificationListState {
  @override
  List<Object> get props => [];

  final NotificationListModel notificationListModel;
  const NotificationListLoaded(this.notificationListModel);
}

class NotificationListError extends NotificationListState {
  late final String? message;
  NotificationListError(this.message);

  @override
  List<Object> get props => [];
}
