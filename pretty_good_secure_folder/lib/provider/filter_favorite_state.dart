import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_favorite_state.g.dart';

// Provider for storing measurements
@riverpod
class FilterFavoriteState extends _$FilterFavoriteState {
  @override
  bool build() {
    return false;
  }
  void toggle() {
    state = !state;
  }
}