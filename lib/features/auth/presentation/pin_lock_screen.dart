import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../data/providers/auth_provider.dart';
import '../data/repositories/auth_repository.dart';

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  StaffProfilesTableData? _selectedStaff;
  String _pin = '';
  bool _isError = false;

  void _handleNumberPress(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
        _isError = false;
      });

      if (_pin.length == 4) {
        _validatePin();
      }
    }
  }

  void _handleBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _validatePin() async {
    if (_selectedStaff == null) return;
    
    // In a real app, hash the PIN and compare.
    if (_selectedStaff!.pin == _pin) {
      ref.read(activeStaffProvider.notifier).setActiveStaff(_selectedStaff!);
      // GoRouter will automatically redirect to dashboard because activeStaff is not null anymore
    } else {
      setState(() {
        _isError = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final staffListAsync = ref.watch(staffProfilesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: _selectedStaff == null 
              ? _buildStaffSelection(staffListAsync, theme)
              : _buildPinPad(theme),
        ),
      ),
    );
  }

  Widget _buildStaffSelection(AsyncValue<List<StaffProfilesTableData>> staffListAsync, ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_person_outlined, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Who is using the POS?',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          staffListAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, st) => Text('Error loading staff: $e'),
            data: (staffList) {
              if (staffList.isEmpty) {
                return Column(
                  children: [
                    const Text('No staff members found.'),
                    const SizedBox(height: 16),
                    // Allow owner to bypass temporarily to create staff if needed?
                    // Actually, if list is empty, it means the DB has no staff yet. 
                    // Owner should bypass.
                    ElevatedButton(
                      onPressed: () {
                        // Create a dummy owner to unblock setup
                        ref.read(activeStaffProvider.notifier).setActiveStaff(
                          StaffProfilesTableData(
                            id: 'owner-temp',
                            fullName: 'Initial Setup',
                            role: 'OWNER',
                            pin: '0000',
                            isActive: true,
                          )
                        );
                      },
                      child: const Text('Bypass for Initial Setup'),
                    )
                  ],
                );
              }
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: staffList.map((staff) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _selectedStaff = staff;
                        _pin = '';
                        _isError = false;
                      });
                    },
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              staff.fullName.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            staff.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            staff.role,
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPinPad(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              _selectedStaff!.fullName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedStaff!.fullName,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your PIN',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          
          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isError 
                      ? theme.colorScheme.error 
                      : (isFilled ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest),
                ),
              );
            }),
          ),
          
          if (_isError) ...[
            const SizedBox(height: 16),
            Text('Incorrect PIN', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)),
          ] else ...[
            const SizedBox(height: 36),
          ],
          
          // Keypad
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 1; i <= 9; i++) _buildKeypadButton(i.toString(), theme),
              TextButton(
                onPressed: () => setState(() => _selectedStaff = null),
                child: const Text('Back', style: TextStyle(fontSize: 16)),
              ),
              _buildKeypadButton('0', theme),
              IconButton(
                onPressed: _handleBackspace,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String number, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleNumberPress(number),
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
