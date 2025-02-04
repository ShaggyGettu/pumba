import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/helpers/app_show_error.dart';
import 'package:pumba/modules/auth/providers/auth_provider.dart';
import 'package:pumba/modules/auth/widgets/auth_box_widget.dart';
import 'package:pumba/modules/auth/widgets/sign_in_box.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  EdgeInsets get _titlePadding => const EdgeInsets.only(top: 120, bottom: 60);

  @override
  Widget build(BuildContext context) {
    ref.listen(
      authProvider,
      (_, notifier) {
        if (notifier.errorMessage != null) {
          AppShowError.showError(
              context: context, message: notifier.errorMessage!);
          notifier.clearErrorMessage();
        }
      },
    );
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: _titlePadding,
                        child: Text(
                          AppStrings.authPageTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Expanded(
                        child: AuthBoxWidget(
                          child: SignInBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
