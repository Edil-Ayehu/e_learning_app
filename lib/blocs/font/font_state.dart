import 'package:equatable/equatable.dart';

class FontState extends Equatable {
  final double fontScale;
  final String fontFamily;

  const FontState({
    required this.fontScale,
    required this.fontFamily,
  });

  @override
  List<Object?> get props => [fontScale, fontFamily];

  FontState copyWith({
    double? fontScale,
    String? fontFamily,
  }) {
    return FontState(
      fontScale: fontScale ?? this.fontScale,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}