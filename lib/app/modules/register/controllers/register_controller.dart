import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_bustix_app/app/modules/login/views/login_view.dart';
import 'package:my_bustix_app/app/utils/api.dart';

class RegisterController extends GetxController {
  final _getConnect = GetConnect();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final authToken = GetStorage();

  void registerNow() async {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
      );
      return;
    }

    if (passwordController.text != passwordConfirmationController.text) {
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak cocok',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
      );
      return;
    }

    try {
      final response = await _getConnect.post(BaseUrl.register, {
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      });

      if (response.statusCode == 201) {
        // authToken.write('token', response.body['token']);
        // print("register berhasil token yang di simpan $authToken");
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Error',
          response.body['error']?.toString() ?? 'Terjadi kesalahan saat registrasi',
          icon: const Icon(Icons.error),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          forwardAnimationCurve: Curves.bounceIn,
          margin: const EdgeInsets.only(
            top: 10,
            left: 5,
            right: 5,
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Exception',
        'Terjadi kesalahan jaringan atau server',
        icon: const Icon(Icons.error),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        forwardAnimationCurve: Curves.bounceIn,
        margin: const EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
        ),
      );
      print("Exception saat registrasi: \$e");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }
}
