import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:my_bustix_app/app/utils/api.dart';
import '../../result_tiket/views/result_tiket_view.dart';

class HomeController extends GetxController {
  // Dropdown lists
  var kategoriList = <Map<String, dynamic>>[].obs; 
  var startList = <String>[].obs;
  var endList = <String>[].obs;
  var isLoadingDropdown = true.obs;
  var isLoadingSearch = false.obs;

  // Selected values
  var selectedKategori = Rxn<Map<String, dynamic>>(); // ✅ Perbaikan di sini
  var selectedStart = ''.obs;
  var selectedEnd = ''.obs;
  var selectedDate = Rx<DateTime?>(null);

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // Pastikan login
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    final token = box.read('token');
    print('TOKEN YANG DIKIRIM: $token');
    isLoadingDropdown.value = true;

    if (token == null) {
      print("Token tidak ditemukan, hentikan fetchDropdownData.");
      isLoadingDropdown.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.dropdownOptions),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Status Code Dropdown: ${response.statusCode}");
      print("Response Body Dropdown: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<Map<String, dynamic>> categories = [];
        int id = 1;
        for (var name in data['categories']) {
          categories.add({'id': id, 'name': name});
          id++;
        }

        kategoriList.assignAll(categories);
        startList.assignAll(List<String>.from(data['start_routes'] ?? []));
        endList.assignAll(List<String>.from(data['end_routes'] ?? []));

        print("Dropdown berhasil dimuat.");
      } else {
        Get.snackbar('Error', 'Gagal mengambil data dropdown');
      }
    } catch (e) {
      print("Terjadi kesalahan saat fetch dropdown: $e");
      Get.snackbar('Exception', 'Terjadi kesalahan jaringan atau parsing');
    } finally {
      isLoadingDropdown.value = false;
    }
  }

  void searchRute() async {
    if (selectedKategori.value == null ||
        selectedStart.value.isEmpty ||
        selectedEnd.value.isEmpty ||
        selectedDate.value == null) {
      Get.snackbar("Oops", "Semua field wajib diisi");
      return;
    }

    isLoadingSearch.value = true;
    final token = box.read('token');

    final body = {
      'category_id': selectedKategori.value!['id'].toString(), // ✅ Ambil id dari Map
      'start': selectedStart.value,
      'end': selectedEnd.value,
      'waktu': selectedDate.value!.toIso8601String().split('T').first,
    };

    try {
      final response = await http.post(
        Uri.parse(BaseUrl.searchRute),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: body,
      );

      print("Status Code Search: ${response.statusCode}");
      print("Response Body Search: ${response.body}");

      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.to(() => ResultView(hasil: resData['data']));
      } else {
        Get.snackbar("Gagal", resData['message'] ?? 'Data tidak ditemukan');
      }
    } catch (e) {
      print("Error saat search rute: $e");
      Get.snackbar("Exception", "Terjadi kesalahan saat mencari rute");
    } finally {
      isLoadingSearch.value = false;
    }
  }

  void logoutNow() {
    final token = box.read('token');

    http.post(
      Uri.parse(BaseUrl.logout),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).then((value) {
      box.remove('token');
      Get.offAllNamed('/login');
    });
  }

  void checkLoginStatus() {
    final token = box.read('token');

    Future.delayed(Duration(milliseconds: 100), () {
      if (token == null) {
        print("Token tidak ditemukan, redirect ke login.");
        Get.offAllNamed('/login');
      }
    });
  }
}
