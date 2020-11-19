import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:document_file_save/document_file_save.dart';

void main() {
  const MethodChannel channel = MethodChannel('document_file_save');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DocumentFileSave.platformVersion, '42');
  });
}
