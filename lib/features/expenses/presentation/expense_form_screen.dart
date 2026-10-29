import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/language_notifier.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../catalog/presentation/widgets/image_picker_widget.dart';
import '../../dashboard/data/providers/shift_provider.dart';
import '../data/providers/expense_providers.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final String? expenseId;

  const ExpenseFormScreen({super.key, this.expenseId});

  bool get isEditing => expenseId != null;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'INGREDIENTS';
  String _selectedPaymentSource = 'CASH_DRAWER';
  DateTime _selectedDate = DateTime.now();
  File? _receiptFile;
  String? _existingReceiptPath;

  bool _isSaving = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExpense();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadExpense() async {
    setState(() => _isLoading = true);
    final repo = ref.read(expenseRepositoryProvider);
    final expense = await repo.getExpenseById(widget.expenseId!);
    if (expense != null && mounted) {
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _notesController.text = expense.notes ?? '';
      _selectedCategory = expense.category;
      _selectedPaymentSource = expense.paymentSource;
      _selectedDate = expense.expenseDate;
      _existingReceiptPath = expense.receiptImagePath;
      if (expense.receiptImagePath != null) {
        final file = File(expense.receiptImagePath!);
        if (file.existsSync()) {
          _receiptFile = file;
        }
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (!mounted) return;

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            _selectedDate.hour,
            _selectedDate.minute,
          );
        });
      }
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final lang = ref.read(languageProvider).languageCode;
    final amount = int.tryParse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang == 'en' ? 'Amount must be greater than 0' : 'Nominal harus lebih dari 0'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(expenseRepositoryProvider);
      final activeStaff = ref.read(activeStaffProvider);
      final activeShift = ref.read(shiftProvider).value;

      final receiptPath = _receiptFile?.path ?? _existingReceiptPath;

      if (widget.isEditing) {
        await repo.updateExpense(
          id: widget.expenseId!,
          title: _titleController.text.trim(),
          amount: amount,
          category: _selectedCategory,
          paymentSource: _selectedPaymentSource,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          receiptImagePath: receiptPath,
          expenseDate: _selectedDate,
        );
      } else {
        await repo.createExpense(
          title: _titleController.text.trim(),
          amount: amount,
          category: _selectedCategory,
          paymentSource: _selectedPaymentSource,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          receiptImagePath: receiptPath,
          expenseDate: _selectedDate,
          shiftId: _selectedPaymentSource == 'CASH_DRAWER' ? activeShift?.id : null,
          createdByStaffId: activeStaff?.id,
          createdByName: activeStaff?.fullName,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? (lang == 'en' ? 'Expense updated successfully' : 'Pengeluaran berhasil diperbarui')
                  : (lang == 'en' ? 'Expense added successfully' : 'Pengeluaran berhasil dicatat'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteExpense() async {
    final lang = ref.read(languageProvider).languageCode;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'en' ? 'Delete Expense?' : 'Hapus Pengeluaran?'),
        content: Text(
          lang == 'en'
              ? 'Are you sure you want to delete this expense record? This cannot be undone.'
              : 'Apakah Anda yakin ingin menghapus catatan pengeluaran ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang == 'en' ? 'Cancel' : 'Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(lang == 'en' ? 'Delete' : 'Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isSaving = true);
      try {
        await ref.read(expenseRepositoryProvider).deleteExpense(widget.expenseId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang == 'en' ? 'Expense deleted' : 'Pengeluaran telah dihapus'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider).languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? (lang == 'en' ? 'Edit Expense' : 'Ubah Pengeluaran')
              : (lang == 'en' ? 'Record Expense' : 'Catat Pengeluaran'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: lang == 'en' ? 'Delete' : 'Hapus',
              onPressed: _isSaving ? null : _deleteExpense,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Amount Input Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.3), width: 1.5),
              ),
              color: Colors.redAccent.withOpacity(0.04),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'en' ? 'Expense Amount' : 'Nominal Pengeluaran',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rp ',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return lang == 'en' ? 'Please enter amount' : 'Masukkan nominal';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title / Description
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Expense Description / Item Name *' : 'Keterangan Pengeluaran / Nama Item *',
                hintText: lang == 'en' ? 'e.g. Rice 25kg, LPG Gas, Staff Meal' : 'Contoh: Beras 25kg, Gas LPG 3kg, Es Batu',
                prefixIcon: const Icon(Icons.receipt_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return lang == 'en' ? 'Please enter description' : 'Keterangan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Category Selector
            Text(
              lang == 'en' ? 'Category' : 'Kategori',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: expenseCategories.map((cat) {
                final isSelected = _selectedCategory == cat.id;
                return ChoiceChip(
                  avatar: Icon(
                    cat.icon,
                    size: 18,
                    color: isSelected ? Colors.white : cat.color,
                  ),
                  label: Text(cat.localizedName(lang)),
                  selected: isSelected,
                  selectedColor: cat.color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat.id);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Payment Source (Sumber Dana)
            Text(
              lang == 'en' ? 'Payment Source (Sumber Dana)' : 'Sumber Dana Pengeluaran',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: expensePaymentSources.map((source) {
                final isSelected = _selectedPaymentSource == source.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected ? colorScheme.primary.withOpacity(0.06) : null,
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      source.icon,
                      color: isSelected ? colorScheme.primary : Colors.grey,
                    ),
                    title: Text(
                      source.localizedName(lang),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? colorScheme.primary : null,
                      ),
                    ),
                    subtitle: source.id == 'CASH_DRAWER'
                        ? Text(
                            lang == 'en'
                                ? 'Deducts physical cash in the current cashier drawer'
                                : 'Mengurangi uang kas fisik pada sesi kasir saat ini',
                            style: const TextStyle(fontSize: 11),
                          )
                        : null,
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary, size: 20)
                        : const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20),
                    onTap: () => setState(() => _selectedPaymentSource = source.id),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Date & Time Picker
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(lang == 'en' ? 'Expense Date & Time' : 'Tanggal & Waktu'),
              subtitle: Text(
                dateFormatter.format(_selectedDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 20),

            // Additional Notes
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Notes (Optional)' : 'Catatan Tambahan (Opsional)',
                hintText: lang == 'en' ? 'Vendor, receipt number, or details' : 'Nama warung/toko, no nota, keterangan',
                prefixIcon: const Icon(Icons.edit_note_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),

            // Receipt Photo (Bukti Struk)
            Text(
              lang == 'en' ? 'Receipt Photo / Proof (Optional)' : 'Foto Nota / Struk (Opsional)',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ImagePickerWidget(
              selectedFile: _receiptFile,
              currentImageUrl: _existingReceiptPath,
              languageCode: lang,
              onImageSelected: (file) => setState(() => _receiptFile = file),
            ),
            const SizedBox(height: 36),

            // Submit Button
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveExpense,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: colorScheme.primary,
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _isSaving
                    ? (lang == 'en' ? 'Saving...' : 'Menyimpan...')
                    : (widget.isEditing
                        ? (lang == 'en' ? 'Update Expense' : 'Simpan Perubahan')
                        : (lang == 'en' ? 'Save Expense' : 'Catat Pengeluaran')),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
