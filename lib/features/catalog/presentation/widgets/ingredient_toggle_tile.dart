import 'package:flutter/material.dart';
import '../../data/models/default_ingredient_model.dart';

class IngredientToggleTile extends StatelessWidget {
  final DefaultIngredientModel ingredient;
  final bool isRemoved;
  final ValueChanged<bool> onChanged;
  final String languageCode;

  const IngredientToggleTile({
    super.key,
    required this.ingredient,
    required this.isRemoved,
    required this.onChanged,
    this.languageCode = 'id',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLocked = !ingredient.isRemovable;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : () => onChanged(!isRemoved),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: 24,
                height: 24,
                child: isLocked
                    ? Icon(
                        Icons.lock_outline,
                        size: 18,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      )
                    : Checkbox(
                        value: !isRemoved,
                        onChanged: (v) => onChanged(!(v ?? true)),
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
                  ingredient.localizedName(languageCode),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isRemoved
                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                        : colorScheme.onSurface,
                    decoration: isRemoved ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              // Status
              if (isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    languageCode == 'en' ? 'Required' : 'Wajib',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
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
