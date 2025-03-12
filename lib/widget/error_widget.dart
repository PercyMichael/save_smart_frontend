import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  // ignore: use_super_parameters
  const CustomErrorWidget({
    Key? key,
    this.message = AppStrings.error,
    this.onRetry,
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
              Icons.error_outline,
              color: AppColors.errorColor,
              size: 56,
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSizes.paddingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text(AppStrings.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
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