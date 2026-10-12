import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import 'detail_mahasiswa_page.dart';
import 'form_mahasiswa_page.dart';

class ListMahasiswaPage extends StatefulWidget {
  const ListMahasiswaPage({super.key});

  @override
  State<ListMahasiswaPage> createState() => _ListMahasiswaPageState();
}

class _ListMahasiswaPageState extends State<ListMahasiswaPage> {
  final _search = TextEditingController();

  final _mahasiswa = <Mahasiswa>[
    const Mahasiswa(
      nim: '2026001',
      nama: 'Andi Pratama',
      namaPanggilan: 'Andi',
      email: 'andi@kampus.ac.id',
      nomorHp: '081234567890',
      password: 'andi123',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Bogor',
      agama: 'Islam',
      prodi: 'Teknik Informatika',
      semester: 1,
      kelas: 'A',
      status: 'Aktif',
      ipk: 3.50,
      beasiswa: false,
      bersediaMagang: true,
      minat: ['Mobile', 'Web'],
      alamat: 'Bogor, Jawa Barat',
      provinsi: 'Jawa Barat',
      kota: 'Bogor',
      warnaProfil: 'Biru',
      persetujuanData: true,
    ),
    const Mahasiswa(
      nim: '2026002',
      nama: 'Siti Aisyah',
      namaPanggilan: 'Siti',
      email: 'siti@kampus.ac.id',
      nomorHp: '081234567891',
      password: 'siti123',
      jenisKelamin: 'Perempuan',
      tempatLahir: 'Depok',
      agama: 'Islam',
      prodi: 'Sistem Informasi',
      semester: 2,
      kelas: 'B',
      status: 'Aktif',
      ipk: 3.75,
      beasiswa: true,
      bersediaMagang: true,
      minat: ['UI/UX', 'Data'],
      alamat: 'Depok, Jawa Barat',
      provinsi: 'Jawa Barat',
      kota: 'Depok',
      warnaProfil: 'Ungu',
      persetujuanData: true,
    ),
    const Mahasiswa(
      nim: '2026003',
      nama: 'Budi Santoso',
      namaPanggilan: 'Budi',
      email: 'budi@kampus.ac.id',
      nomorHp: '081234567892',
      password: 'budi123',
      jenisKelamin: 'Laki-laki',
      tempatLahir: 'Bandung',
      agama: 'Islam',
      prodi: 'Manajemen',
      semester: 3,
      kelas: 'C',
      status: 'Aktif',
      ipk: 3.25,
      beasiswa: false,
      bersediaMagang: false,
      minat: ['Data'],
      alamat: 'Bandung, Jawa Barat',
      provinsi: 'Jawa Barat',
      kota: 'Bandung',
      warnaProfil: 'Hijau',
      persetujuanData: true,
    ),
  ];

  // Controller form
  final _nim = TextEditingController();
  final _nama = TextEditingController();
  final _panggilan = TextEditingController();
  final _email = TextEditingController();
  final _hp = TextEditingController();
  final _password = TextEditingController();
  final _tempatLahir = TextEditingController();
  final _alamat = TextEditingController();

  String _gender = 'Laki-laki';
  DateTime? _tanggalLahir;
  String _agama = 'Islam';
  String _prodi = 'Teknik Informatika';
  int _semester = 1;
  String _kelas = 'A';
  String _status = 'Aktif';
  double _ipk = 2.0;
  bool _beasiswa = false;
  bool _magang = false;
  final Set<String> _minat = {};
  String _provinsi = 'Jawa Barat';
  String _kota = 'Bogor';
  String _warna = 'Biru';
  bool _persetujuan = false;

  final List<String> _warnaPilihan = [
    'Biru',
    'Merah',
    'Hijau',
    'Oranye',
    'Ungu',
    'Teal',
  ];

  @override
  void dispose() {
    _search.dispose();
    _nim.dispose();
    _nama.dispose();
    _panggilan.dispose();
    _email.dispose();
    _hp.dispose();
    _password.dispose();
    _tempatLahir.dispose();
    _alamat.dispose();
    super.dispose();
  }

  Set<String> _nimTerpakai([Mahasiswa? except]) {
    return _mahasiswa
        .where((item) => item != except)
        .map((item) => item.nim.toLowerCase())
        .toSet();
  }

  void _pesan(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _tambah() async {
    final result = await Navigator.push<Mahasiswa>(
      context,
      MaterialPageRoute(
        builder: (_) => FormMahasiswaPage(
          nimTerpakai: _nimTerpakai(),
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() => _mahasiswa.add(result));
    _pesan('Data mahasiswa berhasil ditambahkan');
  }

  Future<void> _detail(Mahasiswa mahasiswa) async {
    final result = await Navigator.push<DetailResult>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailMahasiswaPage(
          mahasiswa: mahasiswa,
          nimLain: _nimTerpakai(mahasiswa),
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      final index = _mahasiswa.indexOf(mahasiswa);
      if (index < 0) return;

      if (result.mahasiswa == null) {
        _mahasiswa.removeAt(index);
      } else {
        _mahasiswa[index] = result.mahasiswa!;
      }
    });

    _pesan(
      result.mahasiswa == null
          ? 'Data mahasiswa berhasil dihapus'
          : 'Data mahasiswa berhasil diperbarui',
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboard,
    bool obscure = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown<T>(
    String label,
    T value,
    List<T> items,
    ValueChanged<T?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text('$item'),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _resetForm() {
    _nim.clear();
    _nama.clear();
    _panggilan.clear();
    _email.clear();
    _hp.clear();
    _password.clear();
    _tempatLahir.clear();
    _alamat.clear();

    _gender = 'Laki-laki';
    _tanggalLahir = null;
    _agama = 'Islam';
    _prodi = 'Teknik Informatika';
    _semester = 1;
    _kelas = 'A';
    _status = 'Aktif';
    _ipk = 2;
    _beasiswa = false;
    _magang = false;
    _minat.clear();
    _provinsi = 'Jawa Barat';
    _kota = 'Bogor';
    _warna = 'Biru';
    _persetujuan = false;
  }

  Future<void> _bukaForm25() async {
    final formKey = GlobalKey<FormState>();

    final simpan = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Form Data Mahasiswa'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _field(
                      'NIM',
                      _nim,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'NIM wajib diisi';
                        }
                        return null;
                      },
                    ),
                    _field(
                      'Nama Lengkap',
                      _nama,
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Nama wajib diisi'
                              : null,
                    ),
                    _field('Nama Panggilan', _panggilan),
                    _field(
                      'Email',
                      _email,
                      keyboard: TextInputType.emailAddress,
                    ),
                    _field(
                      'No. HP',
                      _hp,
                      keyboard: TextInputType.phone,
                    ),
                    _field(
                      'Password Portal',
                      _password,
                      obscure: true,
                    ),

                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Jenis Kelamin'),
                    ),
                    RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _gender,
                      onChanged: (v) =>
                          setDialogState(() => _gender = v!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _gender,
                      onChanged: (v) =>
                          setDialogState(() => _gender = v!),
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tanggal Lahir'),
                      subtitle: Text(
                        _tanggalLahir == null
                            ? 'Belum dipilih'
                            : '${_tanggalLahir!.day}/'
                                '${_tanggalLahir!.month}/'
                                '${_tanggalLahir!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final hasil = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2005),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                        );

                        if (hasil != null) {
                          setDialogState(
                            () => _tanggalLahir = hasil,
                          );
                        }
                      },
                    ),

                    _field('Tempat Lahir', _tempatLahir),

                    _dropdown<String>(
                      'Agama',
                      _agama,
                      [
                        'Islam',
                        'Kristen',
                        'Katolik',
                        'Hindu',
                        'Buddha',
                        'Konghucu',
                      ],
                      (v) => setDialogState(() => _agama = v!),
                    ),

                    _dropdown<String>(
                      'Program Studi',
                      _prodi,
                      [
                        'TRM',
                        'Teknik Informatika',
                        'Sistem Informasi',
                        'Manajemen',
                      ],
                      (v) => setDialogState(() => _prodi = v!),
                    ),

                    _dropdown<int>(
                      'Semester',
                      _semester,
                      List.generate(8, (i) => i + 1),
                      (v) => setDialogState(() => _semester = v!),
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Kelas'),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'A',
                          label: Text('A'),
                        ),
                        ButtonSegment(
                          value: 'B',
                          label: Text('B'),
                        ),
                        ButtonSegment(
                          value: 'C',
                          label: Text('C'),
                        ),
                      ],
                      selected: {_kelas},
                      onSelectionChanged: (v) =>
                          setDialogState(() => _kelas = v.first),
                    ),

                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Status Mahasiswa'),
                    ),
                    Wrap(
                      spacing: 8,
                      children: ['Aktif', 'Cuti', 'Lulus']
                          .map(
                            (s) => ChoiceChip(
                              label: Text(s),
                              selected: _status == s,
                              onSelected: (_) =>
                                  setDialogState(() => _status = s),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 12),
                    Text('IPK: ${_ipk.toStringAsFixed(2)}'),
                    Slider(
                      value: _ipk,
                      min: 0,
                      max: 4,
                      divisions: 400,
                      label: _ipk.toStringAsFixed(2),
                      onChanged: (v) =>
                          setDialogState(() => _ipk = v),
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Penerima Beasiswa'),
                      value: _beasiswa,
                      onChanged: (v) =>
                          setDialogState(() => _beasiswa = v),
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Bersedia Magang'),
                      value: _magang,
                      onChanged: (v) =>
                          setDialogState(() => _magang = v ?? false),
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Minat'),
                    ),
                    Wrap(
                      spacing: 8,
                      children: ['Mobile', 'Web', 'AI', 'UI/UX', 'Data']
                          .map(
                            (m) => FilterChip(
                              label: Text(m),
                              selected: _minat.contains(m),
                              onSelected: (selected) {
                                setDialogState(() {
                                  if (selected) {
                                    _minat.add(m);
                                  } else {
                                    _minat.remove(m);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),

                    _field(
                      'Alamat Lengkap',
                      _alamat,
                      maxLines: 3,
                    ),

                    _dropdown<String>(
                      'Provinsi',
                      _provinsi,
                      [
                        'Jawa Barat',
                        'DKI Jakarta',
                        'Jawa Tengah',
                        'Jawa Timur',
                        'Banten',
                        'DI Yogyakarta',
                      ],
                      (v) => setDialogState(() {
                        _provinsi = v!;
                        _kota = v == 'Jawa Barat' ? 'Bogor' : '';
                      }),
                    ),

                    _dropdown<String>(
                      'Kota/Kabupaten',
                      _kota,
                      _provinsi == 'Jawa Barat'
                          ? ['Bogor', 'Depok', 'Bandung', 'Bekasi']
                          : _provinsi == 'DKI Jakarta'
                              ? [
                                  'Jakarta Pusat',
                                  'Jakarta Barat',
                                  'Jakarta Selatan',
                                  'Jakarta Timur',
                                  'Jakarta Utara',
                                ]
                              : ['Kota', 'Kabupaten'],
                      (v) => setDialogState(() => _kota = v!),
                    ),

                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Foto Profil'),
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: _warnaWarna(_warna),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const Text(
                      'Pemilih foto belum dihubungkan',
                      style: TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Dokumen / KTM'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _pesan('Pemilih dokumen belum dihubungkan'),
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Pilih Dokumen'),
                    ),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Warna Profil'),
                    ),
                    Wrap(
                      spacing: 12,
                      children: _warnaPilihan.map((w) {
                        final warna = _warnaWarna(w);
                        return GestureDetector(
                          onTap: () =>
                              setDialogState(() => _warna = w),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: warna,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _warna == w
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: _warna == w
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Saya menyetujui penggunaan data mahasiswa',
                      ),
                      value: _persetujuan,
                      onChanged: (v) => setDialogState(
                        () => _persetujuan = v ?? false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                if (!_persetujuan) {
                  _pesan(
                    'Centang persetujuan data terlebih dahulu',
                  );
                  return;
                }

                Navigator.pop(dialogContext, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    if (!mounted || simpan != true) return;

    if (_nimTerpakai().contains(_nim.text.trim().toLowerCase())) {
      _pesan('NIM sudah digunakan');
      return;
    }

    setState(() {
      _mahasiswa.add(
        Mahasiswa(
          nim: _nim.text.trim(),
          nama: _nama.text.trim(),
          namaPanggilan: _panggilan.text.trim(),
          email: _email.text.trim(),
          nomorHp: _hp.text.trim(),
          password: _password.text,
          jenisKelamin: _gender,
          tanggalLahir: _tanggalLahir,
          tempatLahir: _tempatLahir.text.trim(),
          agama: _agama,
          prodi: _prodi,
          semester: _semester,
          kelas: _kelas,
          status: _status,
          ipk: _ipk,
          beasiswa: _beasiswa,
          bersediaMagang: _magang,
          minat: _minat.toList(),
          alamat: _alamat.text.trim(),
          provinsi: _provinsi,
          kota: _kota,
          warnaProfil: _warna,
          persetujuanData: _persetujuan,
        ),
      );

      _resetForm();
    });

    _pesan('Data mahasiswa berhasil ditambahkan');
  }

  Color _warnaWarna(String warna) {
    switch (warna) {
      case 'Merah':
        return Colors.red;
      case 'Hijau':
        return Colors.green;
      case 'Oranye':
        return Colors.orange;
      case 'Ungu':
        return Colors.purple;
      case 'Teal':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _search.text.trim().toLowerCase();

    final filtered = _mahasiswa.where((item) {
      return item.nama.toLowerCase().contains(keyword) ||
          item.nim.toLowerCase().contains(keyword) ||
          item.prodi.toLowerCase().contains(keyword) ||
          item.nomorHp.toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        actions: [
          IconButton(
            tooltip: 'Form 25 Widget',
            onPressed: _bukaForm25,
            icon: const Icon(Icons.assignment_add),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('Manajemen Mahasiswa'),
              ),
              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Daftar Mahasiswa'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.person_add_outlined),
                title: const Text('Tambah Mahasiswa'),
                onTap: () {
                  Navigator.pop(context);
                  _tambah();
                },
              ),
              ListTile(
                leading: const Icon(Icons.widgets_outlined),
                title: const Text('Form 25 Widget'),
                onTap: () {
                  Navigator.pop(context);
                  _bukaForm25();
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Cari nama, NIM, atau program studi',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(_search.clear),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filtered.length} dari ${_mahasiswa.length} mahasiswa',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          _mahasiswa.isEmpty
                              ? 'Belum ada mahasiswa. Tambahkan data baru.'
                              : 'Mahasiswa tidak ditemukan.',
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 96),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final mahasiswa = filtered[index];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _warnaWarna(
                                mahasiswa.warnaProfil,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(mahasiswa.nama),
                            subtitle: Text(
                              '${mahasiswa.nim} • ${mahasiswa.prodi}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _detail(mahasiswa),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Mahasiswa'),
      ),
    );
  }
}