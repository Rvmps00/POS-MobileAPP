import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../../../core/database/app_database.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  
  void _showStaffDialog([StaffProfilesTableData? staff]) {
    showDialog(
      context: context,
      builder: (context) => _StaffDialog(staff: staff),
    ).then((_) {
      // Refresh list
      ref.invalidate(allStaffProfilesProvider);
      ref.invalidate(staffProfilesProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(allStaffProfilesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStaffDialog(),
            tooltip: 'Add Staff',
          )
        ],
      ),
      body: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (staffList) {
          if (staffList.isEmpty) {
            return const Center(child: Text('No staff profiles found.'));
          }
          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staff = staffList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: staff.isActive ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                  child: Text(
                    staff.fullName.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: staff.isActive ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant),
                  ),
                ),
                title: Text(staff.fullName, style: TextStyle(
                  decoration: staff.isActive ? null : TextDecoration.lineThrough,
                  color: staff.isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                )),
                subtitle: Text('Role: ${staff.role} • PIN: ${staff.pin}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: staff.isActive,
                      onChanged: (val) async {
                        await ref.read(authRepositoryProvider).updateStaff(
                          staff.id, staff.fullName, staff.role, staff.pin, val
                        );
                        ref.invalidate(allStaffProfilesProvider);
                        ref.invalidate(staffProfilesProvider);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showStaffDialog(staff),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StaffDialog extends ConsumerStatefulWidget {
  final StaffProfilesTableData? staff;
  
  const _StaffDialog({this.staff});

  @override
  ConsumerState<_StaffDialog> createState() => _StaffDialogState();
}

class _StaffDialogState extends ConsumerState<_StaffDialog> {
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  String _role = 'CASHIER';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _nameController.text = widget.staff!.fullName;
      _pinController.text = widget.staff!.pin;
      _role = widget.staff!.role;
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _pinController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      if (widget.staff == null) {
        await repo.addStaff(_nameController.text, _role, _pinController.text);
      } else {
        await repo.updateStaff(
          widget.staff!.id, 
          _nameController.text, 
          _role, 
          _pinController.text, 
          widget.staff!.isActive
        );
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.staff == null ? 'Add Staff' : 'Edit Staff'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pinController,
            decoration: const InputDecoration(labelText: '4-Digit PIN'),
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _role,
            items: const [
              DropdownMenuItem(value: 'CASHIER', child: Text('Cashier')),
              DropdownMenuItem(value: 'MANAGER', child: Text('Manager')),
              DropdownMenuItem(value: 'OWNER', child: Text('Owner')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _role = val);
            },
            decoration: const InputDecoration(labelText: 'Role'),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) : const Text('Save'),
        )
      ],
    );
  }
}
