import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/product_certificates.dart';
import 'package:HalalCheck/database/models/certificates.dart';

class ProductCertificatesLinkPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductCertificatesLinkPage({Key? key, required this.productId, required this.productName}) : super(key: key);

  @override
  _ProductCertificatesLinkPageState createState() => _ProductCertificatesLinkPageState();
}

class _ProductCertificatesLinkPageState extends State<ProductCertificatesLinkPage> {
  final ProductCertificateService _productCertificateService = ProductCertificateService();
  final CertificateService _certificateService = CertificateService();

  List<Certificate> _certificates = [];
  Set<int> _linkedCertificateIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final certs = await _certificateService.getCertificates();
    final links = await _productCertificateService.getProductCertificates();

    final linkedCertIds = links
        .where((link) => link.productId == widget.productId)
        .map((link) => link.certId)
        .toSet();

    setState(() {
      _certificates = certs;
      _linkedCertificateIds = linkedCertIds;
    });
  }

  Future<void> _onCertificateToggle(int certId, bool selected) async {
    if (selected) {
      await _productCertificateService.insertProductCertificate(
        ProductCertificate(productId: widget.productId, certId: certId),
      );
    } else {
      await _productCertificateService.deleteProductCertificate(widget.productId, certId);
    }

    // Refresh links after adding/deleting
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificates for "${widget.productName}"'),
        backgroundColor: Colors.green,
      ),
      body: _certificates.isEmpty
          ? const Center(child: Text('No certificates found.'))
          : ListView.builder(
        itemCount: _certificates.length,
        itemBuilder: (context, index) {
          final cert = _certificates[index];
          final isLinked = _linkedCertificateIds.contains(cert.id);

          return CheckboxListTile(
            value: isLinked,
            onChanged: (bool? selected) {
              if (selected != null) {
                _onCertificateToggle(cert.id!, selected);
              }
            },
            title: Text(cert.certNumber),
            subtitle: Text('Expiry: ${cert.expiryDate}'),
          );
        },
      ),
    );
  }
}
