import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/notification_count.dart';
import '../../repository/NotificationCountRepository.dart';

part 'notification_count_event.dart';
part 'notification_count_state.dart';

class NotificationCountBloc extends Bloc<NotificationCountEvent, NotificationCountState> {
  NotificationCountBloc() : super(NotificationCountInitial()) {
    final GetNotificationCountRepository _apiRepository = GetNotificationCountRepository();

    on<NotificationCountEvent>((event, emit) async {
      try {
        emit(NotificationCountLoading());
        final mList = await _apiRepository.notificationcountData();
        emit(NotificationCountLoaded(mList));
        if (mList.error != null) {
          emit(NotificationCountError(mList.error));
        }
      } on NetworkError {
        emit(NotificationCountError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
