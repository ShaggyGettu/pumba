import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pumba/core/app_colors.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/helpers/app_show_error.dart';
import 'package:pumba/core/providers/permission_provider.dart';
import 'package:pumba/core/utils/datetime_ext.dart';
import 'package:pumba/core/widgets/buttons/app_elevated_button.dart';
import 'package:pumba/core/widgets/dialog/app_confirm_dialog.dart';
import 'package:pumba/modules/auth/providers/auth_provider.dart';
import 'package:pumba/modules/auth/providers/user_provider.dart';
import 'package:pumba/modules/home/providers/location_provider.dart';
import 'package:pumba/modules/home/providers/notification_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateTime? _time;
  bool _isShowStartButton = true;

  EdgeInsets get _allowLocationPadding =>
      const EdgeInsets.only(top: 16, right: 64, left: 64);
  Duration get _waitDuration => const Duration(minutes: 2);

  void _deleteUser() {
    AppConfirmDialog.show(
      context: context,
      title: AppStrings.deleteUser,
      message: AppStrings.deleteUserMessage,
    ).then(
      (value) {
        if (value == true) {
          ref.read(authProvider).deleteUser();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(locationProvider).isLoading;

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

    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, child) {
          final firstName = ref.watch(userProvider)?.firstName ?? '';
          final lastName = ref.watch(userProvider)?.lastName ?? '';
          return Text(
            _time != null
                ? AppStrings.notificationWillAppear(_time!.hhmm)
                : AppStrings.greetUser(firstName, lastName),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          );
        }),
        leading: IconButton(
          icon: Icon(Icons.delete_forever_rounded),
          onPressed: _deleteUser,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator.adaptive()
            else
              Consumer(
                builder: (context, ref, child) {
                  final address = ref.watch(locationProvider).location;
                  return ref
                              .watch(permissionProvider)
                              .locationPermissionStatus ==
                          PermissionStatus.granted
                      ? Text(address)
                      : Padding(
                          padding: _allowLocationPadding,
                          child: AppElevatedButton(
                            text: AppStrings.allowLocation,
                            backgroundColor: AppColors.background,
                            height: 48,
                            onPressed: () async {
                              await ref
                                  .read(permissionProvider)
                                  .requestLocationPermission();
                              if (ref
                                      .watch(permissionProvider)
                                      .locationPermissionStatus ==
                                  PermissionStatus.granted) {
                                await ref.read(locationProvider).getAddress();
                              }
                            },
                          ),
                        );
                },
              ),
            if (_isShowStartButton)
              Padding(
                padding: _allowLocationPadding,
                child: Consumer(
                  builder: (context, ref, child) {
                    return AppElevatedButton(
                      text: AppStrings.start,
                      backgroundColor: AppColors.background,
                      height: 48,
                      onPressed: () async {
                        final scheduled = DateTime.now().add(_waitDuration);
                        await ref.read(notificationProvider).showNotification(
                              context: context,
                              title: AppStrings.notificationTitle,
                              body: AppStrings.notificationBody,
                              scheduledDate: scheduled,
                            );
                        if (ref
                            .watch(notificationProvider)
                            .isPermissionGranted) {
                          setState(() {
                            _time = scheduled;
                            _isShowStartButton = false;
                          });
                          Timer(
                            _waitDuration,
                            () {
                              setState(() {
                                _time = null;
                              });
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
