import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Tiket'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Apakah kamu yakin ingin logout?",
                textConfirm: "Ya",
                textCancel: "Batal",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  controller.logoutNow();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingDropdown.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(
                () => DropdownButton<Map<String, dynamic>>(
                  isExpanded: true,
                  hint: Text("Pilih kategori"),
                  value: controller.selectedKategori.value,
                  items: controller.kategoriList.map((kategori) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: kategori,
                      child: Text(kategori['name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedKategori.value =
                          value; // simpan sebagai map
                    }
                  },
                ),
              ), // <-- DITAMBAH PENUTUP DI SINI

              SizedBox(height: 16),
              Text("Rute Awal", style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("-- Pilih Rute Awal --"),
                    value: controller.selectedStart.value == ''
                        ? null
                        : controller.selectedStart.value,
                    items: controller.startList
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (val) => controller.selectedStart.value = val!,
                  )),
              SizedBox(height: 16),
              Text("Rute Akhir", style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("-- Pilih Rute Akhir --"),
                    value: controller.selectedEnd.value == ''
                        ? null
                        : controller.selectedEnd.value,
                    items: controller.endList
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (val) => controller.selectedEnd.value = val!,
                  )),
              SizedBox(height: 16),
              Text("Tanggal", style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => ListTile(
                    title: Text(
                      controller.selectedDate.value == null
                          ? 'Pilih Tanggal'
                          : '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        controller.selectedDate.value = picked;
                    },
                  )),
              SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoadingSearch.value
                        ? null
                        : () => controller.searchRute(),
                    child: controller.isLoadingSearch.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Cari Tiket'),
                  )),
            ],
          ),
        );
      }),
    );
  }
}
