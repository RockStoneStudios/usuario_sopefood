// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/controllers/notifications_controller.dart';
import 'package:sopefoodusuario/models/api_error.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/models/login_response.dart';
import 'package:sopefoodusuario/views/auth/verification_page.dart';
import 'package:sopefoodusuario/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final controller = Get.put(NotificationsController());
  final box = GetStorage();
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void loginFunc(String model) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);

        box.write(userId, userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("verification", data.verification);

        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        setLoading = false;
        controller.updateUserToken(controller.fcmToken);
        Get.snackbar(
            "Logueado con Exito", "Disfruta de una maravillosa Experiencia !!",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));
        if (data.verification == false) {
          Get.offAll(() => const VerificationPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.offAll(() => MainScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Fallo Login, Por favor Intente de Nuevo",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Fallo Login, Por favor Intente de Nuevo",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void logout() {
    box.erase();
    Get.offAll(() => MainScreen(),
        transition: Transition.fade, duration: const Duration(seconds: 2));
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void deleteAccount() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;
        box.erase();
        Get.offAll(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete, please try again",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
