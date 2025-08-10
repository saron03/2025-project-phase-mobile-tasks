import 'package:flutter/material.dart';

class AuthTextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthTextLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: linkText,
                style: const TextStyle(color: Color(0xFF4A5CF4), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}