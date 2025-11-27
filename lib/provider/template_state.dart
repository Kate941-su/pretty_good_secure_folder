import 'package:pretty_good_secure_folder/model/union/sort_type.dart';
import 'package:pretty_good_secure_folder/model/union/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_state.g.dart';

// Provider for storing measurements
@Riverpod(keepAlive: true)
class TemplateState extends _$TemplateState {
  @override
  Template build() {
    return Template.login();
  }
  void setSortType(Template template) {
    state = template;
  }
}