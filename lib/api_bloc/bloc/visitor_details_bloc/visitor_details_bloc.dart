import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/visitordetailsmodel.dart';
import '../../repository/VisitorDetailsRepository.dart';


part 'visitor_details_event.dart';
part 'visitor_details_state.dart';

class VisitorDetailsBloc extends Bloc<VisitorDetailsEvent, VisitorDetailsState> {
  VisitorDetailsBloc() : super(VisitorDetailsInitial()) {
    final VisitorDetailsRepository _apiRepository = VisitorDetailsRepository();

    on<VisitorDetailsEvent>((event, emit) async {
      try {
        emit(VisitorDetailsLoading());
        final mList = await _apiRepository.visitorData();
        emit(VisitorDetailsLoaded(mList));
        if (mList.error != null) {
          emit(VisitorDetailsError(mList.error));
        }
      } on NetworkError {
        emit(VisitorDetailsError(
            "Failed to fetch data. is your device online?"));
      }     });
  }
}
