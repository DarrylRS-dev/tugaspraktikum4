import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Mahasiswa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final cNama = TextEditingController();
  final cNpm = TextEditingController();
  final cEmail = TextEditingController();
  final cAlamat = TextEditingController();
  final cNoHp = TextEditingController();

  String? JenisKelamin;
  DateTime? tglLahir;
  TimeOfDay? jamBimbingan;

  @override
  void dispose() {
    cNama.dispose();
    cNpm.dispose();
    cEmail.dispose();
    cAlamat.dispose();
    cNoHp.dispose();
    super.dispose();
  }

  // label untuk tanggal
  String get tglLahirLabel {
    if (tglLahir == null) return 'Pilih Tanggal Lahir';
    return '${tglLahir?.day}/${tglLahir?.month}/${tglLahir?.year}';
  }

  // label untuk jam
  String get jamLabel {
    if (jamBimbingan == null) return 'Pilih Jam Bimbingan';
    final jam = jamBimbingan?.hour ?? 0;
    final menit = jamBimbingan?.minute ?? 0;
    return '$jam:${menit.toString().padLeft(2, '0')}';
  }

  void _simpan() {
    if (!_formKey.currentState!.validate() ||
        tglLahir == null ||
        jamBimbingan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Belum Lengkap')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ringkasan Data'),
        content: Text(
          'Nama: ${cNama.text}\n'
          'NPM: ${cNpm.text}\n'
          'Email: ${cEmail.text}\n'
          'Alamat: ${cAlamat.text}\n'
          'Nomor Telepon: ${cNoHp.text}\n'
          'Jenis kelamin: $JenisKelamin\n'
          'Tanggal Lahir: $tglLahirLabel\n'
          'Jam Bimbingan: $jamLabel',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cNama,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  prefixIcon : Icon (Icons.person)),
                validator: (val) =>
                    val == null || val.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: cNpm,
                decoration: const InputDecoration(
                  labelText: "NPM",
                  prefixIcon: Icon(Icons.numbers)),
                validator: (val) =>
                    val == null || val.isEmpty ? "NPM wajib diisi" : null,
              ),
              TextFormField(
                controller: cEmail,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email)),
                validator: (val) =>
                    val == null || val.isEmpty ? "Email wajib diisi"
                    : !RegExp(r'^[\w\.-]+@unsika\.ac\.id$').hasMatch(val) ? "Format email tidak valid" : null,
              ),
              TextFormField(
                controller: cAlamat,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  prefixIcon: Icon(Icons.home)),
                validator: (val) =>
                    val == null || val.isEmpty ? "Alamat wajib diisi" : null,
              ),
              TextFormField(
                controller: cNoHp,
                decoration: const InputDecoration(
                  labelText: "Nomor Telepon",
                  prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
                validator: (val) =>
                val == null || val.isEmpty? "Nomor telepon wajib diisi"
                : !RegExp(r'^[0-9]+$').hasMatch(val)? "Nomor telepon hanya boleh angka"
                : val.length < 10 ? "Nomor telepon minimal 10 digit" : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                icon : Icon (Icons.arrow_drop_down),
                decoration: const InputDecoration(
                labelText: "Jenis Kelamin"),
                items: const [
                  DropdownMenuItem(
                    value: "Laki-laki", child: Text("Laki-laki")),
                  DropdownMenuItem(
                    value: "Perempuan", child: Text("Perempuan")),
              ],  
              initialValue : JenisKelamin, 
              onChanged: (String? newValue) {
                setState(() {
                  JenisKelamin = newValue;
                });
              },
              validator: (val) => val == null || val.isEmpty ? "Jenis kelamin wajib diisi" : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => tglLahir = picked);
                  }
                },
                child: Text(tglLahirLabel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => jamBimbingan = picked);
                  }
                },
                child: Text(jamLabel),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Data disimpan');
                    _simpan();}
            },
            icon: Icon(Icons.save),
            label: Text('Simpan'),
            style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 16),),
            ),
            ],
          ),
        ),
      ),
    );
  }
}