import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guard_property_management/api_bloc/repository/VisitorListRepository.dart';
import 'package:guard_property_management/model/VisitorPequestModel.dart';

part 'visitor_listing_event.dart';
part 'visitor_listing_state.dart';

class VisitorListingBloc extends Bloc<VisitorListingEvent, VisitorListingState> {
  VisitorListingBloc() : super(VisitorListingInitial()) {
    final VisitorListRepository _apiRepository = VisitorListRepository();

    on<VisitorListingEvent>((event, emit) async {
      try {
        emit(VisitorListingLoading());
        final mList = await _apiRepository.visitorListingData();
        emit(VisitorListingLoaded(mList));
        if (mList.error != null) {
          emit(VisitorListingError(mList.error));
        }
      } on NetworkError {
        emit(VisitorListingError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
