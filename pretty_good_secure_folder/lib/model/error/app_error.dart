import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
abstract class AppError with _$AppError {
  AppError._();
  factory AppError.keyStringError() = _KeyStringError;
  factory AppError.emptyString() = _EmptyString;
  factory AppError.keyDupulicateError() = _KeyDublicateError;
}
