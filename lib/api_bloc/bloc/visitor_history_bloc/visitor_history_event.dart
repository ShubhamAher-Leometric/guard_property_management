part of 'visitor_history_bloc.dart';

sealed class VisitorHistoryEvent extends Equatable {
  const VisitorHistoryEvent();
  @override
  List<Object> get props => [];
}
class VisitorHistoryEventData extends VisitorHistoryEvent {
  VisitorHistoryEventData();
}