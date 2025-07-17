class Perpustakaan {
  int? no;
  String nama;
  String alamat;
  String noTelepon;
  String kategori;
  double latitude;
  double longitude;


  Perpustakaan({
    this.no,
    required this.nama,
    required this.alamat,
    required this.noTelepon,
    required this.kategori,
    required this.latitude,
    required this.longitude,

  });

  factory Perpustakaan.fromJson(Map<String, dynamic> json) {
    return Perpustakaan(
      no: json['no'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      kategori: json['kategori'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'no_telepon': noTelepon,
      'kategori': kategori,
      'latitude': latitude,
      'longitude': longitude,

    };
  }
}
