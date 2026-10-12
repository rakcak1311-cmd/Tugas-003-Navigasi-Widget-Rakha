
import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';

class FormMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswa;
  final Set<String> nimTerpakai;

  const FormMahasiswaPage({
    super.key,
    this.mahasiswa,
    required this.nimTerpakai,
  });

  @override
  State<FormMahasiswaPage> createState() =>
      _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nim;
  late final TextEditingController _nama;
  late final TextEditingController _panggilan;
  late final TextEditingController _email;
  late final TextEditingController _hp;
  late final TextEditingController _password;
  late final TextEditingController _tempatLahir;
  late final TextEditingController _alamat;

  String? jenisKelamin;
  String? agama;
  String? prodi;
  int semester = 1;
  String kelas = 'A';
  String status = 'Aktif';
  double ipk = 3.00;
  bool beasiswa = false;
  bool magang = false;
  bool setuju = false;

  DateTime? tanggalLahir;

  String provinsi = 'Jawa Barat';
  String kota = 'Bogor';
  String warnaProfil = 'Biru';

  final Set<String> minatDipilih = {};

  final List<String> agamaList = [
    'Islam', 'Kristen', 'Katolik',
    'Hindu', 'Buddha', 'Konghucu',
  ];

  final List<String> prodiList = ['TRM', 'TI', 'SI'];
  final List<String> kelasList = ['A', 'B', 'C'];
  final List<String> statusList = ['Aktif', 'Cuti', 'Lulus'];
  final List<String> minatList = [
    'Mobile', 'Web', 'AI', 'UI/UX', 'Data',
  ];
  final List<String> provinsiList = [
    'Jawa Barat', 'DKI Jakarta', 'Jawa Tengah',
    'Jawa Timur', 'Banten',
  ];
  final List<String> kotaList = [
    'Bogor', 'Depok', 'Bandung', 'Bekasi',
    'Jakarta', 'Tangerang', 'Semarang', 'Surabaya',
  ];

  final Map<String, Color> warnaList = {
    'Biru': Colors.blue,
    'Merah': Colors.red,
    'Hijau': Colors.green,
    'Ungu': Colors.purple,
    'Oranye': Colors.orange,
  };

  @override
  void initState() {
    super.initState();

    final m = widget.mahasiswa;

    _nim = TextEditingController(text: m?.nim ?? '');
    _nama = TextEditingController(text: m?.nama ?? '');
    _panggilan = TextEditingController(
      text: m?.namaPanggilan ?? '',
    );
    _email = TextEditingController(text: m?.email ?? '');
    _hp = TextEditingController(text: m?.nomorHp ?? '');
    _password = TextEditingController(text: m?.password ?? '');
    _tempatLahir = TextEditingController(
      text: m?.tempatLahir ?? '',
    );
    _alamat = TextEditingController(text: m?.alamat ?? '');

    jenisKelamin = m?.jenisKelamin;
    agama = m?.agama;
    prodi = m?.prodi;
    semester = m?.semester ?? 1;
    kelas = m?.kelas ?? 'A';
    status = m?.status ?? 'Aktif';
    ipk = m?.ipk ?? 3.00;
    beasiswa = m?.beasiswa ?? false;
    magang = m?.bersediaMagang ?? false;
    setuju = m?.persetujuanData ?? false;
    tanggalLahir = m?.tanggalLahir;
    provinsi = m?.provinsi ?? 'Jawa Barat';
    kota = m?.kota ?? 'Bogor';
    warnaProfil = m?.warnaProfil ?? 'Biru';

    minatDipilih.addAll(m?.minat ?? []);
  }

  @override
  void dispose() {
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

  String? wajib(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  Widget judul(String teks) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      teks,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget input(
    TextEditingController controller,
    String label, {
    TextInputType? keyboard,
    bool password = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: password,
        maxLines: password ? 1 : maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text('$item'),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: tanggalLahir ?? DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (hasil != null) {
      setState(() => tanggalLahir = hasil);
    }
  }

  void simpan() {
    if (!_formKey.currentState!.validate()) return;

    if (jenisKelamin == null ||
        agama == null ||
        prodi == null ||
        tanggalLahir == null ||
        !setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi pilihan wajib dan setujui penggunaan data.',
          ),
        ),
      );
      return;
    }

    final nim = _nim.text.trim().toLowerCase();
    final nimLama = widget.mahasiswa?.nim.toLowerCase();

    if (widget.nimTerpakai.contains(nim) && nim != nimLama) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIM sudah digunakan')),
      );
      return;
    }

    Navigator.pop(
      context,
      Mahasiswa(
        nim: _nim.text.trim(),
        nama: _nama.text.trim(),
        namaPanggilan: _panggilan.text.trim(),
        email: _email.text.trim(),
        nomorHp: _hp.text.trim(),
        password: _password.text,
        jenisKelamin: jenisKelamin!,
        tanggalLahir: tanggalLahir,
        tempatLahir: _tempatLahir.text.trim(),
        agama: agama!,
        prodi: prodi!,
        semester: semester,
        kelas: kelas,
        status: status,
        ipk: ipk,
        beasiswa: beasiswa,
        bersediaMagang: magang,
        minat: minatDipilih.toList(),
        alamat: _alamat.text.trim(),
        provinsi: provinsi,
        kota: kota,
        fotoProfil: widget.mahasiswa?.fotoProfil,
        dokumenKtm: widget.mahasiswa?.dokumenKtm,
        warnaProfil: warnaProfil,
        persetujuanData: setuju,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mahasiswa == null
              ? 'Tambah Mahasiswa'
              : 'Edit Mahasiswa',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            judul('Identitas Mahasiswa'),
            input(
              _nim, 'NIM',
              keyboard: TextInputType.number,
              validator: (v) => wajib(v, 'NIM'),
            ),
            input(
              _nama, 'Nama Lengkap',
              validator: (v) => wajib(v, 'Nama lengkap'),
            ),
            input(_panggilan, 'Nama Panggilan'),
            input(
              _email, 'Email',
              keyboard: TextInputType.emailAddress,
              validator: (v) {
                final error = wajib(v, 'Email');
                if (error != null) return error;
                if (!v!.contains('@') || !v.contains('.')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            input(
              _hp, 'No. HP',
              keyboard: TextInputType.phone,
              validator: (v) => wajib(v, 'No. HP'),
            ),
            input(
              _password, 'Password Portal',
              password: true,
              validator: (v) => wajib(v, 'Password'),
            ),

            judul('Jenis Kelamin'),
            RadioListTile<String>(
              title: const Text('Laki-laki'),
              value: 'Laki-laki',
              groupValue: jenisKelamin,
              onChanged: (v) => setState(() => jenisKelamin = v),
            ),
            RadioListTile<String>(
              title: const Text('Perempuan'),
              value: 'Perempuan',
              groupValue: jenisKelamin,
              onChanged: (v) => setState(() => jenisKelamin = v),
            ),

            judul('Tanggal dan Tempat Lahir'),
            OutlinedButton.icon(
              onPressed: pilihTanggal,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                tanggalLahir == null
                    ? 'Pilih Tanggal Lahir'
                    : '${tanggalLahir!.day}/'
                      '${tanggalLahir!.month}/'
                      '${tanggalLahir!.year}',
              ),
            ),
            const SizedBox(height: 16),
            input(_tempatLahir, 'Tempat Lahir'),

            judul('Pendidikan'),
            dropdown<String>(
              label: 'Agama',
              value: agamaList.contains(agama) ? agama! : agamaList.first,
              items: agamaList,
              onChanged: (v) => setState(() => agama = v),
            ),
            dropdown<String>(
              label: 'Program Studi',
              value: prodiList.contains(prodi) ? prodi! : prodiList.first,
              items: prodiList,
              onChanged: (v) => setState(() => prodi = v),
            ),
            dropdown<int>(
              label: 'Semester',
              value: semester,
              items: List.generate(8, (i) => i + 1),
              onChanged: (v) => setState(() => semester = v ?? 1),
            ),

            judul('Kelas'),
            SegmentedButton<String>(
              segments: kelasList.map((k) {
                return ButtonSegment<String>(
                  value: k,
                  label: Text(k),
                );
              }).toList(),
              selected: {kelas},
              onSelectionChanged: (s) =>
                  setState(() => kelas = s.first),
            ),

            judul('Status Mahasiswa'),
            Wrap(
              spacing: 8,
              children: statusList.map((s) {
                return ChoiceChip(
                  label: Text(s),
                  selected: status == s,
                  onSelected: (_) => setState(() => status = s),
                );
              }).toList(),
            ),

            judul('IPK: ${ipk.toStringAsFixed(2)}'),
            Slider(
              value: ipk,
              min: 0,
              max: 4,
              divisions: 400,
              label: ipk.toStringAsFixed(2),
              onChanged: (v) => setState(() => ipk = v),
            ),

            SwitchListTile(
              title: const Text('Penerima Beasiswa'),
              value: beasiswa,
              onChanged: (v) => setState(() => beasiswa = v),
            ),
            CheckboxListTile(
              title: const Text('Bersedia Magang'),
              value: magang,
              onChanged: (v) => setState(() => magang = v ?? false),
            ),

            judul('Minat'),
            Wrap(
              spacing: 8,
              children: minatList.map((item) {
                return FilterChip(
                  label: Text(item),
                  selected: minatDipilih.contains(item),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        minatDipilih.add(item);
                      } else {
                        minatDipilih.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            judul('Alamat'),
            input(_alamat, 'Alamat Lengkap', maxLines: 3),
            dropdown<String>(
              label: 'Provinsi',
              value: provinsiList.contains(provinsi)
                  ? provinsi : provinsiList.first,
              items: provinsiList,
              onChanged: (v) {
                setState(() {
                  provinsi = v!;
                  kota = kotaList.first;
                });
              },
            ),
            dropdown<String>(
              label: 'Kota/Kabupaten',
              value: kotaList.contains(kota) ? kota : kotaList.first,
              items: kotaList,
              onChanged: (v) => setState(() => kota = v!),
            ),

            judul('Warna Profil'),
            Wrap(
              spacing: 12,
              children: warnaList.entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    warnaProfil = entry.key;
                  }),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: warnaProfil == entry.key
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: warnaProfil == entry.key
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                'Saya setuju dengan penggunaan data mahasiswa',
              ),
              value: setuju,
              onChanged: (v) => setState(() => setuju = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Data'),
            ),
          ],
        ),
      ),
    );
  }
}
