import 'package:flutter/material.dart';

// ================= PALET WARNA PANTONE =================
class PantoneColors {
  static const Color transparentYellow = Color(0xFFF5EFC6);
  static const Color sceptreRed = Color(0xFF4D0E12);
  static const Color ceruleanBlue = Color(0xFFA5BCD6);
  static const Color pottingSoil = Color(0xFF4A2E27);
  static const Color javaBrown = Color(0xFF231815);
}

void main() {
  runApp(const KesenianApp());
}

// ================= ABSTRACT CLASS =================

abstract class Kesenian {
  String nama;
  String era; 
  String asal;
  String urlGambar;

  Kesenian(this.nama, this.era, this.asal, this.urlGambar);

  String keterangan() {
    return asal;
  }

  String aksi();

  String informasi() {
    return "Nama : $nama\nEra / Periode : $era";
  }
}

// ================= CLASS TURUNAN =================

class Tari extends Kesenian {
  String daerah;

  Tari(String nama, String era, String asal, String urlGambar, this.daerah)
      : super(nama, era, asal, urlGambar);

  @override
  String aksi() {
    return "$nama berasal dari daerah $daerah";
  }
}

class Musik extends Kesenian {
  String alatMusik;

  Musik(String nama, String era, String asal, String urlGambar, this.alatMusik)
      : super(nama, era, asal, urlGambar);

  @override
  String aksi() {
    return "$nama Berasal dari Bahan $alatMusik";
  }
}

class Pertunjukkan extends Kesenian {
  String jenisPertunjukkan;

  Pertunjukkan(String nama, String era, String asal, String urlGambar, this.jenisPertunjukkan)
      : super(nama, era, asal, urlGambar);

  @override
  String aksi() {
    return "$nama merupakan pertunjukkan $jenisPertunjukkan";
  }
}

// ================= FLUTTER UI =================

class KesenianApp extends StatelessWidget {
  const KesenianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kesenian Tradisional Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: PantoneColors.transparentYellow,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: PantoneColors.sceptreRed,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const DaftarKesenianScreen(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class DaftarKesenianScreen extends StatefulWidget {
  const DaftarKesenianScreen({super.key});

  @override
  State<DaftarKesenianScreen> createState() => _DaftarKesenianScreenState();
}

class _DaftarKesenianScreenState extends State<DaftarKesenianScreen> {
  final List<Kesenian> _daftarKesenian = [];

  void _tambahKesenian(Kesenian kesenianBaru) {
    setState(() {
      _daftarKesenian.add(kesenianBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kesenian Nusantara"),
      ),
      body: _daftarKesenian.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.palette, size: 80, color: PantoneColors.pottingSoil.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data kesenian.",
                    style: TextStyle(
                      fontSize: 18, 
                      color: PantoneColors.javaBrown,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarKesenian.length,
              itemBuilder: (context, index) {
                Kesenian kesenian = _daftarKesenian[index];
                return Card(
                  elevation: 2,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bagian Gambar
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: kesenian.urlGambar.isNotEmpty
                            ? Image.network(
                                kesenian.urlGambar,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: PantoneColors.ceruleanBlue.withOpacity(0.3),
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: PantoneColors.pottingSoil),
                                ),
                              )
                            : Container(
                                height: 180,
                                color: PantoneColors.ceruleanBlue.withOpacity(0.4),
                                child: const Icon(Icons.palette,
                                    size: 50, color: PantoneColors.sceptreRed),
                              ),
                      ),
                      // Bagian Informasi
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kesenian.nama,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: PantoneColors.javaBrown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              kesenian.informasi(),
                              style: const TextStyle(color: PantoneColors.pottingSoil),
                            ),
                            const Divider(height: 24, color: PantoneColors.ceruleanBlue),
                            _buildInfoRow(Icons.location_on, "Asal", kesenian.keterangan()),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.auto_awesome, "Keterangan", kesenian.aksi()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PantoneColors.sceptreRed,
        foregroundColor: Colors.white,
        onPressed: () async {
          final Kesenian? kesenianBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormTambahKesenian()),
          );

          if (kesenianBaru != null) {
            _tambahKesenian(kesenianBaru);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Kesenian"),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: PantoneColors.sceptreRed),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: PantoneColors.javaBrown, fontSize: 14),
              children: [
                TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= HALAMAN FORM =================

class FormTambahKesenian extends StatefulWidget {
  const FormTambahKesenian({super.key});

  @override
  State<FormTambahKesenian> createState() => _FormTambahKesenianState();
}

class _FormTambahKesenianState extends State<FormTambahKesenian> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _eraController = TextEditingController(); 
  final _asalController = TextEditingController();
  final _gambarController = TextEditingController();
  final _atributKhususController = TextEditingController();

  String _jenisKesenian = 'Tari';

  @override
  void dispose() {
    _namaController.dispose();
    _eraController.dispose();
    _asalController.dispose();
    _gambarController.dispose();
    _atributKhususController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      Kesenian kesenianBaru;
      String nama = _namaController.text;
      String era = _eraController.text;
      String asal = _asalController.text;
      String gambar = _gambarController.text;
      String atributKhusus = _atributKhususController.text;

      if (_jenisKesenian == 'Tari') {
        kesenianBaru = Tari(nama, era, asal, gambar, atributKhusus);
      } else if (_jenisKesenian == 'Musik') {
        kesenianBaru = Musik(nama, era, asal, gambar, atributKhusus);
      } else {
        kesenianBaru = Pertunjukkan(nama, era, asal, gambar, atributKhusus);
      }

      Navigator.pop(context, kesenianBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kesenian"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _jenisKesenian,
                decoration: _inputStyle("Jenis Kesenian", Icons.category),
                items: ['Tari', 'Musik', 'Pertunjukan']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisKesenian = value!;
                    _atributKhususController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: _inputStyle("Nama Kesenian", Icons.badge),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _eraController,
                keyboardType: TextInputType.text,
                decoration: _inputStyle("Era / Periode Perkembangan", Icons.history_edu),
                validator: (value) =>
                    value!.isEmpty ? 'Era/periode tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _asalController,
                decoration: _inputStyle("Asal Daerah", Icons.location_on),
                validator: (value) =>
                    value!.isEmpty ? 'Asal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _gambarController,
                decoration: _inputStyle("URL Gambar", Icons.image),
                validator: (value) =>
                    value!.isEmpty ? 'URL tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _atributKhususController,
                decoration: _inputStyle(
                  _jenisKesenian == 'Tari'
                      ? "Ciri Khas"
                      : _jenisKesenian == 'Musik'
                          ? "Alat Musik yang Digunakan"
                          : "Jenis Pertunjukkan",
                  Icons.star,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Atribut ini wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: PantoneColors.sceptreRed,
                ),
                child: const Text(
                  "SIMPAN DATA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: PantoneColors.pottingSoil),
      prefixIcon: Icon(icon, color: PantoneColors.sceptreRed),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PantoneColors.ceruleanBlue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: PantoneColors.sceptreRed, width: 2),
      ),
    );
  }
}