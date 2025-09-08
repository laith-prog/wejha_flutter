import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({
    Key? key,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
} 