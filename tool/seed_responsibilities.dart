#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// Standalone executable to seed responsibilities to Firebase
/// Run with: dart run tool/seed_responsibilities.dart
/// Or make executable: chmod +x tool/seed_responsibilities.dart && ./tool/seed_responsibilities.dart

import 'dart:io';

void main() async {
  print('\n========================================');
  print('🚀 Firebase Responsibilities Seeder');
  print('========================================\n');

  print('📋 Instructions:');
  print('1. This will add 3 responsibilities to your Firebase database');
  print('2. Make sure Firebase is properly configured');
  print('3. Run this script only once to avoid duplicates\n');

  stdout.write('Do you want to continue? (y/n): ');
  final answer = stdin.readLineSync()?.toLowerCase();

  if (answer != 'y' && answer != 'yes') {
    print('\n❌ Seeding cancelled.');
    exit(0);
  }

  print('\n========================================');
  print('Starting seeding process...');
  print('========================================\n');

  print('✓ Step 1: Import the seeder utility in your lib/main.dart:');
  print(
      '   import \'package:portfolio/main/utils/seed_responsibilities.dart\';\n');

  print('✓ Step 2: Add this line after Firebase.initializeApp():');
  print('   await seedResponsibilities();\n');

  print('✓ Step 3: Run your Flutter app:');
  print('   flutter run\n');

  print('✓ Step 4: Check console logs for confirmation\n');

  print('✓ Step 5: Remove the seeding code after success\n');

  print('========================================');
  print('📝 Alternative Quick Method:');
  print('========================================\n');

  print('Add this temporary code in your main() function:\n');

  print('''
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 TEMPORARY: Run once and remove
  await seedResponsibilities();
  
  runApp(const MyApp());
}
''');

  print('\n========================================');
  print('📚 For more options, see SEED_RESPONSIBILITIES.md');
  print('========================================\n');

  print('✓ Setup guide complete!');
  print('  Run your Flutter app to seed the data.\n');
}
