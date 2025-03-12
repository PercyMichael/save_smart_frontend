import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  // ignore: use_super_parameters
  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon = Icons.info_outline,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.textLightColor,
              size: 56,
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: AppSizes.paddingLarge),
              OutlinedButton(
                onPressed: onAction,
                // ignore: sort_child_properties_last
                child: Text(actionLabel!),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                    vertical: AppSizes.paddingMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}