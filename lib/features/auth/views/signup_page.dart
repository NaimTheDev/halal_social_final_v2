import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/auth_controller.dart';
import '../models/app_user.dart';

class SignupPage extends HookConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = useTextEditingController();
    final lastName = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final acceptedTerms = useState(false);

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sign up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text("Please enter your information"),
            const SizedBox(height: 24),
            TextField(controller: firstName, decoration: const InputDecoration(labelText: "First Name")),
            const SizedBox(height: 12),
            TextField(controller: lastName, decoration: const InputDecoration(labelText: "Last Name")),
            const SizedBox(height: 12),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 12),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 12),
            TextField(controller: confirmPassword, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password")),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: acceptedTerms.value,
                  onChanged: (v) => acceptedTerms.value = v ?? false,
                ),
                const Expanded(child: Text.rich(TextSpan(
                  text: "I agree with ",
                  children: [
                    TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.blue)),
                    TextSpan(text: " and "),
                    TextSpan(text: "T&C", style: TextStyle(color: Colors.blue)),
                  ],
                ))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: acceptedTerms.value
                    ? () async {
                        final auth = ref.read(authServiceProvider);
                        await auth.signUp(
                          email.text,
                          password.text,
                          UserRole.mentee,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: acceptedTerms.value ? Colors.black : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // back to login
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [TextSpan(text: 'Login', style: TextStyle(color: Colors.red))],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}