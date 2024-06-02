import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/controllers/login_controller.dart';
import 'package:sopefoodusuario/models/login_request.dart';
import 'package:sopefoodusuario/views/auth/registration.dart';
import 'package:sopefoodusuario/views/auth/widgets/email_textfield.dart';
import 'package:sopefoodusuario/views/auth/widgets/password_field.dart';
import 'package:sopefoodusuario/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 5.w),
          height: 50.h,
          child: Text(
            "Usuario SopeFoods",
            style: appStyle(24, kPrimary, FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Lottie.asset('assets/anime/delivery.json'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                //email
                EmailTextField(
                  focusNode: _passwordFocusNode,
                  hintText: "Email",
                  controller: _emailController,
                  prefixIcon: Icon(
                    CupertinoIcons.mail,
                    color: Theme.of(context).dividerColor,
                    size: 20.h,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),

                SizedBox(
                  height: 25.h,
                ),

                PasswordField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                ),

                SizedBox(
                  height: 6.h,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const RegistrationPage());
                        },
                        child: Text('Registrese',
                            style: appStyle(14, Colors.black, FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 18.h,
                ),

                Obx(
                  () => controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(
                          backgroundColor: kPrimary,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kLightWhite),
                        ))
                      : CustomButton(
                          btnHieght: 37.h,
                          color: kPrimary,
                          text: "L O G I N",
                          onTap: () {
                            LoginRequest model = LoginRequest(
                                email: _emailController.text,
                                password: _passwordController.text);

                            String authData = loginRequestToJson(model);

                            controller.loginFunc(authData);
                          }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
