import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/notificationlistmodel.dart';
import '../../repository/NotificationListRepository.dart';


part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(NotificationListInitial()) {
    final NotificationListRepository _apiRepository = NotificationListRepository();

    on<GetNotificationListEvent>((event, emit) async {
      try {
        emit(NotificationListLoading());
        final mList = await _apiRepository.notificationData();
        emit(NotificationListLoaded(mList));
        if (mList.error != null) {
          emit(NotificationListError(mList.error));
        }
      } on NetworkError {
        emit(NotificationListError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
