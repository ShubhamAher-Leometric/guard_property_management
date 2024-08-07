part of 'notification_count_bloc.dart';

sealed class NotificationCountState extends Equatable {
  const NotificationCountState();
}

final class NotificationCountInitial extends NotificationCountState {
  @override
  List<Object> get props => [];
}

class  NotificationCountLoading extends NotificationCountState {
  @override

  List<Object> get props => [];
}

class  NotificationCountLoaded extends NotificationCountState {
  @override
  List<Object> get props => [];

  final  NotificationCountModel notificationCountModel;
  const  NotificationCountLoaded(this.notificationCountModel);
}

class  NotificationCountError extends NotificationCountState {
  late final String? message;
  NotificationCountError(this.message);

  @override
  List<Object> get props => [];
}
