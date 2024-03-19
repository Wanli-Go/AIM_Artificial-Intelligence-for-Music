import 'package:flutter/material.dart';
import 'package:music_therapy/login/login.dart';
import 'package:music_therapy/login/login_service.dart';
import 'package:music_therapy/login/utils/login_regex.dart';
import 'package:music_therapy/theme.dart';

import 'components/app_text_form_field.dart';
import 'components/gradient_background.dart';

import 'login_themes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  void initializeControllers() {
    nameController = TextEditingController()..addListener(controllerListener);
    phoneController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final name = nameController.text;
    final email = phoneController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) return;

    if (AppRegex.phoneRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password) &&
        AppRegex.passwordRegex.hasMatch(confirmPassword)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const GradientBackground(
            children: [
              Text("注册新用户。", style: LoginTheme.titleLarge),
              SizedBox(height: 6),
              Text("请在下方输入您的账号信息", style: LoginTheme.bodySmall),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 9,
                  ),
                  AppTextFormField(
                    autofocus: true,
                    labelText: "账户名称",
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? "请输入账户名称。"
                          : value.length < 4
                              ? "请至少输入4个字符！"
                              : null;
                    },
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  AppTextFormField(
                    labelText: "手机号 (+86)",
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? "请输入手机号"
                          : AppRegex.phoneRegex.hasMatch(value)
                              ? null
                              : "无效的手机号格式。";
                    },
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: "密码",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? "请输入密码"
                              : AppRegex.passwordRegex.hasMatch(value)
                                  ? null
                                  : "请输入有效的密码";
                        },
                        suffixIcon: Focus(
                          /// If false,
                          ///
                          /// disable focus for all of this node's descendants
                          descendantsAreFocusable: false,

                          /// If false,
                          ///
                          /// make this widget's descendants un-traversable.
                          // descendantsAreTraversable: false,
                          child: IconButton(
                            onPressed: () =>
                                passwordNotifier.value = !passwordObscure,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(48),
                            ),
                            icon: Icon(
                              passwordObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordNotifier,
                    builder: (_, confirmPasswordObscure, __) {
                      return AppTextFormField(
                        labelText: "确认密码",
                        controller: confirmPasswordController,
                        obscureText: confirmPasswordObscure,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? "请确认密码"
                              : AppRegex.passwordRegex.hasMatch(value)
                                  ? passwordController.text ==
                                          confirmPasswordController.text
                                      ? null
                                      : "密码不匹配！"
                                  : "无效的密码格式";
                        },
                        suffixIcon: Focus(
                          /// If false,
                          ///
                          /// disable focus for all of this node's descendants.
                          descendantsAreFocusable: false,

                          /// If false,
                          ///
                          /// make this widget's descendants un-traversable.
                          // descendantsAreTraversable: false,
                          child: IconButton(
                            onPressed: () => confirmPasswordNotifier.value =
                                !confirmPasswordObscure,
                            style: IconButton.styleFrom(
                              minimumSize: const Size.square(48),
                            ),
                            icon: Icon(
                              confirmPasswordObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return Center(
                        child: SizedBox(
                          width: 100,
                          child: FilledButton(
                            style: LoginTheme.clickableButtonStyle,
                            onPressed: isValid
                                ? () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // Prevent dismiss when tapping outside
                                        builder: (context) => const AlertDialog(
                                              content: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(width: 20),
                                                  Text("注册中..."),
                                                ],
                                              ),
                                            ));
                                    final result = await LoginService.register(
                                        nameController.text,
                                        phoneController.text,
                                        passwordController.text);
                                    // Dismiss the dialog
                                    Navigator.pop(context);
                                    if (result == "1") {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) =>
                                            LoginScreen(existingName: nameController.text, existingPassword: passwordController.text,), // 将数据传递给下一个页面
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            '注册失败: $result'), // Incorporate error code
                                        backgroundColor:
                                            mainTheme, // Set a color for error
                                      ));
                                    }
                                  }
                                : null,
                            child: const Text("注册", style: LoginTheme.clickableTextStyle,),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "已有账号？",
                style: LoginTheme.bodySmall.copyWith(color: Colors.black),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("直接登陆。"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
