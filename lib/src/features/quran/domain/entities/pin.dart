import 'package:equatable/equatable.dart';

class PinEntity extends Equatable {
  final String? title;
  final int? surah;
  final int? ayah;

  const PinEntity({this.title, this.surah, this.ayah});

  @override
  List<Object?> get props => [title, surah, ayah];
}
