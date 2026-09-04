import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/printer/printer_providers.dart';
import '../../../core/printer/receipt_builder.dart';

class PrinterSetupScreen extends ConsumerStatefulWidget {
  const PrinterSetupScreen({super.key});

  @override
  ConsumerState<PrinterSetupScreen> createState() => _PrinterSetupScreenState();
}

class _PrinterSetupScreenState extends ConsumerState<PrinterSetupScreen> {
  List<BluetoothInfo> _devices = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanDevices();
    });
  }

  Future<void> _scanDevices() async {
    setState(() => _isScanning = true);
    
    // Check if permissions are already granted
    final locationStatus = await Permission.location.status;
    final bluetoothScanStatus = await Permission.bluetoothScan.status;
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;

    if (!locationStatus.isGranted || !bluetoothScanStatus.isGranted || !bluetoothConnectStatus.isGranted) {
      // Show Prominent Disclosure Dialog for Play Store Compliance
      if (mounted) {
        final proceed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Printer Connection Setup'),
            content: const Text(
              'This app requires Bluetooth and Location permissions solely to discover and connect to your Bluetooth thermal printer. We do not track your physical location or share it with third parties.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Deny'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        );

        if (proceed != true) {
          setState(() => _isScanning = false);
          return;
        }
      }

      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }

    final printerService = ref.read(printerServiceProvider);
    final devices = await printerService.getPairedDevices();
    
    if (mounted) {
      setState(() {
        _devices = devices;
        _isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(BluetoothInfo device) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connecting to ${device.name}...')),
    );
    
    final success = await ref.read(printerConnectionProvider.notifier).connect(device.macAdress);
    
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printer connected!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to connect.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _disconnect() async {
    await ref.read(printerConnectionProvider.notifier).disconnect();
  }

  Future<void> _testPrint() async {
    final bytes = await ReceiptBuilder.buildTestReceipt();
    final success = await ref.read(printerServiceProvider).printBytes(bytes);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test print failed.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(printerConnectionProvider);
    final savedMac = ref.watch(printerServiceProvider).savedMacAddress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Setup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _scanDevices,
            tooltip: 'Scan for printers',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isConnected ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  isConnected ? Icons.print : Icons.print_disabled,
                  color: isConnected ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isConnected ? 'Connected' : 'Disconnected',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (savedMac != null && !isConnected)
                        Text('Saved: $savedMac (Will auto-connect)', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                if (isConnected)
                  TextButton(
                    onPressed: _disconnect,
                    child: const Text('DISCONNECT'),
                  ),
              ],
            ),
          ),
          
          if (isConnected)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _testPrint,
                icon: const Icon(Icons.receipt),
                label: const Text('Test Print'),
              ),
            ),
            
          const Divider(),
          
          Expanded(
            child: _isScanning
                ? const Center(child: CircularProgressIndicator())
                : _devices.isEmpty
                    ? const Center(child: Text('No paired bluetooth devices found. Pair a printer in Android Settings first.'))
                    : ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          final isThisDeviceConnected = isConnected && savedMac == device.macAdress;
                          
                          return ListTile(
                            leading: const Icon(Icons.bluetooth),
                            title: Text(device.name),
                            subtitle: Text(device.macAdress),
                            trailing: isThisDeviceConnected
                                ? const Icon(Icons.check_circle, color: Colors.green)
                                : ElevatedButton(
                                    onPressed: () => _connectToDevice(device),
                                    child: const Text('Connect'),
                                  ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
