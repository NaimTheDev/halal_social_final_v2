import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../models/app_user.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final role = useState<UserRole>(UserRole.mentee); // default

    return Scaffold(
      appBar: AppBar(title: Text(isLogin.value ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            if (!isLogin.value)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Select Role:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Mentor'),
                    leading: Radio(
                      value: UserRole.mentor,
                      groupValue: role.value,
                      onChanged: (value) => role.value = value!,
                    ),
                  ),
                  ListTile(
                    title: const Text('Mentee'),
                    leading: Radio(
                      value: UserRole.mentee,
                      groupValue: role.value,
                      onChanged: (value) => role.value = value!,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                try {
                  if (isLogin.value) {
                    await authService.login(email, password);
                  } else {
                    await authService.signUp(email, password, role.value);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text(isLogin.value ? 'Login' : 'Sign Up'),
            ),

            TextButton(
              onPressed: () => isLogin.value = !isLogin.value,
              child: Text(isLogin.value ? 'Need an account? Sign up' : 'Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}