import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  Timer? _timer;

  SplashBloc() : super(SplashInitialState()) {
    on<InitializeSplashEvent>(_onInitializeSplash);
    on<SplashCompletedEvent>(_onSplashCompleted);
    on<NavigateToHomeEvent>(_onNavigateToHome);
  }

  Future<void> _onInitializeSplash(
    InitializeSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());

    // Show splash screen
    emit(SplashDisplayState());

    // Navigate after 3 seconds (adjust duration as needed)
    _timer = Timer(const Duration(seconds: 3), () {
      add(SplashCompletedEvent());
    });
  }

  void _onSplashCompleted(
    SplashCompletedEvent event,
    Emitter<SplashState> emit,
  ) {
    emit(SplashDisplayState());
    Future.delayed(const Duration(milliseconds: 500), () {
      add(NavigateToHomeEvent());
    });
  }

  void _onNavigateToHome(NavigateToHomeEvent event, Emitter<SplashState> emit) {
    emit(SplashNavigateState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
