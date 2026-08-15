import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../data/models/product_model.dart';
import '../data/providers/catalog_providers.dart';
import 'widgets/image_picker_widget.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormScreen({super.key, this.productId});

  bool get isEditing => productId != null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController(text: '100');
  final _variationsController = TextEditingController();

  String? _selectedCategoryId;
  bool _isAvailable = true;
  File? _selectedImage;
  String? _currentImageUrl;
  bool _isSaving = false;
  bool _isLoaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _variationsController.dispose();
    super.dispose();
  }

  void _loadProduct(ProductModel product) {
    if (_isLoaded) return;
    _isLoaded = true;
    _nameController.text = product.name;
    _nameEnController.text = product.nameEn ?? '';
    _priceController.text = product.basePrice.toString();
    _descriptionController.text = product.description ?? '';
    _stockController.text = product.stockQty.toString();
    _variationsController.text = product.variations.join(', ');
    _selectedCategoryId = product.categoryId;
    _isAvailable = product.isAvailable;
    _currentImageUrl = product.imageUrl;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(catalogRepositoryProvider);
      String? imageUrl = _currentImageUrl;

      // Upload image if new one selected
      if (_selectedImage != null) {
        final fileName = '${const Uuid().v4()}.jpg';
        imageUrl = await repo.uploadProductImage(fileName, _selectedImage!);
      }

      final data = {
        'name': _nameController.text.trim(),
        'name_en': _nameEnController.text.trim().isEmpty
            ? null
            : _nameEnController.text.trim(),
        'base_price': int.parse(_priceController.text.trim()),
        'category_id': _selectedCategoryId,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'is_available': _isAvailable,
        'stock_qty': int.tryParse(_stockController.text.trim()) ?? 0,
        'variations': _variationsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'image_url': imageUrl,
      };

      ProductModel? savedProduct;
      if (widget.isEditing) {
        savedProduct = await repo.updateProduct(widget.productId!, data);
      } else {
        savedProduct = await repo.createProduct(data);
      }

      // Refresh products list
      ref.invalidate(productsProvider);
      ref.invalidate(filteredProductsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Produk berhasil diperbarui'
                  : 'Produk berhasil ditambahkan',
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        if (widget.isEditing) {
          context.pop();
        } else {
          context.replace('/menu/${savedProduct.id}/edit');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: const Text('Produk ini akan dihapus secara permanen.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(catalogRepositoryProvider);
      await repo.deleteProduct(widget.productId!);
      ref.invalidate(productsProvider);
      ref.invalidate(filteredProductsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(categoriesProvider);

    // Load existing product if editing
    if (widget.isEditing) {
      final productAsync = ref.watch(productDetailProvider(widget.productId!));
      productAsync.whenData((product) {
        if (product != null) _loadProduct(product);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Produk' : 'Tambah Produk'),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: _isSaving ? null : _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Image
            ImagePickerWidget(
              currentImageUrl: _currentImageUrl,
              selectedFile: _selectedImage,
              onImageSelected: (file) => setState(() => _selectedImage = file),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk *',
                hintText: 'Contoh: Nasi Goreng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Name English
            TextFormField(
              controller: _nameEnController,
              decoration: InputDecoration(
                labelText: 'Name (English)',
                hintText: 'e.g., Fried Rice',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Kategori *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.icon ?? ''} ${c.name}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
                validator: (v) => v == null ? 'Pilih kategori' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Gagal memuat kategori'),
            ),
            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Harga (Rp) *',
                hintText: '15000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Harga wajib diisi';
                }
                if (int.tryParse(v.trim()) == null) {
                  return 'Masukkan angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Variations
            TextFormField(
              controller: _variationsController,
              decoration: InputDecoration(
                labelText: 'Variasi (Opsional)',
                hintText: 'Contoh: Panas, Dingin',
                helperText: 'Pisahkan dengan koma (,) untuk pilihan tunggal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stock
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stok',
                hintText: '100',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Deskripsi produk (opsional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Availability toggle
            SwitchListTile(
              title: const Text('Tersedia'),
              subtitle: Text(
                _isAvailable
                    ? 'Produk bisa dipesan'
                    : 'Produk tidak tersedia (Habis)',
              ),
              value: _isAvailable,
              onChanged: (v) => setState(() => _isAvailable = v),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),

            // Ingredient/Topping management links (edit mode only)
            if (widget.isEditing) ...[
              const Divider(height: 32),
              ListTile(
                leading: const Icon(Icons.list_alt_outlined),
                title: const Text('Kelola Bahan Bawaan'),
                subtitle: const Text('Bahan yang bisa dihilangkan'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () =>
                    context.push('/menu/${widget.productId}/ingredients'),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Kelola Tambahan'),
                subtitle: const Text('Topping & extra dengan harga'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => context.push('/menu/${widget.productId}/toppings'),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        widget.isEditing ? 'Simpan Perubahan' : 'Simpan Produk',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
