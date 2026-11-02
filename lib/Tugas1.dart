import 'dart:math';

// 3. Membuat class DataSensor untuk menampung objek suhu
class DataSensor {
  final double nilaiSuhu;
  final String status;

  DataSensor(this.nilaiSuhu) : status = statusSuhu(nilaiSuhu);
}

// 2. Fungsi statusSuhu() menerima angka suhu dan mengembalikan statusnya
String statusSuhu(double nilaiSuhu) {
  if (nilaiSuhu >= 35.2) {
    return "Panas";
  } else {
    return "Normal";
  }
}

void main() {
  // 1. Buat List berisi 5 data suhu
  List<double> suhu = [32.0, 33.5, 34.7, 35.2, 36.5];

  // 1. Menghitung rata-rata
  double total = 0;
  for (var s in suhu) {
    total += s;
  }

  // 1. Cetak Rata-rata dan Suhu Tertinggi
  double rataRata = total / suhu.length;
  double tertinggi = suhu.reduce(max);

  print("Rata-rata Suhu : ${rataRata.toStringAsFixed(2)} °C");
  print("Suhu Tertinggi : $tertinggi °C");
  print("--------------------------------");

  // 3. Mengubah setiap data suhu menjadi objek DataSensor
  List<DataSensor> daftarSensor = suhu.map((s) => DataSensor(s)).toList();

  print("Data yang terlalu panas:");
  // 3. Cetak hanya data yang terlalu panas.
  for (var data in daftarSensor) {
    if (data.status == "Panas") {
      print("- Suhu: ${data.nilaiSuhu} °C [Status: ${data.status}]");
    }
  }
}
