import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_service.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class SharedPreferenceService extends _$SharedPreferenceService {
  late final SharedPreferences _pref;
  @override
  void build() {
    return;
  }

  Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  SharedPreferences get shared => _pref;

}