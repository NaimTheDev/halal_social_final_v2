import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentor_app/shared/widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';
import '../models/app_user.dart';
import 'package:mentor_app/features/onboarding/onboarding_flow.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final role = useState<UserRole>(UserRole.mentee);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ConnectlyLogo(
              height: 32,
              variant: ConnectlyLogoVariant.iconOnly,
              forDarkBackground: true,
            ),
            const SizedBox(width: 12),
            Text(isLogin.value ? 'Login' : 'Sign Up'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connectly logo at the top
            const Center(
              child: ConnectlyLogo(
                height: 120,
                variant: ConnectlyLogoVariant.full,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isLogin.value ? 'Welcome back!' : 'Join Connectly',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (!isLogin.value) ...[
              const Text(
                "Select Role:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authService = ref.read(authServiceProvider);
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                try {
                  if (isLogin.value) {
                    await authService.login(email, password);
                    Navigator.of(context).pushReplacementNamed('/Home');
                  } else {
                    await authService.signUp(email, password, role.value);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder:
                            (_) => OnboardingFlow(
                              isMentor: role.value == UserRole.mentor,
                            ),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text(isLogin.value ? 'Login' : 'Sign Up'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => isLogin.value = !isLogin.value,
              child: Text(
                isLogin.value
                    ? 'Need an account? Sign up'
                    : 'Have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
