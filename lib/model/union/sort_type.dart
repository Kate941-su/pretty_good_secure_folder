import 'package:freezed_annotation/freezed_annotation.dart';

part 'sort_type.freezed.dart';

@freezed
abstract class SortType with _$SortType {

  const SortType._();

  const factory SortType.dateAscend() = DateAscend;
  const factory SortType.dateDescend() = DateDescend;
  const factory SortType.wordAscend() = WordAscend;
  const factory SortType.wordDescend() = WordDescend;

  String get name {
    return when(
        dateAscend: () => "Sort by date ascending",
        dateDescend: () => "Sort by date descending",
        wordAscend: () => "Sort by word ascending",
        wordDescend: () => "Sort by word descending",
    );
  }
}

