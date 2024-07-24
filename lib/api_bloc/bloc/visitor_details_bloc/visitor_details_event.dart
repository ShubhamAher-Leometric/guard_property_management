part of 'visitor_details_bloc.dart';

sealed class VisitorDetailsEvent extends Equatable {
  const VisitorDetailsEvent();
  @override
  List<Object> get props => [];
}
class VisitorDetailsData extends VisitorDetailsEvent {
  VisitorDetailsData();
}
