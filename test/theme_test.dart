import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_app/theme/app_theme.dart';
import 'package:mentor_app/shared/widgets/connectly_logo.dart';

void main() {
  group('Connectly Theme Tests', () {
    test('AppColors should have orange primary color', () {
      expect(AppColors.primary, const Color(0xFFFF8C00));
      expect(AppColors.primaryLight, const Color(0xFFFFB347));
      expect(AppColors.primaryDark, const Color(0xFFCC7000));
    });

    test('AppColors should have proper contrast colors', () {
      expect(AppColors.onPrimary, const Color(0xFFFFFFFF));
      expect(AppColors.onBackground, const Color(0xFF1C1B1F));
      expect(AppColors.onSurface, const Color(0xFF1C1B1F));
    });

    testWidgets('appTheme should use orange primary color', (WidgetTester tester) async {
      final theme = appTheme;
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.onPrimary, AppColors.onPrimary);
      expect(theme.appBarTheme.backgroundColor, AppColors.primary);
    });

    testWidgets('ConnectlyLogo widget should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: const Scaffold(
            body: ConnectlyLogo(),
          ),
        ),
      );

      // Should render fallback widget since no actual image assets
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('ConnectlyLogo should show fallback with correct colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: const Scaffold(
            body: ConnectlyLogo(variant: ConnectlyLogoVariant.iconOnly),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFF8C00)); // Orange color
    });
  });
}