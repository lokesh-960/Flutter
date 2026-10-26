import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local persistent cache
  await LocalStorageService.getInstance();

  runApp(const DLMSApp());
}
