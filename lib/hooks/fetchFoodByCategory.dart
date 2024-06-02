import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sopefoodusuario/constants/constants.dart';
import 'package:sopefoodusuario/models/api_error.dart';
import 'package:sopefoodusuario/models/environment.dart';
import 'package:sopefoodusuario/models/foods.dart';
import 'package:sopefoodusuario/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchFoodByCategory(id, code) {
  final foodList = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url =
          Uri.parse('${Environment.appBaseUrl}/api/foods/categories/$id/$code');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        foodList.value = foodFromJson(response.body);
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kRed,
          colorText: kWhite,
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      isLoading.value = false;
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: foodList.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
