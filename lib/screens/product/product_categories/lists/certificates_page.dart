import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HalalCheck/database/models/certificates.dart';
import '../forms/certefication_form.dart'; // 👈 Form page to add certificate

class CertificateListPage extends StatefulWidget {
  const CertificateListPage({super.key});

  @override
  _CertificateListPageState createState() => _CertificateListPageState();
}

class _CertificateListPageState extends State<CertificateListPage> {
  final CertificateService _certificateService = CertificateService();
  List<Certificate> _certificates = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadCertificates();
    _checkIfAdmin();
  }

  Future<void> _loadCertificates() async {
    final certificates = await _certificateService.getCertificates();
    setState(() {
      _certificates = certificates;
    });
  }

  Future<void> _checkIfAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('user_is_admin') ?? false;
    });
  }

  Future<void> _confirmDeleteCertificate(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить Сертификат?'),
        content: const Text('Вы уверены, что хотите удалить этот сертификат?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _certificateService.deleteCertificate(id);
      _loadCertificates();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Сертификат успешно удален!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificates'),
        backgroundColor: Colors.green,
      ),
      body: _certificates.isEmpty
          ? const Center(child: Text('No certificates yet.'))
          : ListView.builder(
        itemCount: _certificates.length,
        itemBuilder: (context, index) {
          final cert = _certificates[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                cert.verified ? Icons.verified : Icons.warning,
                color: cert.verified ? Colors.green : Colors.orange,
              ),
              title: Text(cert.certNumber),
              subtitle: Text('Expiry: ${cert.expiryDate}'),
              trailing: _isAdmin
                  ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteCertificate(cert.id!),
              )
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CertificationFormPage()),
          );
          _loadCertificates(); // Refresh after adding
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
    );
  }
}


