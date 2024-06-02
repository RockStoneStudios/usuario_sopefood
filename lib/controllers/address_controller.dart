// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/all_addresses.dart';
import 'package:sopefoodusuario/models/api_error.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/views/entrypoint.dart';
import 'package:sopefoodusuario/views/profile/address.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  final box = GetStorage();
  AddressesList? defaultAddress;
  Location? userLoc;
  String? userAddress;

  // Reactive state
  var _address = false.obs;

  // Getter
  bool get address => _address.value;

  // Setter
  set setAddress(bool newValue) {
    _address.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void addAddress(String address) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: address,
      );

      if (response.statusCode == 201) {
        setLoading = false;

        Get.snackbar("Direccion Agregada Correcta",
            "Gracias por agregar la dirección, ahora puedes pedir domicilios",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.off(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message,
            "No se pudo agregar la dirección, inténtelo nuevamente",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(
          e.toString(), "No se pudo agregar la dirección, inténtelo nuevamente",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void setDefaultAddress(String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address/default/$id');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        Get.snackbar("Dirección por defectto actualizada correctamente",
            "Gracias por actualizar la dirección, ahora puedes pedir domicilios",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.off(() => const Addresses(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message,
            "No se pudo actualizar la dirección, inténtelo nuevamente",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(),
          "No se pudo actualizar la dirección, inténtelo nuevamente",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  var _index = 0.obs;
  // Getter
  int get getIndex => _index.value;

  // Setter
  set setIndex(int newValue) {
    _index.value = newValue;
  }

  var _dfSwitch = false;

  // Getter
  bool get dfSwitch => _dfSwitch;

  // Setter
  set setDfSwitch(bool newValue) {
    _dfSwitch = newValue;
  }
}
