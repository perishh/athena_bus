import 'package:athena_bus/generated/material_community_icons.dart';
import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorContainer({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          spacing: 12,
          children: [
            const Icon(
              MaterialCommunityIcons.alert_circle_outline,
              size: 40,
              color: Colors.black54,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(MaterialCommunityIcons.refresh, size: 18),
              label: const Text('Επανάληψη'),
            ),
          ],
        ),
      ),
    );
  }
}
