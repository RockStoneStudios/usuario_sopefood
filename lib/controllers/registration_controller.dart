import 'package:flutter/material.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/api_error.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/models/sucess_model.dart';
import 'package:sopefoodusuario/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void registration(String model) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/register');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;

        Get.snackbar(data.message, "Procede a Loguearte",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.to(() => const Login(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Fallo el Login, Vuelva a intentarlo",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Fallo el Login, Vuelva a intentarlo",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
