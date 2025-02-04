import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EyePasswordSuffix extends ConsumerWidget {
  final bool isObscureText;
  final void Function() setIsObscureText;

  const EyePasswordSuffix({
    super.key,
    required this.isObscureText,
    required this.setIsObscureText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: setIsObscureText,
        child: Icon(
          isObscureText ? Icons.visibility : Icons.visibility_off,
          color: isObscureText
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).scaffoldBackgroundColor,
          size: 24,
        ),
      ),
    );
  }
}
