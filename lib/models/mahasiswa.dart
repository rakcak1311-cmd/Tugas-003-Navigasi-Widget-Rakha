
class Mahasiswa {
  final String nim;
  final String nama;
  final String namaPanggilan;
  final String email;
  final String nomorHp;
  final String password;
  final String jenisKelamin;
  final DateTime? tanggalLahir;
  final String tempatLahir;
  final String agama;
  final String prodi;
  final int semester;
  final String kelas;
  final String status;
  final double ipk;
  final bool beasiswa;
  final bool bersediaMagang;
  final List<String> minat;
  final String alamat;
  final String provinsi;
  final String kota;
  final String? fotoProfil;
  final String? dokumenKtm;
  final String warnaProfil;
  final bool persetujuanData;

  const Mahasiswa({
    required this.nim,
    required this.nama,
    required this.namaPanggilan,
    required this.email,
    required this.nomorHp,
    required this.password,
    required this.jenisKelamin,
    this.tanggalLahir,
    required this.tempatLahir,
    required this.agama,
    required this.prodi,
    required this.semester,
    required this.kelas,
    required this.status,
    required this.ipk,
    required this.beasiswa,
    required this.bersediaMagang,
    required this.minat,
    required this.alamat,
    required this.provinsi,
    required this.kota,
    this.fotoProfil,
    this.dokumenKtm,
    required this.warnaProfil,
    required this.persetujuanData,
  });
}
