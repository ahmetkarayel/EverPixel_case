import 'package:flutter/material.dart';

class WidgetContainerButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;
  const WidgetContainerButton({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 8,),
            Text(title)
          ],
        ),
      ),
    );
  }
}