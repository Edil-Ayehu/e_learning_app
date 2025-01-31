import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'font_event.dart';
import 'font_state.dart';
import '../../services/font_service.dart';

class FontBloc extends Bloc<FontEvent, FontState> {
  final GetStorage _storage = GetStorage();

  FontBloc()
      : super(FontState(
          fontScale: FontService.currentFontScale,
          fontFamily: FontService.currentFontFamily,
        )) {
    on<UpdateFontScale>(_onUpdateFontScale);
    on<UpdateFontFamily>(_onUpdateFontFamily);
  }

  void _onUpdateFontScale(UpdateFontScale event, Emitter<FontState> emit) async {
    await FontService.setFontScale(event.scale);
    emit(state.copyWith(fontScale: event.scale));
  }

  void _onUpdateFontFamily(UpdateFontFamily event, Emitter<FontState> emit) async {
    await FontService.setFontFamily(event.family);
    emit(state.copyWith(fontFamily: event.family));
  }
}