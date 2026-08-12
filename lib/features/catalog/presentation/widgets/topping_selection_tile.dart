import 'package:flutter/material.dart';
import '../../data/models/addon_topping_model.dart';

class ToppingSelectionTile extends StatelessWidget {
  final AddonToppingModel topping;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  final String languageCode;

  const ToppingSelectionTile({
    super.key,
    required this.topping,
    required this.isSelected,
    required this.onChanged,
    this.languageCode = 'id',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = !topping.isAvailable;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged(!isSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: isDisabled ? null : (v) => onChanged(v ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              // Name
              Expanded(
                child: Text(
                  topping.localizedName(languageCode),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDisabled
                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              // Price
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: topping.isFree
                      ? Colors.green.withValues(alpha: 0.1)
                      : colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  topping.formattedPrice,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: topping.isFree
                        ? Colors.green.shade700
                        : colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
