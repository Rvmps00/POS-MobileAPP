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
    _scanDevices();
  }

  Future<void> _scanDevices() async {
    setState(() => _isScanning = true);
    final printerService = ref.read(printerServiceProvider);
    
    // Request permission internally or assume handled by the package.
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

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
