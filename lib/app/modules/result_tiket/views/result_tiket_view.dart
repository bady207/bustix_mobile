import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultView extends StatelessWidget {
  final List<dynamic> hasil;

  ResultView({required this.hasil});

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text("Hasil Tiket"),
        centerTitle: true,
      ),
      body: hasil.isEmpty
          ? Center(
              child: Text(
                "Tidak ada tiket ditemukan",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: hasil.length,
              itemBuilder: (context, index) {
                final tiket = hasil[index];
                final hargaFormatted = currencyFormatter
                    .format(int.tryParse(tiket['harga'].toString()) ?? 0);

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.airplane_ticket_outlined,
                                color: Colors.blue[700]),
                            SizedBox(width: 8),
                            Text(
                              "Kategori: ${tiket['kategori'] ?? 'Kategori tidak diketahui'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Harga: $hargaFormatted",
                            style: TextStyle(
                                fontSize: 15, color: Colors.green[700])),
                        SizedBox(height: 4),
                        Text("Dari: ${tiket['start']}",
                            style: TextStyle(fontSize: 14)),
                        Text("Ke: ${tiket['end']}",
                            style: TextStyle(fontSize: 14)),
                        Text("Tanggal: ${tiket['waktu']}",
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
