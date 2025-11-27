import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pretty_good_secure_folder/model/vault_item.dart';
import 'package:uuid/v4.dart';

part 'template.freezed.dart';

@freezed
abstract class Template with _$Template {
  const Template._();

  const factory Template.passport() = _Passport;

  const factory Template.creditCard() = _CreditCard;

  const factory Template.login() = _Login;

  static List<VaultItem> createPassport() {
    List<VaultItem> list = [];
    List<String> keys = [
      "type",
      "code",
      "Surname",
      "given_name",
      "nationality",
      "birth_day",
      "sex",
      "place_of_birth",
      "issue_date",
      "expiry_date",
    ];
    for (var key in keys) {
      final id = UuidV4().generate().hashCode;
      list.add(VaultItem(id: id, key: key, value: "*"));
    }
    return list;
  }

  static List<VaultItem> createCreditCard() {
    List<VaultItem> list = [];
    List<String> keys = ["name", "number", "security_code"];
    for (var key in keys) {
      final id = UuidV4().generate().hashCode;
      list.add(VaultItem(id: id, key: key, value: "*"));
    }
    return list;
  }

  static List<VaultItem> createLogin() {
    List<VaultItem> list = [];
    List<String> keys = ["username", "password"];
    for (var key in keys) {
      final id = UuidV4().generate().hashCode;
      list.add(VaultItem(id: id, key: key, value: "*"));
    }
    return list;
  }

  String get name {
    return when(
      passport: () => "Passport",
      creditCard: () => "Credit Card",
      login: () => "Login",
    );
  }

  List<VaultItem> get item {
    return when(
      passport: () => Template.createPassport(),
      creditCard: () => Template.createCreditCard(),
      login: () => Template.createLogin(),
    );
  }
}
