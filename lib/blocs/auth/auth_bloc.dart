import 'dart:async';
import 'package:e_learning_app/blocs/auth/auth_event.dart';
import 'package:e_learning_app/blocs/auth/auth_state.dart';
import 'package:e_learning_app/models/user_model.dart';
import 'package:e_learning_app/repository/auth_repository.dart';
import 'package:e_learning_app/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
    final AuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;
  
    AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState()) {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user)),
    );

    on<AuthStateChanged>(_onAuthStateChanged);
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
    emit(state.copyWith(
      userModel: event.user,
      isLoading: false,
      error: null,
    ));

    // // Navigate based on user role
    // if (event.user?.role == UserRole.teacher) {
    //   Get.offAllNamed(AppRoutes.teacherHome);
    // } else {
    //   Get.offAllNamed(AppRoutes.main);
    // }
  } else {
    emit(const AuthState());
    // Get.offAllNamed(AppRoutes.login);
  }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        role: event.role,
      );
      emit(state.copyWith(
      isLoading: false,
      userModel: user,
      error: null,
    ));

    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _authRepository.signOut();
      emit(const AuthState());
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.resetPassword(event.email);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.updateProfile(
        fullName: event.fullName,
        photoUrl: event.photoUrl,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

   @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
