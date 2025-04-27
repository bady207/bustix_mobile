import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_bustix_app/app/routes/app_pages.dart';
import 'package:my_bustix_app/app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final authToken = GetStorage();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void loginNow() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Password wajib diisi!',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final response = await _getConnect.post(
      BaseUrl.login,
      {
        'username': usernameController.text,
        'password': passwordController.text,
      },
      headers: {
        'Accept': 'application/json',
      },
    );
        
    print('=== DEBUG LOGIN ===');
    print('Status Code: ${response.statusCode}');
    print('Raw Response Body: ${response.bodyString}');

    isLoading.value = false;

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.bodyString!);
        print('Parsed Data: $data');

        final token = data['access_token']; 
        final type = data['token_type'] ?? 'Bearer';

        if (token != null) {
          await authToken.write('token', token);
          await authToken.write('token_type', type);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          print('Token yang disimpan: ${authToken.read('token')}'); // ✅ Harus tampil


          Get.offAllNamed(Routes.MAIN); // pakai routing
        } else {
          Get.snackbar(
            'Login Gagal',
            'Token tidak ditemukan di response!',
            icon: const Icon(Icons.error),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        String errorMessage = 'Login gagal. Cek kembali email dan password.';
        try {
          final errorData = json.decode(response.bodyString!);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (_) {}

        Get.snackbar(
          'Login Gagal',
          errorMessage,
          icon: const Icon(Icons.error),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal parsing data! ${e.toString()}',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
