import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_screen_state.dart';

class AddScreenCubit extends Cubit<AddScreenState> {
  AddScreenCubit() : super(AddScreenState(selectedDate: DateTime.now()));

  void updateSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate));
  }
}