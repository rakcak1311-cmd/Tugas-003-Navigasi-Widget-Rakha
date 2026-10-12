
import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import 'form_mahasiswa_page.dart';

class DetailResult {
  final Mahasiswa? mahasiswa;

  const DetailResult.updated(Mahasiswa this.mahasiswa);
  const DetailResult.deleted() : mahasiswa = null;
}

class DetailMahasiswaPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final Set<String> nimLain;

  const DetailMahasiswaPage({
    super.key,
    required this.mahasiswa,
    required this.nimLain,
  });

  @override
  State<DetailMahasiswaPage> createState() =>
      _DetailMahasiswaPageState();
}

class _DetailMahasiswaPageState extends State<DetailMahasiswaPage> {
  Future<void> _edit() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (_) => FormMahasiswaPage(
          mahasiswa: widget.mahasiswa,
          nimTerpakai: widget.nimLain,
        ),
      ),
    );

    if (!mounted || result == null) return;
    Navigator.pop(context, DetailResult.updated(result));
  }

  Future<void> _hapus() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus mahasiswa?'),
        content: Text(
          'Data ${widget.mahasiswa.nama} '
          '(${widget.mahasiswa.nim}) akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    Navigator.pop(context, const DetailResult.deleted());
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mahasiswa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mahasiswa'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              CircleAvatar(
                radius: 48,
                child: m.fotoProfil == null
                    ? const Icon(Icons.school_outlined, size: 48)
                    : ClipOval(
                        child: Image.network(
                          m.fotoProfil!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person),
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              _item('NIM', m.nim),
              _item('Nama Lengkap', m.nama),
              _item('Nama Panggilan', m.namaPanggilan),
              _item('Email', m.email),
              _item('Nomor HP', m.nomorHp),
              _item('Jenis Kelamin', m.jenisKelamin),
              _item(
                'Tanggal Lahir',
                m.tanggalLahir == null
                    ? '-'
                    : '${m.tanggalLahir!.day}/'
                      '${m.tanggalLahir!.month}/'
                      '${m.tanggalLahir!.year}',
              ),
              _item('Tempat Lahir', m.tempatLahir),
              _item('Agama', m.agama),
              _item('Program Studi', m.prodi),
              _item('Semester', '${m.semester}'),
              _item('Kelas', m.kelas),
              _item('Status Mahasiswa', m.status),
              _item('IPK', m.ipk.toStringAsFixed(2)),
              _item('Penerima Beasiswa', m.beasiswa ? 'Ya' : 'Tidak'),
              _item(
                'Bersedia Magang',
                m.bersediaMagang ? 'Ya' : 'Tidak',
              ),
              _item(
                'Minat',
                m.minat.isEmpty ? '-' : m.minat.join(', '),
              ),
              _item('Alamat', m.alamat),
              _item('Provinsi', m.provinsi),
              _item('Kota/Kabupaten', m.kota),
              _item('Dokumen KTM', m.dokumenKtm ?? '-'),
              _item('Warna Profil', m.warnaProfil),
              _item(
                'Persetujuan Data',
                m.persetujuanData ? 'Setuju' : 'Belum setuju',
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _edit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Data'),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _hapus,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus Data'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String judul, String isi) {
    return ListTile(
      title: Text(judul),
      subtitle: Text(isi.isEmpty ? '-' : isi),
    );
  }
}
