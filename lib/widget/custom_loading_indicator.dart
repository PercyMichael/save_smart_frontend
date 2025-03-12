import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color color;
  final double size;

  // ignore: use_super_parameters
  const CustomLoadingIndicator({
    Key? key,
    this.message,
    this.color = Colors.blue,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 4.0,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                message!,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}