import 'package:flutter/material.dart';
import '../models/perpustakaan.dart';
import '../services/api_service.dart';
import 'perpustakaan_detail_page.dart';
import 'tambah_perpustakaan_page.dart';
import 'edit_perpustakaan_page.dart';

class PerpustakaanListPage extends StatefulWidget {
  const PerpustakaanListPage({super.key});

  @override
  State<PerpustakaanListPage> createState() => _PerpustakaanListPageState();
}

class _PerpustakaanListPageState extends State<PerpustakaanListPage> {
  late Future<List<Perpustakaan>> _perpustakaanList;

  @override
  void initState() {
    super.initState();
    _perpustakaanList = ApiService.fetchPerpustakaan();
  }

  void _refreshData() {
    setState(() {
      _perpustakaanList = ApiService.fetchPerpustakaan();
    });
  }

  void _hapusData(int no) async {
    try {
      await ApiService.deletePerpustakaan(no);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data berhasil dihapus')),
      );
      _refreshData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menghapus data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Daftar Perpustakaan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Perpustakaan>>(
        future: _perpustakaanList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('📭 Tidak ada data perpustakaan'));
          }

          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final perpustakaan = data[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.school, color: Colors.indigo),
                    ),
                    title: Text(
                      perpustakaan.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(perpustakaan.alamat),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PerpustakaanDetailPage(perpustakaan: perpustakaan),
                        ),
                      ).then((_) => _refreshData());
                    },
                    trailing: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPerpustakaanPage(perpustakaan: perpustakaan),
                            ),
                          );
                          if (result == true) _refreshData();
                        } else if (value == 'hapus') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Data'),
                              content: const Text('Yakin ingin menghapus data ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) _hapusData(perpustakaan.no!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
                        const PopupMenuItem(value: 'hapus', child: Text('🗑️ Hapus')),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPerpustakaanPage()),
          );
          if (result == true) _refreshData();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
