import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_service.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class SharedPreferenceService extends _$SharedPreferenceService {

  SharedPreferences? _pref;

  @override
  SharedPreferences? build() {
    return _pref;
  }

  Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

}