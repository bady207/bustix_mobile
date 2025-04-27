import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterController controller = Get.put(RegisterController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor('#2193b0'), // biru muda
              HexColor('#6dd5ed'), // biru terang
              HexColor('#1e3c72'), // biru gelap
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Lottie.asset(
                  'asset/lottie/tiket.json',
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: controller.nameController,
                        label: "Full Name",
                        hint: "Masukan Nama",
                        icon: Icons.person,
                      ),
                      _buildTextField(
                        controller: controller.usernameController,
                        label: "Email",
                        hint: "Masukan Email",
                        icon: Icons.email,
                      ),
                      _buildTextField(
                        controller: controller.passwordController,
                        label: "Password",
                        hint: "Masukan Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      _buildTextField(
                        controller: controller.passwordConfirmationController,
                        label: "Password Confirmation",
                        hint: "Masukan Ulang Password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.registerNow();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor('#1e3c72'), // biru gelap
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}