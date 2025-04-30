import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HalalCheck/database/models/halal_authorities.dart';
import '../forms/halal_authority_form.dart';

class HalalAuthorityListPage extends StatefulWidget {
  const HalalAuthorityListPage({super.key});

  @override
  _HalalAuthorityListPageState createState() => _HalalAuthorityListPageState();
}

class _HalalAuthorityListPageState extends State<HalalAuthorityListPage> {
  final HalalAuthorityService _authorityService = HalalAuthorityService();
  List<HalalAuthority> _authorities = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadAuthorities();
    _checkIfAdmin();
  }

  Future<void> _loadAuthorities() async {
    final authorities = await _authorityService.getHalalAuthorities();
    setState(() {
      _authorities = authorities;
    });
  }

  Future<void> _checkIfAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('user_is_admin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halal Authorities'),
        backgroundColor: Colors.green,
      ),
      body: _authorities.isEmpty
          ? const Center(child: Text('No Halal Authorities found.'))
          : ListView.builder(
        itemCount: _authorities.length,
        itemBuilder: (context, index) {
          final authority = _authorities[index];
          return ListTile(
            title: Text(authority.name),
            subtitle: Text('Trust Level: ${authority.trustLevel}'),
          );
        },
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HalalAuthorityFormPage()),
          );
          _loadAuthorities(); // Refresh list after adding
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
    );
  }
}
