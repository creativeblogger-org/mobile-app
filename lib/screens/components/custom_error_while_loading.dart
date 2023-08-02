import 'package:flutter/material.dart';

class CustomErrorWhileLoadingComponent extends StatelessWidget {
  const CustomErrorWhileLoadingComponent({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
