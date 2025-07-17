import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/perpustakaan.dart';

class PerpustakaanDetailPage extends StatelessWidget {
  final Perpustakaan perpustakaan;

  const PerpustakaanDetailPage({Key? key, required this.perpustakaan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng posisi = LatLng(perpustakaan.latitude, perpustakaan.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(perpustakaan.nama,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.library_books),
            title: Text(
              perpustakaan.nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Alamat'),
            subtitle: Text(perpustakaan.alamat),
          ),
          ListTile(
            title: const Text('No Telepon'),
            subtitle: Text(perpustakaan.noTelepon),
          ),
          ListTile(
            title: const Text('Kategori'),
            subtitle: Text(perpustakaan.kategori),
          ),
          ListTile(
            title: const Text('Koordinat'),
            subtitle: Text('(${perpustakaan.latitude}, ${perpustakaan.longitude})'),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lokasi Perpustakaan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: posisi,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('lokasiPerpustakaan'),
                  position: posisi,
                  infoWindow: InfoWindow(title: perpustakaan.nama),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
