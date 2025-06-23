import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final String buttonText;

  const AuthForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Contraseña'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSubmit,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
