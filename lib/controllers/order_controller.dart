// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/api_error.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/models/order_item.dart';
import 'package:sopefoodusuario/models/order_response.dart';
import 'package:sopefoodusuario/models/payment_request.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  final box = GetStorage();

  Order? order;

  void set setOrder(Order newValue) {
    order = newValue;
  }

  final RxString _paymentUrl = ''.obs;

  String get paymentUrl => _paymentUrl.value;

  set paymentUrl(String newValue) {
    _paymentUrl.value = newValue;
  }

  final RxString _orderId = ''.obs;

  String get orderId => _orderId.value;

  set orderId(String newValue) {
    _orderId.value = newValue;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxBool _iconChanger = false.obs;

  bool get iconChanger => _iconChanger.value;

  set setIcon(bool newValue) {
    _iconChanger.value = newValue;
  }

  void createOrder(String order, Order item) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: order,
      );

      if (response.statusCode == 201) {
        setLoading = false;
        OrderResponse data = orderResponseFromJson(response.body);

        orderId = data.orderId;

        Get.snackbar("Order creada Stisfactorimante", data.message,
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.money));

        Payment payment = Payment(userId: item.userId, cartItems: [
          CartItem(
              name: item.orderItems[0].foodId,
              id: orderId,
              price: item.grandTotal,
              quantity: 1,
              restaurantId: item.restaurantId)
        ]);

        String paymentData = paymentToJson(payment);
        paymentFunction(paymentData);
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
            data.message, "Fallo al crear la Orden, por favor intente de nuevo",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(
          e.toString(), "Fallo al crear la Orden, por favor intente de nuevo",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void paymentFunction(String payment) async {
    setLoading = true;
    var url =
        Uri.parse('${Environment.paymentUrl}/stripe/create-checkout-session');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: payment,
      );

      if (response.statusCode == 200) {
        var urlData = jsonDecode(response.body);

        paymentUrl = urlData['url'];
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }
}
