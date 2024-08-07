part of 'read_delete_notification_bloc.dart';

sealed class ReadDeleteNotificationState extends Equatable {
  const ReadDeleteNotificationState();
}

final class ReadDeleteNotificationInitial extends ReadDeleteNotificationState {
  @override
  List<Object> get props => [];
}

class ReadDeleteNotificationLoading extends ReadDeleteNotificationState {
  @override
  List<Object> get props => [];
}

class ReadDeleteNotificationError extends ReadDeleteNotificationState {
  late final String? message;
  ReadDeleteNotificationError(this.message);

  @override
  List<Object> get props => [];
}

class ReadDeleteNotificationLoaded extends ReadDeleteNotificationState {
  @override
  List<Object> get props => [];

  final ReadDeleteNotificationModel readDeleteNotificationModel;
  const ReadDeleteNotificationLoaded(this.readDeleteNotificationModel);
}
