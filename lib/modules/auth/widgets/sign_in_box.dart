import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pumba/core/app_colors.dart';
import 'package:pumba/core/app_strings.dart';
import 'package:pumba/core/helpers/form_validators.dart';
import 'package:pumba/core/widgets/app_form_field.dart';
import 'package:pumba/core/widgets/buttons/app_drop_down.dart';
import 'package:pumba/core/widgets/buttons/app_elevated_button.dart';
import 'package:pumba/modules/auth/models/gender.dart';
import 'package:pumba/modules/auth/providers/auth_provider.dart';
import 'package:pumba/modules/auth/widgets/eye_password_suffix.dart';

class SignInBox extends ConsumerStatefulWidget {
  const SignInBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInBoxState();
}

class _SignInBoxState extends ConsumerState<SignInBox> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
        text: 'abc@gmail.com',
      ),
      _passwordController = TextEditingController(
        text: '123456Abr',
      ),
      _firstNameController = TextEditingController(
        text: 'John',
      ),
      _lastNameController = TextEditingController(
        text: 'Doe',
      );
  final _emailFocusNode = FocusNode(),
      _passwordFocusNode = FocusNode(),
      _firstNameFocusNode = FocusNode(),
      _lastNameFocusNode = FocusNode();
  bool _isObscureText = true;
  Gender _selectedGender = Gender.other;

  void setIsObscureText() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  Future<void> _trySignUp() async {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider).createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            gender: _selectedGender,
          );
    }
  }

  @override
  void initState() {
    _emailFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  EdgeInsets get _tFPadding =>
      const EdgeInsets.only(top: 16.0, left: 32, right: 48);

  EdgeInsets get _genderPadding => const EdgeInsets.only(top: 16);

  EdgeInsets get _signupPadding =>
      const EdgeInsets.only(top: 16, right: 64, left: 64);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppFormField(
              padding: _tFPadding,
              validator: FormValidators.emailValidator,
              focusNode: _emailFocusNode,
              controller: _emailController,
              label: AppStrings.emailLabel,
              placeholder: AppStrings.emailPlaceholder,
              keyboardType: TextInputType.emailAddress,
              isShowingLabel: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                _emailFocusNode.unfocus();
                _firstNameFocusNode.requestFocus();
              },
            ),
          ),
          AppFormField(
            padding: _tFPadding,
            validator: FormValidators.firstNameValidator,
            controller: _firstNameController,
            label: AppStrings.firstNameLabel,
            placeholder: AppStrings.firstNamePlaceholder,
            keyboardType: TextInputType.text,
            isShowingLabel: true,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _firstNameFocusNode.unfocus();
              _lastNameFocusNode.requestFocus();
            },
          ),
          AppFormField(
            padding: _tFPadding,
            validator: FormValidators.lastNameValidator,
            controller: _lastNameController,
            label: AppStrings.lastNameLabel,
            placeholder: AppStrings.lastNamePlaceholder,
            keyboardType: TextInputType.text,
            isShowingLabel: true,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              _lastNameFocusNode.unfocus();
              _passwordFocusNode.requestFocus();
            },
          ),
          Padding(
            padding: _genderPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: _tFPadding,
                  child: Text(AppStrings.gender),
                ),
                AppDropDown<Gender>(
                  items: Gender.values,
                  value: _selectedGender,
                  display: (gender) => gender.name,
                  onChanged: (gender) {
                    if (gender == null) return;
                    setState(() {
                      _selectedGender = gender;
                    });
                  },
                ),
              ],
            ),
          ),
          AppFormField(
            padding: _tFPadding,
            validator: FormValidators.passwordValidator,
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            label: AppStrings.passwordLabel,
            placeholder: AppStrings.passwordPlaceholder,
            keyboardType: TextInputType.visiblePassword,
            isShowingLabel: true,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            onEditingComplete: () {
              _passwordFocusNode.unfocus();
            },
            isObscureText: _isObscureText,
            suffixWidget: EyePasswordSuffix(
              isObscureText: _isObscureText,
              setIsObscureText: setIsObscureText,
            ),
          ),
          Padding(
            padding: _signupPadding,
            child: AppElevatedButton(
              text: AppStrings.signUp,
              backgroundColor: AppColors.background,
              onPressed: _trySignUp,
            ),
          ),
        ],
      ),
    );
  }
}
