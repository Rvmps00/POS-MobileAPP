import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPosScreen extends StatelessWidget {
  const MainPosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main POS (Placeholder)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Main POS Screen Placeholder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/cart'),
              child: const Text('Go to Cart'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/checkout'),
              child: const Text('Go to Checkout'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/inventory'),
              child: const Text('Go to Inventory'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/orders'),
              child: const Text('Go to Order History'),
            ),
          ],
        ),
      ),
    );
  }
}

