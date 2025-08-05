class Usashakim {
  final int? id;
  final String nama;
  final String nobp;

  Usashakim({
    this.id,
    required this.nama,
    required this.nobp,
  });

  factory Usashakim.fromJson(Map<String, dynamic> json) {
    return Usashakim(
      id: json['id'],
      nama: json['nama'],
      nobp: json['nobp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nobp': nobp,
    };
  }

  @override
  String toString() {
    return 'Usashakim(id: $id, nama: $nama, nobp: $nobp)';
  }
} 