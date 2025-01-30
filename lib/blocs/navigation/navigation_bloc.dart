import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NavigationEvent {}

class NavigateToTab extends NavigationEvent {
  final int index;
  NavigateToTab(this.index);
}

// States
class NavigationState {
  final int currentIndex;
  NavigationState(this.currentIndex);
}

// BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<NavigateToTab>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}