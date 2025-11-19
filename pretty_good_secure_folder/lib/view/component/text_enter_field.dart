import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_good_secure_folder/model/error/app_error.dart';

class TextEnterField extends HookConsumerWidget {
  const TextEnterField({
    super.key,
    required this.title,
    required this.controller,
    this.error,
  });

  final String title;
  final TextEditingController controller;
  final AppError? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter the Value',
              errorText: error?.when(
                  keyStringError: () => "Key must not contain white space",
                  emptyString: () => "Empty string is not allowed",
                  keyDupulicateError: () => "Key already exists"
              ),
            ),
            onSubmitted: (String value) async {},
          ),
        ],
      ),
    );
  }
}
