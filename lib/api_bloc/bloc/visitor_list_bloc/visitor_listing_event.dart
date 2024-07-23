part of 'visitor_listing_bloc.dart';

sealed class VisitorListingEvent extends Equatable {
  const VisitorListingEvent();
  @override
  List<Object> get props => [];
}
class VisitorListEventData extends VisitorListingEvent {
  VisitorListEventData();
}
