import 'package:expensag/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providerListner/theme_notifier.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ThemePickerDialog(),
        );
      },
      child: const Text('Choose Theme'),
    );
  }
}

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Pick a Theme'),
      content: SizedBox(
        width: double.maxFinite,
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: AppThemes.themes.entries.map((entry) {
            final color = entry.value.primaryColor;

            return GestureDetector(
              onTap: () {
                themeProvider.setTheme(entry.key);
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
