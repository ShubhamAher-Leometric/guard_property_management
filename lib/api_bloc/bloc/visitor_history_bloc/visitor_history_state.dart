part of 'visitor_history_bloc.dart';

sealed class VisitorHistoryState extends Equatable {
  const VisitorHistoryState();
}

final class VisitorHistoryInitial extends VisitorHistoryState {
  @override
  List<Object> get props => [];
}

class VisitorHistoryLoading extends VisitorHistoryState {
  @override
  List<Object> get props => [];
}

class VisitorHistoryLoaded extends VisitorHistoryState {
  @override
  List<Object> get props => [];
  final VisitorHistoryModel visitorHistoryModel;
  const VisitorHistoryLoaded(this.visitorHistoryModel);
}

class VisitorHistoryError extends VisitorHistoryState {
  late final String? message;
  VisitorHistoryError(this.message);
  @override
  List<Object> get props => [];
}
