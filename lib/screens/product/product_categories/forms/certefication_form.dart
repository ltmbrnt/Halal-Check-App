import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/certificates.dart';
import 'package:HalalCheck/database/models/halal_authorities.dart';

class CertificationFormPage extends StatefulWidget {
  const CertificationFormPage({Key? key}) : super(key: key);

  @override
  _CertificationFormPageState createState() => _CertificationFormPageState();
}

class _CertificationFormPageState extends State<CertificationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _certNumberController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _verified = false;

  final HalalAuthorityService _halalAuthorityService = HalalAuthorityService();
  final CertificateService _certificateService = CertificateService();

  List<HalalAuthority> _halalAuthorities = [];
  int? _selectedAuthorityId;

  @override
  void initState() {
    super.initState();
    _loadAuthorities();
  }

  Future<void> _loadAuthorities() async {
    final authorities = await _halalAuthorityService.getHalalAuthorities();
    setState(() {
      _halalAuthorities = authorities;
    });
  }

  @override
  void dispose() {
    _certNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveCertificate() async {
    if (_formKey.currentState!.validate()) {
      final randomCertNumber = "CERT-${DateTime.now().millisecondsSinceEpoch}";
      final certNumber = _certNumberController.text.trim().isEmpty
          ? randomCertNumber
          : _certNumberController.text.trim();

      final cert = Certificate(
        authorityId: _selectedAuthorityId!,
        certNumber: certNumber,
        issueDate: _issueDateController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text.trim() : null,
        verified: _verified,
        notes: _notesController.text.isNotEmpty ? _notesController.text.trim() : null,
      );

      await _certificateService.insertCertificate(cert);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Сертификат успешно добавлен!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить Сертификат'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Выберите орган Халяль'),
                value: _selectedAuthorityId,
                items: _halalAuthorities.map((auth) {
                  return DropdownMenuItem<int>(
                    value: auth.id,
                    child: Text(auth.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAuthorityId = value;
                  });
                },
                validator: (value) => value == null ? 'Выберите орган' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _certNumberController,
                decoration: const InputDecoration(labelText: 'Номер сертификата (опционально)'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _issueDateController,
                decoration: const InputDecoration(labelText: 'Дата выпуска (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Введите дату выпуска' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _expiryDateController,
                decoration: const InputDecoration(labelText: 'Дата окончания (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Введите дату окончания' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Ссылка на изображение (опционально)'),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                title: const Text('Подтвержденный сертификат?'),
                value: _verified,
                onChanged: (val) {
                  setState(() {
                    _verified = val;
                  });
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Заметки (опционально)'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveCertificate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Сохранить Сертификат'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

