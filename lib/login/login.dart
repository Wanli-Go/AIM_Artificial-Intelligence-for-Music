import 'package:flutter/material.dart';
import 'package:music_therapy/main/view/main_scaffold.dart';
import 'package:music_therapy/login/components/app_text_form_field.dart';
import 'package:music_therapy/login/components/gradient_background.dart';
import 'package:music_therapy/login/utils/login_service.dart';
import 'package:music_therapy/login/utils/login_themes.dart';
import 'package:music_therapy/login/register.dart';
import 'package:music_therapy/login/utils/login_regex.dart';
import 'package:music_therapy/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.existingName, this.existingPassword});
  final String? existingName;
  final String? existingPassword;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController phoneController;
  late final TextEditingController passwordController;

  void initializeControllers() {
    phoneController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    phoneController.text = widget.existingName?? '';
    passwordController.text = widget.existingPassword?? '';
  }

  void disposeControllers() {
    phoneController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = phoneController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    if (AppRegex.phoneRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password)) {
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
        padding: EdgeInsets.zero,
        children: [
          const GradientBackground(
            children: [
              Text(
                "登陆\n音乐疗愈助手",
                style: LoginTheme.titleLarge,
              ),
              SizedBox(height: 6),
              Text("Sign in to Artificial Intelligence for Music",
                  style: LoginTheme.bodySmall),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    controller: phoneController,
                    labelText: "手机 / Mobile (+86)",
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? "请输入手机号。"
                          : AppRegex.phoneRegex.hasMatch(value)
                              ? null
                              : "请输入正确的手机号。";
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: "密码 / Password",
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? "请输入密码。"
                              : AppRegex.passwordRegex.hasMatch(value)
                                  ? null
                                  : "无效的密码格式。";
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                              passwordNotifier.value = !passwordObscure,
                          style: IconButton.styleFrom(
                            minimumSize: const Size.square(48),
                          ),
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("忘记密码？"),
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return Center(
                        child: SizedBox(
                          width: 120,
                          child: FilledButton(
                            style: LoginTheme.clickableButtonStyle,

                            /*
                            // IMPORTANT: Login Button Submitted Logic
                            */
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
                                                  Text("登录中..."),
                                                ],
                                              ),
                                            ));
                                    final result = await LoginService.login(
                                        phoneController.text,
                                        passwordController.text);
                                    passwordController.clear();
                                    // Dismiss the dialog
                                    Navigator.pop(context);
                                    if (result == "1") {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (_) =>
                                            const ScaffoldPage(), // 将数据传递给下一个页面
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            '登陆失败: $result'), // Incorporate error code
                                        backgroundColor:
                                            mainTheme, // Set a color for error
                                      ));
                                    }
                                  }
                                : null,



                            child: const Text(
                              "登陆",
                              style: LoginTheme.clickableTextStyle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "没有账号？",
                style: LoginTheme.bodySmall.copyWith(color: Colors.black),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()))
                },
                child: const Text("创建一个。"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
