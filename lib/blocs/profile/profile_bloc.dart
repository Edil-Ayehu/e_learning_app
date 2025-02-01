import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/blocs/profile/profile_event.dart';
import 'package:e_learning_app/blocs/profile/profile_state.dart';
import 'package:e_learning_app/blocs/auth/auth_bloc.dart';
import 'package:e_learning_app/models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;

  ProfileBloc({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UpdateProfilePhotoRequested>(_onUpdateProfilePhotoRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final userModel = _authBloc.state.userModel;
      
      if (userModel != null) {
        final profile = ProfileModel(
          fullName: userModel.fullName ?? '',
          email: userModel.email,
          photoUrl: userModel.photoUrl,
          stats: const ProfileStats(
            coursesCount: 0,
            hoursSpent: 0,
            successRate: 0,
          ),
        );
        emit(state.copyWith(profile: profile, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Will implement actual Firebase update later
    try {
      emit(state.copyWith(isLoading: true));
      if (state.profile != null) {
        final updatedProfile = state.profile!.copyWith(
          fullName: event.fullName,
          phoneNumber: event.phoneNumber,
          bio: event.bio,
          photoUrl: event.photoUrl,
        );
        emit(state.copyWith(profile: updatedProfile, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onUpdateProfilePhotoRequested(
    UpdateProfilePhotoRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Will implement actual Firebase Storage upload later
    try {
      emit(state.copyWith(isPhotoUploading: true));
      // Photo upload logic will go here
      emit(state.copyWith(isPhotoUploading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isPhotoUploading: false));
    }
  }
}
