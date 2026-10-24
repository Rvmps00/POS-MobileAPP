import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/l10n/language_notifier.dart';
import '../../../core/printer/printer_providers.dart';

class RestaurantInfoScreen extends ConsumerStatefulWidget {
  const RestaurantInfoScreen({super.key});

  @override
  ConsumerState<RestaurantInfoScreen> createState() => _RestaurantInfoScreenState();
}

class _RestaurantInfoScreenState extends ConsumerState<RestaurantInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _footerController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = ref.read(sharedPreferencesProvider);
    _nameController.text = _prefs.getString('store_name') ?? 'POINT OF SALE';
    _addressController.text = _prefs.getString('store_address') ?? '';
    _phoneController.text = _prefs.getString('store_phone') ?? '';
    _footerController.text = _prefs.getString('store_footer') ?? 'Terima Kasih!\nSelamat Menikmati 🙏';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  Future<void> _save(String lang) async {
    if (_formKey.currentState!.validate()) {
      await _prefs.setString('store_name', _nameController.text);
      await _prefs.setString('store_address', _addressController.text);
      await _prefs.setString('store_phone', _phoneController.text);
      await _prefs.setString('store_footer', _footerController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang == 'en'
                  ? 'Restaurant Info saved successfully!'
                  : 'Informasi Restoran berhasil disimpan!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Restaurant Info' : 'Informasi Restoran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _save(lang),
            tooltip: lang == 'en' ? 'Save' : 'Simpan',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              lang == 'en'
                  ? 'This information will be printed on the receipts.'
                  : 'Informasi ini akan dicetak pada struk pembayaran.',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Store Name' : 'Nama Restoran / Toko',
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? (lang == 'en' ? 'Required' : 'Wajib diisi')
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Address' : 'Alamat',
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Phone Number' : 'Nomor Telepon',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _footerController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Footer Message' : 'Pesan Penutup Struk',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _save(lang),
              child: Text(lang == 'en' ? 'Save Info' : 'Simpan Informasi'),
            ),
          ],
        ),
      ),
    );
  }
}
