import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/certificates.dart';

class CertificateDetailPage extends StatefulWidget {
  final int certId;

  const CertificateDetailPage({Key? key, required this.certId}) : super(key: key);

  @override
  _CertificateDetailPageState createState() => _CertificateDetailPageState();
}

class _CertificateDetailPageState extends State<CertificateDetailPage> {
  final CertificateService _certificateService = CertificateService();
  Certificate? _certificate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCertificate();
  }

  Future<void> _loadCertificate() async {
    final cert = await _certificateService.getCertificateById(widget.certId);
    setState(() {
      _certificate = cert;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Details'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _certificate == null
          ? const Center(child: Text('Certificate not found.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Certificate Number', _certificate!.certNumber),
            _buildDetailRow('Authority ID', _certificate!.authorityId.toString()),
            _buildDetailRow('Issue Date', _certificate!.issueDate),
            _buildDetailRow('Expiry Date', _certificate!.expiryDate),
            _buildDetailRow('Verified', _certificate!.verified ? 'Yes' : 'No'),
            _buildDetailRow('Notes', _certificate!.notes ?? '-'),
            const SizedBox(height: 20),
            if (_certificate!.imageUrl != null && _certificate!.imageUrl!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Certificate Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Image.network(_certificate!.imageUrl!, fit: BoxFit.cover),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
