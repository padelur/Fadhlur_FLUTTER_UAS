import 'package:flutter/material.dart';
import '../models/perpustakaan.dart';
import '../services/api_service.dart';

class TambahPerpustakaanPage extends StatefulWidget {
  const TambahPerpustakaanPage({super.key});

  @override
  State<TambahPerpustakaanPage> createState() => _TambahPerpustakaanPageState();
}

class _TambahPerpustakaanPageState extends State<TambahPerpustakaanPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  final kategoriController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();


  bool _isLoading = false;

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Perpustakaan perpustakaan = Perpustakaan(
        nama: namaController.text,
        alamat: alamatController.text,
        noTelepon: teleponController.text,
        kategori: kategoriController.text,
        latitude: double.parse(latitudeController.text),
        longitude: double.parse(longitudeController.text),

      );

      try {
        await ApiService.createPerpustakaan(perpustakaan);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Data berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal menambahkan data: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    teleponController.dispose();
    kategoriController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tambah Perpustakaan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Form Tambah Perpustakaan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              const Text(
                'Silakan lengkapi data perpustakaan di bawah ini.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildTextField(namaController, 'Nama Perpustakaan', icon: Icons.library_books),
              _buildTextField(alamatController, 'Alamat', icon: Icons.location_on),
              _buildTextField(teleponController, 'No. Telepon', icon: Icons.phone),
              _buildTextField(kategoriController, 'Kategori', icon: Icons.category),
              _buildTextField(latitudeController, 'Latitude', icon: Icons.map, isNumber: true),
              _buildTextField(longitudeController, 'Longitude', icon: Icons.map, isNumber: true),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _simpanData,
                icon: const Icon(Icons.save, color: Colors.white),
                label: _isLoading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize: const Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
      ),
    );
  }
}
