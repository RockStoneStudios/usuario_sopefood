import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sopefoodusuario/common/app_style.dart';
import 'package:sopefoodusuario/common/reusable_text.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/controllers/email_verification_controller.dart';
import 'package:sopefoodusuario/controllers/login_controller.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sopefoodusuario/models/login_response.dart';
import 'package:sopefoodusuario/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());
    final userController = Get.put(LoginController());
    LoginResponse? user = userController.getUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(
            height: 100.h,
          ),
          Lottie.asset('assets/anime/delivery.json'),
          SizedBox(
            height: 30.h,
          ),
          ReusableText(
              text: "VERIFICA TU CUENTA",
              style: appStyle(20, kPrimary, FontWeight.bold)),
          Text(
              "Ingresa el código enviado a tu correo electrónico, si no lo enviaste recibe el código haz clic en reenviar",
              style: appStyle(10, kGrayLight, FontWeight.normal)),
          SizedBox(
            height: 20.h,
          ),
          OtpTextField(
            numberOfFields: 6,
            borderColor: kPrimary,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            focusedBorderColor: kSecondary,
            textStyle: appStyle(17, kDark, FontWeight.bold),
            showFieldAsBox: false,
            borderWidth: 2.0,
            onSubmit: (String verificationCode) {
              controller.code = verificationCode;
            },
          ),
          SizedBox(
            height: 20.h,
          ),
          CustomButton(
            onTap: () {
              controller.verifyEmail();
            },
            color: kPrimary,
            text: "Verifica Cuenta",
            btnHieght: 40.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
              "El correo electrónico ha sido enviado a ${user!.email}. Si el correo electrónico no es correcto, elimine esta cuenta y cree una nueva con el correo electrónico correcto. Alternativamente, puede cerrar sesión y navegar por la aplicación sin una cuenta.",
              textAlign: TextAlign.justify,
              style: appStyle(10, kGray, FontWeight.normal)),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    userController.logout();
                  },
                  child: ReusableText(
                      text: "Salir",
                      style: appStyle(12, kSecondary, FontWeight.w600))),
              GestureDetector(
                onTap: () {
                  userController.deleteAccount();
                },
                child: ReusableText(
                    text: "Borrar Cuenta",
                    style: appStyle(12, kRed, FontWeight.w600)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
