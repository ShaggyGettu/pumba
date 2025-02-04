import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pumba/core/app_colors.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/helpers/app_show_error.dart';
import 'package:pumba/core/providers/permission_provider.dart';
import 'package:pumba/core/widgets/buttons/app_elevated_button.dart';
import 'package:pumba/modules/auth/providers/auth_provider.dart';
import 'package:pumba/modules/auth/providers/user_provider.dart';
import 'package:pumba/modules/home/providers/location_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showButton = true;
  TimeOfDay? _time;
  Timer? _timer;
  EdgeInsets get _allowLocationPadding =>
      const EdgeInsets.only(top: 16, right: 64, left: 64);

  @override
  Widget build(BuildContext context) {
    final address = ref.watch(locationProvider).location;
    final locationPermission =
        ref.watch(permissionProvider).locationPermissionStatus;
    final isLoading = ref.watch(locationProvider).isLoading;
    final firstName = ref.watch(userProvider)?.firstName ?? '';
    final lastName = ref.watch(userProvider)?.lastName ?? '';

    if (locationPermission == PermissionStatus.granted) {
      _timer?.cancel();
      _time = null;
    } else {
      _showButton = true;
    }

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
        title: Text(
          _time != null
              ? AppStrings.notificationWillAppear(_time!.hour, _time!.minute)
              : AppStrings.greetUser(firstName, lastName),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.delete_forever_rounded),
          onPressed: ref.read(authProvider).deleteUser,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator.adaptive()
            else
              locationPermission == PermissionStatus.granted
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
                          if (locationPermission == PermissionStatus.granted) {
                            await ref.read(locationProvider).getAddress();
                          }
                        },
                      ),
                    ),
            if (_showButton)
              Padding(
                padding: _allowLocationPadding,
                child: AppElevatedButton(
                  text: AppStrings.start,
                  backgroundColor: AppColors.background,
                  height: 48,
                  onPressed: () async {
                    if (locationPermission == PermissionStatus.granted) {
                      setState(() {
                        _showButton = false;
                      });
                      return;
                    }
                    _timer?.cancel();
                    final now = TimeOfDay.now();
                    setState(() {
                      _time = TimeOfDay(hour: now.hour, minute: now.minute + 2);
                    });
                    _timer = Timer(
                      const Duration(minutes: 2),
                      () async {
                        await ref
                            .read(permissionProvider)
                            .requestLocationPermission();
                        await ref.read(locationProvider).getAddress();
                        setState(() {
                          _time = null;
                        });
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
