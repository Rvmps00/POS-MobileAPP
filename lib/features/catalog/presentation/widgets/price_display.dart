import 'package:flutter/material.dart';

class PriceDisplay extends StatelessWidget {
  final int price;
  final String? prefix;
  final TextStyle? style;

  const PriceDisplay({super.key, required this.price, this.prefix, this.style});

  String get formattedPrice {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '${prefix ?? ''}Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedPrice,
      style:
          style ??
          TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
}
