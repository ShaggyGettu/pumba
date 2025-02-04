import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthBoxWidget extends ConsumerWidget {
  final Widget? child;

  const AuthBoxWidget({
    super.key,
    this.child,
  });

  BorderRadius get _borderRadius => const BorderRadius.only(
        topLeft: Radius.circular(56),
        topRight: Radius.circular(56),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: _borderRadius,
      ),
      child: child,
    );
  }
}
