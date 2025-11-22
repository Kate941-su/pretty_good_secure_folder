import 'package:pretty_good_secure_folder/model/union/sort_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_type_state.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class SortTypeState extends _$SortTypeState {
  @override
  SortType build() {
    return SortType.wordAscend();
  }
  void setSortType(SortType type) {
    state = type;
  }
}